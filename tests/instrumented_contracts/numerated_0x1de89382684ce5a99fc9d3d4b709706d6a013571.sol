1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 /**
55  * Utility library of inline functions on addresses
56  */
57 library AddressUtils {
58 
59   /**
60    * Returns whether the target address is a contract
61    * @dev This function will return false if invoked during the constructor of a contract,
62    * as the code is not actually created until after the constructor finishes.
63    * @param addr address to check
64    * @return whether the target address is a contract
65    */
66   function isContract(address addr) internal view returns (bool) {
67     uint256 size;
68     // XXX Currently there is no better way to check if there is a contract in an address
69     // than to check the size of the code at that address.
70     // See https://ethereum.stackexchange.com/a/14016/36603
71     // for more details about how this works.
72     // TODO Check this again before the Serenity release, because all addresses will be
73     // contracts then.
74     // solium-disable-next-line security/no-inline-assembly
75     assembly { size := extcodesize(addr) }
76     return size > 0;
77   }
78 
79 }
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87     address public owner;
88     address public admin;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91     /**
92      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93      * account.
94      */
95     constructor() public {
96         owner = msg.sender;
97         admin = msg.sender;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107 
108     modifier onlyAdmin() {
109         require(msg.sender == admin || msg.sender == owner);
110         _;
111     }
112 
113     /**
114      * @dev Allows the current owner to transfer control of the contract to a newOwner.
115      * @param newOwner The address to transfer ownership to.
116      */
117     function transferOwnership(address newOwner) public onlyOwner {
118         require(newOwner != address(0));
119         emit OwnershipTransferred(owner, newOwner);
120         owner = newOwner;
121     }
122 
123     function setAdmin(address newAdmin) public onlyOwner {
124         require(newAdmin != address(0));
125         admin = newAdmin;
126     }
127 }
128 
129 /**
130  * @title Pausable
131  * @dev Base contract which allows children to implement an emergency stop mechanism.
132  */
133 contract Pausable is Ownable {
134     bool public paused = true;
135 
136     /**
137      * @dev modifier to allow actions only when the contract IS paused
138      */
139     modifier whenNotPaused() {
140         require(!paused);
141         _;
142     }
143 
144     /**
145      * @dev modifier to allow actions only when the contract IS NOT paused
146      */
147     modifier whenPaused {
148         require(paused);
149         _;
150     }
151 
152     /**
153      * @dev called by the owner to pause, triggers stopped state
154      */
155     function pause() public onlyOwner whenNotPaused {
156         paused = true;
157     }
158 
159     /**
160      * @dev called by the owner to unpause, returns to normal state
161      */
162     function unpause() public onlyOwner whenPaused {
163         paused = false;
164     }
165 }
166 
167 contract BrokenContract is Pausable {
168     /// Set in case the core contract is broken and an upgrade is required
169     address public newContractAddress;
170 
171     ///@dev only for serious breaking bug
172     function setNewAddress(address _v2Address) external onlyOwner whenPaused {
173         //withdraw all balance when contract update
174         owner.transfer(address(this).balance);
175 
176         newContractAddress = _v2Address;
177     }
178 }
179 
180 
181 /**
182  * @title ERC721 Non-Fungible Token Standard basic interface
183  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
184  */
185 contract ERC721Basic {
186     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
187     //event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
188 
189     function balanceOf(address _owner) public view returns (uint256 _balance);
190     function ownerOf(uint256 _tokenId) public view returns (address _owner);
191     function exists(uint256 _tokenId) public view returns (bool _exists);
192 
193     //function approve(address _to, uint256 _tokenId) public;
194     //function getApproved(uint256 _tokenId) public view returns (address _operator);
195     //function transferFrom(address _from, address _to, uint256 _tokenId) public;
196 }
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
200  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
201  */
202 contract ERC721Enumerable is ERC721Basic {
203     function totalSupply() public view returns (uint256);
204     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
205     function tokenByIndex(uint256 _index) public view returns (uint256);
206 }
207 
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
212  */
213 contract ERC721Metadata is ERC721Basic {
214     function name() public view returns (string _name);
215     function symbol() public view returns (string _symbol);
216 }
217 
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
221  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
222  */
223 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
224 }
225 
226 /**
227  * @title ERC721 Non-Fungible Token Standard basic implementation
228  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
229  */
230 contract ERC721BasicToken is BrokenContract, ERC721Basic {
231     using SafeMath for uint256;
232     using AddressUtils for address;
233 
234     // Mapping from token ID to owner
235     mapping (uint256 => address) internal tokenOwner;
236 
237     // Mapping from token ID to approved address
238     //mapping (uint256 => address) internal tokenApprovals;
239 
240     // Mapping from owner to number of owned token
241     mapping (address => uint256) internal ownedTokensCount;
242 
243     /**
244      * @dev Guarantees msg.sender is owner of the given token
245      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
246      */
247     modifier onlyOwnerOf(uint256 _tokenId) {
248         require(ownerOf(_tokenId) == msg.sender);
249         _;
250     }
251 
252     /**
253      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
254      * @param _tokenId uint256 ID of the token to validate
255      */
256     /*modifier canTransfer(uint256 _tokenId) {
257         require(isApprovedOrOwner(msg.sender, _tokenId));
258         _;
259     }*/
260 
261     /**
262      * @dev Gets the balance of the specified address
263      * @param _owner address to query the balance of
264      * @return uint256 representing the amount owned by the passed address
265      */
266     function balanceOf(address _owner) public view returns (uint256) {
267         require(_owner != address(0));
268         return ownedTokensCount[_owner];
269     }
270 
271     /**
272      * @dev Gets the owner of the specified token ID
273      * @param _tokenId uint256 ID of the token to query the owner of
274      * @return owner address currently marked as the owner of the given token ID
275      */
276     function ownerOf(uint256 _tokenId) public view returns (address) {
277         address owner = tokenOwner[_tokenId];
278         require(owner != address(0));
279         return owner;
280     }
281 
282     /**
283      * @dev Returns whether the specified token exists
284      * @param _tokenId uint256 ID of the token to query the existence of
285      * @return whether the token exists
286      */
287     function exists(uint256 _tokenId) public view returns (bool) {
288         address owner = tokenOwner[_tokenId];
289         return owner != address(0);
290     }
291 
292     /**
293      * @dev Approves another address to transfer the given token ID
294      * @dev The zero address indicates there is no approved address.
295      * @dev There can only be one approved address per token at a given time.
296      * @dev Can only be called by the token owner or an approved operator.
297      * @param _to address to be approved for the given token ID
298      * @param _tokenId uint256 ID of the token to be approved
299      */
300     /*function approve(address _to, uint256 _tokenId) public whenNotPaused {
301         address owner = ownerOf(_tokenId);
302         require(_to != owner);
303         require(msg.sender == owner);
304 
305         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
306             tokenApprovals[_tokenId] = _to;
307             emit Approval(owner, _to, _tokenId);
308         }
309     }*/
310 
311     /**
312      * @dev Gets the approved address for a token ID, or zero if no address set
313      * @param _tokenId uint256 ID of the token to query the approval of
314      * @return address currently approved for the given token ID
315      */
316     /*function getApproved(uint256 _tokenId) public view returns (address) {
317         return tokenApprovals[_tokenId];
318     }*/
319 
320     /**
321      * @dev Transfers the ownership of a given token ID to another address
322      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
323      * @dev Requires the msg sender to be the owner, approved, or operator
324      * @param _from current owner of the token
325      * @param _to address to receive the ownership of the given token ID
326      * @param _tokenId uint256 ID of the token to be transferred
327     */
328     /*function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused canTransfer(_tokenId) {
329         require(_from != address(0));
330         require(_to != address(0));
331 
332         clearApproval(_from, _tokenId);
333         removeTokenFrom(_from, _tokenId);
334         addTokenTo(_to, _tokenId);
335 
336         emit Transfer(_from, _to, _tokenId);
337     }*/
338 
339     /**
340      * @dev Returns whether the given spender can transfer a given token ID
341      * @param _spender address of the spender to query
342      * @param _tokenId uint256 ID of the token to be transferred
343      * @return bool whether the msg.sender is approved for the given token ID,
344      *  is an operator of the owner, or is the owner of the token
345      */
346     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
347         address owner = ownerOf(_tokenId);
348         return _spender == owner/* || getApproved(_tokenId) == _spender*/;
349     }
350 
351     /**
352      * @dev Internal function to mint a new token
353      * @dev Reverts if the given token ID already exists
354      * @param _to The address that will own the minted token
355      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
356      */
357     function _mint(address _to, uint256 _tokenId) internal {
358         require(_to != address(0));
359         addTokenTo(_to, _tokenId);
360         emit Transfer(address(0), _to, _tokenId);
361     }
362 
363     /**
364      * @dev Internal function to clear current approval of a given token ID
365      * @dev Reverts if the given address is not indeed the owner of the token
366      * @param _owner owner of the token
367      * @param _tokenId uint256 ID of the token to be transferred
368      */
369     /*function clearApproval(address _owner, uint256 _tokenId) internal {
370         require(ownerOf(_tokenId) == _owner);
371         if (tokenApprovals[_tokenId] != address(0)) {
372             tokenApprovals[_tokenId] = address(0);
373             emit Approval(_owner, address(0), _tokenId);
374         }
375     }*/
376 
377     /**
378      * @dev Internal function to add a token ID to the list of a given address
379      * @param _to address representing the new owner of the given token ID
380      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
381      */
382     function addTokenTo(address _to, uint256 _tokenId) internal {
383         require(tokenOwner[_tokenId] == address(0));
384         tokenOwner[_tokenId] = _to;
385         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
386     }
387 
388     /**
389      * @dev Internal function to remove a token ID from the list of a given address
390      * @param _from address representing the previous owner of the given token ID
391      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
392      */
393     function removeTokenFrom(address _from, uint256 _tokenId) internal {
394         require(ownerOf(_tokenId) == _from);
395         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
396         tokenOwner[_tokenId] = address(0);
397     }
398 }
399 
400 
401 /**
402  * @title Full ERC721 Token
403  * This implementation includes all the required and some optional functionality of the ERC721 standard
404  * Moreover, it includes approve all functionality using operator terminology
405  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
406  */
407 contract ERC721Token is ERC721, ERC721BasicToken {
408     // Token name
409     string internal name_;
410 
411     // Token symbol
412     string internal symbol_;
413 
414     // Mapping from owner to list of owned token IDs
415     mapping(address => uint256[]) internal ownedTokens;
416 
417     // Mapping from token ID to index of the owner tokens list
418     mapping(uint256 => uint256) internal ownedTokensIndex;
419 
420     // Array with all token ids, used for enumeration
421     uint256[] internal allTokens;
422 
423     // Mapping from token id to position in the allTokens array
424     mapping(uint256 => uint256) internal allTokensIndex;
425 
426     /**
427      * @dev Constructor function
428      */
429     constructor(string _name, string _symbol) public {
430         name_ = _name;
431         symbol_ = _symbol;
432     }
433 
434     /**
435      * @dev Gets the token name
436      * @return string representing the token name
437      */
438     function name() public view returns (string) {
439         return name_;
440     }
441 
442     /**
443      * @dev Gets the token symbol
444      * @return string representing the token symbol
445      */
446     function symbol() public view returns (string) {
447         return symbol_;
448     }
449 
450     /**
451      * @dev Gets the token ID at a given index of the tokens list of the requested owner
452      * @param _owner address owning the tokens list to be accessed
453      * @param _index uint256 representing the index to be accessed of the requested tokens list
454      * @return uint256 token ID at the given index of the tokens list owned by the requested address
455      */
456     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
457         require(_index < balanceOf(_owner));
458         return ownedTokens[_owner][_index];
459     }
460 
461     /**
462      * @dev Gets the total amount of tokens stored by the contract
463      * @return uint256 representing the total amount of tokens
464      */
465     function totalSupply() public view returns (uint256) {
466         return allTokens.length;
467     }
468 
469     /**
470      * @dev Gets the token ID at a given index of all the tokens in this contract
471      * @dev Reverts if the index is greater or equal to the total number of tokens
472      * @param _index uint256 representing the index to be accessed of the tokens list
473      * @return uint256 token ID at the given index of the tokens list
474      */
475     function tokenByIndex(uint256 _index) public view returns (uint256) {
476         require(_index < totalSupply());
477         return allTokens[_index];
478     }
479 
480     /**
481      * @dev Internal function to add a token ID to the list of a given address
482      * @param _to address representing the new owner of the given token ID
483      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
484      */
485     function addTokenTo(address _to, uint256 _tokenId) internal {
486         super.addTokenTo(_to, _tokenId);
487         uint256 length = ownedTokens[_to].length;
488         ownedTokens[_to].push(_tokenId);
489         ownedTokensIndex[_tokenId] = length;
490     }
491 
492     /**
493    * @dev Internal function to remove a token ID from the list of a given address
494    * @param _from address representing the previous owner of the given token ID
495    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
496    */
497     function removeTokenFrom(address _from, uint256 _tokenId) internal {
498         super.removeTokenFrom(_from, _tokenId);
499 
500         uint256 tokenIndex = ownedTokensIndex[_tokenId];
501         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
502         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
503 
504         ownedTokens[_from][tokenIndex] = lastToken;
505         ownedTokens[_from][lastTokenIndex] = 0;
506         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
507         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
508         // the lastToken to the first position, and then dropping the element placed in the last position of the list
509 
510         ownedTokens[_from].length--;
511         ownedTokensIndex[_tokenId] = 0;
512         ownedTokensIndex[lastToken] = tokenIndex;
513     }
514 
515     /**
516      * @dev Internal function to mint a new token
517      * @dev Reverts if the given token ID already exists
518      * @param _to address the beneficiary that will own the minted token
519      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
520      */
521     function _mint(address _to, uint256 _tokenId) internal {
522         super._mint(_to, _tokenId);
523 
524         allTokensIndex[_tokenId] = allTokens.length;
525         allTokens.push(_tokenId);
526     }
527 
528 }
529 
530 
531 ///@dev Base game contract. Holds all common structs, events and base variables.
532 contract BaseGame is ERC721Token {
533     /// EVENTS
534     ///@dev the Created event is fired whenever create or clone new fan token
535     event NewAccount(address owner, uint tokenId, uint parentTokenId, uint blockNumber);
536 
537     ///@dev the NewForecast event is fired whenever any user create new forecast for game
538     event NewForecast(address owner, uint tokenId, uint forecastId, uint _gameId,
539         uint _forecastData);
540 
541     /// STRUCTS
542     ///@dev Token - main token struct
543     struct Token {
544         // create block number, for tournament round, and date
545         uint createBlockNumber;
546 
547         // parent
548         uint parentId;
549     }
550 
551     enum Teams { DEF,
552         RUS, SAU, EGY, URY,     // group A
553         PRT, ESP, MAR, IRN,     // group B
554         FRA, AUS, PER, DNK,     // group C
555         ARG, ISL, HRV, NGA,     // D
556         BRA, CHE, CRI, SRB,     // E
557         DEU, MEX, SWE, KOR,     // F
558         BEL, PAN, TUN, GBR,     // G
559         POL, SEN, COL, JPN      // H
560     }
561 
562     ///#dev game changed event
563     event GameChanged(uint _gameId, uint64 gameDate, Teams teamA, Teams teamB,
564         uint goalA, uint goalB, bool odds, uint shotA, uint shotB);
565 
566 
567     ///@dev Game info with result, index = official game id
568     struct Game {
569         // timestamp game date
570         uint64 gameDate;
571 
572         // id teamA and teamB
573         Teams teamA;
574         Teams teamB;
575 
576         // count of total goal
577         uint goalA;
578         uint goalB;
579 
580         // game overweight / true - A / false - B
581         bool odds;
582 
583         // total blows on target
584         uint shotA;
585         uint shotB;
586 
587         // list of ID forecast's
588         uint[] forecasts;
589     }
590 
591     ///@dev Forecast - fan forecast to game
592     struct Forecast {
593         // bits forecast for game from fan
594         uint gameId;
595         uint forecastBlockNumber;
596 
597         uint forecastData;
598     }
599 
600     /// STORAGE
601     ///@dev array of token fans
602     Token[] tokens;
603 
604     ///@dev array of game from, 0 - invalid, index - official ID of game
605     // http://welcome2018.com/matches/#
606     //Game[65] games;
607     mapping (uint => Game) games;
608 
609     ///@dev array of forecast for game from fans
610     Forecast[] forecasts;
611 
612     ///@dev forecast -> token
613     mapping (uint => uint) internal forecastToToken;
614 
615     ///@dev token -> forecast's
616     mapping (uint => uint[]) internal tokenForecasts;
617 
618     /**
619     * @dev Constructor function
620     */
621     constructor(string _name, string _symbol) ERC721Token(_name, _symbol) public {}
622 
623     /// METHOD's
624     ///@dev create new token
625     function _createToken(uint _parentId, address _owner) internal whenNotPaused
626     returns (uint) {
627         Token memory _token = Token({
628             createBlockNumber: block.number,
629             parentId: _parentId
630             });
631         uint newTokenId = tokens.push(_token) - 1;
632 
633         emit NewAccount(_owner, newTokenId, uint(_token.parentId), uint(_token.createBlockNumber));
634         _mint(_owner, newTokenId);
635         return newTokenId;
636     }
637 
638     ///@dev Create new forecast
639     function _createForecast(uint _tokenId, uint _gameId, uint _forecastData) internal whenNotPaused returns (uint) {
640         require(_tokenId < tokens.length);
641 
642         Forecast memory newForecast = Forecast({
643             gameId: _gameId,
644             forecastBlockNumber: block.number,
645             forecastData: _forecastData
646             });
647 
648         uint newForecastId = forecasts.push(newForecast) - 1;
649 
650         forecastToToken[newForecastId] = _tokenId;
651         tokenForecasts[_tokenId].push(newForecastId);
652         games[_gameId].forecasts.push(newForecastId);
653 
654         //fire forecast!
655         emit NewForecast(tokenOwner[_tokenId], _tokenId, newForecastId, _gameId, _forecastData);
656         return newForecastId;
657     }    
658 }
659 
660 
661 contract BaseGameLogic is BaseGame {
662 
663     ///@dev prize fund count
664     uint public prizeFund = 0;
665     ///@dev payment for create new Token
666     uint public basePrice = 21 finney;
667     ///@dev cut game on each clone operation, measured in basis points (1/100 of a percent).
668 
669     /// values 0 - 10 000 -> 0 - 100%
670     uint public gameCloneFee = 7000;         /// % game fee (contract + prizeFund)
671     uint public priceFactor = 10000;         /// %% calculate price (increase/decrease)
672     uint public prizeFundFactor = 5000;      /// %% prizeFund
673 
674     /**
675     * @dev Constructor function
676     */
677     constructor(string _name, string _symbol) BaseGame(_name, _symbol) public {}
678 
679     ///@dev increase prize fund
680     function _addToFund(uint _val, bool isAll) internal whenNotPaused {
681         if(isAll) {
682             prizeFund = prizeFund.add(_val);
683         } else {
684             prizeFund = prizeFund.add(_val.mul(prizeFundFactor).div(10000));
685         }
686     }
687 
688     ///@dev create new Token
689     function createAccount() external payable whenNotPaused returns (uint) {
690         require(msg.value >= basePrice);
691 
692         ///todo: return excess funds
693         _addToFund(msg.value, false);
694         return _createToken(0, msg.sender);
695     }
696 
697     ///@dev buy clone of token
698     function cloneAccount(uint _tokenId) external payable whenNotPaused returns (uint) {
699         require(exists(_tokenId));
700 
701         uint tokenPrice = calculateTokenPrice(_tokenId);
702         require(msg.value >= tokenPrice);
703 
704         /// create clone
705         uint newToken = _createToken( _tokenId, msg.sender);
706 
707         /// calculate game fee
708         //uint gameFee = _calculateGameFee(tokenPrice);
709         uint gameFee = tokenPrice.mul(gameCloneFee).div(10000);
710         /// increase prizeFund
711         _addToFund(gameFee, false);
712         /// send income to token owner
713         uint ownerProceed = tokenPrice.sub(gameFee);
714         address tokenOwnerAddress = tokenOwner[_tokenId];
715         tokenOwnerAddress.transfer(ownerProceed);
716 
717         return newToken;
718     }
719 
720 
721     ///@dev create forecast, check game stop
722     function createForecast(uint _tokenId, uint _gameId,
723         uint8 _goalA, uint8 _goalB, bool _odds, uint8 _shotA, uint8 _shotB)
724     external whenNotPaused onlyOwnerOf(_tokenId) returns (uint){
725         require(exists(_tokenId));
726         require(block.timestamp < games[_gameId].gameDate);
727 
728         uint _forecastData = toForecastData(_goalA, _goalB, _odds, _shotA, _shotB);
729         return _createForecast(_tokenId, _gameId, _forecastData);
730 
731         //check exist forecast from this token/account
732         /* uint forecastId = 0;
733         uint _forecastCount = tokenForecasts[_tokenId].length;
734         uint _testForecastId;
735         for (uint _forecastIndex = 0; _forecastIndex < _forecastCount; _forecastIndex++) {
736             _testForecastId = tokenForecasts[_tokenId][_forecastIndex];
737             if(forecasts[_testForecastId].gameId == _gameId) {
738                 forecastId = _testForecastId;
739                 break;
740             }
741         }
742 
743         uint _forecastData = toForecastData(_goalA, _goalB, _odds, _shotA, _shotB);
744 
745         if(forecastId > 0) {
746             return _editForecast(forecastId, _forecastData);
747         } else {
748             return _createForecast(_tokenId, _gameId, _forecastData);
749         } */
750     }
751 
752     ///@dev get list of token
753     function tokensOfOwner(address _owner) public view returns(uint[] ownerTokens) {
754         uint tokenCount = balanceOf(_owner);
755 
756         if (tokenCount == 0) {
757             // Return an empty array
758             return new uint[](0);
759         } else {
760             uint[] memory result = new uint[](tokenCount);
761             uint totalToken = totalSupply();
762             uint resultIndex = 0;
763 
764             uint _tokenId;
765             for (_tokenId = 1; _tokenId <= totalToken; _tokenId++) {
766                 if (tokenOwner[_tokenId] == _owner) {
767                     result[resultIndex] = _tokenId;
768                     resultIndex++;
769                 }
770             }
771 
772             return result;
773         }
774     }
775 
776     ///@dev get list of forecast by token
777     function forecastOfToken(uint _tokenId) public view returns(uint[]) {
778         uint forecastCount = tokenForecasts[_tokenId].length;
779 
780         if (forecastCount == 0) {
781             // Return an empty array
782             return new uint[](0);
783         } else {
784             uint[] memory result = new uint[](forecastCount);
785             uint resultIndex;
786             for (resultIndex = 0; resultIndex < forecastCount; resultIndex++) {
787                 result[resultIndex] = tokenForecasts[_tokenId][resultIndex];
788             }
789 
790             return result;
791         }
792     }
793 
794     ///@dev get info by game
795     function gameInfo(uint _gameId) external view returns(
796         uint64 gameDate, Teams teamA, Teams teamB, uint goalA, uint gaolB,
797         bool odds, uint shotA, uint shotB, uint forecastCount
798     ){
799         gameDate = games[_gameId].gameDate;
800         teamA = games[_gameId].teamA;
801         teamB = games[_gameId].teamB;
802         goalA = games[_gameId].goalA;
803         gaolB = games[_gameId].goalB;
804         odds = games[_gameId].odds;
805         shotA = games[_gameId].shotA;
806         shotB = games[_gameId].shotB;
807         forecastCount = games[_gameId].forecasts.length;
808     }
809 
810     ///@dev get info by forecast
811     function forecastInfo(uint _fId) external view
812         returns(uint gameId, uint f) {
813         gameId = forecasts[_fId].gameId;
814         f = forecasts[_fId].forecastData;
815     }
816 
817     function tokenInfo(uint _tokenId) external view
818         returns(uint createBlockNumber, uint parentId, uint forecast, uint score, uint price) {
819 
820         createBlockNumber = tokens[_tokenId].createBlockNumber;
821         parentId = tokens[_tokenId].parentId;
822         price = calculateTokenPrice(_tokenId);
823         forecast = getForecastCount(_tokenId, block.number, false);
824         score = getScore(_tokenId);
825     }
826 
827     ///@dev calculate token price
828     function calculateTokenPrice(uint _tokenId) public view returns(uint) {
829         require(exists(_tokenId));
830         /// token price = (forecast count + 1) * basePrice * priceFactor / 10000
831         uint forecastCount = getForecastCount(_tokenId, block.number, true);
832         return (forecastCount.add(1)).mul(basePrice).mul(priceFactor).div(10000);
833     }
834 
835     ///@dev get forecast count by tokenID
836     function getForecastCount(uint _tokenId, uint _blockNumber, bool isReleased) public view returns(uint) {
837         require(exists(_tokenId));
838 
839         uint forecastCount = 0 ;
840 
841         uint index = 0;
842         uint count = tokenForecasts[_tokenId].length;
843         for (index = 0; index < count; index++) {
844             //game's ended
845             if(forecasts[tokenForecasts[_tokenId][index]].forecastBlockNumber < _blockNumber){
846                 if(isReleased) {
847                     if (games[forecasts[tokenForecasts[_tokenId][index]].gameId].gameDate < block.timestamp) {
848                         forecastCount = forecastCount + 1;
849                     }
850                 } else {
851                     forecastCount = forecastCount + 1;
852                 }
853             }
854         }
855 
856         /// if token are cloned, calculate parent forecast score
857         if(tokens[_tokenId].parentId != 0){
858             forecastCount = forecastCount.add(getForecastCount(tokens[_tokenId].parentId,
859                 tokens[_tokenId].createBlockNumber, isReleased));
860         }
861         return forecastCount;
862     }
863 
864     ///@dev calculate score by fan's forecasts
865     function getScore(uint _tokenId) public view returns (uint){
866         uint[] memory _gameForecast = new uint[](65);
867         return getScore(_tokenId, block.number, _gameForecast);
868     }
869 
870     ///@dev calculate score by fan's forecast to a specific block number
871     function getScore(uint _tokenId, uint _blockNumber, uint[] _gameForecast) public view returns (uint){
872         uint score = 0;
873 
874         /// find all forecasts and calculate forecast score
875         uint[] memory _forecasts = forecastOfToken(_tokenId);
876         if (_forecasts.length > 0){
877             uint256 _index;
878             for(_index = _forecasts.length - 1; _index >= 0 && _index < _forecasts.length ; _index--){
879                 /// check:
880                 ///     forecastBlockNumber < current block number
881                 ///     one forecast for one game (last)
882                 if(forecasts[_forecasts[_index]].forecastBlockNumber < _blockNumber &&
883                     _gameForecast[forecasts[_forecasts[_index]].gameId] == 0 &&
884                     block.timestamp > games[forecasts[_forecasts[_index]].gameId].gameDate
885                 ){
886                     score = score.add(calculateScore(
887                             forecasts[_forecasts[_index]].gameId,
888                             forecasts[_forecasts[_index]].forecastData
889                         ));
890                     _gameForecast[forecasts[_forecasts[_index]].gameId] = forecasts[_forecasts[_index]].forecastBlockNumber;
891                 }
892             }
893         }
894 
895         /// if token are cloned, calculate parent forecast score
896         if(tokens[_tokenId].parentId != 0){
897             score = score.add(getScore(tokens[_tokenId].parentId, tokens[_tokenId].createBlockNumber, _gameForecast));
898         }
899         return score;
900     }
901 
902     /// get forecast score
903     function getForecastScore(uint256 _forecastId) external view returns (uint256) {
904         require(_forecastId < forecasts.length);
905 
906         return calculateScore(
907             forecasts[_forecastId].gameId,
908             forecasts[_forecastId].forecastData
909         );
910     }
911 
912     ///@dev calculate score by game forecast (only for games that have ended)
913     function calculateScore(uint256 _gameId, uint d)
914     public view returns (uint256){
915         require(block.timestamp > games[_gameId].gameDate);
916 
917         uint256 _shotB = (d & 0xff);
918         d = d >> 8;
919         uint256 _shotA = (d & 0xff);
920         d = d >> 8;
921         uint odds8 = (d & 0xff);
922         bool _odds = odds8 == 1 ? true: false;
923         d = d >> 8;
924         uint256 _goalB = (d & 0xff);
925         d = d >> 8;
926         uint256 _goalA = (d & 0xff);
927         d = d >> 8;
928 
929         Game memory cGame = games[_gameId];
930 
931         uint256 _score = 0;
932         bool isDoubleScore = true;
933         if(cGame.shotA == _shotA) {
934             _score = _score.add(1);
935         } else {
936             isDoubleScore = false;
937         }
938         if(cGame.shotB == _shotB) {
939             _score = _score.add(1);
940         } else {
941             isDoubleScore = false;
942         }
943         if(cGame.odds == _odds) {
944             _score = _score.add(1);
945         } else {
946             isDoubleScore = false;
947         }
948 
949         /// total goal count's
950         if((cGame.goalA + cGame.goalB) == (_goalA + _goalB)) {
951             _score = _score.add(2);
952         } else {
953             isDoubleScore = false;
954         }
955 
956         /// exact match score
957         if(cGame.goalA == _goalA && cGame.goalB == _goalB) {
958             _score = _score.add(3);
959         } else {
960             isDoubleScore = false;
961         }
962 
963         if( ((cGame.goalA > cGame.goalB) && (_goalA > _goalB)) ||
964             ((cGame.goalA < cGame.goalB) && (_goalA < _goalB)) ||
965             ((cGame.goalA == cGame.goalB) && (_goalA == _goalB))) {
966             _score = _score.add(1);
967         } else {
968             isDoubleScore = false;
969         }
970 
971         /// double if all win
972         if(isDoubleScore) {
973             _score = _score.mul(2);
974         }
975         return _score;
976     }
977 
978     /// admin logic
979     ///@dev set new base Price for create token
980     function setBasePrice(uint256 _val) external onlyAdmin {
981         require(_val > 0);
982         basePrice = _val;
983     }
984 
985     ///@dev change fee for clone token
986     function setGameCloneFee(uint256 _val) external onlyAdmin {
987         require(_val <= 10000);
988         gameCloneFee = _val;
989     }
990 
991     ///@dev change fee for clone token
992     function setPrizeFundFactor(uint256 _val) external onlyAdmin {
993         require(_val <= 10000);
994         prizeFundFactor = _val;
995     }
996 
997     ///@dev change fee for clone token
998     function setPriceFactor(uint256 _val) external onlyAdmin {
999         priceFactor = _val;
1000     }
1001 
1002     ///@dev game info edit
1003     function gameEdit(uint256 _gameId, uint64 gameDate,
1004         Teams teamA, Teams teamB)
1005     external onlyAdmin {
1006         games[_gameId].gameDate = gameDate;
1007         games[_gameId].teamA = teamA;
1008         games[_gameId].teamB = teamB;
1009 
1010         emit GameChanged(_gameId, games[_gameId].gameDate, games[_gameId].teamA, games[_gameId].teamB,
1011             0, 0, true, 0, 0);
1012     }
1013 
1014     function gameResult(uint256 _gameId, uint256 goalA, uint256 goalB, bool odds, uint256 shotA, uint256 shotB)
1015     external onlyAdmin {
1016         games[_gameId].goalA = goalA;
1017         games[_gameId].goalB = goalB;
1018         games[_gameId].odds = odds;
1019         games[_gameId].shotA = shotA;
1020         games[_gameId].shotB = shotB;
1021 
1022         emit GameChanged(_gameId, games[_gameId].gameDate, games[_gameId].teamA, games[_gameId].teamB,
1023             goalA, goalB, odds, shotA, shotB);
1024     }
1025 
1026     function toForecastData(uint8 _goalA, uint8 _goalB, bool _odds, uint8 _shotA, uint8 _shotB)
1027     pure internal returns (uint) {
1028         uint forecastData;
1029         forecastData = forecastData << 8 | _goalA;
1030         forecastData = forecastData << 8 | _goalB;
1031         uint8 odds8 = _odds ? 1 : 0;
1032         forecastData = forecastData << 8 | odds8;
1033         forecastData = forecastData << 8 | _shotA;
1034         forecastData = forecastData << 8 | _shotB;
1035 
1036         return forecastData;
1037     }
1038 }
1039 
1040 
1041 contract HWCIntegration is BaseGameLogic {
1042 
1043     event NewHWCRegister(address owner, string aD, string aW);
1044 
1045     constructor(string _name, string _symbol) BaseGameLogic(_name, _symbol) public {}
1046 
1047     struct HWCInfo {
1048         string aDeposit;
1049         string aWithdraw;
1050         uint deposit;
1051         uint index1;        // index + 1
1052     }
1053 
1054     uint public cHWCtoEth = 0;
1055     uint256 public prizeFundHWC = 0;
1056 
1057     // address => hwc address
1058     mapping (address => HWCInfo) hwcAddress;
1059     address[] hwcAddressList;
1060 
1061     function _addToFundHWC(uint256 _val) internal whenNotPaused {
1062         prizeFundHWC = prizeFundHWC.add(_val.mul(prizeFundFactor).div(10000));
1063     }
1064 
1065     function registerHWCDep(string _a) public {
1066         require(bytes(_a).length == 34);
1067         hwcAddress[msg.sender].aDeposit = _a;
1068 
1069         if(hwcAddress[msg.sender].index1 == 0){
1070             hwcAddress[msg.sender].index1 = hwcAddressList.push(msg.sender);
1071         }
1072 
1073         emit NewHWCRegister(msg.sender, _a, '');
1074     }
1075 
1076     function registerHWCWit(string _a) public {
1077         require(bytes(_a).length == 34);
1078         hwcAddress[msg.sender].aWithdraw = _a;
1079 
1080         if(hwcAddress[msg.sender].index1 == 0){
1081             hwcAddress[msg.sender].index1 = hwcAddressList.push(msg.sender);
1082         }
1083 
1084         emit NewHWCRegister(msg.sender, '', _a);
1085     }
1086 
1087     function getHWCAddressCount() public view returns (uint){
1088         return hwcAddressList.length;
1089     }
1090 
1091     function getHWCAddressByIndex(uint _index) public view returns (string aDeposit, string aWithdraw, uint d) {
1092         require(_index < hwcAddressList.length);
1093         return getHWCAddress(hwcAddressList[_index]);
1094     }
1095 
1096     function getHWCAddress(address _val) public view returns (string aDeposit, string aWithdraw, uint d) {
1097         aDeposit = hwcAddress[_val].aDeposit;
1098         aWithdraw = hwcAddress[_val].aWithdraw;
1099         d = hwcAddress[_val].deposit;
1100     }
1101 
1102     function setHWCDeposit(address _user, uint _val) external onlyAdmin {
1103         hwcAddress[_user].deposit = _val;
1104     }
1105 
1106     function createTokenByHWC(address _userTo, uint256 _parentId) external onlyAdmin whenNotPaused returns (uint) {
1107         //convert eth to hwc
1108         uint256 tokenPrice = basePrice.div(1e10).mul(cHWCtoEth);
1109         if(_parentId > 0) {
1110             tokenPrice = calculateTokenPrice(_parentId);
1111             tokenPrice = tokenPrice.div(1e10).mul(cHWCtoEth);
1112             //uint256 gameFee = _calculateGameFee(tokenPrice);
1113             uint gameFee = tokenPrice.mul(gameCloneFee).div(10000);
1114             _addToFundHWC(gameFee);
1115 
1116             uint256 ownerProceed = tokenPrice.sub(gameFee);
1117             address tokenOwnerAddress = tokenOwner[_parentId];
1118 
1119             hwcAddress[tokenOwnerAddress].deposit = hwcAddress[tokenOwnerAddress].deposit + ownerProceed;
1120         } else {
1121             _addToFundHWC(tokenPrice);
1122         }
1123 
1124         return _createToken(_parentId, _userTo);
1125     }
1126 
1127     function setCourse(uint _val) external onlyAdmin {
1128         cHWCtoEth = _val;
1129     }
1130 }
1131 
1132 
1133 contract SolutionGame is HWCIntegration {
1134 
1135     ///@dev winner token list
1136     uint256 countWinnerPlace;
1137     //place -> %%% ( 100% - 10000)
1138     mapping (uint256 => uint256) internal prizeDistribution;
1139     //place -> prize
1140     mapping (uint256 => uint256) internal prizesByPlace;
1141     mapping (uint256 => uint256) internal scoreByPlace;
1142     //token -> prize
1143     mapping (uint => uint) winnerMap;
1144     uint[] winnerList;
1145 
1146     mapping (uint256 => uint256) internal prizesByPlaceHWC;
1147 
1148     bool isWinnerTime = false;
1149 
1150     modifier whenWinnerTime() {
1151         require(isWinnerTime);
1152         _;
1153     }
1154 
1155     constructor(string _name, string _symbol) HWCIntegration(_name, _symbol) public {
1156         countWinnerPlace = 0;      //top 10!
1157     }
1158 
1159     /// @notice No tipping!
1160     /// @dev Reject all Ether from being sent here, unless it's from one of the
1161     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1162     function() external payable {
1163         _addToFund(msg.value, true);
1164     }
1165 
1166     function setWinnerTimeStatus(bool _status) external onlyOwner {
1167         isWinnerTime = _status;
1168     }
1169 
1170     // @dev withdraw balance without prizeFund
1171     function withdrawBalance() external onlyOwner {
1172         owner.transfer(address(this).balance.sub(prizeFund));
1173     }
1174 
1175     /// @dev set count winner place / top1/top5/top10 etc
1176     function setCountWinnerPlace(uint256 _val) external onlyOwner {
1177         countWinnerPlace = _val;
1178     }
1179 
1180     /// @dev set the distribution of the prize by place
1181     function setWinnerPlaceDistribution(uint256 place, uint256 _val) external onlyOwner {
1182         require(place <= countWinnerPlace);
1183         require(_val <= 10000);
1184 
1185         uint256 testVal = 0;
1186         uint256 index;
1187         for (index = 1; index <= countWinnerPlace; index ++) {
1188             if(index != place) {
1189                 testVal = testVal + prizeDistribution[index];
1190             }
1191         }
1192 
1193         testVal = testVal + _val;
1194         require(testVal <= 10000);
1195         prizeDistribution[place] = _val;
1196     }
1197 
1198     ///@dev method for manual add/edit winner list and winner count
1199     /// only after final
1200     function setCountWinnerByPlace(uint256 place, uint256 _winnerCount, uint256 _winnerScore) public onlyOwner whenPaused {
1201         require(_winnerCount > 0);
1202         require(place <= countWinnerPlace);
1203         prizesByPlace[place] = prizeFund.mul(prizeDistribution[place]).div(10000).div(_winnerCount);
1204         prizesByPlaceHWC[place] = prizeFundHWC.mul(prizeDistribution[place]).div(10000).div(_winnerCount);
1205         scoreByPlace[place] = _winnerScore;
1206     }
1207 
1208     function checkIsWinner(uint _tokenId) public view whenPaused onlyOwnerOf(_tokenId)
1209     returns (uint place) {
1210         place = 0;
1211         uint score = getScore(_tokenId);
1212         for(uint index = 1; index <= countWinnerPlace; index ++) {
1213             if (score == scoreByPlace[index]) {
1214                 // token - winner
1215                 place = index;
1216                 break;
1217             }
1218         }
1219     }
1220 
1221     function getMyPrize() external whenWinnerTime {
1222         uint[] memory tokenList = tokensOfOwner(msg.sender);
1223 
1224         for(uint index = 0; index < tokenList.length; index ++) {
1225             getPrizeByToken(tokenList[index]);
1226         }
1227     }
1228 
1229     function getPrizeByToken(uint _tokenId) public whenWinnerTime onlyOwnerOf(_tokenId) {
1230         uint place = checkIsWinner(_tokenId);
1231         require (place > 0);
1232 
1233         uint prize = prizesByPlace[place];
1234         if(prize > 0) {
1235             if(winnerMap[_tokenId] == 0) {
1236                 winnerMap[_tokenId] = prize;
1237                 winnerList.push(_tokenId);
1238 
1239                 address _owner = tokenOwner[_tokenId];
1240                 if(_owner != address(0)){
1241                     //for hwc integration
1242                     uint hwcPrize = prizesByPlaceHWC[place];
1243                     hwcAddress[_owner].deposit = hwcAddress[_owner].deposit + hwcPrize;
1244 
1245                     _owner.transfer(prize);
1246                 }
1247             }
1248         }
1249     }
1250 
1251     function getWinnerList() external view onlyAdmin returns (uint[]) {
1252         return winnerList;
1253     }
1254 
1255     function getWinnerInfo(uint _tokenId) external view onlyAdmin returns (uint){
1256         return winnerMap[_tokenId];
1257     }
1258 
1259     function getResultTable(uint _start, uint _count) external view returns (uint[]) {
1260         uint[] memory results = new uint[](_count);
1261         for(uint index = _start; index < tokens.length && index < (_start + _count); index++) {
1262             results[(index - _start)] = getScore(index);
1263         }
1264         return results;
1265     }
1266 }