1 pragma solidity ^0.4.24;
2 /*
3  * -PlayerBook - v0.3.14
4  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
5  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
6  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
7  *                                  _____                      _____
8  *                                 (, /     /)       /) /)    (, /      /)          /)
9  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
10  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
11  *          ┴ ┴                /   /          .-/ _____   (__ /
12  *                            (__ /          (_/ (, /                                      /)™
13  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
14  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
15  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
16  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
17  *     ______   _                                 ______                 _
18  *====(_____ \=| |===============================(____  \===============| |=============*
19  *     _____) )| |  _____  _   _  _____   ____    ____)  )  ___    ___  | |  _
20  *    |  ____/ | | (____ || | | || ___ | / ___)  |  __  (  / _ \  / _ \ | |_/ )
21  *    | |      | | / ___ || |_| || ____|| |      | |__)  )| |_| || |_| ||  _ (
22  *====|_|=======\_)\_____|=\__  ||_____)|_|======|______/==\___/==\___/=|_|=\_)=========*
23  *                        (____/
24  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
25  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
26  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
27  */
28 
29 
30 interface PlayerBookReceiverInterface {
31     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
32     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
33 }
34 
35 
36 contract PlayerBook {
37     using NameFilter for string;
38     using SafeMath for uint256;
39 
40     address private admin = msg.sender;
41     //==============================================================================
42     //     _| _ _|_ _    _ _ _|_    _   .
43     //    (_|(_| | (_|  _\(/_ | |_||_)  .
44     //=============================|================================================
45     uint256 public registrationFee_ = 10 finney;            // price to register a name
46     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
47     mapping(address => bytes32) public gameNames_;          // lookup a games name
48     mapping(address => uint256) public gameIDs_;            // lokup a games ID
49     uint256 public gID_;        // total number of games
50     uint256 public pID_;        // total number of players
51     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
52     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
53     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
54     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
55     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
56     struct Player {
57         address addr;
58         bytes32 name;
59         uint256 laff;
60         uint256 names;
61     }
62     //==============================================================================
63     //     _ _  _  __|_ _    __|_ _  _  .
64     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
65     //==============================================================================
66     constructor()
67     public
68     {
69         // premine the dev names (sorry not sorry)
70         // No keys are purchased with this method, it's simply locking our addresses,
71         // PID's and names for referral codes.
72         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
73         plyr_[1].name = "justo";
74         plyr_[1].names = 1;
75         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
76         pIDxName_["justo"] = 1;
77         plyrNames_[1]["justo"] = true;
78         plyrNameList_[1][1] = "justo";
79         pID_ = 1;
80     }
81     //==============================================================================
82     //     _ _  _  _|. |`. _  _ _  .
83     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
84     //==============================================================================
85     /**
86      * @dev prevents contracts from interacting with fomo3d
87      */
88     modifier isHuman() {
89         address _addr = msg.sender;
90         uint256 _codeLength;
91 
92         assembly {_codeLength := extcodesize(_addr)}
93         require(_codeLength == 0, "sorry humans only");
94         _;
95     }
96 
97 
98     modifier isRegisteredGame()
99     {
100         require(gameIDs_[msg.sender] != 0);
101         _;
102     }
103     //==============================================================================
104     //     _    _  _ _|_ _  .
105     //    (/_\/(/_| | | _\  .
106     //==============================================================================
107     // fired whenever a player registers a name
108     event onNewName
109     (
110         uint256 indexed playerID,
111         address indexed playerAddress,
112         bytes32 indexed playerName,
113         bool isNewPlayer,
114         uint256 affiliateID,
115         address affiliateAddress,
116         bytes32 affiliateName,
117         uint256 amountPaid,
118         uint256 timeStamp
119     );
120     //==============================================================================
121     //     _  _ _|__|_ _  _ _  .
122     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
123     //=====_|=======================================================================
124     function checkIfNameValid(string _nameStr)
125     public
126     view
127     returns(bool)
128     {
129         bytes32 _name = _nameStr.nameFilter();
130         if (pIDxName_[_name] == 0)
131             return (true);
132         else
133             return (false);
134     }
135     //==============================================================================
136     //     _    |_ |. _   |`    _  __|_. _  _  _  .
137     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
138     //====|=========================================================================
139     /**
140      * @dev registers a name.  UI will always display the last name you registered.
141      * but you will still own all previously registered names to use as affiliate
142      * links.
143      * - must pay a registration fee.
144      * - name must be unique
145      * - names will be converted to lowercase
146      * - name cannot start or end with a space
147      * - cannot have more than 1 space in a row
148      * - cannot be only numbers
149      * - cannot start with 0x
150      * - name must be at least 1 char
151      * - max length of 32 characters long
152      * - allowed characters: a-z, 0-9, and space
153      * -functionhash- 0x921dec21 (using ID for affiliate)
154      * -functionhash- 0x3ddd4698 (using address for affiliate)
155      * -functionhash- 0x685ffd83 (using name for affiliate)
156      * @param _nameString players desired name
157      * @param _affCode affiliate ID, address, or name of who refered you
158      * @param _all set to true if you want this to push your info to all games
159      * (this might cost a lot of gas)
160      */
161     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
162     isHuman()
163     public
164     payable
165     {
166         // make sure name fees paid
167         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
168 
169         // filter name + condition checks
170         bytes32 _name = NameFilter.nameFilter(_nameString);
171 
172         // set up address
173         address _addr = msg.sender;
174 
175         // set up our tx event data and determine if player is new or not
176         bool _isNewPlayer = determinePID(_addr);
177 
178         // fetch player id
179         uint256 _pID = pIDxAddr_[_addr];
180 
181         // manage affiliate residuals
182         // if no affiliate code was given, no new affiliate code was given, or the
183         // player tried to use their own pID as an affiliate code, lolz
184         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
185         {
186             // update last affiliate
187             plyr_[_pID].laff = _affCode;
188         } else if (_affCode == _pID) {
189             _affCode = 0;
190         }
191 
192         // register name
193         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
194     }
195 
196     function registerNameXaddr(string _nameString, address _affCode, bool _all)
197     isHuman()
198     public
199     payable
200     {
201         // make sure name fees paid
202         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
203 
204         // filter name + condition checks
205         bytes32 _name = NameFilter.nameFilter(_nameString);
206 
207         // set up address
208         address _addr = msg.sender;
209 
210         // set up our tx event data and determine if player is new or not
211         bool _isNewPlayer = determinePID(_addr);
212 
213         // fetch player id
214         uint256 _pID = pIDxAddr_[_addr];
215 
216         // manage affiliate residuals
217         // if no affiliate code was given or player tried to use their own, lolz
218         uint256 _affID;
219         if (_affCode != address(0) && _affCode != _addr)
220         {
221             // get affiliate ID from aff Code
222             _affID = pIDxAddr_[_affCode];
223 
224             // if affID is not the same as previously stored
225             if (_affID != plyr_[_pID].laff)
226             {
227                 // update last affiliate
228                 plyr_[_pID].laff = _affID;
229             }
230         }
231 
232         // register name
233         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
234     }
235 
236     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
237     isHuman()
238     public
239     payable
240     {
241         // make sure name fees paid
242         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
243 
244         // filter name + condition checks
245         bytes32 _name = NameFilter.nameFilter(_nameString);
246 
247         // set up address
248         address _addr = msg.sender;
249 
250         // set up our tx event data and determine if player is new or not
251         bool _isNewPlayer = determinePID(_addr);
252 
253         // fetch player id
254         uint256 _pID = pIDxAddr_[_addr];
255 
256         // manage affiliate residuals
257         // if no affiliate code was given or player tried to use their own, lolz
258         uint256 _affID;
259         if (_affCode != "" && _affCode != _name)
260         {
261             // get affiliate ID from aff Code
262             _affID = pIDxName_[_affCode];
263 
264             // if affID is not the same as previously stored
265             if (_affID != plyr_[_pID].laff)
266             {
267                 // update last affiliate
268                 plyr_[_pID].laff = _affID;
269             }
270         }
271 
272         // register name
273         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
274     }
275 
276     /**
277      * @dev players, if you registered a profile, before a game was released, or
278      * set the all bool to false when you registered, use this function to push
279      * your profile to a single game.  also, if you've  updated your name, you
280      * can use this to push your name to games of your choosing.
281      * -functionhash- 0x81c5b206
282      * @param _gameID game id
283      */
284     function addMeToGame(uint256 _gameID)
285     isHuman()
286     public
287     {
288         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
289         address _addr = msg.sender;
290         uint256 _pID = pIDxAddr_[_addr];
291         require(_pID != 0, "hey there buddy, you dont even have an account");
292         uint256 _totalNames = plyr_[_pID].names;
293 
294         // add players profile and most recent name
295         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
296 
297         // add list of all names
298         if (_totalNames > 1)
299             for (uint256 ii = 1; ii <= _totalNames; ii++)
300                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
301     }
302 
303     /**
304      * @dev players, use this to push your player profile to all registered games.
305      * -functionhash- 0x0c6940ea
306      */
307     function addMeToAllGames()
308     isHuman()
309     public
310     {
311         address _addr = msg.sender;
312         uint256 _pID = pIDxAddr_[_addr];
313         require(_pID != 0, "hey there buddy, you dont even have an account");
314         uint256 _laff = plyr_[_pID].laff;
315         uint256 _totalNames = plyr_[_pID].names;
316         bytes32 _name = plyr_[_pID].name;
317 
318         for (uint256 i = 1; i <= gID_; i++)
319         {
320             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
321             if (_totalNames > 1)
322                 for (uint256 ii = 1; ii <= _totalNames; ii++)
323                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
324         }
325 
326     }
327 
328     /**
329      * @dev players use this to change back to one of your old names.  tip, you'll
330      * still need to push that info to existing games.
331      * -functionhash- 0xb9291296
332      * @param _nameString the name you want to use
333      */
334     function useMyOldName(string _nameString)
335     isHuman()
336     public
337     {
338         // filter name, and get pID
339         bytes32 _name = _nameString.nameFilter();
340         uint256 _pID = pIDxAddr_[msg.sender];
341 
342         // make sure they own the name
343         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
344 
345         // update their current name
346         plyr_[_pID].name = _name;
347     }
348 
349     //==============================================================================
350     //     _ _  _ _   | _  _ . _  .
351     //    (_(_)| (/_  |(_)(_||(_  .
352     //=====================_|=======================================================
353     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
354     private
355     {
356         // if names already has been used, require that current msg sender owns the name
357         if (pIDxName_[_name] != 0)
358             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
359 
360         // add name to player profile, registry, and name book
361         plyr_[_pID].name = _name;
362         pIDxName_[_name] = _pID;
363         if (plyrNames_[_pID][_name] == false)
364         {
365             plyrNames_[_pID][_name] = true;
366             plyr_[_pID].names++;
367             plyrNameList_[_pID][plyr_[_pID].names] = _name;
368         }
369 
370         // registration fee goes directly to community rewards
371         admin.transfer(address(this).balance);
372 
373         // push player info to games
374         if (_all == true)
375             for (uint256 i = 1; i <= gID_; i++)
376                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
377 
378         // fire event
379         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
380     }
381     //==============================================================================
382     //    _|_ _  _ | _  .
383     //     | (_)(_)|_\  .
384     //==============================================================================
385     function determinePID(address _addr)
386     private
387     returns (bool)
388     {
389         if (pIDxAddr_[_addr] == 0)
390         {
391             pID_++;
392             pIDxAddr_[_addr] = pID_;
393             plyr_[pID_].addr = _addr;
394 
395             // set the new player bool to true
396             return (true);
397         } else {
398             return (false);
399         }
400     }
401     //==============================================================================
402     //   _   _|_ _  _ _  _ |   _ _ || _  .
403     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
404     //==============================================================================
405     function getPlayerID(address _addr)
406     isRegisteredGame()
407     external
408     returns (uint256)
409     {
410         determinePID(_addr);
411         return (pIDxAddr_[_addr]);
412     }
413     function getPlayerName(uint256 _pID)
414     external
415     view
416     returns (bytes32)
417     {
418         return (plyr_[_pID].name);
419     }
420     function getPlayerLAff(uint256 _pID)
421     external
422     view
423     returns (uint256)
424     {
425         return (plyr_[_pID].laff);
426     }
427     function getPlayerAddr(uint256 _pID)
428     external
429     view
430     returns (address)
431     {
432         return (plyr_[_pID].addr);
433     }
434     function getNameFee()
435     external
436     view
437     returns (uint256)
438     {
439         return(registrationFee_);
440     }
441     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
442     isRegisteredGame()
443     external
444     payable
445     returns(bool, uint256)
446     {
447         // make sure name fees paid
448         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
449 
450         // set up our tx event data and determine if player is new or not
451         bool _isNewPlayer = determinePID(_addr);
452 
453         // fetch player id
454         uint256 _pID = pIDxAddr_[_addr];
455 
456         // manage affiliate residuals
457         // if no affiliate code was given, no new affiliate code was given, or the
458         // player tried to use their own pID as an affiliate code, lolz
459         uint256 _affID = _affCode;
460         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
461         {
462             // update last affiliate
463             plyr_[_pID].laff = _affID;
464         } else if (_affID == _pID) {
465             _affID = 0;
466         }
467 
468         // register name
469         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
470 
471         return(_isNewPlayer, _affID);
472     }
473     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
474     isRegisteredGame()
475     external
476     payable
477     returns(bool, uint256)
478     {
479         // make sure name fees paid
480         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
481 
482         // set up our tx event data and determine if player is new or not
483         bool _isNewPlayer = determinePID(_addr);
484 
485         // fetch player id
486         uint256 _pID = pIDxAddr_[_addr];
487 
488         // manage affiliate residuals
489         // if no affiliate code was given or player tried to use their own, lolz
490         uint256 _affID;
491         if (_affCode != address(0) && _affCode != _addr)
492         {
493             // get affiliate ID from aff Code
494             _affID = pIDxAddr_[_affCode];
495 
496             // if affID is not the same as previously stored
497             if (_affID != plyr_[_pID].laff)
498             {
499                 // update last affiliate
500                 plyr_[_pID].laff = _affID;
501             }
502         }
503 
504         // register name
505         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
506 
507         return(_isNewPlayer, _affID);
508     }
509     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
510     isRegisteredGame()
511     external
512     payable
513     returns(bool, uint256)
514     {
515         // make sure name fees paid
516         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
517 
518         // set up our tx event data and determine if player is new or not
519         bool _isNewPlayer = determinePID(_addr);
520 
521         // fetch player id
522         uint256 _pID = pIDxAddr_[_addr];
523 
524         // manage affiliate residuals
525         // if no affiliate code was given or player tried to use their own, lolz
526         uint256 _affID;
527         if (_affCode != "" && _affCode != _name)
528         {
529             // get affiliate ID from aff Code
530             _affID = pIDxName_[_affCode];
531 
532             // if affID is not the same as previously stored
533             if (_affID != plyr_[_pID].laff)
534             {
535                 // update last affiliate
536                 plyr_[_pID].laff = _affID;
537             }
538         }
539 
540         // register name
541         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
542 
543         return(_isNewPlayer, _affID);
544     }
545 
546     //==============================================================================
547     //   _ _ _|_    _   .
548     //  _\(/_ | |_||_)  .
549     //=============|================================================================
550     function addGame(address _gameAddress, string _gameNameStr)
551     public
552     {
553         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
554         gID_++;
555         bytes32 _name = _gameNameStr.nameFilter();
556         gameIDs_[_gameAddress] = gID_;
557         gameNames_[_gameAddress] = _name;
558         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
559 
560         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
561     }
562 
563     function setRegistrationFee(uint256 _fee)
564     public
565     {
566         registrationFee_ = _fee;
567     }
568 
569 }
570 
571 /**
572 * @title -Name Filter- v0.1.9
573 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
574 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
575 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
576 *                                  _____                      _____
577 *                                 (, /     /)       /) /)    (, /      /)          /)
578 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
579 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
580 *          ┴ ┴                /   /          .-/ _____   (__ /
581 *                            (__ /          (_/ (, /                                      /)™
582 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
583 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
584 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
585 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
586 *              _       __    _      ____      ____  _   _    _____  ____  ___
587 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
588 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
589 *
590 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
591 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
592 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
593 */
594 library NameFilter {
595 
596     /**
597      * @dev filters name strings
598      * -converts uppercase to lower case.
599      * -makes sure it does not start/end with a space
600      * -makes sure it does not contain multiple spaces in a row
601      * -cannot be only numbers
602      * -cannot start with 0x
603      * -restricts characters to A-Z, a-z, 0-9, and space.
604      * @return reprocessed string in bytes32 format
605      */
606     function nameFilter(string _input)
607     internal
608     pure
609     returns(bytes32)
610     {
611         bytes memory _temp = bytes(_input);
612         uint256 _length = _temp.length;
613 
614         //sorry limited to 32 characters
615         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
616         // make sure it doesnt start with or end with space
617         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
618         // make sure first two characters are not 0x
619         if (_temp[0] == 0x30)
620         {
621             require(_temp[1] != 0x78, "string cannot start with 0x");
622             require(_temp[1] != 0x58, "string cannot start with 0X");
623         }
624 
625         // create a bool to track if we have a non number character
626         bool _hasNonNumber;
627 
628         // convert & check
629         for (uint256 i = 0; i < _length; i++)
630         {
631             // if its uppercase A-Z
632             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
633             {
634                 // convert to lower case a-z
635                 _temp[i] = byte(uint(_temp[i]) + 32);
636 
637                 // we have a non number
638                 if (_hasNonNumber == false)
639                     _hasNonNumber = true;
640             } else {
641                 require
642                 (
643                 // require character is a space
644                     _temp[i] == 0x20 ||
645                 // OR lowercase a-z
646                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
647                 // or 0-9
648                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
649                     "string contains invalid characters"
650                 );
651                 // make sure theres not 2x spaces in a row
652                 if (_temp[i] == 0x20)
653                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
654 
655                 // see if we have a character other than a number
656                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
657                     _hasNonNumber = true;
658             }
659         }
660 
661         require(_hasNonNumber == true, "string cannot be only numbers");
662 
663         bytes32 _ret;
664         assembly {
665             _ret := mload(add(_temp, 32))
666         }
667         return (_ret);
668     }
669 }
670 
671 /**
672  * @title SafeMath v0.1.9
673  * @dev Math operations with safety checks that throw on error
674  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
675  * - added sqrt
676  * - added sq
677  * - added pwr
678  * - changed asserts to requires with error log outputs
679  * - removed div, its useless
680  */
681 library SafeMath {
682 
683     /**
684     * @dev Multiplies two numbers, throws on overflow.
685     */
686     function mul(uint256 a, uint256 b)
687     internal
688     pure
689     returns (uint256 c)
690     {
691         if (a == 0) {
692             return 0;
693         }
694         c = a * b;
695         require(c / a == b, "SafeMath mul failed");
696         return c;
697     }
698 
699     /**
700     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
701     */
702     function sub(uint256 a, uint256 b)
703     internal
704     pure
705     returns (uint256)
706     {
707         require(b <= a, "SafeMath sub failed");
708         return a - b;
709     }
710 
711     /**
712     * @dev Adds two numbers, throws on overflow.
713     */
714     function add(uint256 a, uint256 b)
715     internal
716     pure
717     returns (uint256 c)
718     {
719         c = a + b;
720         require(c >= a, "SafeMath add failed");
721         return c;
722     }
723 
724     /**
725      * @dev gives square root of given x.
726      */
727     function sqrt(uint256 x)
728     internal
729     pure
730     returns (uint256 y)
731     {
732         uint256 z = ((add(x,1)) / 2);
733         y = x;
734         while (z < y)
735         {
736             y = z;
737             z = ((add((x / z),z)) / 2);
738         }
739     }
740 
741     /**
742      * @dev gives square. multiplies x by x
743      */
744     function sq(uint256 x)
745     internal
746     pure
747     returns (uint256)
748     {
749         return (mul(x,x));
750     }
751 
752     /**
753      * @dev x to the power of y
754      */
755     function pwr(uint256 x, uint256 y)
756     internal
757     pure
758     returns (uint256)
759     {
760         if (x==0)
761             return (0);
762         else if (y==0)
763             return (1);
764         else
765         {
766             uint256 z = x;
767             for (uint256 i=1; i < y; i++)
768                 z = mul(z,x);
769             return (z);
770         }
771     }
772 }