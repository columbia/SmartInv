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
41     address private aaa = 0xF29527437Eb2AE5Da10db32d49E27Cb22F04b875;
42 //==============================================================================
43 //     _| _ _|_ _    _ _ _|_    _   .
44 //    (_|(_| | (_|  _\(/_ | |_||_)  .
45 //=============================|================================================
46     uint256 public registrationFee_ = 10 finney;            // price to register a name
47     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
48     mapping(address => bytes32) public gameNames_;          // lookup a games name
49     mapping(address => uint256) public gameIDs_;            // lokup a games ID
50     uint256 public gID_;        // total number of games
51     uint256 public pID_;        // total number of players
52     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
53     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
54     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
55     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
56     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
57     struct Player {
58         address addr;
59         bytes32 name;
60         uint256 laff;
61         uint256 names;
62     }
63 //==============================================================================
64 //     _ _  _  __|_ _    __|_ _  _  .
65 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
66 //==============================================================================
67     constructor()
68         public
69     {
70         // premine the dev names (sorry not sorry)
71             // No keys are purchased with this method, it's simply locking our addresses,
72             // PID's and names for referral codes. //引用代码的PID和名称
73         plyr_[1].addr = 0xF29527437Eb2AE5Da10db32d49E27Cb22F04b875;  //justo的钱包地址
74         plyr_[1].name = "justo";
75         plyr_[1].names = 1;
76         pIDxAddr_[0xF29527437Eb2AE5Da10db32d49E27Cb22F04b875] = 1;
77         pIDxName_["justo"] = 1;
78         plyrNames_[1]["justo"] = true;
79         plyrNameList_[1][1] = "justo";
80 
81         pID_ = 1;
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
99     modifier onlyDevs()
100     {
101         require(admin == msg.sender, "msg sender is not a dev");
102         _;
103     }
104 
105     modifier isRegisteredGame()
106     {
107         require(gameIDs_[msg.sender] != 0);
108         _;
109     }
110 //==============================================================================
111 //     _    _  _ _|_ _  .
112 //    (/_\/(/_| | | _\  .
113 //==============================================================================
114     // fired whenever a player registers a name
115     event onNewName
116     (
117         uint256 indexed playerID,
118         address indexed playerAddress,
119         bytes32 indexed playerName,
120         bool isNewPlayer,
121         uint256 affiliateID,
122         address affiliateAddress,
123         bytes32 affiliateName,
124         uint256 amountPaid,
125         uint256 timeStamp
126     );
127 //==============================================================================
128 //     _  _ _|__|_ _  _ _  .
129 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
130 //=====_|=======================================================================
131     function checkIfNameValid(string _nameStr)
132         public
133         view
134         returns(bool)
135     {
136         bytes32 _name = _nameStr.nameFilter();
137         if (pIDxName_[_name] == 0)
138             return (true);
139         else
140             return (false);
141     }
142 //==============================================================================
143 //     _    |_ |. _   |`    _  __|_. _  _  _  .
144 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
145 //====|=========================================================================
146     /**
147      * @dev registers a name.  UI will always display the last name you registered.
148      * but you will still own all previously registered names to use as affiliate
149      * links.
150      * - must pay a registration fee.
151      * - name must be unique
152      * - names will be converted to lowercase
153      * - name cannot start or end with a space
154      * - cannot have more than 1 space in a row
155      * - cannot be only numbers
156      * - cannot start with 0x
157      * - name must be at least 1 char
158      * - max length of 32 characters long
159      * - allowed characters: a-z, 0-9, and space
160      * -functionhash- 0x921dec21 (using ID for affiliate)
161      * -functionhash- 0x3ddd4698 (using address for affiliate)
162      * -functionhash- 0x685ffd83 (using name for affiliate)
163      * @param _nameString players desired name
164      * @param _affCode affiliate ID, address, or name of who refered you
165      * @param _all set to true if you want this to push your info to all games
166      * (this might cost a lot of gas)
167      */
168     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
169         isHuman()
170         public
171         payable
172     {
173         // make sure name fees paid
174         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
175 
176         // filter name + condition checks
177         bytes32 _name = NameFilter.nameFilter(_nameString);
178 
179         // set up address
180         address _addr = msg.sender;
181 
182         // set up our tx event data and determine if player is new or not
183         bool _isNewPlayer = determinePID(_addr);
184 
185         // fetch player id
186         uint256 _pID = pIDxAddr_[_addr];
187 
188         // manage affiliate residuals
189         // if no affiliate code was given, no new affiliate code was given, or the
190         // player tried to use their own pID as an affiliate code, lolz
191         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
192         {
193             // update last affiliate
194             plyr_[_pID].laff = _affCode;
195         } else if (_affCode == _pID) {
196             _affCode = 0;
197         }
198 
199         // register name
200         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
201     }
202 
203     function registerNameXaddr(string _nameString, address _affCode, bool _all)
204         isHuman()
205         public
206         payable
207     {
208         // make sure name fees paid
209         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
210 
211         // filter name + condition checks
212         bytes32 _name = NameFilter.nameFilter(_nameString);
213 
214         // set up address
215         address _addr = msg.sender;
216 
217         // set up our tx event data and determine if player is new or not
218         bool _isNewPlayer = determinePID(_addr);
219 
220         // fetch player id
221         uint256 _pID = pIDxAddr_[_addr];
222 
223         // manage affiliate residuals
224         // if no affiliate code was given or player tried to use their own, lolz
225         uint256 _affID;
226         if (_affCode != address(0) && _affCode != _addr)
227         {
228             // get affiliate ID from aff Code
229             _affID = pIDxAddr_[_affCode];
230 
231             // if affID is not the same as previously stored
232             if (_affID != plyr_[_pID].laff)
233             {
234                 // update last affiliate
235                 plyr_[_pID].laff = _affID;
236             }
237         }
238 
239         // register name
240         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
241     }
242 
243     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
244         isHuman()
245         public
246         payable
247     {
248         // make sure name fees paid
249         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
250 
251         // filter name + condition checks
252         bytes32 _name = NameFilter.nameFilter(_nameString);
253 
254         // set up address
255         address _addr = msg.sender;
256 
257         // set up our tx event data and determine if player is new or not
258         bool _isNewPlayer = determinePID(_addr);
259 
260         // fetch player id
261         uint256 _pID = pIDxAddr_[_addr];
262 
263         // manage affiliate residuals
264         // if no affiliate code was given or player tried to use their own, lolz
265         uint256 _affID;
266         if (_affCode != "" && _affCode != _name)
267         {
268             // get affiliate ID from aff Code
269             _affID = pIDxName_[_affCode];
270 
271             // if affID is not the same as previously stored
272             if (_affID != plyr_[_pID].laff)
273             {
274                 // update last affiliate
275                 plyr_[_pID].laff = _affID;
276             }
277         }
278 
279         // register name
280         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
281     }
282 
283     /**
284      * @dev players, if you registered a profile, before a game was released, or
285      * set the all bool to false when you registered, use this function to push
286      * your profile to a single game.  also, if you've  updated your name, you
287      * can use this to push your name to games of your choosing.
288      * -functionhash- 0x81c5b206
289      * @param _gameID game id
290      */
291     function addMeToGame(uint256 _gameID)
292         isHuman()
293         public
294     {
295         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
296         address _addr = msg.sender;
297         uint256 _pID = pIDxAddr_[_addr];
298         require(_pID != 0, "hey there buddy, you dont even have an account");
299         uint256 _totalNames = plyr_[_pID].names;
300 
301         // add players profile and most recent name
302         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
303 
304         // add list of all names
305         if (_totalNames > 1)
306             for (uint256 ii = 1; ii <= _totalNames; ii++)
307                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
308     }
309 
310     /**
311      * @dev players, use this to push your player profile to all registered games.
312      * -functionhash- 0x0c6940ea
313      */
314     function addMeToAllGames()
315         isHuman()
316         public
317     {
318         address _addr = msg.sender;
319         uint256 _pID = pIDxAddr_[_addr];
320         require(_pID != 0, "hey there buddy, you dont even have an account");
321         uint256 _laff = plyr_[_pID].laff;
322         uint256 _totalNames = plyr_[_pID].names;
323         bytes32 _name = plyr_[_pID].name;
324 
325         for (uint256 i = 1; i <= gID_; i++)
326         {
327             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
328             if (_totalNames > 1)
329                 for (uint256 ii = 1; ii <= _totalNames; ii++)
330                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
331         }
332 
333     }
334 
335     /**
336      * @dev players use this to change back to one of your old names.  tip, you'll
337      * still need to push that info to existing games.
338      * -functionhash- 0xb9291296
339      * @param _nameString the name you want to use
340      */
341     function useMyOldName(string _nameString)
342         isHuman()
343         public
344     {
345         // filter name, and get pID
346         bytes32 _name = _nameString.nameFilter();
347         uint256 _pID = pIDxAddr_[msg.sender];
348 
349         // make sure they own the name
350         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
351 
352         // update their current name
353         plyr_[_pID].name = _name;
354     }
355 
356 //==============================================================================
357 //     _ _  _ _   | _  _ . _  .
358 //    (_(_)| (/_  |(_)(_||(_  .
359 //=====================_|=======================================================
360     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
361         private
362     {
363         // if names already has been used, require that current msg sender owns the name
364         if (pIDxName_[_name] != 0)
365             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
366 
367         // add name to player profile, registry, and name book
368         plyr_[_pID].name = _name;
369         pIDxName_[_name] = _pID;
370         if (plyrNames_[_pID][_name] == false)
371         {
372             plyrNames_[_pID][_name] = true;
373             plyr_[_pID].names++;
374             plyrNameList_[_pID][plyr_[_pID].names] = _name;
375         }
376 
377         // registration fee goes directly to community rewards
378         aaa.transfer(address(this).balance);
379 
380         // push player info to games
381         if (_all == true)
382             for (uint256 i = 1; i <= gID_; i++)
383                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
384 
385         // fire event
386         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
387     }
388 //==============================================================================
389 //    _|_ _  _ | _  .
390 //     | (_)(_)|_\  .
391 //==============================================================================
392     function determinePID(address _addr)
393         private
394         returns (bool)
395     {
396         if (pIDxAddr_[_addr] == 0)
397         {
398             pID_++;
399             pIDxAddr_[_addr] = pID_;
400             plyr_[pID_].addr = _addr;
401 
402             // set the new player bool to true
403             return (true);
404         } else {
405             return (false);
406         }
407     }
408 //==============================================================================
409 //   _   _|_ _  _ _  _ |   _ _ || _  .
410 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
411 //==============================================================================
412     function getPlayerID(address _addr)
413         isRegisteredGame()
414         external
415         returns (uint256)
416     {
417         determinePID(_addr);
418         return (pIDxAddr_[_addr]);
419     }
420     function getPlayerName(uint256 _pID)
421         external
422         view
423         returns (bytes32)
424     {
425         return (plyr_[_pID].name);
426     }
427     function getPlayerLAff(uint256 _pID)
428         external
429         view
430         returns (uint256)
431     {
432         return (plyr_[_pID].laff);
433     }
434     function getPlayerAddr(uint256 _pID)
435         external
436         view
437         returns (address)
438     {
439         return (plyr_[_pID].addr);
440     }
441     function getNameFee()
442         external
443         view
444         returns (uint256)
445     {
446         return(registrationFee_);
447     }
448     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
449         isRegisteredGame()
450         external
451         payable
452         returns(bool, uint256)
453     {
454         // make sure name fees paid
455         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
456 
457         // set up our tx event data and determine if player is new or not
458         bool _isNewPlayer = determinePID(_addr);
459 
460         // fetch player id
461         uint256 _pID = pIDxAddr_[_addr];
462 
463         // manage affiliate residuals
464         // if no affiliate code was given, no new affiliate code was given, or the
465         // player tried to use their own pID as an affiliate code, lolz
466         uint256 _affID = _affCode;
467         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
468         {
469             // update last affiliate
470             plyr_[_pID].laff = _affID;
471         } else if (_affID == _pID) {
472             _affID = 0;
473         }
474 
475         // register name
476         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
477 
478         return(_isNewPlayer, _affID);
479     }
480     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
481         isRegisteredGame()
482         external
483         payable
484         returns(bool, uint256)
485     {
486         // make sure name fees paid
487         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
488 
489         // set up our tx event data and determine if player is new or not
490         bool _isNewPlayer = determinePID(_addr);
491 
492         // fetch player id
493         uint256 _pID = pIDxAddr_[_addr];
494 
495         // manage affiliate residuals
496         // if no affiliate code was given or player tried to use their own, lolz
497         uint256 _affID;
498         if (_affCode != address(0) && _affCode != _addr)
499         {
500             // get affiliate ID from aff Code
501             _affID = pIDxAddr_[_affCode];
502 
503             // if affID is not the same as previously stored
504             if (_affID != plyr_[_pID].laff)
505             {
506                 // update last affiliate
507                 plyr_[_pID].laff = _affID;
508             }
509         }
510 
511         // register name
512         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
513 
514         return(_isNewPlayer, _affID);
515     }
516     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
517         isRegisteredGame()
518         external
519         payable
520         returns(bool, uint256)
521     {
522         // make sure name fees paid
523         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
524 
525         // set up our tx event data and determine if player is new or not
526         bool _isNewPlayer = determinePID(_addr);
527 
528         // fetch player id
529         uint256 _pID = pIDxAddr_[_addr];
530 
531         // manage affiliate residuals
532         // if no affiliate code was given or player tried to use their own, lolz
533         uint256 _affID;
534         if (_affCode != "" && _affCode != _name)
535         {
536             // get affiliate ID from aff Code
537             _affID = pIDxName_[_affCode];
538 
539             // if affID is not the same as previously stored
540             if (_affID != plyr_[_pID].laff)
541             {
542                 // update last affiliate
543                 plyr_[_pID].laff = _affID;
544             }
545         }
546 
547         // register name
548         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
549 
550         return(_isNewPlayer, _affID);
551     }
552 
553 //==============================================================================
554 //   _ _ _|_    _   .
555 //  _\(/_ | |_||_)  .
556 //=============|================================================================
557     function addGame(address _gameAddress, string _gameNameStr)
558         onlyDevs()
559         public
560     {
561         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
562             gID_++;
563             bytes32 _name = _gameNameStr.nameFilter();
564             gameIDs_[_gameAddress] = gID_;
565             gameNames_[_gameAddress] = _name;
566             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
567 
568             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
569             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
570             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
571             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
572     }
573 
574     function setRegistrationFee(uint256 _fee)
575         onlyDevs()
576         public
577     {
578       registrationFee_ = _fee;
579     }
580 
581 }
582 
583 /**
584 * @title -Name Filter- v0.1.9
585 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
586 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
587 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
588 *                                  _____                      _____
589 *                                 (, /     /)       /) /)    (, /      /)          /)
590 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
591 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
592 *          ┴ ┴                /   /          .-/ _____   (__ /
593 *                            (__ /          (_/ (, /                                      /)™
594 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
595 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
596 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
597 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
598 *              _       __    _      ____      ____  _   _    _____  ____  ___
599 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
600 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
601 *
602 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
603 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
604 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
605 */
606 library NameFilter {
607 
608     /**
609      * @dev filters name strings
610      * -converts uppercase to lower case.
611      * -makes sure it does not start/end with a space
612      * -makes sure it does not contain multiple spaces in a row
613      * -cannot be only numbers
614      * -cannot start with 0x
615      * -restricts characters to A-Z, a-z, 0-9, and space.
616      * @return reprocessed string in bytes32 format
617      */
618     function nameFilter(string _input)
619         internal
620         pure
621         returns(bytes32)
622     {
623         bytes memory _temp = bytes(_input);
624         uint256 _length = _temp.length;
625 
626         //sorry limited to 32 characters
627         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
628         // make sure it doesnt start with or end with space
629         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
630         // make sure first two characters are not 0x
631         if (_temp[0] == 0x30)
632         {
633             require(_temp[1] != 0x78, "string cannot start with 0x");
634             require(_temp[1] != 0x58, "string cannot start with 0X");
635         }
636 
637         // create a bool to track if we have a non number character
638         bool _hasNonNumber;
639 
640         // convert & check
641         for (uint256 i = 0; i < _length; i++)
642         {
643             // if its uppercase A-Z
644             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
645             {
646                 // convert to lower case a-z
647                 _temp[i] = byte(uint(_temp[i]) + 32);
648 
649                 // we have a non number
650                 if (_hasNonNumber == false)
651                     _hasNonNumber = true;
652             } else {
653                 require
654                 (
655                     // require character is a space
656                     _temp[i] == 0x20 ||
657                     // OR lowercase a-z
658                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
659                     // or 0-9
660                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
661                     "string contains invalid characters"
662                 );
663                 // make sure theres not 2x spaces in a row
664                 if (_temp[i] == 0x20)
665                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
666 
667                 // see if we have a character other than a number
668                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
669                     _hasNonNumber = true;
670             }
671         }
672 
673         require(_hasNonNumber == true, "string cannot be only numbers");
674 
675         bytes32 _ret;
676         assembly {
677             _ret := mload(add(_temp, 32))
678         }
679         return (_ret);
680     }
681 }
682 
683 /**
684  * @title SafeMath v0.1.9
685  * @dev Math operations with safety checks that throw on error
686  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
687  * - added sqrt
688  * - added sq
689  * - added pwr
690  * - changed asserts to requires with error log outputs
691  * - removed div, its useless
692  */
693 library SafeMath {
694 
695     /**
696     * @dev Multiplies two numbers, throws on overflow.
697     */
698     function mul(uint256 a, uint256 b)
699         internal
700         pure
701         returns (uint256 c)
702     {
703         if (a == 0) {
704             return 0;
705         }
706         c = a * b;
707         require(c / a == b, "SafeMath mul failed");
708         return c;
709     }
710 
711     /**
712     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
713     */
714     function sub(uint256 a, uint256 b)
715         internal
716         pure
717         returns (uint256)
718     {
719         require(b <= a, "SafeMath sub failed");
720         return a - b;
721     }
722 
723     /**
724     * @dev Adds two numbers, throws on overflow.
725     */
726     function add(uint256 a, uint256 b)
727         internal
728         pure
729         returns (uint256 c)
730     {
731         c = a + b;
732         require(c >= a, "SafeMath add failed");
733         return c;
734     }
735 
736     /**
737      * @dev gives square root of given x.
738      */
739     function sqrt(uint256 x)
740         internal
741         pure
742         returns (uint256 y)
743     {
744         uint256 z = ((add(x,1)) / 2);
745         y = x;
746         while (z < y)
747         {
748             y = z;
749             z = ((add((x / z),z)) / 2);
750         }
751     }
752 
753     /**
754      * @dev gives square. multiplies x by x
755      */
756     function sq(uint256 x)
757         internal
758         pure
759         returns (uint256)
760     {
761         return (mul(x,x));
762     }
763 
764     /**
765      * @dev x to the power of y
766      */
767     function pwr(uint256 x, uint256 y)
768         internal
769         pure
770         returns (uint256)
771     {
772         if (x==0)
773             return (0);
774         else if (y==0)
775             return (1);
776         else
777         {
778             uint256 z = x;
779             for (uint256 i=1; i < y; i++)
780                 z = mul(z,x);
781             return (z);
782         }
783     }
784 }