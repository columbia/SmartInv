1 pragma solidity ^0.4.24;
2 
3 
4 interface PlayerBookReceiverInterface {
5     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
6     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
7 }
8 
9 
10 contract PlayerBook {
11     using NameFilter for string;
12     using SafeMath for uint256;
13     
14     //address private communityAddr = 0x2b5006d3dce09dafec33bfd08ebec9327f1612d8;
15     address private communityAddr = 0xfd76dB2AF819978d43e07737771c8D9E8bd8cbbF;
16     address private activateAddr1 = 0x6c7dfe3c255a098ea031f334436dd50345cfc737;
17     //address private communityAddr = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
18 //==============================================================================
19 //     _| _ _|_ _    _ _ _|_    _   .
20 //    (_|(_| | (_|  _\(/_ | |_||_)  .
21 //=============================|================================================    
22     uint256 public registrationFee_ = 1 finney;            // price to register a name
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
49         plyr_[1].addr = 0x33E161A482C560DCA9180D84706eCDd2D906668B;
50         plyr_[1].name = "daddy";
51         plyr_[1].names = 1;
52         pIDxAddr_[0x33E161A482C560DCA9180D84706eCDd2D906668B] = 1;
53         pIDxName_["daddy"] = 1;
54         plyrNames_[1]["daddy"] = true;
55         plyrNameList_[1][1] = "daddy";
56         
57         plyr_[2].addr = 0x9eb79e917b9e051A1BEf27f8A6cCDA316F228a7c;
58         plyr_[2].name = "suoha";
59         plyr_[2].names = 1;
60         pIDxAddr_[0x9eb79e917b9e051A1BEf27f8A6cCDA316F228a7c] = 2;
61         pIDxName_["suoha"] = 2;
62         plyrNames_[2]["suoha"] = true;
63         plyrNameList_[2][1] = "suoha";
64         
65         plyr_[3].addr = 0x261901840C99C914Aa8Cc2f7AEd0d2e09A749c8B;
66         plyr_[3].name = "nodumb";
67         plyr_[3].names = 1;
68         pIDxAddr_[0x261901840C99C914Aa8Cc2f7AEd0d2e09A749c8B] = 3;
69         pIDxName_["nodumb"] = 3;
70         plyrNames_[3]["nodumb"] = true;
71         plyrNameList_[3][1] = "nodumb";
72         
73         plyr_[4].addr = 0x7649938FAdf6C597F27349D338e3bDC8488c14e6;
74         plyr_[4].name = "dddos";
75         plyr_[4].names = 1;
76         pIDxAddr_[0x7649938FAdf6C597F27349D338e3bDC8488c14e6] = 4;
77         pIDxName_["dddos"] = 4;
78         plyrNames_[4]["dddos"] = true;
79         plyrNameList_[4][1] = "dddos";
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
99     modifier onlyCommunity() 
100     {
101         require(msg.sender == activateAddr1, "msg sender is not the community");
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
378         communityAddr.transfer(address(this).balance);
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
558      onlyCommunity()
559         public
560     {
561         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
562 
563             gID_++;
564             bytes32 _name = _gameNameStr.nameFilter();
565             gameIDs_[_gameAddress] = gID_;
566             gameNames_[_gameAddress] = _name;
567             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
568         
569             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
570             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
571             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
572             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
573     }
574     
575     function setRegistrationFee(uint256 _fee)
576      onlyCommunity()
577         public
578     {
579             registrationFee_ = _fee;
580     }
581         
582 } 
583 
584 /**
585 * @title -Name Filter- v0.1.9
586 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
587 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
588 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
589 *                                  _____                      _____
590 *                                 (, /     /)       /) /)    (, /      /)          /)
591 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
592 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
593 *          ┴ ┴                /   /          .-/ _____   (__ /                               
594 *                            (__ /          (_/ (, /                                      /)? 
595 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
596 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
597 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  ? Jekyll Island Inc. 2018
598 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
599 *              _       __    _      ____      ____  _   _    _____  ____  ___  
600 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
601 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
602 *
603 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
604 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ dddos │
605 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
606 */
607 library NameFilter {
608     
609     /**
610      * @dev filters name strings
611      * -converts uppercase to lower case.  
612      * -makes sure it does not start/end with a space
613      * -makes sure it does not contain multiple spaces in a row
614      * -cannot be only numbers
615      * -cannot start with 0x 
616      * -restricts characters to A-Z, a-z, 0-9, and space.
617      * @return reprocessed string in bytes32 format
618      */
619     function nameFilter(string _input)
620         internal
621         pure
622         returns(bytes32)
623     {
624         bytes memory _temp = bytes(_input);
625         uint256 _length = _temp.length;
626         
627         //sorry limited to 32 characters
628         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
629         // make sure it doesnt start with or end with space
630         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
631         // make sure first two characters are not 0x
632         if (_temp[0] == 0x30)
633         {
634             require(_temp[1] != 0x78, "string cannot start with 0x");
635             require(_temp[1] != 0x58, "string cannot start with 0X");
636         }
637         
638         // create a bool to track if we have a non number character
639         bool _hasNonNumber;
640         
641         // convert & check
642         for (uint256 i = 0; i < _length; i++)
643         {
644             // if its uppercase A-Z
645             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
646             {
647                 // convert to lower case a-z
648                 _temp[i] = byte(uint(_temp[i]) + 32);
649                 
650                 // we have a non number
651                 if (_hasNonNumber == false)
652                     _hasNonNumber = true;
653             } else {
654                 require
655                 (
656                     // require character is a space
657                     _temp[i] == 0x20 || 
658                     // OR lowercase a-z
659                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
660                     // or 0-9
661                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
662                     "string contains invalid characters"
663                 );
664                 // make sure theres not 2x spaces in a row
665                 if (_temp[i] == 0x20)
666                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
667                 
668                 // see if we have a character other than a number
669                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
670                     _hasNonNumber = true;    
671             }
672         }
673         
674         require(_hasNonNumber == true, "string cannot be only numbers");
675         
676         bytes32 _ret;
677         assembly {
678             _ret := mload(add(_temp, 32))
679         }
680         return (_ret);
681     }
682 }
683 
684 /**
685  * @title SafeMath v0.1.9
686  * @dev Math operations with safety checks that throw on error
687  * change notes:  original SafeMath library from OpenZeppelin modified by dddos
688  * - added sqrt
689  * - added sq
690  * - added pwr 
691  * - changed asserts to requires with error log outputs
692  * - removed div, its useless
693  */
694 library SafeMath {
695     
696     /**
697     * @dev Multiplies two numbers, throws on overflow.
698     */
699     function mul(uint256 a, uint256 b) 
700         internal 
701         pure 
702         returns (uint256 c) 
703     {
704         if (a == 0) {
705             return 0;
706         }
707         c = a * b;
708         require(c / a == b, "SafeMath mul failed");
709         return c;
710     }
711 
712     /**
713     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
714     */
715     function sub(uint256 a, uint256 b)
716         internal
717         pure
718         returns (uint256) 
719     {
720         require(b <= a, "SafeMath sub failed");
721         return a - b;
722     }
723 
724     /**
725     * @dev Adds two numbers, throws on overflow.
726     */
727     function add(uint256 a, uint256 b)
728         internal
729         pure
730         returns (uint256 c) 
731     {
732         c = a + b;
733         require(c >= a, "SafeMath add failed");
734         return c;
735     }
736     
737     /**
738      * @dev gives square root of given x.
739      */
740     function sqrt(uint256 x)
741         internal
742         pure
743         returns (uint256 y) 
744     {
745         uint256 z = ((add(x,1)) / 2);
746         y = x;
747         while (z < y) 
748         {
749             y = z;
750             z = ((add((x / z),z)) / 2);
751         }
752     }
753     
754     /**
755      * @dev gives square. multiplies x by x
756      */
757     function sq(uint256 x)
758         internal
759         pure
760         returns (uint256)
761     {
762         return (mul(x,x));
763     }
764     
765     /**
766      * @dev x to the power of y 
767      */
768     function pwr(uint256 x, uint256 y)
769         internal 
770         pure 
771         returns (uint256)
772     {
773         if (x==0)
774             return (0);
775         else if (y==0)
776             return (1);
777         else 
778         {
779             uint256 z = x;
780             for (uint256 i=1; i < y; i++)
781                 z = mul(z,x);
782             return (z);
783         }
784     }
785 }