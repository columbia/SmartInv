1 pragma solidity ^0.4.24;
2 interface PlayerBookReceiverInterface {
3     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
4     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
5 }
6 library NameFilter {
7     /**
8      * @dev filters name strings
9      * -converts uppercase to lower case.
10      * -makes sure it does not start/end with a space
11      * -makes sure it does not contain multiple spaces in a row
12      * -cannot be only numbers
13      * -cannot start with 0x
14      * -restricts characters to A-Z, a-z, 0-9, and space.
15      * @return reprocessed string in bytes32 format
16      */
17     function nameFilter(string _input)
18         internal
19         pure
20         returns(bytes32)
21     {
22         bytes memory _temp = bytes(_input);
23         uint256 _length = _temp.length;
24 
25         //sorry limited to 32 characters
26         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
27         // make sure it doesnt start with or end with space
28         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
29         // make sure first two characters are not 0x
30         if (_temp[0] == 0x30)
31         {
32             require(_temp[1] != 0x78, "string cannot start with 0x");
33             require(_temp[1] != 0x58, "string cannot start with 0X");
34         }
35 
36         // create a bool to track if we have a non number character
37         bool _hasNonNumber;
38 
39         // convert & check
40         for (uint256 i = 0; i < _length; i++)
41         {
42             // if its uppercase A-Z
43             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
44             {
45                 // convert to lower case a-z
46                 _temp[i] = byte(uint(_temp[i]) + 32);
47 
48                 // we have a non number
49                 if (_hasNonNumber == false)
50                     _hasNonNumber = true;
51             } else {
52                 require
53                 (
54                     // require character is a space
55                     _temp[i] == 0x20 ||
56                     // OR lowercase a-z
57                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
58                     // or 0-9
59                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
60                     "string contains invalid characters"
61                 );
62                 // make sure theres not 2x spaces in a row
63                 if (_temp[i] == 0x20)
64                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
65 
66                 // see if we have a character other than a number
67                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
68                     _hasNonNumber = true;
69             }
70         }
71 
72         require(_hasNonNumber == true, "string cannot be only numbers");
73 
74         bytes32 _ret;
75         assembly {
76             _ret := mload(add(_temp, 32))
77         }
78         return (_ret);
79     }
80 }
81 library SafeMath {
82 
83     /**
84     * @dev Multiplies two numbers, throws on overflow.
85     */
86     function mul(uint256 a, uint256 b)
87         internal
88         pure
89         returns (uint256 c)
90     {
91         if (a == 0) {
92             return 0;
93         }
94         c = a * b;
95         require(c / a == b, "SafeMath mul failed");
96         return c;
97     }
98 
99     /**
100     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
101     */
102     function sub(uint256 a, uint256 b)
103         internal
104         pure
105         returns (uint256)
106     {
107         require(b <= a, "SafeMath sub failed");
108         return a - b;
109     }
110 
111     /**
112     * @dev Adds two numbers, throws on overflow.
113     */
114     function add(uint256 a, uint256 b)
115         internal
116         pure
117         returns (uint256 c)
118     {
119         c = a + b;
120         require(c >= a, "SafeMath add failed");
121         return c;
122     }
123 
124     /**
125      * @dev gives square root of given x.
126      */
127     function sqrt(uint256 x)
128         internal
129         pure
130         returns (uint256 y)
131     {
132         uint256 z = ((add(x,1)) / 2);
133         y = x;
134         while (z < y)
135         {
136             y = z;
137             z = ((add((x / z),z)) / 2);
138         }
139     }
140 
141     /**
142      * @dev gives square. multiplies x by x
143      */
144     function sq(uint256 x)
145         internal
146         pure
147         returns (uint256)
148     {
149         return (mul(x,x));
150     }
151 
152     /**
153      * @dev x to the power of y
154      */
155     function pwr(uint256 x, uint256 y)
156         internal
157         pure
158         returns (uint256)
159     {
160         if (x==0)
161             return (0);
162         else if (y==0)
163             return (1);
164         else
165         {
166             uint256 z = x;
167             for (uint256 i=1; i < y; i++)
168                 z = mul(z,x);
169             return (z);
170         }
171     }
172 }
173 contract PlayerBook {
174     using NameFilter for string;
175     using SafeMath for uint256;
176     
177     address private admin = msg.sender;
178 //==============================================================================
179 //     _| _ _|_ _    _ _ _|_    _   .
180 //    (_|(_| | (_|  _\(/_ | |_||_)  .
181 //=============================|================================================    
182     uint256 public registrationFee_ = 10 finney;            // price to register a name
183     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
184     mapping(address => bytes32) public gameNames_;          // lookup a games name
185     mapping(address => uint256) public gameIDs_;            // lokup a games ID
186     uint256 public gID_;        // total number of games
187     uint256 public pID_;        // total number of players
188     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
189     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
190     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
191     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
192     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
193     struct Player {
194         address addr;
195         bytes32 name;
196         uint256 laff;
197         uint256 names;
198     }
199 //==============================================================================
200 //     _ _  _  __|_ _    __|_ _  _  .
201 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
202 //==============================================================================    
203     constructor()
204         public
205     {
206         // premine the dev names (sorry not sorry)
207             // No keys are purchased with this method, it's simply locking our addresses,
208             // PID's and names for referral codes.
209         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
210         plyr_[1].name = "justo";
211         plyr_[1].names = 1;
212         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
213         pIDxName_["justo"] = 1;
214         plyrNames_[1]["justo"] = true;
215         plyrNameList_[1][1] = "justo";
216         
217         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
218         plyr_[2].name = "mantso";
219         plyr_[2].names = 1;
220         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
221         pIDxName_["mantso"] = 2;
222         plyrNames_[2]["mantso"] = true;
223         plyrNameList_[2][1] = "mantso";
224         
225         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
226         plyr_[3].name = "sumpunk";
227         plyr_[3].names = 1;
228         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
229         pIDxName_["sumpunk"] = 3;
230         plyrNames_[3]["sumpunk"] = true;
231         plyrNameList_[3][1] = "sumpunk";
232         
233         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
234         plyr_[4].name = "inventor";
235         plyr_[4].names = 1;
236         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
237         pIDxName_["inventor"] = 4;
238         plyrNames_[4]["inventor"] = true;
239         plyrNameList_[4][1] = "inventor";
240         
241         pID_ = 4;
242     }
243 //==============================================================================
244 //     _ _  _  _|. |`. _  _ _  .
245 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
246 //==============================================================================    
247     /**
248      * @dev prevents contracts from interacting with fomo3d 
249      */
250     modifier isHuman() {
251         address _addr = msg.sender;
252         uint256 _codeLength;
253         
254         assembly {_codeLength := extcodesize(_addr)}
255         require(_codeLength == 0, "sorry humans only");
256         _;
257     }
258    
259     
260     modifier isRegisteredGame()
261     {
262         require(gameIDs_[msg.sender] != 0);
263         _;
264     }
265 //==============================================================================
266 //     _    _  _ _|_ _  .
267 //    (/_\/(/_| | | _\  .
268 //==============================================================================    
269     // fired whenever a player registers a name
270     event onNewName
271     (
272         uint256 indexed playerID,
273         address indexed playerAddress,
274         bytes32 indexed playerName,
275         bool isNewPlayer,
276         uint256 affiliateID,
277         address affiliateAddress,
278         bytes32 affiliateName,
279         uint256 amountPaid,
280         uint256 timeStamp
281     );
282 //==============================================================================
283 //     _  _ _|__|_ _  _ _  .
284 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
285 //=====_|=======================================================================
286     function checkIfNameValid(string _nameStr)
287         public
288         view
289         returns(bool)
290     {
291         bytes32 _name = _nameStr.nameFilter();
292         if (pIDxName_[_name] == 0)
293             return (true);
294         else 
295             return (false);
296     }
297 //==============================================================================
298 //     _    |_ |. _   |`    _  __|_. _  _  _  .
299 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
300 //====|=========================================================================    
301     /**
302      * @dev registers a name.  UI will always display the last name you registered.
303      * but you will still own all previously registered names to use as affiliate 
304      * links.
305      * - must pay a registration fee.
306      * - name must be unique
307      * - names will be converted to lowercase
308      * - name cannot start or end with a space 
309      * - cannot have more than 1 space in a row
310      * - cannot be only numbers
311      * - cannot start with 0x 
312      * - name must be at least 1 char
313      * - max length of 32 characters long
314      * - allowed characters: a-z, 0-9, and space
315      * -functionhash- 0x921dec21 (using ID for affiliate)
316      * -functionhash- 0x3ddd4698 (using address for affiliate)
317      * -functionhash- 0x685ffd83 (using name for affiliate)
318      * @param _nameString players desired name
319      * @param _affCode affiliate ID, address, or name of who refered you
320      * @param _all set to true if you want this to push your info to all games 
321      * (this might cost a lot of gas)
322      */
323     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
324         isHuman()
325         public
326         payable 
327     {
328         // make sure name fees paid
329         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
330         
331         // filter name + condition checks
332         bytes32 _name = NameFilter.nameFilter(_nameString);
333         
334         // set up address 
335         address _addr = msg.sender;
336         
337         // set up our tx event data and determine if player is new or not
338         bool _isNewPlayer = determinePID(_addr);
339         
340         // fetch player id
341         uint256 _pID = pIDxAddr_[_addr];
342         
343         // manage affiliate residuals
344         // if no affiliate code was given, no new affiliate code was given, or the 
345         // player tried to use their own pID as an affiliate code, lolz
346         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
347         {
348             // update last affiliate 
349             plyr_[_pID].laff = _affCode;
350         } else if (_affCode == _pID) {
351             _affCode = 0;
352         }
353         
354         // register name 
355         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
356     }
357     
358     function registerNameXaddr(string _nameString, address _affCode, bool _all)
359         isHuman()
360         public
361         payable 
362     {
363         // make sure name fees paid
364         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
365         
366         // filter name + condition checks
367         bytes32 _name = NameFilter.nameFilter(_nameString);
368         
369         // set up address 
370         address _addr = msg.sender;
371         
372         // set up our tx event data and determine if player is new or not
373         bool _isNewPlayer = determinePID(_addr);
374         
375         // fetch player id
376         uint256 _pID = pIDxAddr_[_addr];
377         
378         // manage affiliate residuals
379         // if no affiliate code was given or player tried to use their own, lolz
380         uint256 _affID;
381         if (_affCode != address(0) && _affCode != _addr)
382         {
383             // get affiliate ID from aff Code 
384             _affID = pIDxAddr_[_affCode];
385             
386             // if affID is not the same as previously stored 
387             if (_affID != plyr_[_pID].laff)
388             {
389                 // update last affiliate
390                 plyr_[_pID].laff = _affID;
391             }
392         }
393         
394         // register name 
395         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
396     }
397     
398     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
399         isHuman()
400         public
401         payable 
402     {
403         // make sure name fees paid
404         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
405         
406         // filter name + condition checks
407         bytes32 _name = NameFilter.nameFilter(_nameString);
408         
409         // set up address 
410         address _addr = msg.sender;
411         
412         // set up our tx event data and determine if player is new or not
413         bool _isNewPlayer = determinePID(_addr);
414         
415         // fetch player id
416         uint256 _pID = pIDxAddr_[_addr];
417         
418         // manage affiliate residuals
419         // if no affiliate code was given or player tried to use their own, lolz
420         uint256 _affID;
421         if (_affCode != "" && _affCode != _name)
422         {
423             // get affiliate ID from aff Code 
424             _affID = pIDxName_[_affCode];
425             
426             // if affID is not the same as previously stored 
427             if (_affID != plyr_[_pID].laff)
428             {
429                 // update last affiliate
430                 plyr_[_pID].laff = _affID;
431             }
432         }
433         
434         // register name 
435         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
436     }
437     
438     /**
439      * @dev players, if you registered a profile, before a game was released, or
440      * set the all bool to false when you registered, use this function to push
441      * your profile to a single game.  also, if you've  updated your name, you
442      * can use this to push your name to games of your choosing.
443      * -functionhash- 0x81c5b206
444      * @param _gameID game id 
445      */
446     function addMeToGame(uint256 _gameID)
447         isHuman()
448         public
449     {
450         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
451         address _addr = msg.sender;
452         uint256 _pID = pIDxAddr_[_addr];
453         require(_pID != 0, "hey there buddy, you dont even have an account");
454         uint256 _totalNames = plyr_[_pID].names;
455         
456         // add players profile and most recent name
457         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
458         
459         // add list of all names
460         if (_totalNames > 1)
461             for (uint256 ii = 1; ii <= _totalNames; ii++)
462                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
463     }
464     
465     /**
466      * @dev players, use this to push your player profile to all registered games.
467      * -functionhash- 0x0c6940ea
468      */
469     function addMeToAllGames()
470         isHuman()
471         public
472     {
473         address _addr = msg.sender;
474         uint256 _pID = pIDxAddr_[_addr];
475         require(_pID != 0, "hey there buddy, you dont even have an account");
476         uint256 _laff = plyr_[_pID].laff;
477         uint256 _totalNames = plyr_[_pID].names;
478         bytes32 _name = plyr_[_pID].name;
479         
480         for (uint256 i = 1; i <= gID_; i++)
481         {
482             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
483             if (_totalNames > 1)
484                 for (uint256 ii = 1; ii <= _totalNames; ii++)
485                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
486         }
487                 
488     }
489     
490     /**
491      * @dev players use this to change back to one of your old names.  tip, you'll
492      * still need to push that info to existing games.
493      * -functionhash- 0xb9291296
494      * @param _nameString the name you want to use 
495      */
496     function useMyOldName(string _nameString)
497         isHuman()
498         public 
499     {
500         // filter name, and get pID
501         bytes32 _name = _nameString.nameFilter();
502         uint256 _pID = pIDxAddr_[msg.sender];
503         
504         // make sure they own the name 
505         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
506         
507         // update their current name 
508         plyr_[_pID].name = _name;
509     }
510     
511 //==============================================================================
512 //     _ _  _ _   | _  _ . _  .
513 //    (_(_)| (/_  |(_)(_||(_  . 
514 //=====================_|=======================================================    
515     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
516         private
517     {
518         // if names already has been used, require that current msg sender owns the name
519         if (pIDxName_[_name] != 0)
520             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
521         
522         // add name to player profile, registry, and name book
523         plyr_[_pID].name = _name;
524         pIDxName_[_name] = _pID;
525         if (plyrNames_[_pID][_name] == false)
526         {
527             plyrNames_[_pID][_name] = true;
528             plyr_[_pID].names++;
529             plyrNameList_[_pID][plyr_[_pID].names] = _name;
530         }
531         
532         // registration fee goes directly to community rewards
533         admin.transfer(address(this).balance);
534         
535         // push player info to games
536         if (_all == true)
537             for (uint256 i = 1; i <= gID_; i++)
538                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
539         
540         // fire event
541         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
542     }
543 //==============================================================================
544 //    _|_ _  _ | _  .
545 //     | (_)(_)|_\  .
546 //==============================================================================    
547     function determinePID(address _addr)
548         private
549         returns (bool)
550     {
551         if (pIDxAddr_[_addr] == 0)
552         {
553             pID_++;
554             pIDxAddr_[_addr] = pID_;
555             plyr_[pID_].addr = _addr;
556             
557             // set the new player bool to true
558             return (true);
559         } else {
560             return (false);
561         }
562     }
563 //==============================================================================
564 //   _   _|_ _  _ _  _ |   _ _ || _  .
565 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
566 //==============================================================================
567     function getPlayerID(address _addr)
568         isRegisteredGame()
569         external
570         returns (uint256)
571     {
572         determinePID(_addr);
573         return (pIDxAddr_[_addr]);
574     }
575     function getPlayerName(uint256 _pID)
576         external
577         view
578         returns (bytes32)
579     {
580         return (plyr_[_pID].name);
581     }
582     function getPlayerLAff(uint256 _pID)
583         external
584         view
585         returns (uint256)
586     {
587         return (plyr_[_pID].laff);
588     }
589     function getPlayerAddr(uint256 _pID)
590         external
591         view
592         returns (address)
593     {
594         return (plyr_[_pID].addr);
595     }
596     function getNameFee()
597         external
598         view
599         returns (uint256)
600     {
601         return(registrationFee_);
602     }
603     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
604         isRegisteredGame()
605         external
606         payable
607         returns(bool, uint256)
608     {
609         // make sure name fees paid
610         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
611         
612         // set up our tx event data and determine if player is new or not
613         bool _isNewPlayer = determinePID(_addr);
614         
615         // fetch player id
616         uint256 _pID = pIDxAddr_[_addr];
617         
618         // manage affiliate residuals
619         // if no affiliate code was given, no new affiliate code was given, or the 
620         // player tried to use their own pID as an affiliate code, lolz
621         uint256 _affID = _affCode;
622         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
623         {
624             // update last affiliate 
625             plyr_[_pID].laff = _affID;
626         } else if (_affID == _pID) {
627             _affID = 0;
628         }
629         
630         // register name 
631         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
632         
633         return(_isNewPlayer, _affID);
634     }
635     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
636         isRegisteredGame()
637         external
638         payable
639         returns(bool, uint256)
640     {
641         // make sure name fees paid
642         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
643         
644         // set up our tx event data and determine if player is new or not
645         bool _isNewPlayer = determinePID(_addr);
646         
647         // fetch player id
648         uint256 _pID = pIDxAddr_[_addr];
649         
650         // manage affiliate residuals
651         // if no affiliate code was given or player tried to use their own, lolz
652         uint256 _affID;
653         if (_affCode != address(0) && _affCode != _addr)
654         {
655             // get affiliate ID from aff Code 
656             _affID = pIDxAddr_[_affCode];
657             
658             // if affID is not the same as previously stored 
659             if (_affID != plyr_[_pID].laff)
660             {
661                 // update last affiliate
662                 plyr_[_pID].laff = _affID;
663             }
664         }
665         
666         // register name 
667         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
668         
669         return(_isNewPlayer, _affID);
670     }
671     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
672         isRegisteredGame()
673         external
674         payable
675         returns(bool, uint256)
676     {
677         // make sure name fees paid
678         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
679         
680         // set up our tx event data and determine if player is new or not
681         bool _isNewPlayer = determinePID(_addr);
682         
683         // fetch player id
684         uint256 _pID = pIDxAddr_[_addr];
685         
686         // manage affiliate residuals
687         // if no affiliate code was given or player tried to use their own, lolz
688         uint256 _affID;
689         if (_affCode != "" && _affCode != _name)
690         {
691             // get affiliate ID from aff Code 
692             _affID = pIDxName_[_affCode];
693             
694             // if affID is not the same as previously stored 
695             if (_affID != plyr_[_pID].laff)
696             {
697                 // update last affiliate
698                 plyr_[_pID].laff = _affID;
699             }
700         }
701         
702         // register name 
703         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
704         
705         return(_isNewPlayer, _affID);
706     }
707     
708 //==============================================================================
709 //   _ _ _|_    _   .
710 //  _\(/_ | |_||_)  .
711 //=============|================================================================
712     function addGame(address _gameAddress, string _gameNameStr)
713         public
714     {
715         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
716             gID_++;
717             bytes32 _name = _gameNameStr.nameFilter();
718             gameIDs_[_gameAddress] = gID_;
719             gameNames_[_gameAddress] = _name;
720             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
721         
722             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
723             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
724             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
725             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
726     }
727     
728     function setRegistrationFee(uint256 _fee)
729         public
730     {
731       registrationFee_ = _fee;
732     }
733         
734 }