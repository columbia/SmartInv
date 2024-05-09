1 pragma solidity ^0.4.24;
2 /*
3  * FOMO Fast-PlayerBook - v0.3.14
4  */
5 
6 
7 interface PlayerBookReceiverInterface {
8     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
9     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
10 }
11 
12 
13 contract PlayerBook {
14     using NameFilter for string;
15     using SafeMath for uint256;
16 
17     address private admin = msg.sender;
18 //==============================================================================
19 //     _| _ _|_ _    _ _ _|_    _   .
20 //    (_|(_| | (_|  _\(/_ | |_||_)  .
21 //=============================|================================================
22     uint256 public registrationFee_ = 10 finney;            // price to register a name
23     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
24     mapping(address => bytes32) public gameNames_;          // lookup a games name
25     mapping(address => uint256) public gameIDs_;            // lokup a games ID
26     uint256 public gID_;        // total number of games
27     uint256 public pID_;        // total number of players
28     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
29     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
30     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
31     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
32     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
33     struct Player {
34         address addr;
35         bytes32 name;
36         uint256 laff;
37         uint256 names;
38     }
39 //==============================================================================
40 //     _ _  _  __|_ _    __|_ _  _  .
41 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
42 //==============================================================================
43     constructor()
44         public
45     {
46         // premine the dev names (sorry not sorry)
47             // No keys are purchased with this method, it's simply locking our addresses,
48             // PID's and names for referral codes.
49         plyr_[1].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
50         plyr_[1].name = "justo";
51         plyr_[1].names = 1;
52         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 1;
53         pIDxName_["justo"] = 1;
54         plyrNames_[1]["justo"] = true;
55         plyrNameList_[1][1] = "justo";
56 
57         plyr_[2].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
58         plyr_[2].name = "mantso";
59         plyr_[2].names = 1;
60         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 2;
61         pIDxName_["mantso"] = 2;
62         plyrNames_[2]["mantso"] = true;
63         plyrNameList_[2][1] = "mantso";
64 
65         plyr_[3].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
66         plyr_[3].name = "sumpunk";
67         plyr_[3].names = 1;
68         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 3;
69         pIDxName_["sumpunk"] = 3;
70         plyrNames_[3]["sumpunk"] = true;
71         plyrNameList_[3][1] = "sumpunk";
72 
73         plyr_[4].addr = 0x718B6aCa52548416e27AB38699cbc4C0Ed304b95;
74         plyr_[4].name = "inventor";
75         plyr_[4].names = 1;
76         pIDxAddr_[0x718B6aCa52548416e27AB38699cbc4C0Ed304b95] = 4;
77         pIDxName_["inventor"] = 4;
78         plyrNames_[4]["inventor"] = true;
79         plyrNameList_[4][1] = "inventor";
80 
81         pID_ = 4;
82     }
83 //==============================================================================
84 //     _ _  _  _|. |`. _  _ _  .
85 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
86 //==============================================================================
87     /**
88      * @dev prevents contracts from interacting with fomo3d
89      */
90     modifier isHuman() {
91         address _addr = msg.sender;
92         uint256 _codeLength;
93 
94         assembly {_codeLength := extcodesize(_addr)}
95         require(_codeLength == 0, "sorry humans only");
96         _;
97     }
98 
99 
100     modifier isRegisteredGame()
101     {
102         require(gameIDs_[msg.sender] != 0);
103         _;
104     }
105 //==============================================================================
106 //     _    _  _ _|_ _  .
107 //    (/_\/(/_| | | _\  .
108 //==============================================================================
109     // fired whenever a player registers a name
110     event onNewName
111     (
112         uint256 indexed playerID,
113         address indexed playerAddress,
114         bytes32 indexed playerName,
115         bool isNewPlayer,
116         uint256 affiliateID,
117         address affiliateAddress,
118         bytes32 affiliateName,
119         uint256 amountPaid,
120         uint256 timeStamp
121     );
122 //==============================================================================
123 //     _  _ _|__|_ _  _ _  .
124 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
125 //=====_|=======================================================================
126     function checkIfNameValid(string _nameStr)
127         public
128         view
129         returns(bool)
130     {
131         bytes32 _name = _nameStr.nameFilter();
132         if (pIDxName_[_name] == 0)
133             return (true);
134         else
135             return (false);
136     }
137 //==============================================================================
138 //     _    |_ |. _   |`    _  __|_. _  _  _  .
139 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
140 //====|=========================================================================
141     /**
142      * @dev registers a name.  UI will always display the last name you registered.
143      * but you will still own all previously registered names to use as affiliate
144      * links.
145      * - must pay a registration fee.
146      * - name must be unique
147      * - names will be converted to lowercase
148      * - name cannot start or end with a space
149      * - cannot have more than 1 space in a row
150      * - cannot be only numbers
151      * - cannot start with 0x
152      * - name must be at least 1 char
153      * - max length of 32 characters long
154      * - allowed characters: a-z, 0-9, and space
155      * -functionhash- 0x921dec21 (using ID for affiliate)
156      * -functionhash- 0x3ddd4698 (using address for affiliate)
157      * -functionhash- 0x685ffd83 (using name for affiliate)
158      * @param _nameString players desired name
159      * @param _affCode affiliate ID, address, or name of who refered you
160      * @param _all set to true if you want this to push your info to all games
161      * (this might cost a lot of gas)
162      */
163     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
164         isHuman()
165         public
166         payable
167     {
168         // make sure name fees paid
169         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
170 
171         // filter name + condition checks
172         bytes32 _name = NameFilter.nameFilter(_nameString);
173 
174         // set up address
175         address _addr = msg.sender;
176 
177         // set up our tx event data and determine if player is new or not
178         bool _isNewPlayer = determinePID(_addr);
179 
180         // fetch player id
181         uint256 _pID = pIDxAddr_[_addr];
182 
183         // manage affiliate residuals
184         // if no affiliate code was given, no new affiliate code was given, or the
185         // player tried to use their own pID as an affiliate code, lolz
186         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
187         {
188             // update last affiliate
189             plyr_[_pID].laff = _affCode;
190         } else if (_affCode == _pID) {
191             _affCode = 0;
192         }
193 
194         // register name
195         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
196     }
197 
198     function registerNameXaddr(string _nameString, address _affCode, bool _all)
199         isHuman()
200         public
201         payable
202     {
203         // make sure name fees paid
204         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
205 
206         // filter name + condition checks
207         bytes32 _name = NameFilter.nameFilter(_nameString);
208 
209         // set up address
210         address _addr = msg.sender;
211 
212         // set up our tx event data and determine if player is new or not
213         bool _isNewPlayer = determinePID(_addr);
214 
215         // fetch player id
216         uint256 _pID = pIDxAddr_[_addr];
217 
218         // manage affiliate residuals
219         // if no affiliate code was given or player tried to use their own, lolz
220         uint256 _affID;
221         if (_affCode != address(0) && _affCode != _addr)
222         {
223             // get affiliate ID from aff Code
224             _affID = pIDxAddr_[_affCode];
225 
226             // if affID is not the same as previously stored
227             if (_affID != plyr_[_pID].laff)
228             {
229                 // update last affiliate
230                 plyr_[_pID].laff = _affID;
231             }
232         }
233 
234         // register name
235         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
236     }
237 
238     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
239         isHuman()
240         public
241         payable
242     {
243         // make sure name fees paid
244         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
245 
246         // filter name + condition checks
247         bytes32 _name = NameFilter.nameFilter(_nameString);
248 
249         // set up address
250         address _addr = msg.sender;
251 
252         // set up our tx event data and determine if player is new or not
253         bool _isNewPlayer = determinePID(_addr);
254 
255         // fetch player id
256         uint256 _pID = pIDxAddr_[_addr];
257 
258         // manage affiliate residuals
259         // if no affiliate code was given or player tried to use their own, lolz
260         uint256 _affID;
261         if (_affCode != "" && _affCode != _name)
262         {
263             // get affiliate ID from aff Code
264             _affID = pIDxName_[_affCode];
265 
266             // if affID is not the same as previously stored
267             if (_affID != plyr_[_pID].laff)
268             {
269                 // update last affiliate
270                 plyr_[_pID].laff = _affID;
271             }
272         }
273 
274         // register name
275         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
276     }
277 
278     /**
279      * @dev players, if you registered a profile, before a game was released, or
280      * set the all bool to false when you registered, use this function to push
281      * your profile to a single game.  also, if you've  updated your name, you
282      * can use this to push your name to games of your choosing.
283      * -functionhash- 0x81c5b206
284      * @param _gameID game id
285      */
286     function addMeToGame(uint256 _gameID)
287         isHuman()
288         public
289     {
290         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
291         address _addr = msg.sender;
292         uint256 _pID = pIDxAddr_[_addr];
293         require(_pID != 0, "hey there buddy, you dont even have an account");
294         uint256 _totalNames = plyr_[_pID].names;
295 
296         // add players profile and most recent name
297         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
298 
299         // add list of all names
300         if (_totalNames > 1)
301             for (uint256 ii = 1; ii <= _totalNames; ii++)
302                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
303     }
304 
305     /**
306      * @dev players, use this to push your player profile to all registered games.
307      * -functionhash- 0x0c6940ea
308      */
309     function addMeToAllGames()
310         isHuman()
311         public
312     {
313         address _addr = msg.sender;
314         uint256 _pID = pIDxAddr_[_addr];
315         require(_pID != 0, "hey there buddy, you dont even have an account");
316         uint256 _laff = plyr_[_pID].laff;
317         uint256 _totalNames = plyr_[_pID].names;
318         bytes32 _name = plyr_[_pID].name;
319 
320         for (uint256 i = 1; i <= gID_; i++)
321         {
322             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
323             if (_totalNames > 1)
324                 for (uint256 ii = 1; ii <= _totalNames; ii++)
325                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
326         }
327 
328     }
329 
330     /**
331      * @dev players use this to change back to one of your old names.  tip, you'll
332      * still need to push that info to existing games.
333      * -functionhash- 0xb9291296
334      * @param _nameString the name you want to use
335      */
336     function useMyOldName(string _nameString)
337         isHuman()
338         public
339     {
340         // filter name, and get pID
341         bytes32 _name = _nameString.nameFilter();
342         uint256 _pID = pIDxAddr_[msg.sender];
343 
344         // make sure they own the name
345         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
346 
347         // update their current name
348         plyr_[_pID].name = _name;
349     }
350 
351 //==============================================================================
352 //     _ _  _ _   | _  _ . _  .
353 //    (_(_)| (/_  |(_)(_||(_  .
354 //=====================_|=======================================================
355     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
356         private
357     {
358         // if names already has been used, require that current msg sender owns the name
359         if (pIDxName_[_name] != 0)
360             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
361 
362         // add name to player profile, registry, and name book
363         plyr_[_pID].name = _name;
364         pIDxName_[_name] = _pID;
365         if (plyrNames_[_pID][_name] == false)
366         {
367             plyrNames_[_pID][_name] = true;
368             plyr_[_pID].names++;
369             plyrNameList_[_pID][plyr_[_pID].names] = _name;
370         }
371 
372         // registration fee goes directly to community rewards
373         admin.transfer(address(this).balance);
374 
375         // push player info to games
376         if (_all == true)
377             for (uint256 i = 1; i <= gID_; i++)
378                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
379 
380         // fire event
381         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
382     }
383 //==============================================================================
384 //    _|_ _  _ | _  .
385 //     | (_)(_)|_\  .
386 //==============================================================================
387     function determinePID(address _addr)
388         private
389         returns (bool)
390     {
391         if (pIDxAddr_[_addr] == 0)
392         {
393             pID_++;
394             pIDxAddr_[_addr] = pID_;
395             plyr_[pID_].addr = _addr;
396 
397             // set the new player bool to true
398             return (true);
399         } else {
400             return (false);
401         }
402     }
403 //==============================================================================
404 //   _   _|_ _  _ _  _ |   _ _ || _  .
405 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
406 //==============================================================================
407     function getPlayerID(address _addr)
408         isRegisteredGame()
409         external
410         returns (uint256)
411     {
412         determinePID(_addr);
413         return (pIDxAddr_[_addr]);
414     }
415     function getPlayerName(uint256 _pID)
416         external
417         view
418         returns (bytes32)
419     {
420         return (plyr_[_pID].name);
421     }
422     function getPlayerLAff(uint256 _pID)
423         external
424         view
425         returns (uint256)
426     {
427         return (plyr_[_pID].laff);
428     }
429     function getPlayerAddr(uint256 _pID)
430         external
431         view
432         returns (address)
433     {
434         return (plyr_[_pID].addr);
435     }
436     function getNameFee()
437         external
438         view
439         returns (uint256)
440     {
441         return(registrationFee_);
442     }
443     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
444         isRegisteredGame()
445         external
446         payable
447         returns(bool, uint256)
448     {
449         // make sure name fees paid
450         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
451 
452         // set up our tx event data and determine if player is new or not
453         bool _isNewPlayer = determinePID(_addr);
454 
455         // fetch player id
456         uint256 _pID = pIDxAddr_[_addr];
457 
458         // manage affiliate residuals
459         // if no affiliate code was given, no new affiliate code was given, or the
460         // player tried to use their own pID as an affiliate code, lolz
461         uint256 _affID = _affCode;
462         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
463         {
464             // update last affiliate
465             plyr_[_pID].laff = _affID;
466         } else if (_affID == _pID) {
467             _affID = 0;
468         }
469 
470         // register name
471         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
472 
473         return(_isNewPlayer, _affID);
474     }
475     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
476         isRegisteredGame()
477         external
478         payable
479         returns(bool, uint256)
480     {
481         // make sure name fees paid
482         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
483 
484         // set up our tx event data and determine if player is new or not
485         bool _isNewPlayer = determinePID(_addr);
486 
487         // fetch player id
488         uint256 _pID = pIDxAddr_[_addr];
489 
490         // manage affiliate residuals
491         // if no affiliate code was given or player tried to use their own, lolz
492         uint256 _affID;
493         if (_affCode != address(0) && _affCode != _addr)
494         {
495             // get affiliate ID from aff Code
496             _affID = pIDxAddr_[_affCode];
497 
498             // if affID is not the same as previously stored
499             if (_affID != plyr_[_pID].laff)
500             {
501                 // update last affiliate
502                 plyr_[_pID].laff = _affID;
503             }
504         }
505 
506         // register name
507         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
508 
509         return(_isNewPlayer, _affID);
510     }
511     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
512         isRegisteredGame()
513         external
514         payable
515         returns(bool, uint256)
516     {
517         // make sure name fees paid
518         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
519 
520         // set up our tx event data and determine if player is new or not
521         bool _isNewPlayer = determinePID(_addr);
522 
523         // fetch player id
524         uint256 _pID = pIDxAddr_[_addr];
525 
526         // manage affiliate residuals
527         // if no affiliate code was given or player tried to use their own, lolz
528         uint256 _affID;
529         if (_affCode != "" && _affCode != _name)
530         {
531             // get affiliate ID from aff Code
532             _affID = pIDxName_[_affCode];
533 
534             // if affID is not the same as previously stored
535             if (_affID != plyr_[_pID].laff)
536             {
537                 // update last affiliate
538                 plyr_[_pID].laff = _affID;
539             }
540         }
541 
542         // register name
543         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
544 
545         return(_isNewPlayer, _affID);
546     }
547 
548 //==============================================================================
549 //   _ _ _|_    _   .
550 //  _\(/_ | |_||_)  .
551 //=============|================================================================
552     function addGame(address _gameAddress, string _gameNameStr)
553         public
554     {
555         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
556             gID_++;
557             bytes32 _name = _gameNameStr.nameFilter();
558             gameIDs_[_gameAddress] = gID_;
559             gameNames_[_gameAddress] = _name;
560             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
561 
562             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
563             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
564             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
565             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
566     }
567 
568     function setRegistrationFee(uint256 _fee)
569         public
570     {
571       registrationFee_ = _fee;
572     }
573 
574 }
575 
576 /**
577 * @title -Name Filter- v0.1.9
578 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
579 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
580 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
581 *                                  _____                      _____
582 *                                 (, /     /)       /) /)    (, /      /)          /)
583 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
584 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
585 *          ┴ ┴                /   /          .-/ _____   (__ /
586 *                            (__ /          (_/ (, /                                      /)™
587 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
588 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
589 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
590 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
591 *              _       __    _      ____      ____  _   _    _____  ____  ___
592 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
593 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
594 *
595 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
596 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
597 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
598 */
599 library NameFilter {
600 
601     /**
602      * @dev filters name strings
603      * -converts uppercase to lower case.
604      * -makes sure it does not start/end with a space
605      * -makes sure it does not contain multiple spaces in a row
606      * -cannot be only numbers
607      * -cannot start with 0x
608      * -restricts characters to A-Z, a-z, 0-9, and space.
609      * @return reprocessed string in bytes32 format
610      */
611     function nameFilter(string _input)
612         internal
613         pure
614         returns(bytes32)
615     {
616         bytes memory _temp = bytes(_input);
617         uint256 _length = _temp.length;
618 
619         //sorry limited to 32 characters
620         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
621         // make sure it doesnt start with or end with space
622         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
623         // make sure first two characters are not 0x
624         if (_temp[0] == 0x30)
625         {
626             require(_temp[1] != 0x78, "string cannot start with 0x");
627             require(_temp[1] != 0x58, "string cannot start with 0X");
628         }
629 
630         // create a bool to track if we have a non number character
631         bool _hasNonNumber;
632 
633         // convert & check
634         for (uint256 i = 0; i < _length; i++)
635         {
636             // if its uppercase A-Z
637             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
638             {
639                 // convert to lower case a-z
640                 _temp[i] = byte(uint(_temp[i]) + 32);
641 
642                 // we have a non number
643                 if (_hasNonNumber == false)
644                     _hasNonNumber = true;
645             } else {
646                 require
647                 (
648                     // require character is a space
649                     _temp[i] == 0x20 ||
650                     // OR lowercase a-z
651                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
652                     // or 0-9
653                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
654                     "string contains invalid characters"
655                 );
656                 // make sure theres not 2x spaces in a row
657                 if (_temp[i] == 0x20)
658                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
659 
660                 // see if we have a character other than a number
661                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
662                     _hasNonNumber = true;
663             }
664         }
665 
666         require(_hasNonNumber == true, "string cannot be only numbers");
667 
668         bytes32 _ret;
669         assembly {
670             _ret := mload(add(_temp, 32))
671         }
672         return (_ret);
673     }
674 }
675 
676 /**
677  * @title SafeMath v0.1.9
678  * @dev Math operations with safety checks that throw on error
679  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
680  * - added sqrt
681  * - added sq
682  * - added pwr
683  * - changed asserts to requires with error log outputs
684  * - removed div, its useless
685  */
686 library SafeMath {
687 
688     /**
689     * @dev Multiplies two numbers, throws on overflow.
690     */
691     function mul(uint256 a, uint256 b)
692         internal
693         pure
694         returns (uint256 c)
695     {
696         if (a == 0) {
697             return 0;
698         }
699         c = a * b;
700         require(c / a == b, "SafeMath mul failed");
701         return c;
702     }
703 
704     /**
705     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
706     */
707     function sub(uint256 a, uint256 b)
708         internal
709         pure
710         returns (uint256)
711     {
712         require(b <= a, "SafeMath sub failed");
713         return a - b;
714     }
715 
716     /**
717     * @dev Adds two numbers, throws on overflow.
718     */
719     function add(uint256 a, uint256 b)
720         internal
721         pure
722         returns (uint256 c)
723     {
724         c = a + b;
725         require(c >= a, "SafeMath add failed");
726         return c;
727     }
728 
729     /**
730      * @dev gives square root of given x.
731      */
732     function sqrt(uint256 x)
733         internal
734         pure
735         returns (uint256 y)
736     {
737         uint256 z = ((add(x,1)) / 2);
738         y = x;
739         while (z < y)
740         {
741             y = z;
742             z = ((add((x / z),z)) / 2);
743         }
744     }
745 
746     /**
747      * @dev gives square. multiplies x by x
748      */
749     function sq(uint256 x)
750         internal
751         pure
752         returns (uint256)
753     {
754         return (mul(x,x));
755     }
756 
757     /**
758      * @dev x to the power of y
759      */
760     function pwr(uint256 x, uint256 y)
761         internal
762         pure
763         returns (uint256)
764     {
765         if (x==0)
766             return (0);
767         else if (y==0)
768             return (1);
769         else
770         {
771             uint256 z = x;
772             for (uint256 i=1; i < y; i++)
773                 z = mul(z,x);
774             return (z);
775         }
776     }
777 }