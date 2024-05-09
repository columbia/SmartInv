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
42 }
43 
44 contract UserDataManager {
45     using NameFilter for string;
46 
47     address private admin = msg.sender;
48     uint256 public registrationFee_ = 0;         
49 
50     mapping(uint256 => UserDataManagerReceiverInterface) public games_;  
51     mapping(address => bytes32) public gameNames_;         
52     mapping(address => uint256) public gameIDs_;           
53     uint256 public gID_;        
54     uint256 public pID_;       
55     mapping (address => uint256) public pIDxAddr_;          
56     mapping (bytes32 => uint256) public pIDxName_;          
57     mapping (uint256 => Player) public plyr_;              
58 
59     struct Player {
60         address addr;
61         bytes32 name;
62         uint256 laff;
63     }
64 
65     constructor()
66         public
67     {
68         plyr_[1].addr = 0xe27c188521248a49adfc61090d3c8ab7c3754e0a;
69         plyr_[1].name = "matt";
70         pIDxAddr_[0xe27c188521248a49adfc61090d3c8ab7c3754e0a] = 1;
71         pIDxName_["matt"] = 1;
72 
73         pID_ = 1;
74     }
75 
76     modifier isHuman() {
77         address _addr = msg.sender;
78         uint256 _codeLength;
79 
80         assembly {_codeLength := extcodesize(_addr)}
81         require(_codeLength == 0, "sorry humans only");
82         _;
83     }
84 
85     modifier onlyDevs()
86     {
87         require(admin == msg.sender, "msg sender is not a dev");
88         _;
89     }
90 
91     modifier isRegisteredGame()
92     {
93         require(gameIDs_[msg.sender] != 0);
94         _;
95     }
96 
97     event onNewPlayer
98     (
99         uint256 indexed playerID,
100         address indexed playerAddress,
101         bytes32 indexed playerName,
102         bool isNewPlayer,
103         uint256 affiliateID,
104         address affiliateAddress,
105         bytes32 affiliateName,
106         uint256 amountPaid,
107         uint256 timeStamp
108     );
109 
110     function checkIfNameValid(string _nameStr)
111         public
112         view
113         returns(bool)
114     {
115         bytes32 _name = _nameStr.nameFilter();
116         if (pIDxName_[_name] == 0)
117             return (true);
118         else
119             return (false);
120     }
121 
122     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
123         isHuman()
124         public
125         payable
126     {
127         require (msg.value >= registrationFee_, "you have to pay the name fee");
128 
129         bytes32 _name = NameFilter.nameFilter(_nameString);
130 
131         address _addr = msg.sender;
132 
133         bool _isNewPlayer = determinePID(_addr);
134 
135         uint256 _pID = pIDxAddr_[_addr];
136 
137         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
138         {
139             plyr_[_pID].laff = _affCode;
140         } else if (_affCode == _pID) {
141             _affCode = 0;
142         }
143 
144         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
145     }
146 
147     function registerNameXaddr(string _nameString, address _affCode, bool _all)
148         isHuman()
149         public
150         payable
151     {
152         require (msg.value >= registrationFee_, "you have to pay the name fee");
153 
154         bytes32 _name = NameFilter.nameFilter(_nameString);
155 
156         address _addr = msg.sender;
157 
158         bool _isNewPlayer = determinePID(_addr);
159 
160         uint256 _pID = pIDxAddr_[_addr];
161 
162         uint256 _affID;
163         if (_affCode != address(0) && _affCode != _addr)
164         {
165             _affID = pIDxAddr_[_affCode];
166 
167             if (_affID != plyr_[_pID].laff)
168             {
169                 plyr_[_pID].laff = _affID;
170             }
171         }
172 
173         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
174     }
175 
176     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
177         isHuman()
178         public
179         payable
180     {
181         require (msg.value >= registrationFee_, "you have to pay the name fee");
182 
183         bytes32 _name = NameFilter.nameFilter(_nameString);
184 
185         address _addr = msg.sender;
186 
187         bool _isNewPlayer = determinePID(_addr);
188 
189         uint256 _pID = pIDxAddr_[_addr];
190 
191         uint256 _affID;
192         if (_affCode != "" && _affCode != _name)
193         {
194             _affID = pIDxName_[_affCode];
195 
196             if (_affID != plyr_[_pID].laff)
197             {
198                 plyr_[_pID].laff = _affID;
199             }
200         }
201 
202         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
203     }
204 
205     function addMeToGame(uint256 _gameID)
206         isHuman()
207         public
208     {
209         require(_gameID <= gID_, "that game doesn't exist yet");
210         address _addr = msg.sender;
211         uint256 _pID = pIDxAddr_[_addr];
212         require(_pID != 0, "player dont even have an account");
213 
214         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
215     }
216 
217     function addMeToAllGames()
218         isHuman()
219         public
220     {
221         address _addr = msg.sender;
222         uint256 _pID = pIDxAddr_[_addr];
223         require(_pID != 0, "player dont even have an account");
224         uint256 _laff = plyr_[_pID].laff;
225         bytes32 _name = plyr_[_pID].name;
226 
227         for (uint256 i = 1; i <= gID_; i++)
228         {
229             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
230         }
231 
232     }
233 
234     function changeMyName(string _nameString)
235         isHuman()
236         public
237     {
238         bytes32 _name = _nameString.nameFilter();
239         uint256 _pID = pIDxAddr_[msg.sender];
240 
241         plyr_[_pID].name = _name;
242     }
243 
244     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
245         private
246     {
247         if (pIDxName_[_name] != 0)
248             require(pIDxName_[_name] == _pID, "sorry that names already taken");
249 
250         plyr_[_pID].name = _name;
251         pIDxName_[_name] = _pID;
252 
253         admin.transfer(address(this).balance);
254 
255         if (_all == true)
256             for (uint256 i = 1; i <= gID_; i++)
257                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
258 
259         emit onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
260     }
261 
262     function determinePID(address _addr)
263         private
264         returns (bool)
265     {
266         if (pIDxAddr_[_addr] == 0)
267         {
268             pID_++;
269             pIDxAddr_[_addr] = pID_;
270             plyr_[pID_].addr = _addr;
271 
272             return (true);
273         } else {
274             return (false);
275         }
276     }
277 
278     function getPlayerID(address _addr)
279         isRegisteredGame()
280         external
281         returns (uint256)
282     {
283         determinePID(_addr);
284         return (pIDxAddr_[_addr]);
285     }
286     function getPlayerName(uint256 _pID)
287         external
288         view
289         returns (bytes32)
290     {
291         return (plyr_[_pID].name);
292     }
293     function getPlayerLaff(uint256 _pID)
294         external
295         view
296         returns (uint256)
297     {
298         return (plyr_[_pID].laff);
299     }
300     function getPlayerAddr(uint256 _pID)
301         external
302         view
303         returns (address)
304     {
305         return (plyr_[_pID].addr);
306     }
307     function getNameFee()
308         external
309         view
310         returns (uint256)
311     {
312         return(registrationFee_);
313     }
314     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
315         isRegisteredGame()
316         external
317         payable
318         returns(bool, uint256)
319     {
320         require (msg.value >= registrationFee_, "you have to pay the name fee");
321 
322         bool _isNewPlayer = determinePID(_addr);
323 
324         uint256 _pID = pIDxAddr_[_addr];
325 
326         uint256 _affID = _affCode;
327         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
328         {
329             plyr_[_pID].laff = _affID;
330         } else if (_affID == _pID) {
331             _affID = 0;
332         }
333 
334         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
335 
336         return(_isNewPlayer, _affID);
337     }
338     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
339         isRegisteredGame()
340         external
341         payable
342         returns(bool, uint256)
343     {
344         require (msg.value >= registrationFee_, "you have to pay the name fee");
345 
346         bool _isNewPlayer = determinePID(_addr);
347 
348         uint256 _pID = pIDxAddr_[_addr];
349 
350         uint256 _affID;
351         if (_affCode != address(0) && _affCode != _addr)
352         {
353             _affID = pIDxAddr_[_affCode];
354 
355             if (_affID != plyr_[_pID].laff)
356             {
357                 plyr_[_pID].laff = _affID;
358             }
359         }
360 
361         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
362 
363         return(_isNewPlayer, _affID);
364     }
365     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
366         isRegisteredGame()
367         external
368         payable
369         returns(bool, uint256)
370     {
371         require (msg.value >= registrationFee_, "you have to pay the name fee");
372 
373         bool _isNewPlayer = determinePID(_addr);
374 
375         uint256 _pID = pIDxAddr_[_addr];
376 
377         uint256 _affID;
378         if (_affCode != "" && _affCode != _name)
379         {
380             _affID = pIDxName_[_affCode];
381 
382             if (_affID != plyr_[_pID].laff)
383             {
384                 plyr_[_pID].laff = _affID;
385             }
386         }
387 
388         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
389 
390         return(_isNewPlayer, _affID);
391     }
392 
393     function addGame(address _gameAddress, string _gameNameStr)
394         onlyDevs()
395         public
396     {
397         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
398         gID_++;
399         bytes32 _name = _gameNameStr.nameFilter();
400         gameIDs_[_gameAddress] = gID_;
401         gameNames_[_gameAddress] = _name;
402         games_[gID_] = UserDataManagerReceiverInterface(_gameAddress);
403 
404         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
405     }
406 
407     function setRegistrationFee(uint256 _fee)
408         onlyDevs()
409         public
410     {
411         registrationFee_ = _fee;
412     }
413 
414 }
415 
416 library NameFilter {
417 
418     function nameFilter(string _input)
419         internal
420         pure
421         returns(bytes32)
422     {
423         bytes memory _temp = bytes(_input);
424         uint256 _length = _temp.length;
425 
426         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
427         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
428 
429         if (_temp[0] == 0x30)
430         {
431             require(_temp[1] != 0x78, "string cannot start with 0x");
432             require(_temp[1] != 0x58, "string cannot start with 0X");
433         }
434 
435         bool _hasNonNumber;
436 
437         for (uint256 i = 0; i < _length; i++)
438         {
439             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
440             {
441                 _temp[i] = byte(uint(_temp[i]) + 32);
442 
443                 if (_hasNonNumber == false)
444                     _hasNonNumber = true;
445             } else {
446                 require
447                 (
448                     _temp[i] == 0x20 ||
449                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
450                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
451                     "string contains invalid characters"
452                 );
453                 if (_temp[i] == 0x20)
454                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
455 
456                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
457                     _hasNonNumber = true;
458             }
459         }
460 
461         require(_hasNonNumber == true, "string cannot be only numbers");
462 
463         bytes32 _ret;
464         assembly {
465             _ret := mload(add(_temp, 32))
466         }
467         return (_ret);
468     }
469 }