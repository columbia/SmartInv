1 /*
2 @author radarzhhua@gamil.com
3 */
4 pragma solidity ^0.4.24;
5 
6 
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12 
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17 
18     function mul(uint a, uint b) internal pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22 
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 library NameFilter {
30 
31     /**
32      * @dev filters name strings
33      * -converts uppercase to lower case.
34      * -makes sure it does not start/end with a space
35      * -makes sure it does not contain multiple spaces in a row
36      * -cannot be only numbers
37      * -cannot start with 0x
38      * -restricts characters to A-Z, a-z, 0-9, and space.
39      * @return reprocessed string in bytes32 format
40      */
41     function nameFilter(string _input) internal pure returns (bytes32){
42         bytes memory _temp = bytes(_input);
43         uint _length = _temp.length;
44         //sorry limited to 32 characters
45         require(_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
46         // make sure it doesnt start with or end with space
47         require(_temp[0] != 0x20 && _temp[_length - 1] != 0x20, "string cannot start or end with space");
48         // make sure first two characters are not 0x
49         if (_temp[0] == 0x30)
50         {
51             require(_temp[1] != 0x78, "string cannot start with 0x");
52             require(_temp[1] != 0x58, "string cannot start with 0X");
53         }
54         // create a bool to track if we have a non number character
55         bool _hasNonNumber;
56         // convert & check
57         for (uint i = 0; i < _length; i++)
58         {
59             // if its uppercase A-Z
60             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
61             {
62                 // convert to lower case a-z
63                 _temp[i] = byte(uint(_temp[i]) + 32);
64 
65                 // we have a non number
66                 if (_hasNonNumber == false)
67                     _hasNonNumber = true;
68             } else {
69                 require
70                 (
71                 // require character is a space
72                     _temp[i] == 0x20 ||
73                 // OR lowercase a-z
74                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
75                 // or 0-9
76                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
77                     "string contains invalid characters"
78                 );
79                 // make sure theres not 2x spaces in a row
80                 if (_temp[i] == 0x20)
81                     require(_temp[i + 1] != 0x20, "string cannot contain consecutive spaces");
82 
83                 // see if we have a character other than a number
84                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
85                     _hasNonNumber = true;
86             }
87         }
88 
89         require(_hasNonNumber == true, "string cannot be only numbers");
90         bytes32 _ret;
91         assembly {
92             _ret := mload(add(_temp, 32))
93         }
94         return (_ret);
95     }
96 }
97 
98 
99 
100 
101 
102 // ----------------------------------------------------------------------------
103 // Owned contract
104 // ----------------------------------------------------------------------------
105 contract Owned {
106     address public owner;
107     address public newOwner;
108 
109     event OwnershipTransferred(address indexed _from, address indexed _to);
110     constructor() public {
111         owner = msg.sender;
112     }
113     modifier onlyOwner {
114         require(msg.sender == owner);
115         _;
116     }
117     function transferOwnership(address _newOwner) public onlyOwner {
118         newOwner = _newOwner;
119     }
120     function acceptOwnership() public {
121         require(msg.sender == newOwner);
122         emit OwnershipTransferred(owner, newOwner);
123         owner = newOwner;
124         newOwner = address(0);
125     }
126 }
127 
128 contract PlayerBook is Owned {
129     using SafeMath for uint;
130     using NameFilter for string;
131     bool public actived = false;
132     uint public registrationFee_ = 1 finney;            // price to register a name
133     uint public pID_;        // total number of players
134     mapping(address => uint) public pIDxAddr_;          // (addr => pID) returns player id by address
135     mapping(uint => Player) public plyr_;               // (pID => data) player data
136     mapping(bytes32 => uint) public pIDxName_;          // (name => pID) returns player id by name
137     mapping(uint => mapping(bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
138     mapping(uint => mapping(uint => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
139     struct Player {
140         address addr;
141         bytes32 name;
142         uint laff;
143         uint names;
144     }
145     /**
146      * @dev prevents contracts from interacting with playerBook
147      */
148     modifier isHuman {
149         address _addr = msg.sender;
150         uint _codeLength;
151         assembly {_codeLength := extcodesize(_addr)}
152         require(_codeLength == 0, "sorry humans only");
153         _;
154     }
155     modifier isActive {
156         require(actived, "sorry game paused");
157         _;
158     }
159     modifier isRegistered {
160         address _addr = msg.sender;
161         uint _pid = pIDxAddr_[msg.sender];
162         require(_pid != 0, " you need register the address");
163         _;
164     }
165 
166     // ------------------------------------------------------------------------
167     // Constructor
168     // ------------------------------------------------------------------------
169     constructor() public {
170         // premine the admin names (sorry not sorry)
171         plyr_[1].addr = 0x2ba0ECF5eC2dD51F115d8526333395beba490363;
172         plyr_[1].name = "admin";
173         plyr_[1].names = 1;
174         pIDxAddr_[0x2ba0ECF5eC2dD51F115d8526333395beba490363] = 1;
175         pIDxName_["admin"] = 1;
176         plyrNames_[1]["admin"] = true;
177         plyrNameList_[1][1] = "admin";
178         pID_ = 1;
179     }
180 
181     function checkIfNameValid(string _nameStr) public view returns (bool){
182         bytes32 _name = _nameStr.nameFilter();
183         if (pIDxName_[_name] == 0)
184             return (true);
185         else
186             return (false);
187     }
188 
189     function determinePID(address _addr) private returns (bool){
190         if (pIDxAddr_[_addr] == 0) {
191             pID_++;
192             pIDxAddr_[_addr] = pID_;
193             plyr_[pID_].addr = _addr;
194             // set the new player bool to true
195             return (true);
196         } else {
197             return (false);
198         }
199     }
200 
201     function registerNameXID(string _nameString, uint _affCode) public isActive isHuman payable {
202         // make sure name fees paid
203         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
204         // filter name + condition checks
205         bytes32 _name = NameFilter.nameFilter(_nameString);
206         // set up address
207         address _addr = msg.sender;
208         // set up our tx event data and determine if player is new or not
209         determinePID(_addr);
210         // fetch player id
211         uint _pID = pIDxAddr_[_addr];
212         // manage affiliate residuals
213         // if no affiliate code was given, no new affiliate code was given, or the
214         // player tried to use their own pID as an affiliate code, lolz
215         //_affCode must little than the pID_
216         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID && _affCode <= pID_) {
217             // update last affiliate
218             plyr_[_pID].laff = _affCode;
219         } else {
220             if(plyr_[_pID].laff == 0)
221               plyr_[_pID].laff = 1;
222         }
223         // register name
224         plyr_[1].addr.transfer(msg.value);
225         registerNameCore(_pID, _name);
226     }
227 
228     function registerNameCore(uint _pID, bytes32 _name) private {
229         if (pIDxName_[_name] != 0)
230             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
231         plyr_[_pID].name = _name;
232         pIDxName_[_name] = _pID;
233         if (plyrNames_[_pID][_name] == false)
234         {
235             plyrNames_[_pID][_name] = true;
236             plyr_[_pID].names++;
237             plyrNameList_[_pID][plyr_[_pID].names] = _name;
238         }
239     }
240 
241     function getPlayerLaffCount(address _addr) internal view returns (uint){
242         uint _pid = pIDxAddr_[_addr];
243         if (_pid == 0) {
244             return 0;
245         } else {
246             uint result = 0;
247             for (uint i = 1; i <= pID_; i++) {
248                 if (plyr_[i].laff == _pid) {
249                     result ++;
250                 }
251             }
252             return result;
253         }
254     }
255 
256     function getPlayerID(address _addr) external view returns (uint) {
257         return (pIDxAddr_[_addr]);
258     }
259 
260     function getPlayerCount() external view returns (uint){
261         return pID_;
262     }
263 
264     function getPlayerName(uint _pID) external view returns (bytes32){
265         return (plyr_[_pID].name);
266     }
267 
268     function getPlayerLAff(uint _pID) external view returns (uint){
269         return (plyr_[_pID].laff);
270     }
271 
272     function getPlayerAddr(uint _pID) external view returns (address){
273         return (plyr_[_pID].addr);
274     }
275 
276     function getNameFee() external view returns (uint){
277         return (registrationFee_);
278     }
279 
280     function setRegistrationFee(uint _fee) public onlyOwner {
281         require(_fee != 0);
282         registrationFee_ = _fee;
283     }
284 
285     function active() public onlyOwner {
286         actived = true;
287     }
288 }
289 
290 
291 
292 // ----------------------------------------------------------------------------
293 contract Treasure is PlayerBook {
294     uint private seed = 18;                    //random seed
295     /* bool private canSet = true; */
296     //module 0,1,2
297     uint[3] public gameRound = [1, 1, 1];                         //rounds index by module
298     uint[3] public maxKeys = [1200, 12000, 60000];              //index by module
299     uint[3] public keyLimits = [100, 1000, 5000];               //index by module
300     uint public keyPrice = 10 finney;
301     uint public devFee = 10;
302     uint public laffFee1 = 10;
303     uint public laffFee2 = 1;
304     address public devWallet = 0xB4D4709C2D537047683294c4040aBB9d616e23B5;
305     mapping(uint => mapping(uint => RoundInfo)) public gameInfo;   //module => round => info
306     mapping(uint => mapping(uint => mapping(uint => uint))) public userAff;     //module => round => pid => affCount
307     struct RoundInfo {
308         uint module;            //module 0,1,2
309         uint rd;                // rounds
310         uint count;             // player number and id
311         uint keys;              // purchased keys
312         uint maxKeys;           // end keys
313         uint keyLimits;
314         uint award;             //award of the round
315         address winner;         //winner
316         bool isEnd;
317         mapping(uint => uint) userKeys;        // pid => keys
318         mapping(uint => uint) userId;      // count => pid
319     }
320 
321     modifier validModule(uint _module){
322         require(_module >= 0 && _module <= 2, " error module");
323         _;
324     }
325 
326     // ------------------------------------------------------------------------
327     // Constructor
328     // ------------------------------------------------------------------------
329     constructor() public {
330         initRoundInfo(0, 1);
331         initRoundInfo(1, 1);
332         initRoundInfo(2, 1);
333     }
334     //only be called once
335     /* function setSeed(uint _seed) public onlyOwner {
336       require(canSet);
337       canSet = false;
338       seed = _seed;
339     } */
340 
341     /**
342    random int
343     */
344     function randInt(uint256 _start, uint256 _end, uint256 _nonce)
345     private
346     view
347     returns (uint256)
348     {
349         uint256 _range = _end.sub(_start);
350         uint256 value = uint256(keccak256(abi.encodePacked(
351                 (block.timestamp).add
352                 (block.difficulty).add
353                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
354                 (block.gaslimit).add
355                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
356                 (block.number),
357                 _nonce
358             )));
359         return (_start + value - ((value / _range) * _range));
360     }
361 
362     function initRoundInfo(uint _mode, uint _rd) private validModule(_mode) {
363         uint _maxKeys = maxKeys[_mode];
364         uint _keyLimits = keyLimits[_mode];
365         RoundInfo memory rf = RoundInfo({
366             module : _mode,
367             rd : _rd,
368             count : 0,
369             keys : 0,
370             maxKeys : _maxKeys,
371             keyLimits : _keyLimits,
372             award : 0,
373             winner : address(0),
374             isEnd : false
375             });
376         gameInfo[_mode][_rd] = rf;
377     }
378     //user detail of one round
379     function getUserDetail(uint _mode, uint _rd) public validModule(_mode) view returns (uint _eth, uint _award, uint _affEth){
380         address _addr = msg.sender;
381         uint _pid = pIDxAddr_[_addr];
382         require(_pid != 0, " you need register the address");
383         uint _userKeys = gameInfo[_mode][_rd].userKeys[_pid];
384         _eth = _userKeys * keyPrice;
385         if (gameInfo[_mode][_rd].winner == _addr)
386             _award = gameInfo[_mode][_rd].award;
387         else
388             _award = 0;
389         _affEth = userAff[_mode][_rd][_pid];
390     }
391 
392     function getAllLaffAwards(address _addr) private view returns (uint){
393         uint _pid = pIDxAddr_[_addr];
394         require(_pid != 0, " you need register the address");
395         uint sum = 0;
396         for (uint i = 0; i < 3; i++) {
397             for (uint j = 1; j <= gameRound[i]; j++) {
398                 uint value = userAff[i][j][_pid];
399                 if (value > 0)
400                     sum = sum.add(value);
401             }
402         }
403         return sum;
404     }
405 
406     function getPlayerAllDetail() external view returns (uint[] modes, uint[] rounds, uint[] eths, uint[] awards, uint _laffAwards, uint _laffCount){
407         address _addr = msg.sender;
408         uint _pid = pIDxAddr_[_addr];
409         require(_pid != 0, " you need register the address");
410         uint i = gameRound[0] + gameRound[1] + gameRound[2];
411         uint counter = 0;
412         RoundInfo[] memory allInfo = new RoundInfo[](i);
413         for (i = 0; i < 3; i++) {
414             for (uint j = 1; j <= gameRound[i]; j++) {
415                 if (gameInfo[i][j].userKeys[_pid] > 0) {
416                     allInfo[counter] = gameInfo[i][j];
417                     counter ++;
418                 }
419             }
420         }
421         modes = new uint[](counter);
422         rounds = new uint[](counter);
423         eths = new uint[](counter);
424         awards = new uint[](counter);
425         for (i = 0; i < counter; i++) {
426             modes[i] = allInfo[i].module;
427             rounds[i] = allInfo[i].rd;
428             eths[i] = gameInfo[modes[i]][rounds[i]].userKeys[_pid].mul(keyPrice);
429             if (_addr == allInfo[i].winner) {
430                 awards[i] = allInfo[i].award;
431             } else {
432                 awards[i] = 0;
433             }
434         }
435         _laffAwards = getAllLaffAwards(_addr);
436         _laffCount = getPlayerLaffCount(_addr);
437     }
438 
439     function buyKeys(uint _mode, uint _rd) public isHuman isActive validModule(_mode) payable {
440         address _addr = msg.sender;
441         uint _pid = pIDxAddr_[_addr];
442         require(_pid != 0, " you need register the address");
443         uint _eth = msg.value;
444         require(_eth >= keyPrice, "you need buy one or more keys");
445         require(_rd == gameRound[_mode], "error round");
446         RoundInfo storage ri = gameInfo[_mode][_rd];
447         require(!ri.isEnd, "the round is end");
448         require(ri.keys < ri.maxKeys, "the round maxKeys");
449         uint _keys = _eth.div(keyPrice);
450         require(ri.userKeys[_pid] < ri.keyLimits);
451         if (ri.userKeys[_pid] == 0) {
452             ri.count ++;
453             ri.userId[ri.count] = _pid;
454         }
455         if (_keys.add(ri.keys) > ri.maxKeys) {
456             _keys = ri.maxKeys.sub(ri.keys);
457         }
458         if (_keys.add(ri.userKeys[_pid]) > ri.keyLimits) {
459             _keys = ri.keyLimits - ri.userKeys[_pid];
460         }
461         require(_keys > 0);
462         uint rand = randInt(0, 100, seed+_keys);
463         seed = seed.add(rand);
464         _eth = _keys.mul(keyPrice);
465         ri.userKeys[_pid] = ri.userKeys[_pid].add(_keys);
466         ri.keys = ri.keys.add(_keys);
467         //back
468         if(msg.value - _eth > 10 szabo )
469           msg.sender.transfer(msg.value - _eth);
470         checkAff(_mode, _rd, _pid, _eth);
471         if (ri.keys >= ri.maxKeys) {
472             endRound(_mode, _rd);
473         }
474     }
475 
476     function getUserInfo(address _addr) public view returns (uint _pID, bytes32 _name, uint _laff, uint[] _keys){
477         _pID = pIDxAddr_[_addr];
478         _name = plyr_[_pID].name;
479         _laff = plyr_[_pID].laff;
480         _keys = new uint[](3);
481         for (uint i = 0; i < 3; i++) {
482             _keys[i] = gameInfo[i][gameRound[i]].userKeys[_pID];
483         }
484     }
485 
486 
487     function endRound(uint _mode, uint _rd) private {
488         RoundInfo storage ri = gameInfo[_mode][_rd];
489         require(!ri.isEnd, "the rounds has end");
490         ri.isEnd = true;
491         uint _eth = ri.award.mul(devFee) / 100;
492         uint _win = calWinner(_mode, _rd);
493         ri.winner = plyr_[_win].addr;
494         gameRound[_mode] = _rd + 1;
495         initRoundInfo(_mode, _rd + 1);
496         devWallet.transfer(_eth);
497         plyr_[_win].addr.transfer(ri.award.sub(_eth));
498     }
499 
500     function calWinner(uint _mode, uint _rd) private returns (uint){
501         RoundInfo storage ri = gameInfo[_mode][_rd];
502         uint rand = randInt(0, ri.maxKeys, seed);
503         seed = seed.add(rand);
504         uint keySum = 0;
505         uint _win = 0;
506         for (uint i = 1; i <= ri.count; i++) {
507             uint _key = ri.userKeys[ri.userId[i]];
508             keySum += _key;
509             if (rand < keySum) {
510                 _win = i;
511                 break;
512             }
513         }
514         require(_win > 0);
515         return ri.userId[_win];
516     }
517 
518     function checkAff(uint _mode, uint _rd, uint _pid, uint _eth) private {
519         uint fee1 = _eth.mul(laffFee1).div(100);
520         uint fee2 = _eth.mul(laffFee2).div(100);
521         uint res = _eth.sub(fee1).sub(fee2);
522         gameInfo[_mode][_rd].award += res;
523         uint laff1 = plyr_[_pid].laff;
524         if (laff1 == 0) {
525             plyr_[1].addr.transfer(fee1.add(fee2));
526         } else {
527             plyr_[laff1].addr.transfer(fee1);
528             userAff[_mode][_rd][laff1] += fee1;
529             uint laff2 = plyr_[laff1].laff;
530             if (laff2 == 0) {
531                 plyr_[1].addr.transfer(fee2);
532             } else {
533                 plyr_[laff2].addr.transfer(fee2);
534                 userAff[_mode][_rd][laff2] += fee2;
535             }
536         }
537     }
538 
539     function getRoundInfo(uint _mode) external validModule(_mode) view returns (uint _cr, uint _ck, uint _mk, uint _award){
540         _cr = gameRound[_mode];
541         _ck = gameInfo[_mode][_cr].keys;
542         _mk = gameInfo[_mode][_cr].maxKeys;
543         _award = gameInfo[_mode][_cr].award;
544     }
545 
546     function getRoundIsEnd(uint _mode, uint _rd) external validModule(_mode) view returns (bool){
547         require(_rd > 0 && _rd <= gameRound[_mode]);
548         return gameInfo[_mode][_rd].isEnd;
549     }
550 
551     function getAwardHistorhy(uint _mode) external validModule(_mode) view returns (address[] dh, uint[] ah){
552         uint hr = gameRound[_mode] - 1;
553         dh = new address[](hr);
554         ah = new uint[](hr);
555         if (hr != 0) {
556             for (uint i = 1; i <= hr; i++) {
557                 RoundInfo memory rf = gameInfo[_mode][i];
558                 dh[i - 1] = rf.winner;
559                 ah[i - 1] = rf.award;
560             }
561         }
562     }
563         /* ****************************************************
564               *********                            *********
565                 *********                        *********
566                   *********    thanks a lot    *********
567                     *********                *********
568                       *********            *********
569                         *********        *********
570                           *********    *********
571                             ******************
572                               **************
573                                 **********
574                                   *****
575                                     *
576          *********************************************************/
577 }