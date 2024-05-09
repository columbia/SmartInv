1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13 
14     return a / b;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
21     c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 interface IDonQuixoteToken{
28     function withhold(address _user,  uint256 _amount) external returns (bool _result);
29     function transfer(address _to, uint256 _value) external;
30     function sendGameGift(address _player) external returns (bool _result);
31     function logPlaying(address _player) external returns (bool _result);
32     function balanceOf(address _user) constant  external returns (uint256 _balance);
33 
34 }
35 contract BaseGame {
36   string public gameName = "ScratchTickets";
37   uint public constant  gameType = 2005;
38   string public officialGameUrl;
39   mapping (address => uint256) public userTokenOf;
40   uint public bankerBeginTime;
41   uint public bankerEndTime;
42   address public currentBanker;
43 
44   function depositToken(uint256 _amount) public;
45   function withdrawToken(uint256 _amount) public;
46   function withdrawAllToken() public;
47   function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);
48   function canSetBanker() view public returns (bool _result);
49 }
50 
51 
52 
53 contract Base is BaseGame {
54   using SafeMath for uint256;
55   uint public createTime = now;
56   address public owner;
57   IDonQuixoteToken public DonQuixoteToken;
58 
59   function Base() public {
60   }
61 
62   modifier onlyOwner {
63     require(msg.sender == owner);
64     _;
65   }
66   function setOwner(address _newOwner)  public  onlyOwner {
67     require(_newOwner != 0x0);
68     owner = _newOwner;
69   }
70 
71   bool public globalLocked = false;
72 
73   function lock() internal {
74     require(!globalLocked);
75     globalLocked = true;
76   }
77 
78   function unLock() internal {
79     require(globalLocked);
80     globalLocked = false;
81   }
82 
83   function setLock()  public onlyOwner{
84     globalLocked = false;
85   }
86 
87   function tokenOf(address _user) view public returns(uint256 _result){
88     _result = DonQuixoteToken.balanceOf(_user);
89   }
90 
91   function depositToken(uint256 _amount) public {
92     lock();
93     _depositToken(msg.sender, _amount);
94     unLock();
95   }
96 
97   function _depositToken(address _to, uint256 _amount) internal {
98     require(_to != 0x0);
99     DonQuixoteToken.withhold(_to, _amount);
100     userTokenOf[_to] = userTokenOf[_to].add(_amount);
101   }
102 
103   function withdrawAllToken() public{
104     uint256 _amount = userTokenOf[msg.sender];
105     withdrawToken(_amount);
106   }
107 
108   function withdrawToken(uint256 _amount) public {
109     lock();
110     _withdrawToken(msg.sender, _amount);
111     unLock();
112   }
113 
114   function _withdrawToken(address _to, uint256 _amount) internal {
115     require(_to != 0x0);
116     userTokenOf[_to] = userTokenOf[_to].sub(_amount);
117     DonQuixoteToken.transfer(_to, _amount);
118   }
119 
120   uint public currentEventId = 1;
121 
122   function getEventId() internal returns(uint _result) {
123     _result = currentEventId;
124     currentEventId ++;
125   }
126 
127   function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
128     officialGameUrl = _newOfficialGameUrl;
129   }
130 }
131 
132 contract ScratchTickets is Base
133 {
134 
135   uint256 public gameMaxBetAmount = 10**9;
136   uint256 public gameMinBetAmount = 10**7;
137 
138   uint public playNo = 1;
139   uint256 public lockTime = 3600;
140   address public auction;
141 
142   uint public donGameGiftLineTime =  now + 60 days + 30 days;
143 
144   struct awardInfo{
145     uint Type;
146     uint Num;
147     uint WinMultiplePer;
148     uint KeyNumber;
149     uint AddIndex;
150   }
151 
152   mapping (uint => awardInfo) public awardInfoOf;
153 
154   struct betInfo
155   {
156     address Player;
157     uint256 BetAmount;
158     uint256 BlockNumber;
159     string RandomStr;
160     address Banker;
161     uint BetNum;
162     uint EventId;
163     bool IsReturnAward;
164   }
165   mapping (uint => betInfo) public playerBetInfoOf;
166 
167   modifier onlyAuction {
168     require(msg.sender == auction);
169     _;
170   }
171   modifier onlyBanker {
172     require(msg.sender == currentBanker);
173     require(bankerBeginTime <= now);
174     require(now < bankerEndTime);
175     _;
176   }
177 
178   function canSetBanker() public view returns (bool _result){
179     _result =  bankerEndTime <= now;
180   }
181 
182   function ScratchTickets(string _gameName,uint256 _gameMinBetAmount,uint256 _gameMaxBetAmount,address _DonQuixoteToken) public{
183     require(_DonQuixoteToken != 0x0);
184     owner = msg.sender;
185     gameName = _gameName;
186     DonQuixoteToken = IDonQuixoteToken(_DonQuixoteToken);
187     gameMinBetAmount = _gameMinBetAmount;
188     gameMaxBetAmount = _gameMaxBetAmount;
189 
190     _initAwardInfo();
191   }
192 
193   function _initAwardInfo() private {
194     awardInfo memory a1 = awardInfo({
195       Type : 1,
196       Num : 1,
197       WinMultiplePer :1000,
198       KeyNumber : 7777,
199       AddIndex : 0
200     });
201     awardInfoOf[1] = a1;
202 
203     awardInfo memory a2 = awardInfo({
204       Type : 2,
205       Num : 10,
206       WinMultiplePer :100,
207       KeyNumber : 888,
208       AddIndex : 1000
209     });
210     awardInfoOf[2] = a2;
211 
212     awardInfo memory a3 = awardInfo({
213       Type : 3,
214       Num : 100,
215       WinMultiplePer :10,
216       KeyNumber : 99,
217       AddIndex : 100
218     });
219     awardInfoOf[3] = a3;
220 
221     awardInfo memory a4 = awardInfo({
222       Type : 4,
223       Num : 1000,
224       WinMultiplePer :2,
225       KeyNumber : 6,
226       AddIndex : 10
227     });
228     awardInfoOf[4] = a4;
229 
230     awardInfo memory a5 = awardInfo({
231       Type : 5,
232       Num : 2000,
233       WinMultiplePer :1,
234       KeyNumber : 3,
235       AddIndex : 5
236     });
237     awardInfoOf[5] = a5;
238   }
239 
240   event OnSetNewBanker(address _caller, address _banker, uint _beginTime, uint _endTime, uint _code,uint _eventTime, uint eventId);
241   event OnPlay(address indexed _player, uint256 _betAmount,string _randomStr, uint _blockNumber,uint _playNo, uint _eventTime, uint eventId);
242   event OnGetAward(address indexed _player,uint indexed _awardType, uint256 _playNo,string _randomStr, uint _blockNumber,bytes32 _blockHash,uint256 _betAmount, uint _eventTime, uint eventId,uint256 _allAmount,uint256 _awardAmount);
243 
244   function setAuction(address _newAuction) public onlyOwner{
245     auction = _newAuction;
246   }
247 
248   function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result){
249     _result = false;
250     require(_banker != 0x0);
251     if(now < bankerEndTime){
252       emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 1, now, getEventId());
253       return;
254     }
255     if(_beginTime > now){
256       emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 3, now, getEventId());
257       return;
258     }
259     if(_endTime <= now){
260       emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 4, now, getEventId());
261       return;
262     }
263     currentBanker = _banker;
264     bankerBeginTime = _beginTime;
265     bankerEndTime = _endTime;
266     emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime,0, now, getEventId());
267     if(now < donGameGiftLineTime){
268       DonQuixoteToken.logPlaying(_banker);
269     }
270     _result = true;
271   }
272 
273   function tokenOf(address _user) view public returns(uint256 _result){
274     _result = DonQuixoteToken.balanceOf(_user);
275   }
276 
277   function play(string _randomStr,uint256 _betAmount) public returns(bool _result){
278     _result = _play(_randomStr, _betAmount);
279   }
280 
281   function _play(string _randomStr, uint256 _betAmount) private  returns(bool _result){
282     _result = false;
283     require(msg.sender != currentBanker);
284     require(now < bankerEndTime.sub(lockTime));
285     require(userTokenOf[currentBanker]>=gameMaxBetAmount.mul(1000));
286     require(bytes(_randomStr).length<=18);
287 
288     uint256 ba = _betAmount;
289     if (ba > gameMaxBetAmount){
290       ba = gameMaxBetAmount;
291     }
292     require(ba >= gameMinBetAmount);
293 
294     if(userTokenOf[msg.sender] < _betAmount){
295       depositToken(_betAmount.sub(userTokenOf[msg.sender]));
296     }
297     require(userTokenOf[msg.sender] >= ba);
298     betInfo memory bi = betInfo({
299       Player :  msg.sender,
300       BetAmount : ba,
301       BlockNumber : block.number,
302       RandomStr : _randomStr,
303       Banker : currentBanker,
304       BetNum : 0,
305       EventId : currentEventId,
306       IsReturnAward: false
307     });
308     playerBetInfoOf[playNo] = bi;
309     userTokenOf[msg.sender] = userTokenOf[msg.sender].sub(ba);
310     userTokenOf[currentBanker] = userTokenOf[currentBanker].add(ba);
311     emit OnPlay(msg.sender,  ba,  _randomStr, block.number,playNo,now, getEventId());
312     if(now < donGameGiftLineTime){
313       DonQuixoteToken.logPlaying(msg.sender);
314     }
315     playNo++;
316     _result = true;
317   }
318 
319   function getAward(uint _playNo) public returns(bool _result){
320     _result = _getaward(_playNo);
321   }
322 
323   function _getaward(uint _playNo) private  returns(bool _result){
324     require(_playNo<=playNo);
325     _result = false;
326     bool isAward = false;
327     betInfo storage bi = playerBetInfoOf[_playNo];
328     require(!bi.IsReturnAward);
329     require(bi.BlockNumber>block.number.sub(256));
330     bytes32 blockHash = block.blockhash(bi.BlockNumber);
331     lock();
332     uint256 randomNum = bi.EventId%1000;
333     bytes32 encrptyHash = keccak256(bi.RandomStr,bi.Player,blockHash,uint8ToString(randomNum));
334     bi.BetNum = uint(encrptyHash)%10000;
335     bi.IsReturnAward = true;
336     for (uint i = 1; i < 6; i++) {
337       awardInfo memory ai = awardInfoOf[i];
338       uint x = bi.BetNum%(10000/ai.Num);
339       if(x == ai.KeyNumber){
340         uint256 AllAmount = bi.BetAmount.mul(ai.WinMultiplePer);
341         uint256 awadrAmount = AllAmount;
342         if(AllAmount >= userTokenOf[bi.Banker]){
343           awadrAmount = userTokenOf[bi.Banker];
344         }
345         userTokenOf[bi.Banker] = userTokenOf[bi.Banker].sub(awadrAmount) ;
346         userTokenOf[bi.Player] =userTokenOf[bi.Player].add(awadrAmount);
347         isAward = true;
348         emit OnGetAward(bi.Player,i, _playNo,bi.RandomStr,bi.BlockNumber,blockHash,bi.BetAmount,now,getEventId(),AllAmount,awadrAmount);
349         break;
350       }
351     }
352     if(!isAward){
353       if(now < donGameGiftLineTime){
354         DonQuixoteToken.sendGameGift(bi.Player);
355       }
356       emit OnGetAward(bi.Player,0, _playNo,bi.RandomStr,bi.BlockNumber,blockHash,bi.BetAmount,now,getEventId(),0,0);
357     }
358     _result = true;
359     unLock();
360   }
361 
362   function _withdrawToken(address _to, uint256 _amount) internal {
363     require(_to != 0x0);
364     if(_to == currentBanker){
365       require(userTokenOf[currentBanker] > gameMaxBetAmount.mul(1000));
366       _amount = userTokenOf[currentBanker].sub(gameMaxBetAmount.mul(1000));
367     }
368     userTokenOf[_to] = userTokenOf[_to].sub(_amount);
369     DonQuixoteToken.transfer(_to, _amount);
370   }
371 
372   function uint8ToString(uint v) private pure returns (string)
373   {
374     uint maxlength = 8;
375     bytes memory reversed = new bytes(maxlength);
376     uint i = 0;
377     while (v != 0) {
378       uint remainder = v % 10;
379       v = v / 10;
380       reversed[i++] = byte(48 + remainder);
381     }
382     bytes memory s = new bytes(i);
383     for (uint j = 0; j < i; j++) {
384       s[j] = reversed[i - j - 1];
385     }
386     string memory str = string(s);
387     return str;
388   }
389 
390   function setLockTime(uint256 _lockTIme)public onlyOwner(){
391     lockTime = _lockTIme;
392   }
393 
394   function transEther() public onlyOwner()
395   {
396     msg.sender.transfer(address(this).balance);
397   }
398 
399   function () public payable {
400   }
401 }