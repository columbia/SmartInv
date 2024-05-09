1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 contract Admin is Ownable {
82 
83     using SafeMath for uint256;
84 
85     struct Tier {
86         uint256 amountInCenter;
87         uint256 amountInOuter;
88         uint256 priceInCenter;
89         uint256 priceInOuter;
90         uint256 soldInCenter;
91         uint256 soldInOuter;
92         bool filledInCenter;
93         bool filledInOuter;
94     }
95 
96     Tier[] public tiers;
97 
98     bool public halted;
99     uint256 public logoPrice = 0;
100     uint256 public logoId;
101     address public platformWallet;
102 
103     uint256 public feeForFirstArtWorkChangeRequest = 0 ether;
104     uint256 public feeForArtWorkChangeRequest = 0.2 ether;
105     uint256 public minResalePercentage = 15;
106 
107     mapping(address => bool) public globalAdmins;
108     mapping(address => bool) public admins;
109     mapping(address => bool) public signers;
110 
111     event Halted(bool _halted);
112 
113     modifier onlyAdmin() {
114         require(true == admins[msg.sender] || true == globalAdmins[msg.sender]);
115         _;
116     }
117 
118     modifier onlyGlobalAdmin() {
119         require(true == globalAdmins[msg.sender]);
120         _;
121     }
122 
123     modifier notHalted() {
124         require(halted == false);
125         _;
126     }
127 
128     function addGlobalAdmin(address _address) public onlyOwner() {
129         globalAdmins[_address] = true;
130     }
131 
132     function removeGlobalAdmin(address _address) public onlyOwner() {
133         globalAdmins[_address] = false;
134     }
135 
136     function addAdmin(address _address) public onlyGlobalAdmin() {
137         admins[_address] = true;
138     }
139 
140     function removeAdmin(address _address) public onlyGlobalAdmin() {
141         admins[_address] = true;
142     }
143 
144     function setSigner(address _address, bool status) public onlyGlobalAdmin() {
145         signers[_address] = status;
146     }
147 
148     function setLogoPrice(uint256 _price) public onlyGlobalAdmin() {
149         logoPrice = _price;
150     }
151 
152     function setFeeForFirstArtWorkChangeRequest(uint256 _fee) public onlyGlobalAdmin() {
153         feeForFirstArtWorkChangeRequest = _fee;
154     }
155 
156     function setFeeForArtWorkChangeRequest(uint256 _fee) public onlyGlobalAdmin() {
157         feeForArtWorkChangeRequest = _fee;
158     }
159 
160     /// @notice global Admin update tier data
161     function setTierData(
162         uint256 _index,
163         uint256 _priceInCenter,
164         uint256 _priceInOuter) public onlyGlobalAdmin() {
165         Tier memory tier = tiers[_index];
166         tier.priceInCenter = _priceInCenter;
167         tier.priceInOuter = _priceInOuter;
168         tiers[_index] = tier;
169     }
170 
171     function setMinResalePercentage(uint256 _minResalePercentage) public onlyGlobalAdmin() {
172         minResalePercentage = _minResalePercentage;
173     }
174 
175     function isAdmin(address _address) public view returns (bool isAdmin_) {
176         return (true == admins[_address] || true == globalAdmins[_address]);
177     }
178 
179     function setHalted(bool _halted) public onlyGlobalAdmin {
180         halted = _halted;
181 
182         emit Halted(_halted);
183     }
184 
185     function verify(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
186         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
187 
188         return ecrecover(keccak256(abi.encodePacked(prefix, _hash)), _v, _r, _s);
189     }
190 
191     function isContract(address addr) public view returns (bool) {
192         uint size;
193         assembly { size := extcodesize(addr) }
194         return size > 0;
195     }
196 
197     function setPlatformWallet(address _addresss) public onlyGlobalAdmin() {
198         platformWallet = _addresss;
199     }
200 }
201 
202 contract BigIoAdSpace is Ownable {
203     using SafeMath for uint256;
204 
205     /// @notice Token
206     struct Token {
207         uint256 id;
208         uint256 x; // position X on map
209         uint256 y; // position Y on map
210         uint256 sizeA;
211         uint256 sizeB;
212         uint256 soldPrice; // price that user paid to buy token
213         uint256 actualPrice;
214         uint256 timesSold; // how many times token was sold
215         uint256 timesUpdated; // how many times artwork has been changed by current owner
216         uint256 soldAt; // when token was sold
217         uint256 inner;
218         uint256 outer;
219         uint256 soldNearby;
220     }
221 
222     struct MetaData {
223         string meta;
224     }
225 
226     struct InnerScope {
227         uint256 x1; // left top
228         uint256 y1;
229         uint256 x2; // right top
230         uint256 y2;
231         uint256 x3; // left bottom
232         uint256 y3;
233         uint256 x4; // right bottom
234         uint256 y4;
235     }
236 
237     InnerScope public innerScope;
238 
239     /// @notice mapping for token URIs
240     mapping(uint256 => MetaData) public metadata;
241 
242     /// @notice Mapping from token ID to owner
243     mapping(uint256 => address) public tokenOwner;
244 
245     mapping(uint256 => mapping(uint256 => bool)) public neighbours;
246     mapping(uint256 => uint256[]) public neighboursArea;
247 
248     /// @notice Here different from base class we store the token not an id
249     /// Array with all token, used for enumeration
250     Token[] public allMinedTokens;
251 
252     /// @notice Mapping from token id to position in the allMinedTokens array
253     mapping(uint256 => uint256) public allTokensIndex;
254 
255     // store sold units and not-sold but generated units
256 //    mapping(uint256 => mapping(uint256 => bool)) public soldUnits;
257     mapping(uint256 => mapping(uint256 => uint256)) public soldUnits;
258 
259     address public platform;
260 
261     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
262     event TokenPriceIncreased(uint256 _tokenId, uint256 _newPrice, uint256 _boughtTokenId, uint256 time);
263 
264     constructor () public {
265         innerScope = InnerScope(
266             12, 11, // left top
267             67, 11, // right top
268             12, 34, // left bottom
269             67, 34
270         );
271     }
272 
273     modifier onlyPlatform() {
274         require(msg.sender == platform);
275         _;
276     }
277 
278     modifier exists(uint256 _tokenId) {
279         address owner = tokenOwner[_tokenId];
280         require(owner != address(0));
281         _;
282     }
283 
284     function setPlatform(address _platform) public onlyOwner() {
285         platform = _platform;
286     }
287 
288     function totalSupply() public view returns (uint256) {
289         return allMinedTokens.length;
290     }
291 
292     /// @notice Check whether token is minted
293     function tokenExists(uint256 _tokenId) public view returns (bool) {
294         address owner = tokenOwner[_tokenId];
295         return owner != address(0);
296     }
297 
298     /// @notice Check whether exist Unit with same x any y coordinates
299     /// and it was sold already
300     /// in order to prevent over writing
301     function unitExists(uint x, uint y) public view returns (bool) {
302         return (soldUnits[x][y] != 0);
303     }
304 
305     function getOwner(uint256 _tokenId) public view returns (address) {
306         return tokenOwner[_tokenId];
307     }
308 
309     /// @return token metadata
310     function getMetadata(uint256 _tokenId) public exists(_tokenId) view returns (string) {
311         return metadata[_tokenId].meta;
312     }
313 
314     /// @notice update metadata for token
315     function setTokenMetadata(uint256 _tokenId, string meta) public  onlyPlatform exists(_tokenId) {
316         metadata[_tokenId] = MetaData(meta);
317     }
318 
319     function increaseUpdateMetadataCounter(uint256 _tokenId) public onlyPlatform {
320         allMinedTokens[allTokensIndex[_tokenId]].timesUpdated = allMinedTokens[allTokensIndex[_tokenId]].timesUpdated.add(1);
321     }
322 
323     /// @notice remove metadata for token
324     function removeTokenMetadata(uint256 _tokenId) public onlyPlatform exists(_tokenId) {
325         delete metadata[_tokenId];
326     }
327 
328     // @return return the current price
329     function getCurrentPriceForToken(uint256 _tokenId) public exists(_tokenId) view returns (uint256) {
330         return allMinedTokens[allTokensIndex[_tokenId]].actualPrice;
331     }
332 
333     /// @return tokenId, x, y, sizeA, sizeB, price, inner, outer
334     function getTokenData(uint256 _tokenId) public exists(_tokenId) view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
335         Token memory token = allMinedTokens[allTokensIndex[_tokenId]];
336         return (_tokenId, token.x, token.y, token.sizeA, token.sizeB, token.actualPrice, token.soldPrice, token.inner, token.outer);
337     }
338 
339     function getTokenSoldPrice(uint256 _tokenId) public exists(_tokenId) view returns (uint256) {
340         Token memory token = allMinedTokens[allTokensIndex[_tokenId]];
341         return token.soldPrice;
342     }
343 
344     function getTokenUpdatedCounter(uint256 _tokenId) public exists(_tokenId) view returns (uint256) {
345         return allMinedTokens[allTokensIndex[_tokenId]].timesUpdated;
346     }
347 
348     // @return return token sizes
349     function getTokenSizes(uint256 _tokenId) public exists(_tokenId) view returns (uint256, uint256) {
350         Token memory token = allMinedTokens[allTokensIndex[_tokenId]];
351         return (token.sizeA, token.sizeB);
352     }
353 
354     // @return return token scopes
355     function getTokenScope(uint256 _tokenId) public exists(_tokenId) view returns (bool, bool) {
356         Token memory token = allMinedTokens[allTokensIndex[_tokenId]];
357         return (token.inner > 0, token.outer > 0);
358     }
359 
360     // @return return token scope counters
361     function getTokenCounters(uint256 _tokenId) public exists(_tokenId) view returns (uint256, uint256, uint256, uint256) {
362         Token memory token = allMinedTokens[allTokensIndex[_tokenId]];
363         return (token.inner, token.outer, token.timesSold, token.soldNearby);
364     }
365 
366     /// @notice Mint new token, not sell new token
367     /// BE sends: owner, x coordinate, y coordinate, price
368     /// @param to new owner
369     /// @param x coordinate
370     /// @param y coordinate
371     /// @param totalPrice calculated price for all units + % for siblings
372     function mint(
373         address to,
374         uint x,
375         uint y,
376         uint sizeA,
377         uint sizeB,
378         uint256 totalPrice,
379         uint256 actualPrice
380     ) public onlyPlatform() returns (uint256) {
381 
382         // 1.
383         require(to != address(0));
384         require(sizeA.mul(sizeB) <= 100);
385 
386         // 2. check area
387         uint256 inner;
388         uint256 total;
389 
390         (total, inner) = calculateCounters(x, y, sizeA, sizeB);
391 
392         // we avoid zero because we later compare against zero
393         uint256 tokenId = (allMinedTokens.length).add(1);
394 
395         // @TODO: ACHTUNG - soldAt equals 0 during minting
396         Token memory minted = Token(tokenId, x, y, sizeA, sizeB, totalPrice, actualPrice, 0, 0, 0, inner, total.sub(inner), 0);
397 
398         // 3. copy units and create siblings
399         copyToAllUnits(x, y, sizeA, sizeB, tokenId);
400 
401         // 4. update state
402         updateInternalState(minted, to);
403 
404         return tokenId;
405     }
406 
407     function updateTokensState(uint256 _tokenId, uint256 newPrice) public onlyPlatform exists(_tokenId) {
408         uint256 index = allTokensIndex[_tokenId];
409         allMinedTokens[index].timesSold += 1;
410         allMinedTokens[index].timesUpdated = 0;
411         allMinedTokens[index].soldNearby = 0;
412         allMinedTokens[index].soldPrice = newPrice;
413         allMinedTokens[index].actualPrice = newPrice;
414         allMinedTokens[index].soldAt = now;
415     }
416 
417     function updateOwner(uint256 _tokenId, address newOwner, address prevOwner) public onlyPlatform exists(_tokenId) {
418         require(newOwner != address(0));
419         require(prevOwner != address(0));
420         require(prevOwner == tokenOwner[_tokenId]);
421 
422         // update data for new owner
423         tokenOwner[_tokenId] = newOwner;
424     }
425 
426     function inInnerScope(uint256 x, uint256 y) public view returns (bool) {
427         // x should be between left top and right top corner
428         // y should be between left top and left bottom corner
429         if ((x >= innerScope.x1) && (x <= innerScope.x2) && (y >= innerScope.y1) && (y <= innerScope.y3)) {
430             return true;
431         }
432 
433         return false;
434     }
435 
436     function calculateCounters(uint256 x, uint256 y, uint256 sizeA, uint256 sizeB) public view returns (uint256 total, uint256 inner) {
437         uint256 upX = x.add(sizeA);
438         uint256 upY = y.add(sizeB);
439 
440         // check for boundaries
441         require(x >= 1);
442         require(y >= 1);
443         require(upX <= 79);
444         require(upY <= 45);
445         require(sizeA > 0);
446         require(sizeB > 0);
447 
448         uint256 i;
449         uint256 j;
450 
451         for (i = x; i < upX; i++) {
452             for (j = y; j < upY; j++) {
453                 require(soldUnits[i][j] == 0);
454 
455                 if (inInnerScope(i, j)) {
456                     inner = inner.add(1);
457                 }
458 
459                 total = total.add(1);
460             }
461         }
462     }
463 
464     function increasePriceForNeighbours(uint256 tokenId) public onlyPlatform {
465 
466         Token memory token = allMinedTokens[allTokensIndex[tokenId]];
467 
468         uint256 upX = token.x.add(token.sizeA);
469         uint256 upY = token.y.add(token.sizeB);
470 
471         uint256 i;
472         uint256 j;
473         uint256 k;
474         uint256 _tokenId;
475 
476 
477         if (neighboursArea[tokenId].length == 0) {
478 
479             for (i = token.x; i < upX; i++) {
480                 // check neighbors on top of area
481                 _tokenId = soldUnits[i][token.y - 1];
482 
483                 if (_tokenId != 0) {
484                     if (!neighbours[tokenId][_tokenId]) {
485                         neighbours[tokenId][_tokenId] = true;
486                         neighboursArea[tokenId].push(_tokenId);
487                     }
488                     if (!neighbours[_tokenId][tokenId]) {
489                         neighbours[_tokenId][tokenId] = true;
490                         neighboursArea[_tokenId].push(tokenId);
491                     }
492                 }
493 
494                 // check neighbors on bottom of area
495                 _tokenId = soldUnits[i][upY];
496                 if (_tokenId != 0) {
497                     if (!neighbours[tokenId][_tokenId]) {
498                         neighbours[tokenId][_tokenId] = true;
499                         neighboursArea[tokenId].push(_tokenId);
500                     }
501                     if (!neighbours[_tokenId][tokenId]) {
502                         neighbours[_tokenId][tokenId] = true;
503                         neighboursArea[_tokenId].push(tokenId);
504                     }
505                 }
506             }
507 
508             for (j = token.y; j < upY; j++) {
509                 // check neighbors on left of area of area
510                 _tokenId = soldUnits[token.x - 1][j];
511                 if (_tokenId != 0) {
512                     if (!neighbours[tokenId][_tokenId]) {
513                         neighbours[tokenId][_tokenId] = true;
514                         neighboursArea[tokenId].push(_tokenId);
515                     }
516                     if (!neighbours[_tokenId][tokenId]) {
517                         neighbours[_tokenId][tokenId] = true;
518                         neighboursArea[_tokenId].push(tokenId);
519                     }
520                 }
521 
522                 // check neighbors on right of area of area
523                 _tokenId = soldUnits[upX][j];
524                 if (_tokenId != 0) {
525                     if (!neighbours[tokenId][_tokenId]) {
526                         neighbours[tokenId][_tokenId] = true;
527                         neighboursArea[tokenId].push(_tokenId);
528                     }
529                     if (!neighbours[_tokenId][tokenId]) {
530                         neighbours[_tokenId][tokenId] = true;
531                         neighboursArea[_tokenId].push(tokenId);
532                     }
533                 }
534             }
535         }
536 
537         // increase price
538         for (k = 0; k < neighboursArea[tokenId].length; k++) {
539             Token storage _token = allMinedTokens[allTokensIndex[neighboursArea[tokenId][k]]];
540             _token.soldNearby = _token.soldNearby.add(1);
541             _token.actualPrice = _token.actualPrice.add((_token.actualPrice.div(100)));
542             emit TokenPriceIncreased(_token.id, _token.actualPrice, _tokenId, now);
543         }
544     }
545 
546     // move generated Units to sold array
547     // generate siblings and put it there
548     function copyToAllUnits(uint256 x, uint256 y, uint256 width, uint256 height, uint256 tokenId) internal {
549         uint256 upX = x + width; // 5
550         uint256 upY = y + height; // 3
551 
552         uint256 i; // 1
553         uint256 j; // 1
554 
555         for (i = x; i < upX; i++) {
556             for (j = y; j < upY; j++) {
557                 soldUnits[i][j] = tokenId;
558             }
559         }
560     }
561 
562     function updateInternalState(Token minted, address _to) internal {
563         uint256 lengthT = allMinedTokens.length;
564         allMinedTokens.push(minted);
565         allTokensIndex[minted.id] = lengthT;
566         tokenOwner[minted.id] = _to;
567     }
568 }
569 
570 contract ERC20Basic {
571   function totalSupply() public view returns (uint256);
572   function balanceOf(address who) public view returns (uint256);
573   function transfer(address to, uint256 value) public returns (bool);
574   event Transfer(address indexed from, address indexed to, uint256 value);
575 }
576 
577 contract BasicToken is ERC20Basic {
578   using SafeMath for uint256;
579 
580   mapping(address => uint256) balances;
581 
582   uint256 totalSupply_;
583 
584   /**
585   * @dev total number of tokens in existence
586   */
587   function totalSupply() public view returns (uint256) {
588     return totalSupply_;
589   }
590 
591   /**
592   * @dev transfer token for a specified address
593   * @param _to The address to transfer to.
594   * @param _value The amount to be transferred.
595   */
596   function transfer(address _to, uint256 _value) public returns (bool) {
597     require(_to != address(0));
598     require(_value <= balances[msg.sender]);
599 
600     balances[msg.sender] = balances[msg.sender].sub(_value);
601     balances[_to] = balances[_to].add(_value);
602     emit Transfer(msg.sender, _to, _value);
603     return true;
604   }
605 
606   /**
607   * @dev Gets the balance of the specified address.
608   * @param _owner The address to query the the balance of.
609   * @return An uint256 representing the amount owned by the passed address.
610   */
611   function balanceOf(address _owner) public view returns (uint256) {
612     return balances[_owner];
613   }
614 
615 }
616 
617 contract ERC20 is ERC20Basic {
618   function allowance(address owner, address spender) public view returns (uint256);
619   function transferFrom(address from, address to, uint256 value) public returns (bool);
620   function approve(address spender, uint256 value) public returns (bool);
621   event Approval(address indexed owner, address indexed spender, uint256 value);
622 }
623 
624 contract StandardToken is ERC20, BasicToken {
625 
626   mapping (address => mapping (address => uint256)) internal allowed;
627 
628 
629   /**
630    * @dev Transfer tokens from one address to another
631    * @param _from address The address which you want to send tokens from
632    * @param _to address The address which you want to transfer to
633    * @param _value uint256 the amount of tokens to be transferred
634    */
635   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
636     require(_to != address(0));
637     require(_value <= balances[_from]);
638     require(_value <= allowed[_from][msg.sender]);
639 
640     balances[_from] = balances[_from].sub(_value);
641     balances[_to] = balances[_to].add(_value);
642     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
643     emit Transfer(_from, _to, _value);
644     return true;
645   }
646 
647   /**
648    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
649    *
650    * Beware that changing an allowance with this method brings the risk that someone may use both the old
651    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
652    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
653    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
654    * @param _spender The address which will spend the funds.
655    * @param _value The amount of tokens to be spent.
656    */
657   function approve(address _spender, uint256 _value) public returns (bool) {
658     allowed[msg.sender][_spender] = _value;
659     emit Approval(msg.sender, _spender, _value);
660     return true;
661   }
662 
663   /**
664    * @dev Function to check the amount of tokens that an owner allowed to a spender.
665    * @param _owner address The address which owns the funds.
666    * @param _spender address The address which will spend the funds.
667    * @return A uint256 specifying the amount of tokens still available for the spender.
668    */
669   function allowance(address _owner, address _spender) public view returns (uint256) {
670     return allowed[_owner][_spender];
671   }
672 
673   /**
674    * @dev Increase the amount of tokens that an owner allowed to a spender.
675    *
676    * approve should be called when allowed[_spender] == 0. To increment
677    * allowed value is better to use this function to avoid 2 calls (and wait until
678    * the first transaction is mined)
679    * From MonolithDAO Token.sol
680    * @param _spender The address which will spend the funds.
681    * @param _addedValue The amount of tokens to increase the allowance by.
682    */
683   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
684     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
685     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
686     return true;
687   }
688 
689   /**
690    * @dev Decrease the amount of tokens that an owner allowed to a spender.
691    *
692    * approve should be called when allowed[_spender] == 0. To decrement
693    * allowed value is better to use this function to avoid 2 calls (and wait until
694    * the first transaction is mined)
695    * From MonolithDAO Token.sol
696    * @param _spender The address which will spend the funds.
697    * @param _subtractedValue The amount of tokens to decrease the allowance by.
698    */
699   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
700     uint oldValue = allowed[msg.sender][_spender];
701     if (_subtractedValue > oldValue) {
702       allowed[msg.sender][_spender] = 0;
703     } else {
704       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
705     }
706     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
707     return true;
708   }
709 
710 }
711 
712 contract BigIOERC20token is StandardToken, Ownable {
713 
714     using SafeMath for uint256;
715 
716     string public name;
717     string public symbol;
718     uint8 public decimals;
719 
720     uint256 public maxSupply;
721 
722     bool public allowedMinting;
723 
724     mapping(address => bool) public mintingAgents;
725     mapping(address => bool) public stateChangeAgents;
726 
727     event MintERC20(address indexed _holder, uint256 _tokens);
728     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
729 
730     modifier onlyMintingAgents () {
731         require(mintingAgents[msg.sender]);
732         _;
733     }
734 
735     constructor (string _name, string _symbol, uint8 _decimals, uint256 _maxSupply) public StandardToken() {
736         name = _name;
737         symbol = _symbol;
738         decimals = _decimals;
739 
740         maxSupply = _maxSupply;
741 
742         allowedMinting = true;
743 
744         mintingAgents[msg.sender] = true;
745     }
746 
747     /// @notice update minting agent
748     function updateMintingAgent(address _agent, bool _status) public onlyOwner {
749         mintingAgents[_agent] = _status;
750     }
751 
752     /// @notice allow to mint tokens
753     function mint(address _holder, uint256 _tokens) public onlyMintingAgents() {
754         require(allowedMinting == true && totalSupply_.add(_tokens) <= maxSupply);
755 
756         totalSupply_ = totalSupply_.add(_tokens);
757 
758         balances[_holder] = balanceOf(_holder).add(_tokens);
759 
760         if (totalSupply_ == maxSupply) {
761             allowedMinting = false;
762         }
763         emit MintERC20(_holder, _tokens);
764         emit Transfer(0x0, _holder, _tokens);
765     }
766 
767 }
768 
769 contract PricingStrategy {
770     using SafeMath for uint256;
771 
772     function calculateMinPriceForNextRound(uint256 _tokenPrice, uint256 _minResalePercentage) public pure returns (uint256) {
773         return _tokenPrice.add(_tokenPrice.div(100).mul(_minResalePercentage));
774     }
775 
776     function calculateSharesInTheRevenue(uint256 _prevTokenPrice, uint256 _newTokenPrice) public pure returns (uint256, uint256) {
777         uint256 revenue = _newTokenPrice.sub(_prevTokenPrice);
778         uint256 platformShare = revenue.mul(40).div(100);
779         uint256 forPrevOwner = revenue.sub(platformShare);
780         return (platformShare, forPrevOwner);
781     }
782 }
783 /// @title Platform
784 /// @author Applicature
785 /// @notice It is front contract which is used to sell, re-sell tokens and initiate paying dividends
786 contract Platform is Admin {
787 
788     using SafeMath for uint256;
789 
790     struct Offer {
791         uint256 tokenId;
792         uint256 offerId;
793         address from;
794         uint256 offeredPrice;
795         uint256 tokenPrice;
796         bool accepted;
797         uint256 timestamp;
798     }
799 
800     struct ArtWorkChangeRequest {
801         address fromUser;
802         uint256 tokenId;
803         uint256 changeId;
804         string meta;
805         uint256 timestamp;
806         bool isReviewed;
807     }
808 
809     BigIoAdSpace public token;
810     BigIOERC20token public erc20token;
811 
812     PricingStrategy public pricingStrategy;
813     ArtWorkChangeRequest[] public artWorkChangeRequests;
814 
815     bool public isLogoInitied;
816 
817     uint256 public logoX = 35;
818     uint256 public logoY = 18;
819 
820     Offer[] public offers;
821 
822     mapping(address => uint256) public pendingReturns;
823 
824     event Minted(address indexed _owner, uint256 _tokenId, uint256 _x, uint256 _y, uint256 _sizeA, uint256 _sizeB, uint256 _price, uint256 _platformTransfer, uint256 _timestamp);
825 
826     event Purchased(address indexed _from, address indexed _to, uint256 _tokenId, uint256 _price, uint256 _prevPrice, uint256 _prevOwnerTransfer, uint256 _platformTransfer, uint256 _timestamp);
827 
828     event OfferMade(address indexed _fromUser, uint256 _tokenId, uint256 _offerId, uint256 _offeredPrice, uint256 _timestamp);
829 
830     event OfferApproved(address indexed _owner, uint256 _tokenId, uint256 _offerId, uint256 _offeredPrice, uint256 _timestamp);
831 
832     event OfferDeclined(address indexed _fromUser, uint256 _tokenId, uint256 _offerId, uint256 _offeredPrice, uint256 _timestamp);
833 
834     event ArtWorkChangeRequestMade(
835         address indexed _fromUser,
836         uint256 _tokenId,
837         uint256 _changeId,
838         string _meta,
839         uint256 _platformTransfer,
840         uint256 _timestamp);
841 
842     event ArtWorkChangeRequestApproved(
843         address indexed _fromUser,
844         uint256 _tokenId,
845         uint256 _changeId,
846         string _meta,
847         uint256 _timestamp);
848 
849     event ArtWorkChangeRequestDeclined(
850         address indexed _fromUser,
851         uint256 _tokenId,
852         uint256 _changeId,
853         string _meta,
854         uint256 _timestamp);
855 
856     event RemovedMetaData(uint256 _tokenId, address _admin, string _meta, uint256 _timestamp);
857     event ChangedOwnership(uint256 _tokenId, address _prevOwner, address _newOwner, uint256 _timestamp);
858 
859     constructor(
860         address _platformWallet, // owner collects money
861         address _token,
862         address _erc20token,
863         address _pricingStrategy,
864         address _signer
865     ) public {
866 
867         token = BigIoAdSpace(_token);
868         erc20token = BigIOERC20token(_erc20token);
869 
870         platformWallet = _platformWallet;
871 
872         pricingStrategy = PricingStrategy(_pricingStrategy);
873 
874         signers[_signer] = true;
875 
876         // 30%
877         tiers.push(
878             Tier(
879                 400, // amountInCenter
880                 600, // amountInOuter
881                 1 ether, // priceInCenter
882                 0.4 ether, // priceInOuter
883                 0, // soldInCenter
884                 0, // soldInOuter
885                 false, // filledInCenter
886                 false // filledInOuter
887             )
888         );
889         // 30%
890         tiers.push(
891             Tier(
892                 400, 600, 1.2 ether, 0.6 ether, 0, 0, false, false
893             )
894         );
895         // 30%
896         tiers.push(
897             Tier(
898                 400, 600, 1.4 ether, 0.8 ether, 0, 0, false, false
899             )
900         );
901         // 10%
902         tiers.push(
903             Tier(
904                 144, 288, 1.6 ether, 1.0 ether, 0, 0, false, false
905             )
906         );
907     }
908 
909     /// @notice init logo, call it as soon as possible
910     /// call it after setting platform in the token
911     /// Logo is BigIOToken which has 10*10 size and position in the center of map
912     function initLogo() public onlyOwner {
913         require(isLogoInitied == false);
914 
915         isLogoInitied = true;
916 
917         logoId = token.mint(platformWallet, logoX, logoY, 10, 10, 0 ether, 0 ether);
918 
919         token.setTokenMetadata(logoId, "");
920 
921         updateTierStatus(100, 0);
922 
923         emit Minted(msg.sender, logoId, logoX, logoY, 10, 10, 0 ether, 0 ether, now);
924     }
925 
926     function getPriceFor(uint256 x, uint256 y, uint256 sizeA, uint256 sizeB) public view returns(uint256 totalPrice, uint256 inner, uint256 outer) {
927         (inner, outer) = preMinting(x, y, sizeA, sizeB);
928 
929         totalPrice = calculateTokenPrice(inner, outer);
930 
931         return (totalPrice, inner, outer);
932     }
933 
934     /// @notice sell new tokens during the round 0
935     /// all except logo
936     function buy(
937         uint256 x, // top left coordinates
938         uint256 y, // top left coordinates
939         uint256 sizeA, // size/width of a square
940         uint256 sizeB, // size/height of a square,
941         uint8 _v,  // component of signature
942         bytes32 _r, // component of signature
943         bytes32 _s // component of signature
944     ) public notHalted() payable {
945         address recoveredSigner = verify(keccak256(msg.sender), _v, _r, _s);
946 
947         require(signers[recoveredSigner] == true);
948         require(msg.value > 0);
949 
950         internalBuy(x, y, sizeA, sizeB);
951     }
952 
953     function internalBuy(
954         uint256 x, // top left coordinates
955         uint256 y, // top left coordinates
956         uint256 sizeA, // size/width of a square
957         uint256 sizeB // size/height of a square,
958     ) internal {
959         // get and validate current tier
960         uint256 inner = 0;
961         uint256 outer = 0;
962         uint256 totalPrice = 0;
963 
964         (inner, outer) = preMinting(x, y, sizeA, sizeB);
965         totalPrice = calculateTokenPrice(inner, outer);
966 
967         require(totalPrice <= msg.value);
968 
969         //         try to mint and update current tier
970         updateTierStatus(inner, outer);
971 
972         uint256 actualPrice = inner.mul(tiers[3].priceInCenter).add(outer.mul(tiers[3].priceInOuter));
973 
974         if (msg.value > actualPrice) {
975             actualPrice = msg.value;
976         }
977 
978         uint256 tokenId = token.mint(msg.sender, x, y, sizeA, sizeB, msg.value, actualPrice);
979         erc20token.mint(msg.sender, inner.add(outer));
980 
981         transferEthers(platformWallet, msg.value);
982 
983         emit Minted(msg.sender, tokenId, x, y, sizeA, sizeB, msg.value, msg.value, now);
984     }
985 
986     /// @notice allow user to make an offer after initial phase(re-sale)
987     /// any offer minResalePercentage is accepted automatically
988     function makeOffer(
989         uint256 _tokenId,
990         uint8 _v,  // component of signature
991         bytes32 _r, // component of signature
992         bytes32 _s // component of signature
993     ) public notHalted() payable {
994 
995         address recoveredSigner = verify(keccak256(msg.sender), _v, _r, _s);
996 
997         require(signers[recoveredSigner] == true);
998 
999         require(msg.sender != address(0));
1000         require(msg.value > 0);
1001 
1002         uint256 currentPrice = getTokenPrice(_tokenId);
1003         require(currentPrice > 0);
1004 
1005         // special case for first sell of logo
1006         if (_tokenId == logoId && token.getCurrentPriceForToken(_tokenId) == 0) {
1007             require(msg.value >= logoPrice);
1008 
1009             //update token's state
1010             token.updateTokensState(logoId, msg.value);
1011 
1012             // mint erc20 tokens
1013             erc20token.mint(msg.sender, 100);
1014 
1015             transferEthers(platformWallet, msg.value);
1016 
1017             emit Purchased(0, msg.sender, _tokenId, msg.value, 0, 0, msg.value, now);
1018 
1019             return;
1020         }
1021 
1022         uint256 minPrice = pricingStrategy.calculateMinPriceForNextRound(currentPrice, minResalePercentage);
1023 
1024         require(msg.value >= minPrice);
1025 
1026         uint256 offerCounter = offers.length;
1027 
1028         offers.push(Offer(_tokenId, offerCounter, msg.sender, msg.value, currentPrice, false, now));
1029         emit OfferMade(msg.sender, _tokenId, offerCounter, msg.value, now);
1030 
1031         // 2. check condition for approve and do it
1032         approve(offerCounter, _tokenId);
1033     }
1034 
1035     function getTokenPrice(uint256 _tokenId) public view returns (uint256 price) {
1036 
1037         uint256 actualPrice = token.getCurrentPriceForToken(_tokenId);
1038 
1039         // special case for first sell of logo
1040         if (_tokenId == logoId && actualPrice == 0) {
1041             require(logoPrice > 0);
1042 
1043             return logoPrice;
1044         } else {
1045             uint256 indexInner = 0;
1046             uint256 indexOuter = 0;
1047 
1048             bool hasInner;
1049             bool hasOuter;
1050 
1051             (hasInner, hasOuter) = token.getTokenScope(_tokenId);
1052             (indexInner, indexOuter) = getCurrentTierIndex();
1053 
1054             if (_tokenId != logoId && hasInner) {
1055                 require(indexInner == 100000);
1056             }
1057 
1058             if (hasOuter) {
1059                 require(indexOuter == 100000);
1060             }
1061 
1062             return actualPrice;
1063         }
1064     }
1065 
1066     function getArtWorkChangeFee(uint256 _tokenId) public view returns (uint256 fee) {
1067 
1068         uint256 counter = token.getTokenUpdatedCounter(_tokenId);
1069 
1070         if (counter > 0) {
1071             return feeForArtWorkChangeRequest;
1072         }
1073 
1074         return feeForFirstArtWorkChangeRequest;
1075     }
1076 
1077     /// @notice it allows token owner to create art work change request
1078     /// first user upload 2 images
1079     /// then do call this function
1080     /// admin can reject or approve it
1081     function artWorkChangeRequest(uint256 _tokenId, string _meta, uint8 _v, bytes32 _r, bytes32 _s)
1082         public payable returns (uint256)
1083     {
1084 
1085         address recoveredSigner = verify(keccak256(_meta), _v, _r, _s);
1086 
1087         require(signers[recoveredSigner] == true);
1088 
1089         require(msg.sender == token.getOwner(_tokenId));
1090 
1091         uint256 fee = getArtWorkChangeFee(_tokenId);
1092 
1093         require(msg.value >= fee);
1094 
1095         uint256 changeRequestCounter = artWorkChangeRequests.length;
1096 
1097         artWorkChangeRequests.push(
1098             ArtWorkChangeRequest(msg.sender, _tokenId, changeRequestCounter, _meta, now, false)
1099         );
1100 
1101         token.increaseUpdateMetadataCounter(_tokenId);
1102 
1103         transferEthers(platformWallet, msg.value);
1104 
1105         emit ArtWorkChangeRequestMade(msg.sender, _tokenId, changeRequestCounter, _meta, msg.value, now);
1106 
1107         return changeRequestCounter;
1108     }
1109 
1110     function artWorkChangeApprove(uint256 _index, uint256 _tokenId, bool approve) public onlyAdmin {
1111         ArtWorkChangeRequest storage request = artWorkChangeRequests[_index];
1112         require(false == request.isReviewed);
1113 
1114         require(_tokenId == request.tokenId);
1115         request.isReviewed = true;
1116         if (approve) {
1117             token.setTokenMetadata(_tokenId, request.meta);
1118             emit ArtWorkChangeRequestApproved(
1119                 request.fromUser,
1120                 request.tokenId,
1121                 request.changeId,
1122                 request.meta,
1123                 now
1124             );
1125         } else {
1126             emit ArtWorkChangeRequestDeclined(
1127                 request.fromUser,
1128                 request.tokenId,
1129                 request.changeId,
1130                 request.meta,
1131                 now
1132             );
1133         }
1134     }
1135 
1136     function artWorkChangeByAdmin(uint256 _tokenId, string _meta, uint256 _changeId) public onlyAdmin {
1137         token.setTokenMetadata(_tokenId, _meta);
1138         emit ArtWorkChangeRequestApproved(
1139             msg.sender,
1140             _tokenId,
1141             _changeId,
1142             _meta,
1143             now
1144         );
1145     }
1146 
1147     function changeTokenOwnerByAdmin(uint256 _tokenId, address _newOwner) public onlyAdmin {
1148         address prevOwner = token.getOwner(_tokenId);
1149         token.updateOwner(_tokenId, _newOwner, prevOwner);
1150         emit ChangedOwnership(_tokenId, prevOwner, _newOwner, now);
1151         string memory meta = token.getMetadata(_tokenId);
1152         token.removeTokenMetadata(_tokenId);
1153         emit RemovedMetaData(_tokenId, msg.sender, meta, now);
1154     }
1155 
1156     /// @return tokenId, x, y, sizeA, sizeB, price
1157     function getTokenData(uint256 _tokenId) public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1158         return token.getTokenData(_tokenId);
1159     }
1160 
1161     function getMetaData(uint256 _tokenId) public view returns(string) {
1162         return token.getMetadata(_tokenId);
1163     }
1164 
1165     /// @notice Withdraw a bid that was overbid and platform owner share
1166     function claim() public returns (bool) {
1167         return claimInternal(msg.sender);
1168     }
1169 
1170     /// @notice Withdraw (for cold storage wallet) a bid that was overbid and platform owner share
1171     function claimByAddress(address _address) public returns (bool) {
1172         return claimInternal(_address);
1173     }
1174 
1175     function claimInternal(address _address) internal returns (bool) {
1176         require(_address != address(0));
1177 
1178         uint256 amount = pendingReturns[_address];
1179 
1180         if (amount == 0) {
1181             return;
1182         }
1183 
1184         pendingReturns[_address] = 0;
1185 
1186         _address.transfer(amount);
1187 
1188         return true;
1189     }
1190 
1191     /// @return index of current tiers, if 100000(cannot use -1) then round 0  finished
1192     /// and we need to move to re-sale
1193     function getCurrentTierIndex() public view returns (uint256, uint256) {
1194         // cannot use -1
1195         // so use not possible value for tiers.length
1196         uint256 indexInner = 100000;
1197         uint256 indexOuter = 100000;
1198 
1199         for (uint256 i = 0; i < tiers.length; i++) {
1200             if (!tiers[i].filledInCenter) {
1201                 indexInner = i;
1202                 break;
1203             }
1204         }
1205 
1206         for (uint256 k = 0; k < tiers.length; k++) {
1207             if (!tiers[k].filledInOuter) {
1208                 indexOuter = k;
1209                 break;
1210             }
1211         }
1212 
1213         return (indexInner, indexOuter);
1214     }
1215 
1216     /// @return current tier stats
1217     /// index of current tiers, if 100000(cannot use -1) then initial sale is  finished
1218     /// works only during the initial phase
1219     function getCurrentTierStats() public view returns (uint256 indexInner, uint256 indexOuter, uint256 availableInner, uint256 availableInOuter, uint256 priceInCenter, uint256 priceInOuter, uint256 nextPriceInCenter, uint256 nextPriceInOuter) {
1220 
1221         indexInner = 100000;
1222         indexOuter = 100000;
1223 
1224         for (uint256 i = 0; i < tiers.length; i++) {
1225             if (!tiers[i].filledInCenter) {
1226                 indexInner = i;
1227                 break;
1228             }
1229         }
1230 
1231         for (uint256 k = 0; k < tiers.length; k++) {
1232             if (!tiers[k].filledInOuter) {
1233                 indexOuter = k;
1234                 break;
1235             }
1236         }
1237 
1238         Tier storage tier;
1239 
1240         if (indexInner != 100000) {
1241             tier = tiers[indexInner];
1242 
1243             availableInner = tier.amountInCenter.sub(tier.soldInCenter);
1244 
1245             priceInCenter = tier.priceInCenter;
1246 
1247             if (indexInner < 3) {
1248                 nextPriceInCenter = tiers[indexInner + 1].priceInCenter;
1249             }
1250         }
1251 
1252         if (indexOuter != 100000) {
1253             tier = tiers[indexOuter];
1254 
1255             availableInOuter = tier.amountInOuter.sub(tier.soldInOuter);
1256 
1257             priceInOuter = tier.priceInOuter;
1258 
1259             if (indexOuter < 3) {
1260                 nextPriceInOuter = tiers[indexOuter + 1].priceInOuter;
1261             }
1262         }
1263     }
1264 
1265     function calculateAmountOfUnits(uint256 sizeA, uint256 sizeB) public pure returns (uint256) {
1266         return sizeA.mul(sizeB);
1267     }
1268 
1269     /// @notice approve the offer
1270     function approve(uint256 _index, uint256 _tokenId) internal {
1271         Offer memory localOffer = offers[_index];
1272 
1273         address newOwner = localOffer.from;
1274         address prevOwner = token.getOwner(_tokenId);
1275 
1276         uint256 platformShare;
1277         uint256 forPrevOwner;
1278 
1279         uint256 soldPrice = token.getTokenSoldPrice(_tokenId);
1280 
1281         (platformShare, forPrevOwner) = pricingStrategy.calculateSharesInTheRevenue(
1282             soldPrice, localOffer.offeredPrice);
1283 
1284         //update token's state
1285         token.updateTokensState(_tokenId, localOffer.offeredPrice);
1286 
1287         // update owner
1288         token.updateOwner(_tokenId, newOwner, prevOwner);
1289         localOffer.accepted = true;
1290 
1291         transferEthers(platformWallet, platformShare);
1292         transferEthers(prevOwner, forPrevOwner.add(soldPrice));
1293 
1294         emit OfferApproved(newOwner, _tokenId, localOffer.offerId, localOffer.offeredPrice, now);
1295         emit Purchased(prevOwner, newOwner, _tokenId, localOffer.offeredPrice, soldPrice, forPrevOwner.add(soldPrice), platformShare, now);
1296 
1297         afterApproveAction(_tokenId);
1298     }
1299 
1300     function transferEthers(address _address, uint256 _wei) internal {
1301         if (isContract(_address)) {
1302             pendingReturns[_address] = pendingReturns[_address].add(_wei);
1303         }
1304         else {
1305             _address.transfer(_wei);
1306         }
1307     }
1308 
1309     function preMinting(uint256 x, uint256 y, uint256 sizeA, uint256 sizeB) internal view returns (uint256, uint256) {
1310         //  calculate units for token
1311         uint256 total = 0;
1312         uint256 inner = 0;
1313         uint256 outer = 0;
1314 
1315 
1316         (total, inner) = token.calculateCounters(x, y, sizeA, sizeB);
1317         outer = total.sub(inner);
1318 
1319         require(total <= 100);
1320 
1321         return (inner, outer);
1322     }
1323 
1324     function updateTierStatus(uint256 inner, uint256 outer) internal {
1325         uint256 leftInner = inner;
1326         uint256 leftOuter = outer;
1327 
1328         for (uint256 i = 0; i < 4; i++) {
1329             Tier storage tier = tiers[i];
1330 
1331             if (leftInner > 0 && tier.filledInCenter == false) {
1332                 uint256 availableInner = tier.amountInCenter.sub(tier.soldInCenter);
1333 
1334                 if (availableInner > leftInner) {
1335                     tier.soldInCenter = tier.soldInCenter.add(leftInner);
1336 
1337                     leftInner = 0;
1338                 } else {
1339                     tier.filledInCenter = true;
1340                     tier.soldInCenter = tier.amountInCenter;
1341 
1342                     leftInner = leftInner.sub(availableInner);
1343                 }
1344             }
1345 
1346             if (leftOuter > 0 && tier.filledInOuter == false) {
1347                 uint256 availableOuter = tier.amountInOuter.sub(tier.soldInOuter);
1348 
1349                 if (availableOuter > leftOuter) {
1350                     tier.soldInOuter = tier.soldInOuter.add(leftOuter);
1351 
1352                     leftOuter = 0;
1353                 } else {
1354                     tier.filledInOuter = true;
1355                     tier.soldInOuter = tier.amountInOuter;
1356 
1357                     leftOuter = leftOuter.sub(availableOuter);
1358                 }
1359             }
1360         }
1361 
1362         require(leftInner == 0 && leftOuter == 0);
1363     }
1364 
1365     function calculateTokenPrice(uint256 inner, uint256 outer) public view returns (uint256 price) {
1366         uint256 leftInner = inner;
1367         uint256 leftOuter = outer;
1368 
1369         for (uint256 i = 0; i < 4; i++) {
1370             Tier storage tier = tiers[i];
1371 
1372             if (leftInner > 0 && tier.filledInCenter == false) {
1373                 uint256 availableInner = tier.amountInCenter.sub(tier.soldInCenter);
1374 
1375                 if (availableInner > leftInner) {
1376                     price = price.add(leftInner.mul(tier.priceInCenter));
1377                     leftInner = 0;
1378                 } else {
1379                     price = price.add(availableInner.mul(tier.priceInCenter));
1380                     leftInner = leftInner.sub(availableInner);
1381                 }
1382             }
1383 
1384             if (leftOuter > 0 && tier.filledInOuter == false) {
1385                 uint256 availableOuter = tier.amountInOuter.sub(tier.soldInOuter);
1386 
1387                 if (availableOuter > leftOuter) {
1388                     price = price.add(leftOuter.mul(tier.priceInOuter));
1389                     leftOuter = 0;
1390                 } else {
1391                     price = price.add(availableOuter.mul(tier.priceInOuter));
1392                     leftOuter = leftOuter.sub(availableOuter);
1393                 }
1394             }
1395         }
1396 
1397         require(leftInner == 0 && leftOuter == 0);
1398     }
1399 
1400     function minPriceForNextRound(uint256 _tokenId) public view returns (uint256) {
1401         if (_tokenId == logoId && token.getCurrentPriceForToken(_tokenId) == 0) {
1402             return logoPrice;
1403         } else {
1404             // @TODO: check if sold-out
1405 
1406             uint256 currentPrice = getTokenPrice(_tokenId);
1407             uint256 minPrice = pricingStrategy.calculateMinPriceForNextRound(currentPrice, minResalePercentage);
1408             return minPrice;
1409         }
1410     }
1411 
1412     function afterApproveAction(uint256 _tokenId) internal {
1413 
1414         uint256 indexInner = 100000;
1415         uint256 indexOuter = 100000;
1416 
1417         bool hasInner;
1418         bool hasOuter;
1419 
1420         (hasInner, hasOuter) = token.getTokenScope(_tokenId);
1421         (indexInner, indexOuter) = getCurrentTierIndex();
1422 
1423         if (hasInner && hasOuter && indexInner == 100000 && indexOuter == 100000) {
1424             token.increasePriceForNeighbours(_tokenId);
1425         } else if (!hasInner && hasOuter && indexOuter == 100000) {
1426             token.increasePriceForNeighbours(_tokenId);
1427         } else if (!hasOuter && hasInner && indexInner == 100000) {
1428             token.increasePriceForNeighbours(_tokenId);
1429         }
1430     }
1431 
1432     function canBuyExistentToken(uint256 _tokenId) public view returns (uint256 _allowed) {
1433         uint256 indexInner = 0;
1434         uint256 indexOuter = 0;
1435 
1436         bool hasInner;
1437         bool hasOuter;
1438 
1439         (hasInner, hasOuter) = token.getTokenScope(_tokenId);
1440         (indexInner, indexOuter) = getCurrentTierIndex();
1441 
1442         if (token.getCurrentPriceForToken(_tokenId) == 0 && logoPrice == 0) {
1443             return 4;
1444         }
1445 
1446         if (_tokenId != logoId && hasInner && indexInner != 100000) {
1447             return 2;
1448         }
1449 
1450         if (hasOuter && indexOuter != 100000) {
1451             return 3;
1452         }
1453 
1454         return 1;
1455     }
1456 }