1 pragma solidity ^0.4.24;
2 
3 library SafeMath {function mul(uint256 a, uint256 b) internal pure returns (uint256 c)
4 {if (a == 0) {return 0;}
5     c = a * b;
6     require(c / a == b, "SafeMath mul failed");
7     return c;}
8 
9     function div(uint256 a, uint256 b) internal pure returns (uint256){uint256 c = a / b;
10         return c;}
11 
12     function sub(uint256 a, uint256 b)
13     internal
14     pure
15     returns (uint256)
16     {require(b <= a, "SafeMath sub failed");
17         return a - b;}
18 
19     function add(uint256 a, uint256 b)
20     internal
21     pure
22     returns (uint256 c)
23     {c = a + b;
24         require(c >= a, "SafeMath add failed");
25         return c;}
26 
27     function sqrt(uint256 x)
28     internal
29     pure
30     returns (uint256 y)
31     {uint256 z = ((add(x, 1)) / 2);
32         y = x;
33         while (z < y)
34         {y = z;
35             z = ((add((x / z), z)) / 2);}}
36 
37     function sq(uint256 x)
38     internal
39     pure
40     returns (uint256)
41     {return (mul(x, x));}
42 
43     function pwr(uint256 x, uint256 y)
44     internal
45     pure
46     returns (uint256)
47     {if (x == 0)
48         return (0); else if (y == 0)
49         return (1); else
50     {uint256 z = x;
51         for (uint256 i = 1; i < y; i++)
52             z = mul(z, x);
53         return (z);}}}
54 
55 library NameFilter {function nameFilter(string _input)
56 internal
57 pure
58 returns (bytes32)
59 {bytes memory _temp = bytes(_input);
60     uint256 _length = _temp.length;
61     require(_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
62     require(_temp[0] != 0x20 && _temp[_length - 1] != 0x20, "string cannot start or end with space");
63     if (_temp[0] == 0x30)
64     {require(_temp[1] != 0x78, "string cannot start with 0x");
65         require(_temp[1] != 0x58, "string cannot start with 0X");}
66     bool _hasNonNumber;
67     for (uint256 i = 0; i < _length; i++)
68     {if (_temp[i] > 0x40 && _temp[i] < 0x5b)
69     {_temp[i] = byte(uint(_temp[i]) + 32);
70         if (_hasNonNumber == false)
71             _hasNonNumber = true;} else {require
72     (_temp[i] == 0x20 || (_temp[i] > 0x60 && _temp[i] < 0x7b) || (_temp[i] > 0x2f && _temp[i] < 0x3a), "string contains invalid characters");
73         if (_temp[i] == 0x20)
74             require(_temp[i + 1] != 0x20, "string cannot contain consecutive spaces");
75         if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
76             _hasNonNumber = true;}}
77     require(_hasNonNumber == true, "string cannot be only numbers");
78     bytes32 _ret;
79     assembly{_ret := mload(add(_temp, 32))}
80     return (_ret);}}
81 
82 contract ProtectEarth {using SafeMath for *;using NameFilter for *;struct Player {address addr;bytes32 name;uint8 level;uint256 recCount;uint256 laffID;uint256 commanderID;uint256 captainID;uint256 win;uint256 enableVault;uint256 affVault;uint256 achievement;uint256 keys;}
83 
84     struct Performance {uint value;uint start;uint end;uint fenzi;uint fenmu;}
85 
86     struct CurrDayPerformance {uint value;uint start;}
87 
88     struct EventReturns {address playerAddress;uint256 playerID;uint256 ethIn;uint256 keysBought;uint256 affiliateID;uint256 commanderID;uint256 captainID;uint256 airAmount;uint256 potAmount;uint256 timeStamp;}
89 
90     event onNewName
91     (uint256 indexed playerID, address indexed playerAddress, bytes32 indexed playerName, bool isNewPlayer, uint256 affiliateID, address affiliateAddress, bytes32 affiliateName, uint256 amountPaid, uint256 timeStamp);
92     event onWithdraw(uint indexed pID, address pAddress, bytes32 pName, uint ethOut, uint timeStamp);
93     event onLevelUp
94     (uint256 indexed playerID, address indexed playerAddress, bytes32 indexed playerName, uint256 timeStamp);
95     event airePotOpen
96     (uint256 indexed playerID, address indexed playerAddress, bytes32 indexed playerName, uint256 amount, uint256 timeStamp);
97     event onNewPlayer
98     (uint256 indexed playerID, address indexed playerAddress, bytes32 indexed playerName, uint256 affiliateID, uint256 commanderID, uint256 captainID, uint256 timeStamp);
99     event onEndTx
100     (address indexed playerAddress, uint256 indexed playerID, uint256 ethIn, uint256 keysBought, uint256 affiliateID, uint256 commanderID, uint256 captainID, uint256 airAmount, uint256 potAmount, uint256 timeStamp);
101 
102     uint256 constant private captionPrice = 15 ether;
103     uint256 constant private leaderPrice = 5 ether;
104     uint256 constant private price = 1 ether;
105     uint256 constant private unLockPrice = 1 ether;
106     uint constant private cap2capRate = 2;
107     uint constant private captainRate = 5;
108     uint constant private comm2commRate = 5;
109     uint constant private firstLevel = 8;
110     uint constant private secondLevel = 5;
111     uint constant private potRate = 60;
112     uint constant private airDropRate = 1;
113     uint256 public airDropPot_;
114     uint16 public openWeek = 0;
115     uint256 public gameStart;
116     bool public activated_ = false;
117     uint256 public totalEth_;
118     uint256 public pot_;
119     uint public constant rebatePeriod_ = 1 days;
120     uint16 public rebateOneFenzi_ = 1;
121     uint16 public rebateOneFenmu_ = 1000;
122     uint16 public rebateTwoFenzi_ = 2;
123     uint16 public rebateTwoFenmu_ = 1000;
124     mapping(uint => Performance[])public rebateOne_;
125     mapping(uint => Performance[])public rebateTwo_;
126     mapping(address => uint256)public pIDxAddr_;
127     mapping(uint256 => Player)public plyr_;
128     uint256 public pID_;
129     mapping(uint => CurrDayPerformance)public plyrCurrDayPerformance_;
130     uint constant private oneDay_ = 1 days;
131     uint constant private oneWeek_ = 1 weeks;
132     uint constant private upCaptainRec_ = 20;
133     uint constant private upCommanderRec_ = 5;
134     address comWallet;
135     address agentWallet;
136     address devWallet;
137     address bossHeWallet;
138     address middleWallet;
139     constructor()public{
140         comWallet = 0x5FA1f7B793d31C2D7303cf3Fd32c8D1f311B0067;
141         agentWallet = 0x8bEcEcA907906d5A40E2755fC1A385eDa848891E;
142         devWallet = 0x09CeF84fFb7D62db252Fae0460Ce9A7526E1E827;
143         bossHeWallet = 0xacC78A6a010aC0f84A9adA41272f1cC9c1b233Fb;
144         middleWallet = 0xcB3B7Ac9733AA0dB340370105f6583bd390032af;
145 
146         plyr_[1].addr = 0x24ECF2efC032FcD6244006036e6B05031c4D44ef;
147         plyr_[1].name = "system";
148         pIDxAddr_[0x24ECF2efC032FcD6244006036e6B05031c4D44ef] = 1;
149 
150         //指挥官
151         plyr_[1].level = 1;
152         plyr_[2].addr = 0x24ECF2efC032FcD6244006036e6B05031c4D44ef;
153         plyr_[2].name = "commander";
154         pIDxAddr_[0x24ECF2efC032FcD6244006036e6B05031c4D44ef] = 2;
155 
156         //舰长
157         plyr_[2].level = 2;
158         plyr_[3].addr = 0x24ECF2efC032FcD6244006036e6B05031c4D44ef;
159         plyr_[3].name = "captain";
160         pIDxAddr_[0x24ECF2efC032FcD6244006036e6B05031c4D44ef] = 3;
161         plyr_[3].level = 3;
162 
163         pID_ = 3;
164 }
165     function getPlayerByAddr(address _addr) public view
166     returns (uint256, bytes32, uint8, uint256, uint256){uint256 _pID = pIDxAddr_[_addr];
167         if (_pID == 0) return (0, "", 0, 0, 0);
168         return (_pID, plyr_[_pID].name, plyr_[_pID].level, plyr_[_pID].recCount, plyr_[_pID].keys);}
169 
170     function getStastiticsByAddr(address _addr) public view
171     returns (uint256, uint256, uint256, uint, uint){uint256 _pID = pIDxAddr_[_addr];
172         if (_pID == 0) return (0, 0, 0, 0, 0);
173         uint256 totalCaptain;
174         uint256 totalCommander;
175         uint256 totalSoldier;
176         for (uint256 i = 1; i <= pID_; i++) {if (plyr_[_pID].level == 3) {if (plyr_[i].level == 3 && plyr_[i].captainID == _pID) {totalCaptain++;}
177             if (plyr_[i].level == 2 && plyr_[i].captainID == _pID) {totalCommander++;}
178             if (plyr_[i].level == 1 && plyr_[i].captainID == _pID) {totalSoldier++;}}
179             if (plyr_[_pID].level == 2) {if (plyr_[i].level == 2 && plyr_[i].commanderID == _pID) {totalCommander++;}
180                 if (plyr_[i].level == 1 && plyr_[i].commanderID == _pID) {totalSoldier++;}}}
181         uint currDayPerf = plyrCurrDayPerformance_[_pID].value;
182         if (isNewDay(_pID)) {currDayPerf = 0;}
183         return (totalCaptain, totalCommander, totalSoldier, currDayPerf, plyr_[_pID].achievement);}
184 
185     function getVaults(address _addr) public view
186     returns (uint, uint, uint, uint){uint256 _pID = pIDxAddr_[_addr];
187         if (_pID == 0) return (0, 0, 0, 1 ether);
188         (uint enaOneRebate, uint totalOneRebate) = calRebateAll(rebateOne_[_pID]);
189         (uint enaTwoRebate, uint totalTwoRebate) = calRebateAll(rebateTwo_[_pID]);
190         return (plyr_[_pID].win, plyr_[_pID].affVault, (plyr_[_pID].enableVault).add(enaOneRebate).add(enaTwoRebate), totalOneRebate.add(totalTwoRebate).sub(enaOneRebate).sub(enaTwoRebate));}
191 
192     function withdraw() public isActivated() isHuman() {uint256 _pID = pIDxAddr_[msg.sender];
193         uint enaOneRebate = calRebateUpdate(rebateOne_[_pID]);
194         uint enaTwoRebate = calRebateUpdate(rebateTwo_[_pID]);
195         uint _earning = (plyr_[_pID].enableVault).add(enaOneRebate).add(enaTwoRebate).add(plyr_[_pID].affVault).add(plyr_[_pID].win);
196         if (_earning > 0) {(plyr_[_pID].addr).transfer(_earning);
197             plyr_[_pID].enableVault = 0;
198             plyr_[_pID].affVault = 0;
199             plyr_[_pID].win = 0;}
200         emit onWithdraw(_pID, plyr_[_pID].addr, plyr_[_pID].name, _earning, now);}
201 
202     function reload(uint _eth) public isActivated() isHuman() {uint256 _pID = pIDxAddr_[msg.sender];
203         uint enaOneRebate = calRebateUpdate(rebateOne_[_pID]);
204         uint enaTwoRebate = calRebateUpdate(rebateTwo_[_pID]);
205         plyr_[_pID].enableVault = (plyr_[_pID].enableVault).add(enaOneRebate).add(enaTwoRebate);
206         require(((plyr_[_pID].enableVault).add(plyr_[_pID].affVault).add(plyr_[_pID].win)) >= _eth, "your balance not enough");
207         if (plyr_[_pID].enableVault >= _eth) {plyr_[_pID].enableVault = (plyr_[_pID].enableVault).sub(_eth);}
208         else if ((plyr_[_pID].enableVault).add(plyr_[_pID].affVault) >= _eth) {plyr_[_pID].affVault = (plyr_[_pID].enableVault).add(plyr_[_pID].affVault).sub(_eth);
209             plyr_[_pID].enableVault = 0;}
210         else {plyr_[_pID].win = (plyr_[_pID].enableVault).add(plyr_[_pID].affVault).add(plyr_[_pID].win).sub(_eth);
211             plyr_[_pID].affVault = 0;
212             plyr_[_pID].enableVault = 0;}
213         EventReturns memory _eventData_;
214         _eventData_.playerID = _pID;
215         _eventData_.playerAddress = msg.sender;
216         _eventData_.affiliateID = plyr_[_pID].laffID;
217         _eventData_.commanderID = plyr_[_pID].commanderID;
218         _eventData_.captainID = plyr_[_pID].captainID;
219         _eventData_.ethIn = _eth;
220         buycore(_pID, _eventData_, false, _eth);}
221 
222     function calRebateUpdate(Performance[]storage _ps) private returns (uint){uint _now = now;
223         uint totalEna;
224         for (uint i = 0; i < _ps.length; i++) {if (_ps[i].end > _ps[i].start) {if (_now > _ps[i].end) _now = _ps[i].end;
225             uint _one = (_now - _ps[i].start) / rebatePeriod_;
226             totalEna = totalEna.add(_one.mul((_ps[i].value).mul(_ps[i].fenzi) / _ps[i].fenmu));
227             if (_now >= _ps[i].end) {_ps[i].end = 0;}
228             else {_ps[i].start = _ps[i].start + (_one * rebatePeriod_);}}}
229         pot_ = pot_.sub(totalEna);
230         return (totalEna);}
231 
232     function calRebateAll(Performance[]memory _ps) private view returns (uint, uint){uint _now = now;
233         uint totalEna;
234         uint total;
235         for (uint i = 0; i < _ps.length; i++) {if (_ps[i].end > _ps[i].start) {if (_now > _ps[i].end) _now = _ps[i].end;
236             uint _one = (_now - _ps[i].start) / rebatePeriod_;
237             totalEna = totalEna.add(_one.mul((_ps[i].value).mul(_ps[i].fenzi) / _ps[i].fenmu));
238             uint _td = (_ps[i].end - _ps[i].start) / rebatePeriod_;
239             total = total.add(_td.mul((_ps[i].value).mul(_ps[i].fenzi) / _ps[i].fenmu));}}
240         return (totalEna, total);}
241 
242     function airdrop()
243     private
244     view
245     returns (uint256)
246     {uint256 seed = uint256(keccak256(abi.encodePacked((block.timestamp).add
247     (block.difficulty).add
248     ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
249     (block.gaslimit).add
250     ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
251         (block.number))));
252         return seed % pID_ + 1;}
253 
254     function isNewWeek()
255     public
256     view
257     returns (bool)
258     {if ((now - gameStart - (openWeek * oneWeek_)) > oneWeek_) {return true;} else {return false;}}
259 
260     function endWeek() private {uint256 win = airDropPot_ / 2;
261         uint256 plyId = airdrop();
262         plyr_[plyId].win = (plyr_[plyId].win).add(win);
263         airDropPot_ = airDropPot_.sub(win);
264         openWeek++;
265         emit airePotOpen
266         (plyId, plyr_[plyId].addr, plyr_[plyId].name, win, now);}
267 
268     function airDropTime() public view returns (uint256){return (gameStart + (openWeek + 1) * oneWeek_);}
269 
270     function levelUp(uint leveType)
271     public
272     isActivated()
273     isHuman()
274     payable
275     {uint256 value = msg.value;
276         uint256 pId = pIDxAddr_[msg.sender];
277         require(leveType == 1 || leveType == 2, "leveType error");
278         if (leveType == 1) {require(plyr_[pId].level == 1, "your must be a soldier");
279             require(value >= leaderPrice, "your must paid enough money");
280             require(plyr_[pId].recCount >= upCommanderRec_, "you need more soldiers");
281             plyr_[pId].level = 2;}
282         else {require(plyr_[pId].level == 2, "your must be a commander");
283             require(value >= captionPrice, "your must paid enough money");
284             require(plyr_[pId].recCount >= upCaptainRec_, "you need more soldiers");
285             plyr_[pId].level = 3;}
286         distributeLevelUp(value);
287         emit onLevelUp
288         (pId, msg.sender, plyr_[pId].name, now);}
289 
290     function distributeLevelUp(uint256 eth)
291     private
292     {
293         uint256 tempEth = eth / 100;
294         devWallet.transfer(tempEth.mul(2));
295         bossHeWallet.transfer(tempEth.mul(20));
296         middleWallet.transfer(tempEth.mul(3));
297         agentWallet.transfer(eth.sub(tempEth.mul(25)));
298     }
299 
300     function activate()
301     public
302     onlyDevs()
303     {require(activated_ == false, "game already activated");
304         activated_ = true;
305         gameStart = now;}
306 
307     function registerXaddr(uint256 affCode, string _nameString)
308     private
309     {bytes32 _name = NameFilter.nameFilter(_nameString);
310         address _addr = msg.sender;
311         uint256 _pID = pIDxAddr_[_addr];
312         plyr_[_pID].name = _name;
313         plyr_[_pID].level = 1;
314         if (affCode >= 4 && affCode <= pID_ && _pID != affCode) {plyr_[_pID].laffID = affCode;
315             if (plyr_[affCode].level == 1) {plyr_[_pID].commanderID = plyr_[affCode].commanderID;
316                 plyr_[_pID].captainID = plyr_[affCode].captainID;}
317             if (plyr_[affCode].level == 2) {plyr_[_pID].commanderID = affCode;
318                 plyr_[_pID].captainID = plyr_[affCode].captainID;}
319             if (plyr_[affCode].level == 3) {plyr_[_pID].commanderID = affCode;
320                 plyr_[_pID].captainID = affCode;}} else {plyr_[_pID].laffID = 1;
321             plyr_[_pID].commanderID = 2;
322             plyr_[_pID].captainID = 3;}
323         plyr_[plyr_[_pID].laffID].recCount += 1;
324         emit onNewPlayer(_pID, _addr, _name, affCode, plyr_[_pID].commanderID, plyr_[_pID].captainID, now);}
325 
326     function buyXaddr(uint256 _affCode, string _name)
327     public
328     isActivated()
329     isHuman()
330     payable
331     {EventReturns memory _eventData_;
332         uint256 _pID = pIDxAddr_[msg.sender];
333         bool isNewPlyr = false;
334         if (_pID == 0)
335         {require(msg.value >= unLockPrice, "you must pay 1 eth to unlock your account");
336             pID_++;
337             pIDxAddr_[msg.sender] = pID_;
338             plyr_[pID_].addr = msg.sender;
339             _pID = pID_;
340             registerXaddr(_affCode, _name);
341             isNewPlyr = true;}
342         _eventData_.playerID = _pID;
343         _eventData_.playerAddress = msg.sender;
344         _eventData_.affiliateID = plyr_[_pID].laffID;
345         _eventData_.commanderID = plyr_[_pID].commanderID;
346         _eventData_.captainID = plyr_[_pID].captainID;
347         _eventData_.ethIn = msg.value;
348         buycore(_pID, _eventData_, isNewPlyr, msg.value);}
349 
350     function buycore(uint256 _pID, EventReturns memory _eventData_, bool isNewPlyr, uint _eth)
351     private
352     {uint256 _keys = _eth.mul(1000000000000000000) / price;
353         plyr_[_pID].keys = (plyr_[_pID].keys).add(_keys);
354         totalEth_ = _eth.add(totalEth_);
355         pot_ = pot_.add(_eth.mul(potRate) / 100);
356         airDropPot_ = (distributeAirepot(_eth)).add(airDropPot_);
357         uint256 residual = distribute(_pID, _eth, isNewPlyr);
358         uint256 _com = _eth.sub(_eth.mul(90) / 100).add(residual);
359         comWallet.transfer(_com);
360         if (isNewWeek()) {endWeek();}
361         _eventData_.keysBought = _keys;
362         _eventData_.airAmount = airDropPot_;
363         _eventData_.potAmount = pot_;
364         emit onEndTx(_eventData_.playerAddress, _eventData_.playerID, _eventData_.ethIn, _eventData_.keysBought, _eventData_.affiliateID, _eventData_.commanderID, _eventData_.captainID, _eventData_.airAmount, _eventData_.potAmount, now);}
365 
366     function distributeAirepot(uint256 eth)
367     private returns (uint256 airpot)
368     {airpot = eth.mul(airDropRate) / 100;
369         devWallet.transfer(airpot);
370         middleWallet.transfer(airpot);
371         bossHeWallet.transfer(airpot.mul(2));}
372 
373     function distribute(uint256 _pID, uint256 _eth, bool isNewPlyr)
374     private returns (uint256 residual)
375     {uint calDays = 1 * rebateTwoFenmu_ / rebateTwoFenzi_ * rebatePeriod_;
376         if (isNewPlyr) {rebateTwo_[_pID].push(Performance(_eth.mul(5) + 1 ether, now, now + calDays, rebateTwoFenzi_, rebateTwoFenmu_));} else {rebateTwo_[_pID].push(Performance(_eth.mul(5), now, now + calDays, rebateTwoFenzi_, rebateTwoFenmu_));}
377         uint256 _affFee1 = _eth.mul(firstLevel) / 100;
378         uint256 _affFee2 = _eth.mul(secondLevel) / 100;
379         uint256 _affID = plyr_[_pID].laffID;
380         uint256 _commanderID = plyr_[_pID].commanderID;
381         uint256 _captainID = plyr_[_pID].captainID;
382         plyr_[_affID].affVault = _affFee1.add(plyr_[_affID].affVault);
383         if (_affID == 1) {residual = residual.add(_affFee2);} else {plyr_[plyr_[_affID].laffID].affVault = _affFee2.add(plyr_[plyr_[_affID].laffID].affVault);}
384         calDays = 1 * rebateOneFenmu_ / rebateOneFenzi_ * rebatePeriod_;
385         rebateOne_[_commanderID].push(Performance(_eth, now, now + calDays, rebateOneFenzi_, rebateOneFenmu_));
386         if (_commanderID == 2) {residual = residual.add((_eth.mul(comm2commRate) / 100));} else {plyr_[plyr_[_commanderID].commanderID].enableVault = (_eth.mul(comm2commRate) / 100).add(plyr_[plyr_[_commanderID].commanderID].enableVault);}
387         plyr_[_captainID].enableVault = (_eth.mul(captainRate) / 100).add(plyr_[_captainID].enableVault);
388         if (_captainID == 3) {residual = residual.add((_eth.mul(cap2capRate) / 100));} else {plyr_[plyr_[_captainID].captainID].enableVault = (_eth.mul(cap2capRate) / 100).add(plyr_[plyr_[_captainID].captainID].enableVault);}
389         uint _now = now;
390         if (isNewDay(_affID)) {plyrCurrDayPerformance_[_pID].value = 0;
391             plyrCurrDayPerformance_[_pID].start = _now;}
392         plyrCurrDayPerformance_[_affID].value = _eth.add(plyrCurrDayPerformance_[_affID].value);
393         plyr_[_affID].achievement = _eth.add(plyr_[_affID].achievement);
394         if (isNewDay(_commanderID)) {plyrCurrDayPerformance_[_commanderID].value = 0;
395             plyrCurrDayPerformance_[_commanderID].start = _now;}
396         plyrCurrDayPerformance_[_commanderID].value = _eth.add(plyrCurrDayPerformance_[_commanderID].value);
397         plyr_[_commanderID].achievement = _eth.add(plyr_[_commanderID].achievement);
398         if (isNewDay(_captainID)) {plyrCurrDayPerformance_[_captainID].value = 0;
399             plyrCurrDayPerformance_[_captainID].start = _now;}
400         plyrCurrDayPerformance_[_captainID].value = _eth.add(plyrCurrDayPerformance_[_captainID].value);
401         plyr_[_captainID].achievement = _eth.add(plyr_[_captainID].achievement);}
402 
403     function isNewDay(uint pID)
404     private
405     view
406     returns (bool)
407     {if ((now / oneDay_) != plyrCurrDayPerformance_[pID].start / oneDay_) {return true;} else {return false;}}
408     modifier isActivated(){require(activated_ == true, "its not ready yet.  check ?eta in discord");
409         _;}
410     modifier onlyDevs(){require(msg.sender == 0x24ECF2efC032FcD6244006036e6B05031c4D44ef, "only team just can activate");
411         _;}
412     modifier isHuman(){address _addr = msg.sender;
413         require(_addr == tx.origin);
414         uint256 _codeLength;
415         assembly{_codeLength := extcodesize(_addr)}
416         require(_codeLength == 0, "sorry humans only");
417         _;}
418     function recharge() public isActivated() onlyDevs() payable {pot_ = pot_.add(msg.value);}
419 
420     function potWithdraw(address _addr, uint _eth) public isActivated() onlyDevs() {require(pot_ >= _eth, "contract balance not enough");
421         pot_ = pot_.sub(_eth);
422         _addr.transfer(_eth);}
423 
424     function airWithdraw(address _addr, uint _eth) public isActivated() onlyDevs() {require(airDropPot_ >= _eth, "contract balance not enough");
425         airDropPot_ = airDropPot_.sub(_eth);
426         _addr.transfer(_eth);}
427 
428     function setrebateOneRate(uint16 fenzi, uint16 fenmu) public isActivated() onlyDevs() {require(fenzi >= 1 && fenmu >= 1, "param error");
429         rebateOneFenzi_ = fenzi;
430         rebateOneFenmu_ = fenmu;}
431 
432     function setrebateTwoRate(uint16 fenzi, uint16 fenmu) public isActivated() onlyDevs() {require(fenzi >= 1 && fenmu >= 1, "param error");
433         rebateTwoFenzi_ = fenzi;
434         rebateTwoFenmu_ = fenmu;}}