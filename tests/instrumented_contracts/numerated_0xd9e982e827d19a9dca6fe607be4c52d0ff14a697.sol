1 pragma solidity ^0.4.24;
2 /*
3 *　　　　　　　　　　　　　　　　　　　　 　 　 ＿＿＿
4 *　　　　　　　　　　　　　　　　　　　　　　　|三三三i
5 *　　　　　　　　　　　　　　　　　　　　　　　|三三三|  
6 *　　神さま　かなえて　happy-end　　　　　　ノ三三三.廴        
7 *　　　　　　　　　　　　　　　　　　　　　　从ﾉ_八ﾑ_}ﾉ
8 *　　　＿＿}ヽ__　　　　　　　　　　 　 　 　 ヽ‐个‐ｱ.     © Team EC Present. 
9 *　　 　｀ﾋｙ　　ﾉ三ﾆ==ｪ- ＿＿＿ ｨｪ=ｧ='ﾌ)ヽ-''Lヽ         
10 *　　　　 ｀‐⌒L三ﾆ=ﾆ三三三三三三三〈oi 人 ）o〉三ﾆ、　　　 
11 *　　　　　　　　　　 　 ｀￣￣￣￣｀弌三三}. !　ｒ三三三iｊ　　　　　　
12 *　　　　　　　　　　 　 　 　 　 　 　,': ::三三|. ! ,'三三三刈、
13 *　　　　　　　　　 　 　 　 　 　 　 ,': : :::｀i三|人|三三ﾊ三j: ;　　　　　
14 *　                  　　　　　　 ,': : : : : 比|　 |三三i |三|: ',
15 *　　　　　　　　　　　　　　　　　,': : : : : : :Vi|　 |三三i |三|: : ',
16 *　　　　　　　　　　　　　　　　, ': : : : : : : ﾉ }乂{三三| |三|: : :;
17 *  UserDataManager v0.1　　,': : : : : : : : ::ｊ三三三三|: |三i: : ::,
18 *　　　　　　　　　　　 　 　 ,': : : : : : : : :/三三三三〈: :!三!: : ::;
19 *　　　　　　　　　 　 　 　 ,': : : : : : : : /三三三三三!, |三!: : : ,
20 *　　　　　　　 　 　 　 　 ,': : : : : : : : ::ｊ三三八三三Y {⌒i: : : :,
21 *　　　　　　　　 　 　 　 ,': : : : : : : : : /三//: }三三ｊ: : ー': : : : ,
22 *　　　　　　 　 　 　 　 ,': : : : : : : : :.//三/: : |三三|: : : : : : : : :;
23 *　　　　 　 　 　 　 　 ,': : : : : : : : ://三/: : : |三三|: : : : : : : : ;
24 *　　 　 　 　 　 　 　 ,': : : : : : : : :/三ii/ : : : :|三三|: : : : : : : : :;
25 *　　　 　 　 　 　 　 ,': : : : : : : : /三//: : : : ::!三三!: : : : : : : : ;
26 *　　　　 　 　 　 　 ,': : : : : : : : :ｊ三// : : : : ::|三三!: : : : : : : : :;
27 *　　 　 　 　 　 　 ,': : : : : : : : : |三ij: : : : : : ::ｌ三ﾆ:ｊ: : : : : : : : : ;
28 *　　　 　 　 　 　 ,': : : : : : : : ::::|三ij: : : : : : : !三刈: : : : : : : : : ;
29 *　 　 　 　 　 　 ,': : : : : : : : : : :|三ij: : : : : : ::ｊ三iiﾃ: : : : : : : : : :;
30 *　　 　 　 　 　 ,': : : : : : : : : : : |三ij: : : : : : ::|三iiﾘ: : : : : : : : : : ;
31 *　　　 　 　 　 ,':: : : : : : : : : : : :|三ij::: : :: :: :::|三リ: : : : : : : : : : :;
32 *　　　　　　　 ,': : : : : : : : : : : : :|三ij : : : : : ::ｌ三iﾘ: : : : : : : : : : : ',
33 *           　　　　　　　　　　　　　　   ｒ'三三jiY, : : : : : ::|三ij : : : : : : : : : : : ',
34 *　 　 　 　 　 　      　　                |三 j´　　　　　　　　｀',    signature:
35 *　　　　　　　　　　　　 　 　 　 　 　 　 　  |三三k、
36 *                            　　　　　　　　｀ー≠='.  93511761c3aa73c0a197c55537328f7f797c4429 
37 */
38 
39 
40 interface UserDataManagerReceiverInterface {
41     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
42     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
43 }
44 
45 contract UserDataManager {
46     using NameFilter for string;
47     using SafeMath for uint256;
48 
49     address private admin = msg.sender;
50     uint256 public registrationFee_ = 0;                   
51     mapping(uint256 => UserDataManagerReceiverInterface) public games_;  
52     mapping(address => bytes32) public gameNames_;         
53     mapping(address => uint256) public gameIDs_;           
54     uint256 public gID_;        
55     uint256 public pID_;       
56     mapping (address => uint256) public pIDxAddr_;          
57     mapping (bytes32 => uint256) public pIDxName_;          
58     mapping (uint256 => Player) public plyr_;              
59     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; 
60     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; 
61     struct Player {
62         address addr;
63         bytes32 name;
64         uint256 laff;
65         uint256 names;
66     }
67 
68     constructor()
69         public
70     {
71         // premine the dev names 
72         plyr_[1].addr = 0xe27c188521248a49adfc61090d3c8ab7c3754e0a;
73         plyr_[1].name = "matt";
74         plyr_[1].names = 1;
75         pIDxAddr_[0xe27c188521248a49adfc61090d3c8ab7c3754e0a] = 1;
76         pIDxName_["matt"] = 1;
77         plyrNames_[1]["matt"] = true;
78         plyrNameList_[1][1] = "matt";
79 
80         pID_ = 1;
81     }
82 
83     modifier isHuman() {
84         address _addr = msg.sender;
85         uint256 _codeLength;
86 
87         assembly {_codeLength := extcodesize(_addr)}
88         require(_codeLength == 0, "sorry humans only");
89         _;
90     }
91 
92     modifier onlyDevs()
93     {
94         require(admin == msg.sender, "msg sender is not a dev");
95         _;
96     }
97 
98     modifier isRegisteredGame()
99     {
100         require(gameIDs_[msg.sender] != 0);
101         _;
102     }
103 
104     event onNewName
105     (
106         uint256 indexed playerID,
107         address indexed playerAddress,
108         bytes32 indexed playerName,
109         bool isNewPlayer,
110         uint256 affiliateID,
111         address affiliateAddress,
112         bytes32 affiliateName,
113         uint256 amountPaid,
114         uint256 timeStamp
115     );
116 
117     function checkIfNameValid(string _nameStr)
118         public
119         view
120         returns(bool)
121     {
122         bytes32 _name = _nameStr.nameFilter();
123         if (pIDxName_[_name] == 0)
124             return (true);
125         else
126             return (false);
127     }
128 
129     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
130         isHuman()
131         public
132         payable
133     {
134         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
135 
136         bytes32 _name = NameFilter.nameFilter(_nameString);
137 
138         address _addr = msg.sender;
139 
140         bool _isNewPlayer = determinePID(_addr);
141 
142         uint256 _pID = pIDxAddr_[_addr];
143 
144         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
145         {
146             plyr_[_pID].laff = _affCode;
147         } else if (_affCode == _pID) {
148             _affCode = 0;
149         }
150 
151         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
152     }
153 
154     function registerNameXaddr(string _nameString, address _affCode, bool _all)
155         isHuman()
156         public
157         payable
158     {
159         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
160 
161         bytes32 _name = NameFilter.nameFilter(_nameString);
162 
163         address _addr = msg.sender;
164 
165         bool _isNewPlayer = determinePID(_addr);
166 
167         uint256 _pID = pIDxAddr_[_addr];
168 
169         uint256 _affID;
170         if (_affCode != address(0) && _affCode != _addr)
171         {
172             _affID = pIDxAddr_[_affCode];
173 
174             if (_affID != plyr_[_pID].laff)
175             {
176                 plyr_[_pID].laff = _affID;
177             }
178         }
179 
180         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
181     }
182 
183     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
184         isHuman()
185         public
186         payable
187     {
188         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
189 
190         bytes32 _name = NameFilter.nameFilter(_nameString);
191 
192         address _addr = msg.sender;
193 
194         bool _isNewPlayer = determinePID(_addr);
195 
196         uint256 _pID = pIDxAddr_[_addr];
197 
198         uint256 _affID;
199         if (_affCode != "" && _affCode != _name)
200         {
201             _affID = pIDxName_[_affCode];
202 
203             if (_affID != plyr_[_pID].laff)
204             {
205                 plyr_[_pID].laff = _affID;
206             }
207         }
208 
209         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
210     }
211 
212     function addMeToGame(uint256 _gameID)
213         isHuman()
214         public
215     {
216         require(_gameID <= gID_, "that game doesn't exist yet");
217         address _addr = msg.sender;
218         uint256 _pID = pIDxAddr_[_addr];
219         require(_pID != 0, "player dont even have an account");
220         uint256 _totalNames = plyr_[_pID].names;
221 
222         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
223 
224         // add list of all names
225         if (_totalNames > 1)
226             for (uint256 ii = 1; ii <= _totalNames; ii++)
227                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
228     }
229 
230     function addMeToAllGames()
231         isHuman()
232         public
233     {
234         address _addr = msg.sender;
235         uint256 _pID = pIDxAddr_[_addr];
236         require(_pID != 0, "player dont even have an account");
237         uint256 _laff = plyr_[_pID].laff;
238         uint256 _totalNames = plyr_[_pID].names;
239         bytes32 _name = plyr_[_pID].name;
240 
241         for (uint256 i = 1; i <= gID_; i++)
242         {
243             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
244             if (_totalNames > 1)
245                 for (uint256 ii = 1; ii <= _totalNames; ii++)
246                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
247         }
248 
249     }
250 
251     function useMyOldName(string _nameString)
252         isHuman()
253         public
254     {
255         bytes32 _name = _nameString.nameFilter();
256         uint256 _pID = pIDxAddr_[msg.sender];
257 
258         require(plyrNames_[_pID][_name] == true, "thats not a name you own");
259 
260         plyr_[_pID].name = _name;
261     }
262 
263     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
264         private
265     {
266         // if names already has been used, require that current msg sender owns the name
267         if (pIDxName_[_name] != 0)
268             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
269 
270         // add name to player profile, registry, and name book
271         plyr_[_pID].name = _name;
272         pIDxName_[_name] = _pID;
273         if (plyrNames_[_pID][_name] == false)
274         {
275             plyrNames_[_pID][_name] = true;
276             plyr_[_pID].names++;
277             plyrNameList_[_pID][plyr_[_pID].names] = _name;
278         }
279 
280         // registration fee goes directly to community rewards
281         admin.transfer(address(this).balance);
282 
283         // push player info to games
284         if (_all == true)
285             for (uint256 i = 1; i <= gID_; i++)
286                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
287 
288         // fire event
289         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
290     }
291 
292     function determinePID(address _addr)
293         private
294         returns (bool)
295     {
296         if (pIDxAddr_[_addr] == 0)
297         {
298             pID_++;
299             pIDxAddr_[_addr] = pID_;
300             plyr_[pID_].addr = _addr;
301 
302             // set the new player bool to true
303             return (true);
304         } else {
305             return (false);
306         }
307     }
308 
309     function getPlayerID(address _addr)
310         isRegisteredGame()
311         external
312         returns (uint256)
313     {
314         determinePID(_addr);
315         return (pIDxAddr_[_addr]);
316     }
317     function getPlayerName(uint256 _pID)
318         external
319         view
320         returns (bytes32)
321     {
322         return (plyr_[_pID].name);
323     }
324     function getPlayerLAff(uint256 _pID)
325         external
326         view
327         returns (uint256)
328     {
329         return (plyr_[_pID].laff);
330     }
331     function getPlayerAddr(uint256 _pID)
332         external
333         view
334         returns (address)
335     {
336         return (plyr_[_pID].addr);
337     }
338     function getNameFee()
339         external
340         view
341         returns (uint256)
342     {
343         return(registrationFee_);
344     }
345     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
346         isRegisteredGame()
347         external
348         payable
349         returns(bool, uint256)
350     {
351         // make sure name fees paid
352         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
353 
354         // set up our tx event data and determine if player is new or not
355         bool _isNewPlayer = determinePID(_addr);
356 
357         // fetch player id
358         uint256 _pID = pIDxAddr_[_addr];
359 
360         uint256 _affID = _affCode;
361         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
362         {
363             // update last affiliate
364             plyr_[_pID].laff = _affID;
365         } else if (_affID == _pID) {
366             _affID = 0;
367         }
368 
369         // register name
370         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
371 
372         return(_isNewPlayer, _affID);
373     }
374     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
375         isRegisteredGame()
376         external
377         payable
378         returns(bool, uint256)
379     {
380         // make sure name fees paid
381         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
382 
383         // set up our tx event data and determine if player is new or not
384         bool _isNewPlayer = determinePID(_addr);
385 
386         // fetch player id
387         uint256 _pID = pIDxAddr_[_addr];
388 
389         // manage affiliate residuals
390         // if no affiliate code was given or player tried to use their own, lolz
391         uint256 _affID;
392         if (_affCode != address(0) && _affCode != _addr)
393         {
394             // get affiliate ID from aff Code
395             _affID = pIDxAddr_[_affCode];
396 
397             // if affID is not the same as previously stored
398             if (_affID != plyr_[_pID].laff)
399             {
400                 // update last affiliate
401                 plyr_[_pID].laff = _affID;
402             }
403         }
404 
405         // register name
406         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
407 
408         return(_isNewPlayer, _affID);
409     }
410     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
411         isRegisteredGame()
412         external
413         payable
414         returns(bool, uint256)
415     {
416         // make sure name fees paid
417         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
418 
419         // set up our tx event data and determine if player is new or not
420         bool _isNewPlayer = determinePID(_addr);
421 
422         // fetch player id
423         uint256 _pID = pIDxAddr_[_addr];
424 
425         // manage affiliate residuals
426         // if no affiliate code was given or player tried to use their own, lolz
427         uint256 _affID;
428         if (_affCode != "" && _affCode != _name)
429         {
430             // get affiliate ID from aff Code
431             _affID = pIDxName_[_affCode];
432 
433             // if affID is not the same as previously stored
434             if (_affID != plyr_[_pID].laff)
435             {
436                 // update last affiliate
437                 plyr_[_pID].laff = _affID;
438             }
439         }
440 
441         // register name
442         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
443 
444         return(_isNewPlayer, _affID);
445     }
446 
447     function addGame(address _gameAddress, string _gameNameStr)
448         onlyDevs()
449         public
450     {
451         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
452         gID_++;
453         bytes32 _name = _gameNameStr.nameFilter();
454         gameIDs_[_gameAddress] = gID_;
455         gameNames_[_gameAddress] = _name;
456         games_[gID_] = UserDataManagerReceiverInterface(_gameAddress);
457 
458         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
459         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
460         games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
461         games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
462     }
463 
464     function setRegistrationFee(uint256 _fee)
465         onlyDevs()
466         public
467     {
468         registrationFee_ = _fee;
469     }
470 
471 }
472 
473 library NameFilter {
474 
475     function nameFilter(string _input)
476         internal
477         pure
478         returns(bytes32)
479     {
480         bytes memory _temp = bytes(_input);
481         uint256 _length = _temp.length;
482 
483         //sorry limited to 32 characters
484         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
485         // make sure it doesnt start with or end with space
486         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
487         // make sure first two characters are not 0x
488         if (_temp[0] == 0x30)
489         {
490             require(_temp[1] != 0x78, "string cannot start with 0x");
491             require(_temp[1] != 0x58, "string cannot start with 0X");
492         }
493 
494         // create a bool to track if we have a non number character
495         bool _hasNonNumber;
496 
497         // convert & check
498         for (uint256 i = 0; i < _length; i++)
499         {
500             // if its uppercase A-Z
501             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
502             {
503                 // convert to lower case a-z
504                 _temp[i] = byte(uint(_temp[i]) + 32);
505 
506                 // we have a non number
507                 if (_hasNonNumber == false)
508                     _hasNonNumber = true;
509             } else {
510                 require
511                 (
512                     // require character is a space
513                     _temp[i] == 0x20 ||
514                     // OR lowercase a-z
515                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
516                     // or 0-9
517                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
518                     "string contains invalid characters"
519                 );
520                 // make sure theres not 2x spaces in a row
521                 if (_temp[i] == 0x20)
522                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
523 
524                 // see if we have a character other than a number
525                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
526                     _hasNonNumber = true;
527             }
528         }
529 
530         require(_hasNonNumber == true, "string cannot be only numbers");
531 
532         bytes32 _ret;
533         assembly {
534             _ret := mload(add(_temp, 32))
535         }
536         return (_ret);
537     }
538 }
539 
540 library SafeMath {
541 
542     /**
543     * @dev Multiplies two numbers, throws on overflow.
544     */
545     function mul(uint256 a, uint256 b)
546         internal
547         pure
548         returns (uint256 c)
549     {
550         if (a == 0) {
551             return 0;
552         }
553         c = a * b;
554         require(c / a == b, "SafeMath mul failed");
555         return c;
556     }
557 
558     /**
559     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
560     */
561     function sub(uint256 a, uint256 b)
562         internal
563         pure
564         returns (uint256)
565     {
566         require(b <= a, "SafeMath sub failed");
567         return a - b;
568     }
569 
570     /**
571     * @dev Adds two numbers, throws on overflow.
572     */
573     function add(uint256 a, uint256 b)
574         internal
575         pure
576         returns (uint256 c)
577     {
578         c = a + b;
579         require(c >= a, "SafeMath add failed");
580         return c;
581     }
582 
583     /**
584      * @dev gives square root of given x.
585      */
586     function sqrt(uint256 x)
587         internal
588         pure
589         returns (uint256 y)
590     {
591         uint256 z = ((add(x,1)) / 2);
592         y = x;
593         while (z < y)
594         {
595             y = z;
596             z = ((add((x / z),z)) / 2);
597         }
598     }
599 
600     /**
601      * @dev gives square. multiplies x by x
602      */
603     function sq(uint256 x)
604         internal
605         pure
606         returns (uint256)
607     {
608         return (mul(x,x));
609     }
610 
611     /**
612      * @dev x to the power of y
613      */
614     function pwr(uint256 x, uint256 y)
615         internal
616         pure
617         returns (uint256)
618     {
619         if (x==0)
620             return (0);
621         else if (y==0)
622             return (1);
623         else
624         {
625             uint256 z = x;
626             for (uint256 i=1; i < y; i++)
627                 z = mul(z,x);
628             return (z);
629         }
630     }
631 }