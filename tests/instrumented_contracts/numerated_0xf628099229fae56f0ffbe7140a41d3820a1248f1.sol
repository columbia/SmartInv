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
41 //==============================================================================
42 //     _| _ _|_ _    _ _ _|_    _   .
43 //    (_|(_| | (_|  _\(/_ | |_||_)  .
44 //=============================|================================================    
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
62 //==============================================================================
63 //     _ _  _  __|_ _    __|_ _  _  .
64 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
65 //==============================================================================    
66     constructor()
67         public
68     {
69         // premine the dev names (sorry not sorry)
70             // No keys are purchased with this method, it's simply locking our addresses,
71             // PID's and names for referral codes.
72         plyr_[1].addr = 0xe15Ccba132Ae5e7faA1C98a33C743a4C7161e136;
73         plyr_[1].name = "inventor";
74         plyr_[1].names = 1;
75         pIDxAddr_[0xe15Ccba132Ae5e7faA1C98a33C743a4C7161e136] = 1;
76         pIDxName_["inventor"] = 1;
77         plyrNames_[1]["inventor"] = true;
78         plyrNameList_[1][1] = "inventor";
79         
80         pID_ = 1;
81     }
82 //==============================================================================
83 //     _ _  _  _|. |`. _  _ _  .
84 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
85 //==============================================================================    
86     /**
87      * @dev prevents contracts from interacting with fomo3d 
88      */
89     modifier isHuman() {
90         address _addr = msg.sender;
91         uint256 _codeLength;
92         
93         assembly {_codeLength := extcodesize(_addr)}
94         require(_codeLength == 0, "sorry humans only");
95         _;
96     }
97    
98     
99     modifier isRegisteredGame()
100     {
101         require(gameIDs_[msg.sender] != 0);
102         _;
103     }
104 //==============================================================================
105 //     _    _  _ _|_ _  .
106 //    (/_\/(/_| | | _\  .
107 //==============================================================================    
108     // fired whenever a player registers a name
109     event onNewName
110     (
111         uint256 indexed playerID,
112         address indexed playerAddress,
113         bytes32 indexed playerName,
114         bool isNewPlayer,
115         uint256 affiliateID,
116         address affiliateAddress,
117         bytes32 affiliateName,
118         uint256 amountPaid,
119         uint256 timeStamp
120     );
121 //==============================================================================
122 //     _  _ _|__|_ _  _ _  .
123 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
124 //=====_|=======================================================================
125     function checkIfNameValid(string _nameStr)
126         public
127         view
128         returns(bool)
129     {
130         bytes32 _name = _nameStr.nameFilter();
131         if (pIDxName_[_name] == 0)
132             return (true);
133         else 
134             return (false);
135     }
136 //==============================================================================
137 //     _    |_ |. _   |`    _  __|_. _  _  _  .
138 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
139 //====|=========================================================================    
140     /**
141      * @dev registers a name.  UI will always display the last name you registered.
142      * but you will still own all previously registered names to use as affiliate 
143      * links.
144      * - must pay a registration fee.
145      * - name must be unique
146      * - names will be converted to lowercase
147      * - name cannot start or end with a space 
148      * - cannot have more than 1 space in a row
149      * - cannot be only numbers
150      * - cannot start with 0x 
151      * - name must be at least 1 char
152      * - max length of 32 characters long
153      * - allowed characters: a-z, 0-9, and space
154      * -functionhash- 0x921dec21 (using ID for affiliate)
155      * -functionhash- 0x3ddd4698 (using address for affiliate)
156      * -functionhash- 0x685ffd83 (using name for affiliate)
157      * @param _nameString players desired name
158      * @param _affCode affiliate ID, address, or name of who refered you
159      * @param _all set to true if you want this to push your info to all games 
160      * (this might cost a lot of gas)
161      */
162     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
163         isHuman()
164         public
165         payable 
166     {
167         // make sure name fees paid
168         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
169         
170         // filter name + condition checks
171         bytes32 _name = NameFilter.nameFilter(_nameString);
172         
173         // set up address 
174         address _addr = msg.sender;
175         
176         // set up our tx event data and determine if player is new or not
177         bool _isNewPlayer = determinePID(_addr);
178         
179         // fetch player id
180         uint256 _pID = pIDxAddr_[_addr];
181         
182         // manage affiliate residuals
183         // if no affiliate code was given, no new affiliate code was given, or the 
184         // player tried to use their own pID as an affiliate code, lolz
185         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
186         {
187             // update last affiliate 
188             plyr_[_pID].laff = _affCode;
189         } else if (_affCode == _pID) {
190             _affCode = 0;
191         }
192         
193         // register name 
194         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
195     }
196     
197     function registerNameXaddr(string _nameString, address _affCode, bool _all)
198         isHuman()
199         public
200         payable 
201     {
202         // make sure name fees paid
203         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
204         
205         // filter name + condition checks
206         bytes32 _name = NameFilter.nameFilter(_nameString);
207         
208         // set up address 
209         address _addr = msg.sender;
210         
211         // set up our tx event data and determine if player is new or not
212         bool _isNewPlayer = determinePID(_addr);
213         
214         // fetch player id
215         uint256 _pID = pIDxAddr_[_addr];
216         
217         // manage affiliate residuals
218         // if no affiliate code was given or player tried to use their own, lolz
219         uint256 _affID;
220         if (_affCode != address(0) && _affCode != _addr)
221         {
222             // get affiliate ID from aff Code 
223             _affID = pIDxAddr_[_affCode];
224             
225             // if affID is not the same as previously stored 
226             if (_affID != plyr_[_pID].laff)
227             {
228                 // update last affiliate
229                 plyr_[_pID].laff = _affID;
230             }
231         }
232         
233         // register name 
234         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
235     }
236     
237     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
238         isHuman()
239         public
240         payable 
241     {
242         // make sure name fees paid
243         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
244         
245         // filter name + condition checks
246         bytes32 _name = NameFilter.nameFilter(_nameString);
247         
248         // set up address 
249         address _addr = msg.sender;
250         
251         // set up our tx event data and determine if player is new or not
252         bool _isNewPlayer = determinePID(_addr);
253         
254         // fetch player id
255         uint256 _pID = pIDxAddr_[_addr];
256         
257         // manage affiliate residuals
258         // if no affiliate code was given or player tried to use their own, lolz
259         uint256 _affID;
260         if (_affCode != "" && _affCode != _name)
261         {
262             // get affiliate ID from aff Code 
263             _affID = pIDxName_[_affCode];
264             
265             // if affID is not the same as previously stored 
266             if (_affID != plyr_[_pID].laff)
267             {
268                 // update last affiliate
269                 plyr_[_pID].laff = _affID;
270             }
271         }
272         
273         // register name 
274         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
275     }
276     
277     /**
278      * @dev players, if you registered a profile, before a game was released, or
279      * set the all bool to false when you registered, use this function to push
280      * your profile to a single game.  also, if you've  updated your name, you
281      * can use this to push your name to games of your choosing.
282      * -functionhash- 0x81c5b206
283      * @param _gameID game id 
284      */
285     function addMeToGame(uint256 _gameID)
286         isHuman()
287         public
288     {
289         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
290         address _addr = msg.sender;
291         uint256 _pID = pIDxAddr_[_addr];
292         require(_pID != 0, "hey there buddy, you dont even have an account");
293         uint256 _totalNames = plyr_[_pID].names;
294         
295         // add players profile and most recent name
296         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
297         
298         // add list of all names
299         if (_totalNames > 1)
300             for (uint256 ii = 1; ii <= _totalNames; ii++)
301                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
302     }
303     
304     /**
305      * @dev players, use this to push your player profile to all registered games.
306      * -functionhash- 0x0c6940ea
307      */
308     function addMeToAllGames()
309         isHuman()
310         public
311     {
312         address _addr = msg.sender;
313         uint256 _pID = pIDxAddr_[_addr];
314         require(_pID != 0, "hey there buddy, you dont even have an account");
315         uint256 _laff = plyr_[_pID].laff;
316         uint256 _totalNames = plyr_[_pID].names;
317         bytes32 _name = plyr_[_pID].name;
318         
319         for (uint256 i = 1; i <= gID_; i++)
320         {
321             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
322             if (_totalNames > 1)
323                 for (uint256 ii = 1; ii <= _totalNames; ii++)
324                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
325         }
326                 
327     }
328     
329     /**
330      * @dev players use this to change back to one of your old names.  tip, you'll
331      * still need to push that info to existing games.
332      * -functionhash- 0xb9291296
333      * @param _nameString the name you want to use 
334      */
335     function useMyOldName(string _nameString)
336         isHuman()
337         public 
338     {
339         // filter name, and get pID
340         bytes32 _name = _nameString.nameFilter();
341         uint256 _pID = pIDxAddr_[msg.sender];
342         
343         // make sure they own the name 
344         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
345         
346         // update their current name 
347         plyr_[_pID].name = _name;
348     }
349     
350 //==============================================================================
351 //     _ _  _ _   | _  _ . _  .
352 //    (_(_)| (/_  |(_)(_||(_  . 
353 //=====================_|=======================================================    
354     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
355         private
356     {
357         // if names already has been used, require that current msg sender owns the name
358         if (pIDxName_[_name] != 0)
359             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
360         
361         // add name to player profile, registry, and name book
362         plyr_[_pID].name = _name;
363         pIDxName_[_name] = _pID;
364         if (plyrNames_[_pID][_name] == false)
365         {
366             plyrNames_[_pID][_name] = true;
367             plyr_[_pID].names++;
368             plyrNameList_[_pID][plyr_[_pID].names] = _name;
369         }
370         
371         // registration fee goes directly to community rewards
372         admin.transfer(address(this).balance);
373         
374         // push player info to games
375         if (_all == true)
376             for (uint256 i = 1; i <= gID_; i++)
377                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
378         
379         // fire event
380         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
381     }
382 //==============================================================================
383 //    _|_ _  _ | _  .
384 //     | (_)(_)|_\  .
385 //==============================================================================    
386     function determinePID(address _addr)
387         private
388         returns (bool)
389     {
390         if (pIDxAddr_[_addr] == 0)
391         {
392             pID_++;
393             pIDxAddr_[_addr] = pID_;
394             plyr_[pID_].addr = _addr;
395             
396             // set the new player bool to true
397             return (true);
398         } else {
399             return (false);
400         }
401     }
402 //==============================================================================
403 //   _   _|_ _  _ _  _ |   _ _ || _  .
404 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
405 //==============================================================================
406     function getPlayerID(address _addr)
407         isRegisteredGame()
408         external
409         returns (uint256)
410     {
411         determinePID(_addr);
412         return (pIDxAddr_[_addr]);
413     }
414     function getPlayerName(uint256 _pID)
415         external
416         view
417         returns (bytes32)
418     {
419         return (plyr_[_pID].name);
420     }
421     function getPlayerLAff(uint256 _pID)
422         external
423         view
424         returns (uint256)
425     {
426         return (plyr_[_pID].laff);
427     }
428     function getPlayerAddr(uint256 _pID)
429         external
430         view
431         returns (address)
432     {
433         return (plyr_[_pID].addr);
434     }
435     function getNameFee()
436         external
437         view
438         returns (uint256)
439     {
440         return(registrationFee_);
441     }
442     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
443         isRegisteredGame()
444         external
445         payable
446         returns(bool, uint256)
447     {
448         // make sure name fees paid
449         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
450         
451         // set up our tx event data and determine if player is new or not
452         bool _isNewPlayer = determinePID(_addr);
453         
454         // fetch player id
455         uint256 _pID = pIDxAddr_[_addr];
456         
457         // manage affiliate residuals
458         // if no affiliate code was given, no new affiliate code was given, or the 
459         // player tried to use their own pID as an affiliate code, lolz
460         uint256 _affID = _affCode;
461         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
462         {
463             // update last affiliate 
464             plyr_[_pID].laff = _affID;
465         } else if (_affID == _pID) {
466             _affID = 0;
467         }
468         
469         // register name 
470         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
471         
472         return(_isNewPlayer, _affID);
473     }
474     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
475         isRegisteredGame()
476         external
477         payable
478         returns(bool, uint256)
479     {
480         // make sure name fees paid
481         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
482         
483         // set up our tx event data and determine if player is new or not
484         bool _isNewPlayer = determinePID(_addr);
485         
486         // fetch player id
487         uint256 _pID = pIDxAddr_[_addr];
488         
489         // manage affiliate residuals
490         // if no affiliate code was given or player tried to use their own, lolz
491         uint256 _affID;
492         if (_affCode != address(0) && _affCode != _addr)
493         {
494             // get affiliate ID from aff Code 
495             _affID = pIDxAddr_[_affCode];
496             
497             // if affID is not the same as previously stored 
498             if (_affID != plyr_[_pID].laff)
499             {
500                 // update last affiliate
501                 plyr_[_pID].laff = _affID;
502             }
503         }
504         
505         // register name 
506         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
507         
508         return(_isNewPlayer, _affID);
509     }
510     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
511         isRegisteredGame()
512         external
513         payable
514         returns(bool, uint256)
515     {
516         // make sure name fees paid
517         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
518         
519         // set up our tx event data and determine if player is new or not
520         bool _isNewPlayer = determinePID(_addr);
521         
522         // fetch player id
523         uint256 _pID = pIDxAddr_[_addr];
524         
525         // manage affiliate residuals
526         // if no affiliate code was given or player tried to use their own, lolz
527         uint256 _affID;
528         if (_affCode != "" && _affCode != _name)
529         {
530             // get affiliate ID from aff Code 
531             _affID = pIDxName_[_affCode];
532             
533             // if affID is not the same as previously stored 
534             if (_affID != plyr_[_pID].laff)
535             {
536                 // update last affiliate
537                 plyr_[_pID].laff = _affID;
538             }
539         }
540         
541         // register name 
542         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
543         
544         return(_isNewPlayer, _affID);
545     }
546     
547 //==============================================================================
548 //   _ _ _|_    _   .
549 //  _\(/_ | |_||_)  .
550 //=============|================================================================
551     function addGame(address _gameAddress, string _gameNameStr)
552         public
553     {
554         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
555             gID_++;
556             bytes32 _name = _gameNameStr.nameFilter();
557             gameIDs_[_gameAddress] = gID_;
558             gameNames_[_gameAddress] = _name;
559             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
560         
561             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
562             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
563             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
564             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
565     }
566     
567     function setRegistrationFee(uint256 _fee)
568         public
569     {
570       registrationFee_ = _fee;
571     }
572         
573 } 
574 
575 /**
576 * @title -Name Filter- v0.1.9
577 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
578 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
579 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
580 *                                  _____                      _____
581 *                                 (, /     /)       /) /)    (, /      /)          /)
582 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
583 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
584 *          ┴ ┴                /   /          .-/ _____   (__ /                               
585 *                            (__ /          (_/ (, /                                      /)™ 
586 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
587 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
588 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
589 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
590 *              _       __    _      ____      ____  _   _    _____  ____  ___  
591 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
592 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
593 *
594 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
595 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
596 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
597 */
598 library NameFilter {
599     
600     /**
601      * @dev filters name strings
602      * -converts uppercase to lower case.  
603      * -makes sure it does not start/end with a space
604      * -makes sure it does not contain multiple spaces in a row
605      * -cannot be only numbers
606      * -cannot start with 0x 
607      * -restricts characters to A-Z, a-z, 0-9, and space.
608      * @return reprocessed string in bytes32 format
609      */
610     function nameFilter(string _input)
611         internal
612         pure
613         returns(bytes32)
614     {
615         bytes memory _temp = bytes(_input);
616         uint256 _length = _temp.length;
617         
618         //sorry limited to 32 characters
619         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
620         // make sure it doesnt start with or end with space
621         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
622         // make sure first two characters are not 0x
623         if (_temp[0] == 0x30)
624         {
625             require(_temp[1] != 0x78, "string cannot start with 0x");
626             require(_temp[1] != 0x58, "string cannot start with 0X");
627         }
628         
629         // create a bool to track if we have a non number character
630         bool _hasNonNumber;
631         
632         // convert & check
633         for (uint256 i = 0; i < _length; i++)
634         {
635             // if its uppercase A-Z
636             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
637             {
638                 // convert to lower case a-z
639                 _temp[i] = byte(uint(_temp[i]) + 32);
640                 
641                 // we have a non number
642                 if (_hasNonNumber == false)
643                     _hasNonNumber = true;
644             } else {
645                 require
646                 (
647                     // require character is a space
648                     _temp[i] == 0x20 || 
649                     // OR lowercase a-z
650                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
651                     // or 0-9
652                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
653                     "string contains invalid characters"
654                 );
655                 // make sure theres not 2x spaces in a row
656                 if (_temp[i] == 0x20)
657                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
658                 
659                 // see if we have a character other than a number
660                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
661                     _hasNonNumber = true;    
662             }
663         }
664         
665         require(_hasNonNumber == true, "string cannot be only numbers");
666         
667         bytes32 _ret;
668         assembly {
669             _ret := mload(add(_temp, 32))
670         }
671         return (_ret);
672     }
673 }
674 
675 /**
676  * @title SafeMath v0.1.9
677  * @dev Math operations with safety checks that throw on error
678  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
679  * - added sqrt
680  * - added sq
681  * - added pwr 
682  * - changed asserts to requires with error log outputs
683  * - removed div, its useless
684  */
685 library SafeMath {
686     
687     /**
688     * @dev Multiplies two numbers, throws on overflow.
689     */
690     function mul(uint256 a, uint256 b) 
691         internal 
692         pure 
693         returns (uint256 c) 
694     {
695         if (a == 0) {
696             return 0;
697         }
698         c = a * b;
699         require(c / a == b, "SafeMath mul failed");
700         return c;
701     }
702 
703     /**
704     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
705     */
706     function sub(uint256 a, uint256 b)
707         internal
708         pure
709         returns (uint256) 
710     {
711         require(b <= a, "SafeMath sub failed");
712         return a - b;
713     }
714 
715     /**
716     * @dev Adds two numbers, throws on overflow.
717     */
718     function add(uint256 a, uint256 b)
719         internal
720         pure
721         returns (uint256 c) 
722     {
723         c = a + b;
724         require(c >= a, "SafeMath add failed");
725         return c;
726     }
727     
728     /**
729      * @dev gives square root of given x.
730      */
731     function sqrt(uint256 x)
732         internal
733         pure
734         returns (uint256 y) 
735     {
736         uint256 z = ((add(x,1)) / 2);
737         y = x;
738         while (z < y) 
739         {
740             y = z;
741             z = ((add((x / z),z)) / 2);
742         }
743     }
744     
745     /**
746      * @dev gives square. multiplies x by x
747      */
748     function sq(uint256 x)
749         internal
750         pure
751         returns (uint256)
752     {
753         return (mul(x,x));
754     }
755     
756     /**
757      * @dev x to the power of y 
758      */
759     function pwr(uint256 x, uint256 y)
760         internal 
761         pure 
762         returns (uint256)
763     {
764         if (x==0)
765             return (0);
766         else if (y==0)
767             return (1);
768         else 
769         {
770             uint256 z = x;
771             for (uint256 i=1; i < y; i++)
772                 z = mul(z,x);
773             return (z);
774         }
775     }
776 }