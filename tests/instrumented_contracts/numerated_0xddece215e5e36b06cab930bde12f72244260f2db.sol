1 pragma solidity ^0.4.25;
2 
3 /*
4                               (           (        )      )          (          
5    (     (       *   )  *   ) )\ )        )\ )  ( /(   ( /(   (      )\ )       
6  ( )\    )\    ` )  /(` )  /((()/(  (    (()/(  )\())  )\())  )\    (()/(  (    
7  )((_)((((_)(   ( )(_))( )(_))/(_)) )\    /(_))((_)\  ((_)\((((_)(   /(_)) )\   
8 ((_)_  )\ _ )\ (_(_())(_(_())(_))  ((_)  (_))    ((_)__ ((_))\ _ )\ (_))  ((_)  
9  | _ ) (_)_\(_)|_   _||_   _|| |   | __| | _ \  / _ \\ \ / /(_)_\(_)| |   | __| 
10  | _ \  / _ \    | |    | |  | |__ | _|  |   / | (_) |\ V /  / _ \  | |__ | _|  
11  |___/ /_/ \_\   |_|    |_|  |____||___| |_|_\  \___/  |_|  /_/ \_\ |____||___| 
12 
13     Name Book implementation for ETH.TOWN Battle Royale
14     https://eth.town/battle
15 
16     ETH.TOWN https://eth.town/
17     © 2018 ETH.TOWN All rights reserved
18 */
19 
20 contract Owned {
21     address owner;
22 
23     modifier onlyOwner {
24         require(msg.sender == owner, "Not owner");
25         _;
26     }
27 
28     /// @dev Contract constructor
29     constructor() public {
30         owner = msg.sender;
31     }
32 }
33 
34 contract Managed is Owned {
35     mapping(address => bool) public isManager;
36 
37     modifier onlyManagers {
38         require(msg.sender == owner || isManager[msg.sender], "Not authorized");
39         _;
40     }
41 
42     function setIsManager(address _address, bool _value) external onlyOwner {
43         isManager[_address] = _value;
44     }
45 }
46 
47 contract BRNameBook is Managed {
48     using SafeMath for uint256;
49 
50     address public feeRecipient = 0xFd6D4265443647C70f8D0D80356F3b22d596DA29; // Mainnet
51 
52     uint256 public registrationFee = 0.1 ether;             // price to register a name
53     uint256 public numPlayers;                              // total number of players
54     mapping (address => uint256) public playerIdByAddr;     // (addr => pID) returns player id by address
55     mapping (bytes32 => uint256) public playerIdByName;     // (name => pID) returns player id by name
56     mapping (uint256 => Player) public playerData;          // (pID => data) player data
57     mapping (uint256 => mapping (bytes32 => bool)) public playerOwnsName; // (pID => name => bool) whether the player owns the name
58     mapping (uint256 => mapping (uint256 => bytes32)) public playerNamesList; // (pID => nameNum => name) list of names a player owns
59 
60     struct Player {
61         address addr;
62         address loomAddr;
63         bytes32 name;
64         uint256 lastAffiliate;
65         uint256 nameCount;
66     }
67 
68     constructor() public {
69 
70     }
71 
72     /**
73      * @dev prevents calls from contracts
74      */
75     modifier onlyHumans() {
76         require(msg.sender == tx.origin, "Humans only");
77         _;
78     }
79 
80     event NameRegistered (
81         uint256 indexed playerID,
82         address indexed playerAddress,
83         bytes32 indexed playerName,
84         bool isNewPlayer,
85         uint256 affiliateID,
86         address affiliateAddress,
87         bytes32 affiliateName,
88         uint256 amountPaid,
89         uint256 timeStamp
90     );
91 
92     function nameIsValid(string _nameStr) public view returns(bool) {
93         bytes32 _name = _processName(_nameStr);
94         return (playerIdByName[_name] == 0);
95     }
96 
97     function setRegistrationFee(uint256 _newFee) onlyManagers() external {
98         registrationFee = _newFee;
99     }
100 
101     function setFeeRecipient(address _feeRecipient) onlyManagers() external {
102         feeRecipient = _feeRecipient;
103     }
104 
105     /**
106      * @dev registers a name.  UI will always display the last name you registered.
107      * but you will still own all previously registered names to use as affiliate
108      * links.
109      * - must pay a registration fee.
110      * - name must be unique
111      * - names will be converted to lowercase
112      * - name cannot start or end with a space
113      * - cannot have more than 1 space in a row
114      * - cannot be only numbers
115      * - cannot start with 0x
116      * - name must be at least 1 char
117      * - max length of 32 characters long
118      * - allowed characters: a-z, 0-9, and space
119      * -functionhash- 0x921dec21 (using ID for affiliate)
120      * -functionhash- 0x3ddd4698 (using address for affiliate)
121      * -functionhash- 0x685ffd83 (using name for affiliate)
122      * @param _nameString players desired name
123      * @param _affCode affiliate ID, address, or name of who refered you
124      * (this might cost a lot of gas)
125      */
126     function registerNameAffId(string _nameString, uint256 _affCode) onlyHumans() external payable {
127         // make sure name fees paid
128         require (msg.value >= registrationFee, "Value below the fee");
129 
130         // filter name + condition checks
131         bytes32 name = _processName(_nameString);
132 
133         // set up address
134         address addr = msg.sender;
135 
136         // set up our tx event data and determine if player is new or not
137         bool isNewPlayer = _determinePlayerId(addr);
138 
139         // fetch player id
140         uint256 playerId = playerIdByAddr[addr];
141 
142         // manage affiliate residuals
143         // if no affiliate code was given, no new affiliate code was given, or the
144         // player tried to use their own pID as an affiliate code, lolz
145         uint256 affiliateId = _affCode;
146         if (affiliateId != 0 && affiliateId != playerData[playerId].lastAffiliate && affiliateId != playerId) {
147             // update last affiliate
148             playerData[playerId].lastAffiliate = affiliateId;
149         } else if (_affCode == playerId) {
150             affiliateId = 0;
151         }
152 
153         // register name
154         _registerName(playerId, addr, affiliateId, name, isNewPlayer);
155     }
156 
157     function registerNameAffAddress(string _nameString, address _affCode) onlyHumans() external payable {
158         // make sure name fees paid
159         require (msg.value >= registrationFee, "Value below the fee");
160 
161         // filter name + condition checks
162         bytes32 name = _processName(_nameString);
163 
164         // set up address
165         address addr = msg.sender;
166 
167         // set up our tx event data and determine if player is new or not
168         bool isNewPlayer = _determinePlayerId(addr);
169 
170         // fetch player id
171         uint256 playerId = playerIdByAddr[addr];
172 
173         // manage affiliate residuals
174         // if no affiliate code was given or player tried to use their own, lolz
175         uint256 affiliateId;
176         if (_affCode != address(0) && _affCode != addr) {
177             // get affiliate ID from aff Code
178             affiliateId = playerIdByAddr[_affCode];
179 
180             // if affID is not the same as previously stored
181             if (affiliateId != playerData[playerId].lastAffiliate) {
182                 // update last affiliate
183                 playerData[playerId].lastAffiliate = affiliateId;
184             }
185         }
186 
187         // register name
188         _registerName(playerId, addr, affiliateId, name, isNewPlayer);
189     }
190 
191     function registerNameAffName(string _nameString, bytes32 _affCode) onlyHumans() public payable {
192         // make sure name fees paid
193         require (msg.value >= registrationFee, "Value below the fee");
194 
195         // filter name + condition checks
196         bytes32 name = _processName(_nameString);
197 
198         // set up address
199         address addr = msg.sender;
200 
201         // set up our tx event data and determine if player is new or not
202         bool isNewPlayer = _determinePlayerId(addr);
203 
204         // fetch player id
205         uint256 playerId = playerIdByAddr[addr];
206 
207         // manage affiliate residuals
208         // if no affiliate code was given or player tried to use their own, lolz
209         uint256 affiliateId;
210         if (_affCode != "" && _affCode != name) {
211             // get affiliate ID from aff Code
212             affiliateId = playerIdByName[_affCode];
213 
214             // if affID is not the same as previously stored
215             if (affiliateId != playerData[playerId].lastAffiliate) {
216                 // update last affiliate
217                 playerData[playerId].lastAffiliate = affiliateId;
218             }
219         }
220 
221         // register the name
222         _registerName(playerId, addr, affiliateId, name, isNewPlayer);
223     }
224 
225     /**
226      * @dev players use this to change back to one of your old names.  tip, you'll
227      * still need to push that info to existing games.
228      * -functionhash- 0xb9291296
229      * @param _nameString the name you want to use
230      */
231     function useMyOldName(string _nameString) onlyHumans() public {
232         // filter name, and get pID
233         bytes32 name = _processName(_nameString);
234         uint256 playerId = playerIdByAddr[msg.sender];
235 
236         // make sure they own the name
237         require(playerOwnsName[playerId][name] == true, "Not your name");
238 
239         // update their current name
240         playerData[playerId].name = name;
241     }
242 
243 
244     function _registerName(uint256 _playerId, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer) internal {
245         // if names already has been used, require that current msg sender owns the name
246         if (playerIdByName[_name] != 0) {
247             require(playerOwnsName[_playerId][_name] == true, "Name already taken");
248         }
249 
250         // add name to player profile, registry, and name book
251         playerData[_playerId].name = _name;
252         playerIdByName[_name] = _playerId;
253         if (playerOwnsName[_playerId][_name] == false) {
254             playerOwnsName[_playerId][_name] = true;
255             playerData[_playerId].nameCount++;
256             playerNamesList[_playerId][playerData[_playerId].nameCount] = _name;
257         }
258 
259         // process the registration fee
260         uint256 total = address(this).balance;
261         uint256 devDirect = total.mul(375).div(1000);
262         owner.call.value(devDirect)();
263         feeRecipient.call.value(total.sub(devDirect))();
264 
265         // fire event
266         emit NameRegistered(_playerId, _addr, _name, _isNewPlayer, _affID, playerData[_affID].addr, playerData[_affID].name, msg.value, now);
267     }
268 
269     function _determinePlayerId(address _addr) internal returns (bool) {
270         if (playerIdByAddr[_addr] == 0)
271         {
272             numPlayers++;
273             playerIdByAddr[_addr] = numPlayers;
274             playerData[numPlayers].addr = _addr;
275 
276             // set the new player bool to true
277             return true;
278         } else {
279             return false;
280         }
281     }
282 
283     function _processName(string _input) internal pure returns (bytes32) {
284         bytes memory _temp = bytes(_input);
285         uint256 _length = _temp.length;
286 
287         //sorry limited to 32 characters
288         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
289         // make sure it doesnt start with or end with space
290         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
291         // make sure first two characters are not 0x
292         if (_temp[0] == 0x30)
293         {
294             require(_temp[1] != 0x78, "string cannot start with 0x");
295             require(_temp[1] != 0x58, "string cannot start with 0X");
296         }
297 
298         // create a bool to track if we have a non number character
299         bool _hasNonNumber;
300 
301         // convert & check
302         for (uint256 i = 0; i < _length; i++)
303         {
304             // if its uppercase A-Z
305             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
306             {
307                 // convert to lower case a-z
308                 _temp[i] = byte(uint(_temp[i]) + 32);
309 
310                 // we have a non number
311                 if (_hasNonNumber == false)
312                     _hasNonNumber = true;
313             } else {
314                 require
315                 (
316                 // require character is a space
317                     _temp[i] == 0x20 ||
318                 // OR lowercase a-z
319                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
320                 // or 0-9
321                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
322                     "string contains invalid characters"
323                 );
324                 // make sure theres not 2x spaces in a row
325                 if (_temp[i] == 0x20)
326                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
327 
328                 // see if we have a character other than a number
329                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
330                     _hasNonNumber = true;
331             }
332         }
333 
334         require(_hasNonNumber == true, "string cannot be only numbers");
335 
336         bytes32 _ret;
337         assembly {
338             _ret := mload(add(_temp, 32))
339         }
340         return (_ret);
341     }
342 
343     function registerNameAffIdExternal(address _addr, bytes32 _name, uint256 _affCode)
344     onlyManagers()
345     external
346     payable
347     returns (bool, uint256)
348     {
349         // make sure name fees paid
350         require (msg.value >= registrationFee, "Value below the fee");
351 
352         // set up our tx event data and determine if player is new or not
353         bool isNewPlayer = _determinePlayerId(_addr);
354 
355         // fetch player id
356         uint256 playerId = playerIdByAddr[_addr];
357 
358         // manage affiliate residuals
359         // if no affiliate code was given, no new affiliate code was given, or the
360         // player tried to use their own pID as an affiliate code, lolz
361         uint256 affiliateId = _affCode;
362         if (affiliateId != 0 && affiliateId != playerData[playerId].lastAffiliate && affiliateId != playerId) {
363             // update last affiliate
364             playerData[playerId].lastAffiliate = affiliateId;
365         } else if (affiliateId == playerId) {
366             affiliateId = 0;
367         }
368 
369         // register name
370         _registerName(playerId, _addr, affiliateId, _name, isNewPlayer);
371 
372         return (isNewPlayer, affiliateId);
373     }
374 
375     function registerNameAffAddressExternal(address _addr, bytes32 _name, address _affCode)
376     onlyManagers()
377     external
378     payable
379     returns (bool, uint256)
380     {
381         // make sure name fees paid
382         require (msg.value >= registrationFee, "Value below the fee");
383 
384         // set up our tx event data and determine if player is new or not
385         bool isNewPlayer = _determinePlayerId(_addr);
386 
387         // fetch player id
388         uint256 playerId = playerIdByAddr[_addr];
389 
390         // manage affiliate residuals
391         // if no affiliate code was given or player tried to use their own, lolz
392         uint256 affiliateId;
393         if (_affCode != address(0) && _affCode != _addr)
394         {
395             // get affiliate ID from aff Code
396             affiliateId = playerIdByAddr[_affCode];
397 
398             // if affID is not the same as previously stored
399             if (affiliateId != playerData[playerId].lastAffiliate) {
400                 // update last affiliate
401                 playerData[playerId].lastAffiliate = affiliateId;
402             }
403         }
404 
405         // register name
406         _registerName(playerId, _addr, affiliateId, _name, isNewPlayer);
407 
408         return (isNewPlayer, affiliateId);
409     }
410 
411     function registerNameAffNameExternal(address _addr, bytes32 _name, bytes32 _affCode)
412     onlyManagers()
413     external
414     payable
415     returns (bool, uint256)
416     {
417         // make sure name fees paid
418         require (msg.value >= registrationFee, "Value below the fee");
419 
420         // set up our tx event data and determine if player is new or not
421         bool isNewPlayer = _determinePlayerId(_addr);
422 
423         // fetch player id
424         uint256 playerId = playerIdByAddr[_addr];
425 
426         // manage affiliate residuals
427         // if no affiliate code was given or player tried to use their own, lolz
428         uint256 affiliateId;
429         if (_affCode != "" && _affCode != _name)
430         {
431             // get affiliate ID from aff Code
432             affiliateId = playerIdByName[_affCode];
433 
434             // if affID is not the same as previously stored
435             if (affiliateId != playerData[playerId].lastAffiliate) {
436                 // update last affiliate
437                 playerData[playerId].lastAffiliate = affiliateId;
438             }
439         }
440 
441         // register name
442         _registerName(playerId, _addr, affiliateId, _name, isNewPlayer);
443 
444         return (isNewPlayer, affiliateId);
445     }
446 
447     function assignPlayerID(address _addr) onlyManagers() external returns (uint256) {
448         _determinePlayerId(_addr);
449         return playerIdByAddr[_addr];
450     }
451 
452     function getPlayerID(address _addr) public view returns (uint256) {
453         return playerIdByAddr[_addr];
454     }
455 
456     function getPlayerName(uint256 _pID) public view returns (bytes32) {
457         return playerData[_pID].name;
458     }
459 
460     function getPlayerNameCount(uint256 _pID) public view returns (uint256) {
461         return playerData[_pID].nameCount;
462     }
463 
464     function getPlayerLastAffiliate(uint256 _pID) public view returns (uint256) {
465         return playerData[_pID].lastAffiliate;
466     }
467 
468     function getPlayerAddr(uint256 _pID) public view returns (address) {
469         return playerData[_pID].addr;
470     }
471 
472     function getPlayerLoomAddr(uint256 _pID) public view returns (address) {
473         return playerData[_pID].loomAddr;
474     }
475 
476     function getPlayerLoomAddrByAddr(address _addr) public view returns (address) {
477         uint256 playerId = playerIdByAddr[_addr];
478         if (playerId == 0) {
479             return 0;
480         }
481 
482         return playerData[playerId].loomAddr;
483     }
484 
485     function getPlayerNames(uint256 _pID) public view returns (bytes32[]) {
486         uint256 nameCount = playerData[_pID].nameCount;
487 
488         bytes32[] memory names = new bytes32[](nameCount);
489 
490         uint256 i;
491         for (i = 1; i <= nameCount; i++) {
492             names[i - 1] = playerNamesList[_pID][i];
493         }
494 
495         return names;
496     }
497 
498     function setPlayerLoomAddr(uint256 _pID, address _addr, bool _allowOverwrite) onlyManagers() external {
499         require(_allowOverwrite || playerData[_pID].loomAddr == 0x0);
500 
501         playerData[_pID].loomAddr = _addr;
502     }
503 
504 }
505 
506 library SafeMath {
507 
508     /**
509     * @dev Multiplies two numbers, throws on overflow.
510     */
511     function mul(uint256 a, uint256 b) internal pure returns (uint256 c)
512     {
513         if (a == 0) {
514             return 0;
515         }
516         c = a * b;
517         require(c / a == b, "SafeMath mul failed");
518         return c;
519     }
520 
521     /**
522     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
523     */
524     function sub(uint256 a, uint256 b) internal pure returns (uint256)
525     {
526         require(b <= a, "SafeMath sub failed");
527         return a - b;
528     }
529 
530     /**
531     * @dev Adds two numbers, throws on overflow.
532     */
533     function add(uint256 a, uint256 b) internal pure returns (uint256 c)
534     {
535         c = a + b;
536         require(c >= a, "SafeMath add failed");
537         return c;
538     }
539 
540     /**
541     * @dev Divides two numbers, never throws.
542     */
543     function div(uint256 a, uint256 b) internal pure returns (uint256) {
544         // assert(b > 0); // Solidity automatically throws when dividing by 0
545         uint256 c = a / b;
546         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
547         return c;
548     }
549 
550     /**
551      * @dev gives square root of given x.
552      */
553     function sqrt(uint256 x) internal pure returns (uint256 y)
554     {
555         uint256 z = ((add(x,1)) / 2);
556         y = x;
557         while (z < y) {
558             y = z;
559             z = ((add((x / z),z)) / 2);
560         }
561     }
562 
563     /**
564      * @dev gives square. multiplies x by x
565      */
566     function sq(uint256 x) internal pure returns (uint256)
567     {
568         return mul(x,x);
569     }
570 
571     /**
572      * @dev x to the power of y
573      */
574     function pwr(uint256 x, uint256 y) internal pure returns (uint256)
575     {
576         if (x==0) {
577             return 0;
578         } else if (y==0) {
579             return 1;
580         } else {
581             uint256 z = x;
582             for (uint256 i=1; i < y; i++)
583                 z = mul(z,x);
584             return z;
585         }
586     }
587 }