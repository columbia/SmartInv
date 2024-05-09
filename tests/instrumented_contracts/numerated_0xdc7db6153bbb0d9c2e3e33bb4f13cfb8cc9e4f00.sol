1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 interface CitizenInterface {
5     function addWinIncome(address _citizen, uint256 _value) external;
6     function getRef(address _address) external view returns(address);
7     function isCitizen(address _address) external view returns(bool);
8     
9     function addGameEthSpendWin(address _citizen, uint256 _value)  external;
10     function addGameEthSpendLose(address _citizen, uint256 _value) external;
11     function addGameTokenSpend(address _citizen, uint256 _value) external;
12 }
13 
14 interface DAAInterface {
15     function pushDividend() external payable;
16     function payOut(address _winner, uint256 _unit, uint256 _value, uint256 _valuewin) external;
17     function pushGameRefIncome(address _sender,uint256 _unit, uint256 _value) external payable;
18     function citizenUseDeposit(address _citizen, uint _value) external;
19 }
20 
21 library SafeMath {
22     int256 constant private INT256_MIN = -2**255;
23 
24     /**
25     * @dev Multiplies two unsigned integers, reverts on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41     /**
42     * @dev Multiplies two signed integers, reverts on overflow.
43     */
44     function mul(int256 a, int256 b) internal pure returns (int256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
53 
54         int256 c = a * b;
55         require(c / a == b);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Solidity only automatically asserts when dividing by 0
65         require(b > 0);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
74     */
75     function div(int256 a, int256 b) internal pure returns (int256) {
76         require(b != 0); // Solidity only automatically asserts when dividing by 0
77         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
78 
79         int256 c = a / b;
80 
81         return c;
82     }
83 
84     /**
85     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86     */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b <= a);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95     * @dev Subtracts two signed integers, reverts on overflow.
96     */
97     function sub(int256 a, int256 b) internal pure returns (int256) {
98         int256 c = a - b;
99         require((b >= 0 && c <= a) || (b < 0 && c > a));
100 
101         return c;
102     }
103 
104     /**
105     * @dev Adds two unsigned integers, reverts on overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a);
110 
111         return c;
112     }
113 
114     /**
115     * @dev Adds two signed integers, reverts on overflow.
116     */
117     function add(int256 a, int256 b) internal pure returns (int256) {
118         int256 c = a + b;
119         require((b >= 0 && c >= a) || (b < 0 && c < a));
120 
121         return c;
122     }
123 
124     /**
125     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
126     * reverts when dividing by zero.
127     */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0);
130         return a % b;
131     }
132 }
133 
134 library Helper {
135     using SafeMath for uint256;
136     
137         
138     function bytes32ToUint(bytes32 n) 
139         public
140         pure
141         returns (uint256) 
142     {
143         return uint256(n);
144     }
145     
146     function stringToBytes32(string memory source) 
147         public
148         pure
149         returns (bytes32 result) 
150     {
151         bytes memory tempEmptyStringTest = bytes(source);
152         if (tempEmptyStringTest.length == 0) {
153             return 0x0;
154         }
155 
156         assembly {
157             result := mload(add(source, 32))
158         }
159     }
160     
161     function stringToUint(string memory source) 
162         public
163         pure
164         returns (uint256)
165     {
166         return bytes32ToUint(stringToBytes32(source));
167     }
168     
169     function validUsername(string _username)
170         public
171         pure
172         returns(bool)
173     {
174         uint256 len = bytes(_username).length;
175         // Im Raum [4, 18]
176         if ((len < 4) || (len > 18)) return false;
177         // Letzte Char != ' '
178         if (bytes(_username)[len-1] == 32) return false;
179         // Erste Char != '0'
180         return uint256(bytes(_username)[0]) != 48;
181     }   
182     
183     function getRandom(uint256 _seed, uint256 _range)
184         public
185         pure
186         returns(uint256)
187     {
188         if (_range == 0) return _seed;
189         return (_seed % _range);
190     }
191 
192 }
193 
194 contract DiceGame {
195     using SafeMath for uint256;
196     
197     modifier registered(){
198         require(citizenContract.isCitizen(msg.sender), "must be a citizen");
199         _;
200     }
201     
202      modifier onlyAdmin() {
203         require(msg.sender == devTeam1, "admin required");
204         _;
205     }
206     
207     event BetAGame(
208         uint256 totalPayout,
209         uint256 histoyLen,
210         address indexed player,
211         uint256 prediction,
212         bool prediction_type,
213         uint256 result,
214         bool isHighRoller,
215         bool isRareWins,
216         bool isWin,
217         uint256 amount,
218         uint256 payout,
219         uint256 unit,
220         uint256 creationDate
221     );
222     
223     uint8 public decimals = 10;
224     uint256 public unitRate;
225     
226     uint256 constant public MULTIPLIES = 985;
227     uint256 public HIGHROLLER = 8 ether;
228     uint256 public HIGHROLLERTOKEN = 8;
229     uint256 public MIN=0.006 ether;
230     uint256 public MAX=10 ether;
231     uint256 public MIN_TOKEN=1;
232     uint256 public MAX_TOKEN=10;
233     address devTeam1;
234     uint256 privateKey;
235     
236     struct History{
237         address player;
238         uint256 prediction; 
239         bool prediction_type;
240         uint256 result;
241         bool isHighRoller;
242         bool isRareWins;
243         bool isWin;
244         uint256 amount;
245         uint256 payout;
246         uint256 unit;
247         uint256 creationDate;
248     }
249     
250     History[] public gameHistory;
251     mapping(address => History[]) public myHistory;
252     History[] public isHighRollerHistory;
253     History[] public isRareWinsHistory;
254     uint256 public totalPayout;
255     
256     mapping(address=>uint256) public citizenSpendEth;
257     mapping(address=>uint256) public citizenSpendToken;
258     mapping(address=>uint256) public citizenSeed;
259     
260     address[11] public mostTotalSpender;
261     mapping (address => uint256) public mostTotalSpenderId;
262     
263     CitizenInterface public citizenContract;
264     DAAInterface public DAAContract;
265     
266     constructor (address[3] _contract, string _key)
267         public
268     {
269         unitRate = 10 ** uint256(decimals);
270         HIGHROLLERTOKEN = HIGHROLLERTOKEN.mul(unitRate);
271         MIN_TOKEN = MIN_TOKEN.mul(unitRate);
272         MAX_TOKEN = MAX_TOKEN.mul(unitRate);
273         
274         citizenContract = CitizenInterface(_contract[1]);
275         DAAContract = DAAInterface(_contract[0]);
276         devTeam1 = _contract[2];
277         privateKey = Helper.stringToUint(_key);
278     }
279     
280     function setSeed(string _key) public registered() {
281         citizenSeed[msg.sender] =  Helper.stringToUint(_key);
282     }
283     
284     function getMyHistoryLength(address _sender) public view returns(uint256){
285         return myHistory[_sender].length;
286     }
287     
288     function getGameHistoryLength() public view returns(uint256){
289         return gameHistory.length;
290     }
291     
292     function getIsHighRollerHistoryLength() public view returns(uint256){
293         return isHighRollerHistory.length;
294     }
295     
296     function getIsRareWinsHistoryLength() public view returns(uint256){
297         return isRareWinsHistory.length;
298     }
299     
300     function sortMostSpend(address _citizen) public payable {
301         uint256 citizen_spender = citizenSpendEth[_citizen];
302         uint256 i=1;
303         while (i<11) {
304             if (mostTotalSpender[i]==0x0||(mostTotalSpender[i]!=0x0&&citizenSpendEth[mostTotalSpender[i]]<citizen_spender)){
305                 if (mostTotalSpenderId[_citizen]!=0&&mostTotalSpenderId[_citizen]<i){
306                     break;
307                 }
308                 if (mostTotalSpenderId[_citizen]!=0){
309                     mostTotalSpender[mostTotalSpenderId[_citizen]]=0x0;
310                 }
311                 address temp1 = mostTotalSpender[i];
312                 address temp2;
313                 uint256 j=i+1;
314                 while (j<11&&temp1!=0x0){
315                     temp2 = mostTotalSpender[j];
316                     mostTotalSpender[j]=temp1;
317                     mostTotalSpenderId[temp1]=j;
318                     temp1 = temp2;
319                     j++;
320                 }
321                 mostTotalSpender[i]=_citizen;
322                 mostTotalSpenderId[_citizen]=i;
323                 break;
324             }
325             i++;
326         }
327     }
328     
329     function addToHistory(address _sender,uint256 _prediction,bool _prediction_type, uint256 _result,bool _isWin, uint256 _amount, uint256 _payout, uint256 _unit) private returns(History){
330         History memory _history;
331         _history.player = _sender;
332         _history.prediction = _prediction;
333         _history.prediction_type = _prediction_type;
334         _history.result = _result;
335         _history.isWin = _isWin;
336         _history.amount = _amount;
337         _history.payout = _payout;
338         _history.unit = _unit;
339         _history.creationDate = now;
340         
341         uint256 tempRareWin;
342         if (_prediction_type){
343             tempRareWin = _prediction;
344         }else{
345             tempRareWin = 99-_prediction;
346         }
347         if (_isWin==true&&tempRareWin<10) _history.isRareWins = true;
348         if ((_unit==0&&_amount>HIGHROLLER)||(_unit==1&&_amount>HIGHROLLERTOKEN)) _history.isHighRoller = true;
349         
350         gameHistory.push(_history);
351         myHistory[_sender].push(_history);
352         if (_history.isHighRoller) isHighRollerHistory.push(_history);
353         if (_history.isHighRoller) isRareWinsHistory.push(_history);
354         emit BetAGame(totalPayout, gameHistory.length, _sender, _prediction, _prediction_type, _result, _history.isHighRoller, _history.isRareWins, _isWin, _amount, _payout, _unit, _history.creationDate);
355         return _history;
356     }
357     
358     function betByEth(bool _method,uint256 _prediction) public payable registered() {
359         History memory _history;
360         address _sender = msg.sender;
361         uint256 _value = msg.value;
362         require(_value>=MIN&&_value<=MAX);
363         
364         // _method = True is roll under
365         // _method = False is roll over
366         uint256 _seed = getSeed();
367         uint256 _winnumber = Helper.getRandom(_seed, 100);
368         uint256 _valueForRef = _value*15/1000;
369         uint256 _win_value;
370         if(_method){
371             require(_prediction>0&&_prediction<96);
372             citizenSpendEth[_sender] = _value.add(citizenSpendEth[_sender]);
373             DAAContract.pushDividend.value(_value)();
374             DAAContract.pushGameRefIncome(_sender,1,_valueForRef);
375             if (_winnumber<_prediction){
376                 _win_value = _value.mul(MULTIPLIES).div(10).div(_prediction);
377                 // citizenContract.addGametEthSpendWin(_sender,_value);
378                 DAAContract.payOut(_sender,0,_win_value,_value);
379                 totalPayout = totalPayout.add(_win_value);
380                 _history = addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,0);
381             } else {
382                 citizenContract.addGameEthSpendLose(_sender,_value);
383                 _history = addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,0);
384             }
385             
386         }else{
387             require(_prediction>3&&_prediction<99);
388             citizenSpendEth[_sender] = _value.add(citizenSpendEth[_sender]);
389             DAAContract.pushDividend.value(_value)();
390             DAAContract.pushGameRefIncome(_sender,1,_valueForRef);
391             if (_winnumber>_prediction){
392                 _win_value = _value.mul(MULTIPLIES).div(10).div(99-_prediction);
393                 // citizenContract.addGametEthSpendWin(_sender,_value);
394                 DAAContract.payOut(_sender,0,_win_value,_value);
395                 totalPayout = totalPayout.add(_win_value);
396                 _history = addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,0);
397             } else {
398                 citizenContract.addGameEthSpendLose(_sender,_value);
399                 _history = addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,0);
400             }
401         }
402         sortMostSpend(_sender);
403     } 
404     
405     function betByToken(bool _method,uint256 _prediction, uint256 _value) public registered() {
406         History memory _history;
407         address _sender = msg.sender;
408         DAAContract.citizenUseDeposit(_sender, _value);
409         require(_value>=MIN_TOKEN&&_value<=MAX_TOKEN);
410         
411         // _method = True is roll under
412         // _method = False is roll over
413         uint256 _seed = getSeed();
414         uint256 _winnumber = Helper.getRandom(_seed, 100);
415         uint256 _valueForRef = _value*15/1000;
416         uint256 _win_value;
417         if(_method){
418             require(_prediction>0&&_prediction<96);
419             citizenSpendToken[_sender] = _value.add(citizenSpendToken[_sender]);
420             citizenContract.addGameTokenSpend(_sender,_value);
421             DAAContract.pushGameRefIncome(_sender,0,_valueForRef);
422             if (_winnumber<_prediction){
423                 _win_value = _value.mul(MULTIPLIES).div(10).div(_prediction);
424                 DAAContract.payOut(_sender,1,_win_value,_value);
425                 _history = addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,1);
426             } else {
427                 _history = addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,1);
428             }
429             
430         }else{
431             require(_prediction>3&&_prediction<99);
432             citizenSpendToken[_sender] = _value.add(citizenSpendToken[_sender]);
433             citizenContract.addGameTokenSpend(_sender,_value);
434             DAAContract.pushGameRefIncome(_sender,0,_valueForRef);
435             if (_winnumber>_prediction){
436                 _win_value = _value.mul(MULTIPLIES).div(10).div(99-_prediction);
437                 DAAContract.payOut(_sender,1,_win_value,_value);
438                 _history = addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,1);
439             } else {
440                 _history = addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,1);
441             }
442         }
443     }
444     
445     function updateHIGHROLLER(uint256 _value) onlyAdmin() public{
446         HIGHROLLER = _value;
447     }
448     
449     function updateHIGHROLLERTOKEN(uint256 _value) onlyAdmin() public{
450         HIGHROLLERTOKEN = _value;
451     }
452     
453     function updateMinEth(uint256 _value) onlyAdmin() public{
454         MIN = _value;
455     }
456     
457     function updateMaxEth(uint256 _value) onlyAdmin() public {
458         MAX = _value;
459     }
460     
461     function updateMinToken(uint256 _value) onlyAdmin() public{
462         MIN_TOKEN = _value;
463     }
464     
465     function updateMaxToken(uint256 _value) onlyAdmin() public{
466         MAX_TOKEN = _value;
467     }
468     
469     function getSeed()
470         public
471         view
472         returns (uint64)
473     {
474         if (citizenSeed[msg.sender]==0){
475             return uint64(keccak256(block.timestamp, keccak256(block.difficulty, msg.sender, privateKey)));
476         }
477         return uint64(keccak256(block.timestamp, keccak256(block.difficulty, msg.sender, citizenSeed[msg.sender])));
478     }
479     
480     
481 }