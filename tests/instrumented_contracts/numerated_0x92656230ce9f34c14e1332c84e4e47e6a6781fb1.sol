1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27 
28     /**
29     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 library AddressUtils {
47 
48     /**
49      * Returns whether the target address is a contract
50      * @dev This function will return false if invoked during the constructor of a contract,
51      *  as the code is not actually created until after the constructor finishes.
52      * @param addr address to check
53      * @return whether the target address is a contract
54      */
55     function isContract(address addr) internal view returns (bool) {
56         uint256 size;
57         // XXX Currently there is no better way to check if there is a contract in an address
58         // than to check the size of the code at that address.
59         // See https://ethereum.stackexchange.com/a/14016/36603
60         // for more details about how this works.
61         // TODO Check this again before the Serenity release, because all addresses will be
62         // contracts then.
63         assembly {size := extcodesize(addr)}
64         // solium-disable-line security/no-inline-assembly
65         return size > 0;
66     }
67 
68 }
69 
70 contract ERC721 {
71     // Required methods
72     function totalSupply() public view returns (uint256 total);
73 
74     function balanceOf(address _owner) public view returns (uint256 balance);
75 
76     function ownerOf(uint256 _tokenId) external view returns (address owner);
77 
78     function approve(address _to, uint256 _tokenId) external;
79 
80     function transfer(address _to, uint256 _tokenId) external;
81 
82     function transferFrom(address _from, address _to, uint256 _tokenId) external;
83 
84     // Events
85     event Transfer(address from, address to, uint256 tokenId);
86     event Approval(address owner, address approved, uint256 tokenId);
87 
88     // Optional
89     // function name() public view returns (string name);
90     // function symbol() public view returns (string symbol);
91     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
92     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
93 
94     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
95     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
96 }
97 
98 
99 contract Ownable {
100     address public owner;
101 
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105 
106     /**
107      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
108      * account.
109      */
110     constructor() public {
111         owner = msg.sender;
112     }
113 
114     /**
115      * @dev Throws if called by any account other than the owner.
116      */
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121 
122     /**
123      * @dev Allows the current owner to transfer control of the contract to a newOwner.
124      * @param newOwner The address to transfer ownership to.
125      */
126     function transferOwnership(address newOwner) public onlyOwner {
127         require(newOwner != address(0));
128         emit OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130     }
131 
132 }
133 
134 contract AccessControl is Ownable {
135 
136     address private MainAdmin;
137     address private TechnicalAdmin;
138     address private FinancialAdmin;
139     address private MarketingAdmin;
140 
141     constructor() public {
142         MainAdmin = owner;
143     }
144 
145     modifier onlyMainAdmin() {
146         require(msg.sender == MainAdmin);
147         _;
148     }
149 
150     modifier onlyFinancialAdmin() {
151         require(msg.sender == FinancialAdmin);
152         _;
153     }
154 
155     modifier onlyMarketingAdmin() {
156         require(msg.sender == MarketingAdmin);
157         _;
158     }
159 
160     modifier onlyTechnicalAdmin() {
161         require(msg.sender == TechnicalAdmin);
162         _;
163     }
164 
165     modifier onlyAdmins() {
166         require(msg.sender == TechnicalAdmin || msg.sender == MarketingAdmin
167         || msg.sender == FinancialAdmin || msg.sender == MainAdmin);
168         _;
169     }
170 
171     function setMainAdmin(address _newMainAdmin) external onlyOwner {
172         require(_newMainAdmin != address(0));
173         MainAdmin = _newMainAdmin;
174     }
175 
176     function setFinancialAdmin(address _newFinancialAdmin) external onlyMainAdmin {
177         require(_newFinancialAdmin != address(0));
178         FinancialAdmin = _newFinancialAdmin;
179     }
180 
181     function setMarketingAdmin(address _newMarketingAdmin) external onlyMainAdmin {
182         require(_newMarketingAdmin != address(0));
183         MarketingAdmin = _newMarketingAdmin;
184     }
185 
186 
187     function setTechnicalAdmin(address _newTechnicalAdmin) external onlyMainAdmin {
188         require(_newTechnicalAdmin != address(0));
189         TechnicalAdmin = _newTechnicalAdmin;
190     }
191 
192 }
193 
194 
195 contract Pausable is AccessControl {
196     event Pause();
197     event Unpause();
198 
199     bool public paused;
200 
201 
202     constructor() public {
203         paused = false;
204     }
205 
206     /**
207      * @dev Modifier to make a function callable only when the contract is not paused.
208      */
209     modifier whenNotPaused() {
210         require(!paused);
211         _;
212     }
213 
214     /**
215      * @dev Modifier to make a function callable only when the contract is paused.
216      */
217     modifier whenPaused() {
218         require(paused);
219         _;
220     }
221 
222     /**
223      * @dev called by the owner to pause, triggers stopped state
224      */
225     function pause() onlyAdmins whenNotPaused public {
226         paused = true;
227         emit Pause();
228     }
229 
230     /**
231      * @dev called by the owner to unpause, returns to normal state
232      */
233     function unpause() onlyAdmins whenPaused public {
234         paused = false;
235         emit Unpause();
236     }
237 }
238 
239 contract PullPayment is Pausable {
240     using SafeMath for uint256;
241 
242 
243     mapping(address => uint256) public payments;
244     uint256 public totalPayments;
245 
246     /**
247     * @dev Withdraw accumulated balance, called by payee.
248     */
249     function withdrawPayments() whenNotPaused public {
250         address payee = msg.sender;
251         uint256 payment = payments[payee];
252 
253         require(payment != 0);
254         require(address(this).balance >= payment);
255 
256         totalPayments = totalPayments.sub(payment);
257         payments[payee] = 0;
258 
259         payee.transfer(payment);
260     }
261 
262     /**
263     * @dev Called by the payer to store the sent amount as credit to be pulled.
264     * @param dest The destination address of the funds.
265     * @param amount The amount to transfer.
266     */
267     function asyncSend(address dest, uint256 amount) whenNotPaused internal {
268         payments[dest] = payments[dest].add(amount);
269         totalPayments = totalPayments.add(amount);
270     }
271 }
272 
273 contract FootballPlayerBase is PullPayment, ERC721 {
274 
275 
276     struct FootballPlayer {
277         bytes32 name;
278         uint8 position;
279         uint8 star;
280         uint256 level;
281         uint256 dna;
282     }
283 
284     uint32[14] public maxStaminaForLevel = [
285     uint32(50 minutes),
286     uint32(80 minutes),
287     uint32(110 minutes),
288     uint32(130 minutes),
289     uint32(150 minutes),
290     uint32(160 minutes),
291     uint32(170 minutes),
292     uint32(185 minutes),
293     uint32(190 minutes),
294     uint32(210 minutes),
295     uint32(230 minutes),
296     uint32(235 minutes),
297     uint32(245 minutes),
298     uint32(250 minutes)
299     ];
300 
301     FootballPlayer[] players;
302 
303     mapping(uint256 => address) playerIndexToOwner;
304 
305     mapping(address => uint256) addressToPlayerCount;
306 
307     mapping(uint256 => address) public playerIndexToApproved;
308 
309     mapping(uint256 => bool) dnaExists;
310 
311     mapping(uint256 => bool) tokenIsFreezed;
312 
313     function GetPlayer(uint256 _playerId) external view returns (bytes32, uint8, uint8, uint256, uint256) {
314         require(_playerId < players.length);
315         require(_playerId > 0);
316         FootballPlayer memory _player = players[_playerId];
317         return (_player.name, _player.position, _player.star, _player.level, _player.dna);
318     }
319 
320     function ToggleFreezeToken(uint256 _tokenId) public returns (bool){
321         require(_tokenId < players.length);
322         require(_tokenId > 0);
323 
324         tokenIsFreezed[_tokenId] = !tokenIsFreezed[_tokenId];
325 
326         return tokenIsFreezed[_tokenId];
327     }
328 
329     function _transfer(address _from, address _to, uint256 _tokenId) internal {
330         require(_to != address(0), "to address is invalid");
331         require(tokenIsFreezed[_tokenId] == false, "token is freezed");
332 
333         addressToPlayerCount[_to]++;
334 
335         playerIndexToOwner[_tokenId] = _to;
336 
337         if (_from != address(0)) {
338             addressToPlayerCount[_from]--;
339             delete playerIndexToApproved[_tokenId];
340         }
341 
342         emit Transfer(_from, _to, _tokenId);
343     }
344 
345     function CreateSpecialPlayer(bytes32 _name, uint8 _position, uint8 _star, uint256 _dna, uint256 _level,
346         address _owner) external whenNotPaused onlyMarketingAdmin returns (uint256)
347     {
348         require(dnaExists[_dna] == false, "DNA exists");
349 
350         FootballPlayer memory _player = FootballPlayer(
351             _name,
352             _position,
353             _star,
354             _level,
355             _dna
356         );
357 
358         dnaExists[_dna] = true;
359 
360         uint256 newPlayerId = players.push(_player) - 1;
361 
362         _transfer(0, _owner, newPlayerId);
363 
364         return newPlayerId;
365 
366     }
367 
368     function CreateDummyPlayer(bytes32 _name, uint8 _position, uint256 _dna,
369         address _owner) external whenNotPaused onlyAdmins returns (uint256)
370     {
371         require(dnaExists[_dna] == false, "DNA exists!");
372 
373         FootballPlayer memory _player = FootballPlayer(
374             _name,
375             _position,
376             uint8(1),
377             uint256(1),
378             _dna
379         );
380 
381         dnaExists[_dna] = true;
382 
383         uint256 newPlayerId = players.push(_player) - 1;
384 
385         _transfer(0, _owner, newPlayerId);
386 
387         return newPlayerId;
388 
389     }
390 
391 
392 }
393 
394 
395 contract ERC721Metadata {
396 
397     function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
398         if (_tokenId == 1) {
399             buffer[0] = "Hello Football! :D";
400             count = 18;
401         } else if (_tokenId == 2) {
402             buffer[0] = "I would definitely choose a medi";
403             buffer[1] = "um length string.";
404             count = 49;
405         } else if (_tokenId == 3) {
406             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
407             buffer[1] = "st accumsan dapibus augue lorem,";
408             buffer[2] = " tristique vestibulum id, libero";
409             buffer[3] = " suscipit varius sapien aliquam.";
410             count = 128;
411         }
412     }
413 }
414 
415 contract FootballPlayerOwnership is FootballPlayerBase {
416 
417     string public constant name = "CryptoFantasyFootball";
418     string public constant symbol = "CFF"; // Crypto Fantasy Football
419     uint256 public version;
420 
421     ERC721Metadata public erc721Metadata;
422 
423     bytes4 constant InterfaceSignature_ERC165 =
424     bytes4(keccak256('supportsInterface(bytes4)'));
425 
426     bytes4 constant InterfaceSignature_ERC721 =
427     bytes4(keccak256('name()')) ^
428     bytes4(keccak256('symbol()')) ^
429     bytes4(keccak256('totalSupply()')) ^
430     bytes4(keccak256('balanceOf(address)')) ^
431     bytes4(keccak256('ownerOf(uint256)')) ^
432     bytes4(keccak256('approve(address,uint256)')) ^
433     bytes4(keccak256('transfer(address,uint256)')) ^
434     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
435     bytes4(keccak256('tokensOfOwner(address)')) ^
436     bytes4(keccak256('tokenMetadata(uint256,string)'));
437 
438 
439     constructor(uint256 _currentVersion) public {
440         version = _currentVersion;
441     }
442 
443     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
444     ///  Returns true for any standardized interfaces implemented by this contract. We implement
445     ///  ERC-165 (obviously!) and ERC-721.
446     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
447     {
448         // DEBUG ONLY
449         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
450 
451         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
452     }
453 
454     function setMetadataAddress(address _contractAddress) public onlyMainAdmin {
455         require(_contractAddress != address(0));
456         erc721Metadata = ERC721Metadata(_contractAddress);
457     }
458 
459     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
460         return playerIndexToOwner[_tokenId] == _claimant;
461     }
462 
463     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
464         return playerIndexToApproved[_tokenId] == _claimant;
465     }
466 
467     function _approve(uint256 _tokenId, address _approved) internal {
468         playerIndexToApproved[_tokenId] = _approved;
469     }
470 
471     function balanceOf(address _owner) public view returns (uint256 count) {
472         return addressToPlayerCount[_owner];
473     }
474 
475 
476     function transfer(
477         address _to,
478         uint256 _tokenId
479     )
480     external
481     whenNotPaused
482     {
483         // Safety check to prevent against an unexpected 0x0 default.
484         require(_to != address(0));
485         // Disallow transfers to this contract to prevent accidental misuse.
486         // The contract should never own any players 
487         require(_to != address(this), "you can not transfer player to this contract");
488 
489         // You can only send your own player.
490         require(_owns(msg.sender, _tokenId), "You do not own this player");
491 
492         // Reassign ownership, clear pending approvals, emit Transfer event.
493         _transfer(msg.sender, _to, _tokenId);
494     }
495 
496 
497     function approve(address _to, uint256 _tokenId) external whenNotPaused
498     {
499         require(_to != address(0));
500         // Only an owner can grant transfer approval.
501         require(_owns(msg.sender, _tokenId));
502 
503         // Register the approval (replacing any previous approval).
504         _approve(_tokenId, _to);
505 
506         // Emit approval event.
507         emit Approval(msg.sender, _to, _tokenId);
508     }
509 
510     ///  Transfer a player owned by another address, for which the calling address
511     ///  has previously been granted transfer approval by the owner.
512     function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused
513     {
514         // Safety check to prevent against an unexpected 0x0 default.
515         require(_to != address(0));
516         // Disallow transfers to this contract to prevent accidental misuse.
517         // The contract should never own any players.
518         require(_to != address(this) , "You can not send players to this contract");
519         // Check for approval and valid ownership
520         require(_approvedFor(msg.sender, _tokenId) , "You don't have permission to transfer this player");
521         require(_owns(_from, _tokenId) , "from address doesn't have this player");
522 
523         // Reassign ownership (also clears pending approvals and emits Transfer event).
524         _transfer(_from, _to, _tokenId);
525     }
526 
527     function totalSupply() public view returns (uint) {
528         return players.length - 1;
529     }
530 
531     function ownerOf(uint256 _tokenId)
532     external
533     view
534     returns (address owner)
535     {
536         owner = playerIndexToOwner[_tokenId];
537 
538         require(owner != address(0));
539     }
540 
541 
542     function tokensOfOwner(address _owner) external view returns (uint256[] ownerTokens) {
543         uint256 tokenCount = balanceOf(_owner);
544 
545         if (tokenCount == 0) {
546             // Return an empty array
547             return new uint256[](0);
548         } else {
549             uint256[] memory result = new uint256[](tokenCount);
550             uint256 totalPlayers = totalSupply();
551             uint256 resultIndex = 0;
552 
553             // We count on the fact that all players have IDs starting at 1 and increasing
554             // sequentially up to the total players count.
555             uint256 playerId;
556 
557             for (playerId = 1; playerId <= totalPlayers; playerId++) {
558                 if (playerIndexToOwner[playerId] == _owner) {
559                     result[resultIndex] = playerId;
560                     resultIndex++;
561                 }
562             }
563 
564             return result;
565         }
566     }
567 }