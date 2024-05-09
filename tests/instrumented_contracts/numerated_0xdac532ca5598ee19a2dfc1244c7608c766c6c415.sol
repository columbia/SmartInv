1 pragma solidity ^0.4.24;
2 /*
3  * -PlayerBook - beta
4  */
5 
6 interface PlayerBookReceiverInterface {
7     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name) external;
8     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
9 }
10 
11 interface TeamInterface {
12     function requiredSignatures() external view returns(uint256);
13     function requiredDevSignatures() external view returns(uint256);
14     function adminCount() external view returns(uint256);
15     function devCount() external view returns(uint256);
16     function adminName(address _who) external view returns(bytes32);
17     function isAdmin(address _who) external view returns(bool);
18     function isDev(address _who) external view returns(bool);
19 }
20 
21 contract PlayerBook {
22     using NameFilter for string;
23     using SafeMath for uint256;
24     
25     address constant private NameFee = 0x4a1061afb0af7d9f6c2d545ada068da68052c060;
26     TeamInterface constant private Team = TeamInterface(0x8A9E4d7Ba824ce25e0E72971B3e969383B528c06);
27     
28     MSFun.Data private msData;
29     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, Team.requiredDevSignatures(), _whatFunction));}
30     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
31     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
32     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
33     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
34     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(Team.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), Team.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), Team.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
35 //==============================================================================
36 //     _| _ _|_ _    _ _ _|_    _   .
37 //    (_|(_| | (_|  _\(/_ | |_||_)  .
38 //=============================|================================================    
39     uint256 public registrationFee_ = 10 finney;            // price to register a name
40     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
41     mapping(address => bytes32) public gameNames_;          // lookup a games name
42     mapping(address => uint256) public gameIDs_;            // lokup a games ID
43     uint256 public gID_;        // total number of games
44     uint256 public pID_;        // total number of players
45     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
46     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
47     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
48     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
49     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
50     struct Player {
51         address addr;
52         bytes32 name;
53         uint256 names;
54     }
55 //==============================================================================
56 //     _ _  _  __|_ _    __|_ _  _  .
57 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
58 //==============================================================================    
59     constructor()
60         public
61     {
62         // premine the dev names (sorry not sorry)
63             // No keys are purchased with this method, it's simply locking our addresses,
64             // PID's and names for referral codes.
65         plyr_[1].addr = 0x4a1061afb0af7d9f6c2d545ada068da68052c060;
66         plyr_[1].name = "deployer";
67         plyr_[1].names = 1;
68         pIDxAddr_[0x4a1061afb0af7d9f6c2d545ada068da68052c060] = 1;
69         pIDxName_["deployer"] = 1;
70         plyrNames_[1]["deployer"] = true;
71         plyrNameList_[1][1] = "deployer";
72 
73         pID_ = 1;
74     }
75 //==============================================================================
76 //     _ _  _  _|. |`. _  _ _  .
77 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
78 //==============================================================================    
79     /**
80      * @dev prevents contracts from interacting with fomo3dx 
81      */
82     modifier isHuman() {
83         address _addr = msg.sender;
84         uint256 _codeLength;
85         
86         assembly {_codeLength := extcodesize(_addr)}
87         require(_codeLength == 0, "sorry humans only");
88         _;
89     }
90     
91     modifier onlyDevs() 
92     {
93         require(Team.isDev(msg.sender) == true, "msg sender is not a dev");
94         _;
95     }
96     
97     modifier isRegisteredGame()
98     {
99         require(gameIDs_[msg.sender] != 0);
100         _;
101     }
102 //==============================================================================
103 //     _    _  _ _|_ _  .
104 //    (/_\/(/_| | | _\  .
105 //==============================================================================    
106     // fired whenever a player registers a name
107     event onNewName
108     (
109         uint256 indexed playerID,
110         address indexed playerAddress,
111         bytes32 indexed playerName,
112         bool isNewPlayer,
113         uint256 amountPaid,
114         uint256 timeStamp
115     );
116 //==============================================================================
117 //     _  _ _|__|_ _  _ _  .
118 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
119 //=====_|=======================================================================
120     function checkIfNameValid(string _nameStr)
121         public
122         view
123         returns(bool)
124     {
125         bytes32 _name = _nameStr.nameFilter();
126         if (pIDxName_[_name] == 0)
127             return (true);
128         else 
129             return (false);
130     }
131 //==============================================================================
132 //     _    |_ |. _   |`    _  __|_. _  _  _  .
133 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
134 //====|=========================================================================    
135     /**
136      * @dev registers a name.  UI will always display the last name you registered.
137      * - must pay a registration fee.
138      * - name must be unique
139      * - names will be converted to lowercase
140      * - name cannot start or end with a space 
141      * - cannot have more than 1 space in a row
142      * - cannot be only numbers
143      * - cannot start with 0x 
144      * - name must be at least 1 char
145      * - max length of 32 characters long
146      * - allowed characters: a-z, 0-9, and space
147      * @param _nameString players desired name
148      * @param _all set to true if you want this to push your info to all games 
149      * (this might cost a lot of gas)
150      */
151     function registerNameXID(string _nameString, bool _all)
152         isHuman()
153         public
154         payable 
155     {
156         // make sure name fees paid
157         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
158         
159         // filter name + condition checks
160         bytes32 _name = NameFilter.nameFilter(_nameString);
161         
162         // set up address 
163         address _addr = msg.sender;
164         
165         // set up our tx event data and determine if player is new or not
166         bool _isNewPlayer = determinePID(_addr);
167         
168         // fetch player id
169         uint256 _pID = pIDxAddr_[_addr];
170         
171         // register name 
172         registerNameCore(_pID, _addr, _name, _isNewPlayer, _all);
173     }
174     
175     function registerNameXaddr(string _nameString, bool _all)
176         isHuman()
177         public
178         payable 
179     {
180         // make sure name fees paid
181         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
182         
183         // filter name + condition checks
184         bytes32 _name = NameFilter.nameFilter(_nameString);
185         
186         // set up address 
187         address _addr = msg.sender;
188         
189         // set up our tx event data and determine if player is new or not
190         bool _isNewPlayer = determinePID(_addr);
191         
192         // fetch player id
193         uint256 _pID = pIDxAddr_[_addr];
194         
195         // register name 
196         registerNameCore(_pID, _addr, _name, _isNewPlayer, _all);
197     }
198     
199     function registerNameXname(string _nameString, bool _all)
200         isHuman()
201         public
202         payable 
203     {
204         // make sure name fees paid
205         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
206         
207         // filter name + condition checks
208         bytes32 _name = NameFilter.nameFilter(_nameString);
209         
210         // set up address 
211         address _addr = msg.sender;
212         
213         // set up our tx event data and determine if player is new or not
214         bool _isNewPlayer = determinePID(_addr);
215         
216         // fetch player id
217         uint256 _pID = pIDxAddr_[_addr];
218         
219         // register name 
220         registerNameCore(_pID, _addr, _name, _isNewPlayer, _all);
221     }
222     
223     /**
224      * @dev players, if you registered a profile, before a game was released, or
225      * set the all bool to false when you registered, use this function to push
226      * your profile to a single game.  also, if you've  updated your name, you
227      * can use this to push your name to games of your choosing.
228      * -functionhash- 0x81c5b206
229      * @param _gameID game id 
230      */
231     function addMeToGame(uint256 _gameID)
232         isHuman()
233         public
234     {
235         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
236         address _addr = msg.sender;
237         uint256 _pID = pIDxAddr_[_addr];
238         require(_pID != 0, "hey there buddy, you dont even have an account");
239         uint256 _totalNames = plyr_[_pID].names;
240         
241         // add players profile and most recent name
242         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name);
243         
244         // add list of all names
245         if (_totalNames > 1)
246             for (uint256 ii = 1; ii <= _totalNames; ii++)
247                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
248     }
249     
250     /**
251      * @dev players, use this to push your player profile to all registered games.
252      * -functionhash- 0x0c6940ea
253      */
254     function addMeToAllGames()
255         isHuman()
256         public
257     {
258         address _addr = msg.sender;
259         uint256 _pID = pIDxAddr_[_addr];
260         require(_pID != 0, "hey there buddy, you dont even have an account");
261         uint256 _totalNames = plyr_[_pID].names;
262         bytes32 _name = plyr_[_pID].name;
263         
264         for (uint256 i = 1; i <= gID_; i++)
265         {
266             games_[i].receivePlayerInfo(_pID, _addr, _name);
267             if (_totalNames > 1)
268                 for (uint256 ii = 1; ii <= _totalNames; ii++)
269                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
270         }
271                 
272     }
273     
274     /**
275      * @dev players use this to change back to one of your old names.  tip, you'll
276      * still need to push that info to existing games.
277      * -functionhash- 0xb9291296
278      * @param _nameString the name you want to use 
279      */
280     function useMyOldName(string _nameString)
281         isHuman()
282         public 
283     {
284         // filter name, and get pID
285         bytes32 _name = _nameString.nameFilter();
286         uint256 _pID = pIDxAddr_[msg.sender];
287         
288         // make sure they own the name 
289         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
290         
291         // update their current name 
292         plyr_[_pID].name = _name;
293     }
294     
295 //==============================================================================
296 //     _ _  _ _   | _  _ . _  .
297 //    (_(_)| (/_  |(_)(_||(_  . 
298 //=====================_|=======================================================    
299     function registerNameCore(uint256 _pID, address _addr, bytes32 _name, bool _isNewPlayer, bool _all)
300         private
301     {
302         // if names already has been used, require that current msg sender owns the name
303         if (pIDxName_[_name] != 0)
304             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
305         
306         // add name to player profile, registry, and name book
307         plyr_[_pID].name = _name;
308         pIDxName_[_name] = _pID;
309         if (plyrNames_[_pID][_name] == false)
310         {
311             plyrNames_[_pID][_name] = true;
312             plyr_[_pID].names++;
313             plyrNameList_[_pID][plyr_[_pID].names] = _name;
314         }
315         
316         // registration fee goes directly to community rewards
317         NameFee.transfer(address(this).balance);
318         
319         // push player info to games
320         if (_all == true)
321             for (uint256 i = 1; i <= gID_; i++)
322                 games_[i].receivePlayerInfo(_pID, _addr, _name);
323         
324         // fire event
325         emit onNewName(_pID, _addr, _name, _isNewPlayer, msg.value, now);
326     }
327 //==============================================================================
328 //    _|_ _  _ | _  .
329 //     | (_)(_)|_\  .
330 //==============================================================================    
331     function determinePID(address _addr)
332         private
333         returns (bool)
334     {
335         if (pIDxAddr_[_addr] == 0)
336         {
337             pID_++;
338             pIDxAddr_[_addr] = pID_;
339             plyr_[pID_].addr = _addr;
340             
341             // set the new player bool to true
342             return (true);
343         } else {
344             return (false);
345         }
346     }
347 //==============================================================================
348 //   _   _|_ _  _ _  _ |   _ _ || _  .
349 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
350 //==============================================================================
351     function getPlayerID(address _addr)
352         isRegisteredGame()
353         external
354         returns (uint256)
355     {
356         determinePID(_addr);
357         return (pIDxAddr_[_addr]);
358     }
359     function getPlayerName(uint256 _pID)
360         external
361         view
362         returns (bytes32)
363     {
364         return (plyr_[_pID].name);
365     }
366     function getPlayerAddr(uint256 _pID)
367         external
368         view
369         returns (address)
370     {
371         return (plyr_[_pID].addr);
372     }
373     function getNameFee()
374         external
375         view
376         returns (uint256)
377     {
378         return(registrationFee_);
379     }
380     function registerNameXIDFromDapp(address _addr, bytes32 _name, bool _all)
381         isRegisteredGame()
382         external
383         payable
384         returns(bool)
385     {
386         // make sure name fees paid
387         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
388         
389         // set up our tx event data and determine if player is new or not
390         bool _isNewPlayer = determinePID(_addr);
391         
392         // fetch player id
393         uint256 _pID = pIDxAddr_[_addr];
394     
395         // register name 
396         registerNameCore(_pID, _addr, _name, _isNewPlayer, _all);
397         
398         return(_isNewPlayer);
399     }
400     function registerNameXaddrFromDapp(address _addr, bytes32 _name, bool _all)
401         isRegisteredGame()
402         external
403         payable
404         returns(bool)
405     {
406         // make sure name fees paid
407         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
408         
409         // set up our tx event data and determine if player is new or not
410         bool _isNewPlayer = determinePID(_addr);
411         
412         // fetch player id
413         uint256 _pID = pIDxAddr_[_addr];
414 
415         // register name 
416         registerNameCore(_pID, _addr, _name, _isNewPlayer, _all);
417         
418         return(_isNewPlayer);
419     }
420     function registerNameXnameFromDapp(address _addr, bytes32 _name, bool _all)
421         isRegisteredGame()
422         external
423         payable
424         returns(bool)
425     {
426         // make sure name fees paid
427         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
428         
429         // set up our tx event data and determine if player is new or not
430         bool _isNewPlayer = determinePID(_addr);
431         
432         // fetch player id
433         uint256 _pID = pIDxAddr_[_addr];
434         
435         // register name 
436         registerNameCore(_pID, _addr, _name, _isNewPlayer, _all);
437         
438         return(_isNewPlayer);
439     }
440     
441 //==============================================================================
442 //   _ _ _|_    _   .
443 //  _\(/_ | |_||_)  .
444 //=============|================================================================
445     function addGame(address _gameAddress, string _gameNameStr)
446         onlyDevs()
447         public
448     {
449         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
450         
451         if (multiSigDev("addGame") == true)
452         {deleteProposal("addGame");
453             gID_++;
454             bytes32 _name = _gameNameStr.nameFilter();
455             gameIDs_[_gameAddress] = gID_;
456             gameNames_[_gameAddress] = _name;
457             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
458         
459             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name);
460         }
461     }
462     
463     function setRegistrationFee(uint256 _fee)
464         onlyDevs()
465         public
466     {
467         if (multiSigDev("setRegistrationFee") == true)
468         {deleteProposal("setRegistrationFee");
469             registrationFee_ = _fee;
470         }
471     }
472         
473 }
474 
475 /**
476 * @title -Name Filter- beta
477 */
478 
479 library NameFilter {
480     /**
481      * @dev filters name strings
482      * -converts uppercase to lower case.  
483      * -makes sure it does not start/end with a space
484      * -makes sure it does not contain multiple spaces in a row
485      * -cannot be only numbers
486      * -cannot start with 0x 
487      * -restricts characters to A-Z, a-z, 0-9, and space.
488      * @return reprocessed string in bytes32 format
489      */
490     function nameFilter(string _input)
491         internal
492         pure
493         returns(bytes32)
494     {
495         bytes memory _temp = bytes(_input);
496         uint256 _length = _temp.length;
497         
498         //sorry limited to 32 characters
499         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
500         // make sure it doesnt start with or end with space
501         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
502         // make sure first two characters are not 0x
503         if (_temp[0] == 0x30)
504         {
505             require(_temp[1] != 0x78, "string cannot start with 0x");
506             require(_temp[1] != 0x58, "string cannot start with 0X");
507         }
508         
509         // create a bool to track if we have a non number character
510         bool _hasNonNumber;
511         
512         // convert & check
513         for (uint256 i = 0; i < _length; i++)
514         {
515             // if its uppercase A-Z
516             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
517             {
518                 // convert to lower case a-z
519                 _temp[i] = byte(uint(_temp[i]) + 32);
520                 
521                 // we have a non number
522                 if (_hasNonNumber == false)
523                     _hasNonNumber = true;
524             } else {
525                 require
526                 (
527                     // require character is a space
528                     _temp[i] == 0x20 || 
529                     // OR lowercase a-z
530                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
531                     // or 0-9
532                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
533                     "string contains invalid characters"
534                 );
535                 // make sure theres not 2x spaces in a row
536                 if (_temp[i] == 0x20)
537                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
538                 
539                 // see if we have a character other than a number
540                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
541                     _hasNonNumber = true;    
542             }
543         }
544         
545         require(_hasNonNumber == true, "string cannot be only numbers");
546         
547         bytes32 _ret;
548         assembly {
549             _ret := mload(add(_temp, 32))
550         }
551         return (_ret);
552     }
553 }
554 
555 /**
556  * @title SafeMath v0.1.9
557  * @dev Math operations with safety checks that throw on error
558  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
559  * - added sqrt
560  * - added sq
561  * - added pwr 
562  * - changed asserts to requires with error log outputs
563  * - removed div, its useless
564  */
565 library SafeMath {
566     
567     /**
568     * @dev Multiplies two numbers, throws on overflow.
569     */
570     function mul(uint256 a, uint256 b) 
571         internal 
572         pure 
573         returns (uint256 c) 
574     {
575         if (a == 0) {
576             return 0;
577         }
578         c = a * b;
579         require(c / a == b, "SafeMath mul failed");
580         return c;
581     }
582 
583     /**
584     * @dev Integer division of two numbers, truncating the quotient.
585     */
586     function div(uint256 a, uint256 b) internal pure returns (uint256) {
587         // assert(b > 0); // Solidity automatically throws when dividing by 0
588         uint256 c = a / b;
589         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
590         return c;
591     }
592     
593     /**
594     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
595     */
596     function sub(uint256 a, uint256 b)
597         internal
598         pure
599         returns (uint256) 
600     {
601         require(b <= a, "SafeMath sub failed");
602         return a - b;
603     }
604 
605     /**
606     * @dev Adds two numbers, throws on overflow.
607     */
608     function add(uint256 a, uint256 b)
609         internal
610         pure
611         returns (uint256 c) 
612     {
613         c = a + b;
614         require(c >= a, "SafeMath add failed");
615         return c;
616     }
617     
618     /**
619      * @dev gives square root of given x.
620      */
621     function sqrt(uint256 x)
622         internal
623         pure
624         returns (uint256 y) 
625     {
626         uint256 z = ((add(x,1)) / 2);
627         y = x;
628         while (z < y) 
629         {
630             y = z;
631             z = ((add((x / z),z)) / 2);
632         }
633     }
634     
635     /**
636      * @dev gives square. multiplies x by x
637      */
638     function sq(uint256 x)
639         internal
640         pure
641         returns (uint256)
642     {
643         return (mul(x,x));
644     }
645     
646     /**
647      * @dev x to the power of y 
648      */
649     function pwr(uint256 x, uint256 y)
650         internal 
651         pure 
652         returns (uint256)
653     {
654         if (x==0)
655             return (0);
656         else if (y==0)
657             return (1);
658         else 
659         {
660             uint256 z = x;
661             for (uint256 i=1; i < y; i++)
662                 z = mul(z,x);
663             return (z);
664         }
665     }
666 }
667 
668 /** @title -MSFun- v0.2.4
669  *
670  */
671 library MSFun {
672     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
673     // DATA SETS
674     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
675     // contact data setup
676     struct Data 
677     {
678         mapping (bytes32 => ProposalData) proposal_;
679     }
680     struct ProposalData 
681     {
682         // a hash of msg.data 
683         bytes32 msgData;
684         // number of signers
685         uint256 count;
686         // tracking of wither admins have signed
687         mapping (address => bool) admin;
688         // list of admins who have signed
689         mapping (uint256 => address) log;
690     }
691     
692     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
693     // MULTI SIG FUNCTIONS
694     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
695     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
696         internal
697         returns(bool) 
698     {
699         // our proposal key will be a hash of our function name + our contracts address 
700         // by adding our contracts address to this, we prevent anyone trying to circumvent
701         // the proposal's security via external calls.
702         bytes32 _whatProposal = whatProposal(_whatFunction);
703         
704         // this is just done to make the code more readable.  grabs the signature count
705         uint256 _currentCount = self.proposal_[_whatProposal].count;
706         
707         // store the address of the person sending the function call.  we use msg.sender 
708         // here as a layer of security.  in case someone imports our contract and tries to 
709         // circumvent function arguments.  still though, our contract that imports this
710         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
711         // calls the function will be a signer. 
712         address _whichAdmin = msg.sender;
713         
714         // prepare our msg data.  by storing this we are able to verify that all admins
715         // are approving the same argument input to be executed for the function.  we hash 
716         // it and store in bytes32 so its size is known and comparable
717         bytes32 _msgData = keccak256(msg.data);
718         
719         // check to see if this is a new execution of this proposal or not
720         if (_currentCount == 0)
721         {
722             // if it is, lets record the original signers data
723             self.proposal_[_whatProposal].msgData = _msgData;
724             
725             // record original senders signature
726             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
727             
728             // update log (used to delete records later, and easy way to view signers)
729             // also useful if the calling function wants to give something to a 
730             // specific signer.  
731             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
732             
733             // track number of signatures
734             self.proposal_[_whatProposal].count += 1;  
735             
736             // if we now have enough signatures to execute the function, lets
737             // return a bool of true.  we put this here in case the required signatures
738             // is set to 1.
739             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
740                 return(true);
741             }            
742         // if its not the first execution, lets make sure the msgData matches
743         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
744             // msgData is a match
745             // make sure admin hasnt already signed
746             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
747             {
748                 // record their signature
749                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
750                 
751                 // update log (used to delete records later, and easy way to view signers)
752                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
753                 
754                 // track number of signatures
755                 self.proposal_[_whatProposal].count += 1;  
756             }
757             
758             // if we now have enough signatures to execute the function, lets
759             // return a bool of true.
760             // we put this here for a few reasons.  (1) in normal operation, if 
761             // that last recorded signature got us to our required signatures.  we 
762             // need to return bool of true.  (2) if we have a situation where the 
763             // required number of signatures was adjusted to at or lower than our current 
764             // signature count, by putting this here, an admin who has already signed,
765             // can call the function again to make it return a true bool.  but only if
766             // they submit the correct msg data
767             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
768                 return(true);
769             }
770         }
771     }
772     
773     
774     // deletes proposal signature data after successfully executing a multiSig function
775     function deleteProposal(Data storage self, bytes32 _whatFunction)
776         internal
777     {
778         //done for readability sake
779         bytes32 _whatProposal = whatProposal(_whatFunction);
780         address _whichAdmin;
781         
782         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
783         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
784         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
785             _whichAdmin = self.proposal_[_whatProposal].log[i];
786             delete self.proposal_[_whatProposal].admin[_whichAdmin];
787             delete self.proposal_[_whatProposal].log[i];
788         }
789         //delete the rest of the data in the record
790         delete self.proposal_[_whatProposal];
791     }
792     
793     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
794     // HELPER FUNCTIONS
795     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
796 
797     function whatProposal(bytes32 _whatFunction)
798         private
799         view
800         returns(bytes32)
801     {
802         return(keccak256(abi.encodePacked(_whatFunction,this)));
803     }
804     
805     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
806     // VANITY FUNCTIONS
807     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
808     // returns a hashed version of msg.data sent by original signer for any given function
809     function checkMsgData (Data storage self, bytes32 _whatFunction)
810         internal
811         view
812         returns (bytes32 msg_data)
813     {
814         bytes32 _whatProposal = whatProposal(_whatFunction);
815         return (self.proposal_[_whatProposal].msgData);
816     }
817     
818     // returns number of signers for any given function
819     function checkCount (Data storage self, bytes32 _whatFunction)
820         internal
821         view
822         returns (uint256 signature_count)
823     {
824         bytes32 _whatProposal = whatProposal(_whatFunction);
825         return (self.proposal_[_whatProposal].count);
826     }
827     
828     // returns address of an admin who signed for any given function
829     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
830         internal
831         view
832         returns (address signer)
833     {
834         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
835         bytes32 _whatProposal = whatProposal(_whatFunction);
836         return (self.proposal_[_whatProposal].log[_signer - 1]);
837     }
838 }