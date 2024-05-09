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
209         uint256 indexed histoyLen,
210         address indexed player,
211         uint8 prediction,
212         bool prediction_type,
213         uint8 result,
214         bool isHighRoller,
215         bool isRareWins,
216         bool isWin,
217         uint256 amount,
218         uint256 payout,
219         uint8 unit,
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
238         uint8 prediction; 
239         bool prediction_type;
240         uint8 result;
241         bool isHighRoller;
242         bool isRareWins;
243         bool isWin;
244         uint256 amount;
245         uint256 payout;
246         uint8 unit;
247         uint256 creationDate;
248     }
249     
250     // History[] public gameHistory;
251     // mapping(address => History[]) public myHistory;
252     // History[] public isHighRollerHistory;
253     // History[] public isRareWinsHistory;
254     uint256 public totalPayout;
255     uint256 public histoyLen;
256     
257     mapping(address=>uint256) public citizenSpendEth;
258     mapping(address=>uint256) public citizenSpendToken;
259     mapping(address=>uint256) public citizenSeed;
260     
261     address[11] public mostTotalSpender;
262     mapping (address => uint256) public mostTotalSpenderId;
263     
264     CitizenInterface public citizenContract;
265     DAAInterface public DAAContract;
266     
267     constructor (address[3] _contract, string _key)
268         public
269     {
270         unitRate = 10 ** uint256(decimals);
271         HIGHROLLERTOKEN = HIGHROLLERTOKEN.mul(unitRate);
272         MIN_TOKEN = MIN_TOKEN.mul(unitRate);
273         MAX_TOKEN = MAX_TOKEN.mul(unitRate);
274         
275         citizenContract = CitizenInterface(_contract[1]);
276         DAAContract = DAAInterface(_contract[0]);
277         devTeam1 = _contract[2];
278         privateKey = Helper.stringToUint(_key);
279     }
280     
281     function setSeed(string _key) public registered() {
282         citizenSeed[msg.sender] =  Helper.stringToUint(_key);
283     }
284     
285     // function getMyHistoryLength(address _sender) public view returns(uint256){
286     //     return myHistory[_sender].length;
287     // }
288     
289     // function getGameHistoryLength() public view returns(uint256){
290     //     return gameHistory.length;
291     // }
292     
293     // function getIsHighRollerHistoryLength() public view returns(uint256){
294     //     return isHighRollerHistory.length;
295     // }
296     
297     // function getIsRareWinsHistoryLength() public view returns(uint256){
298     //     return isRareWinsHistory.length;
299     // }
300     
301     function sortMostSpend(address _citizen) public payable {
302         uint256 citizen_spender = citizenSpendEth[_citizen];
303         uint256 i=1;
304         while (i<11) {
305             if (mostTotalSpender[i]==0x0||(mostTotalSpender[i]!=0x0&&citizenSpendEth[mostTotalSpender[i]]<citizen_spender)){
306                 if (mostTotalSpenderId[_citizen]!=0&&mostTotalSpenderId[_citizen]<i){
307                     break;
308                 }
309                 if (mostTotalSpenderId[_citizen]!=0){
310                     mostTotalSpender[mostTotalSpenderId[_citizen]]=0x0;
311                 }
312                 address temp1 = mostTotalSpender[i];
313                 address temp2;
314                 uint256 j=i+1;
315                 while (j<11&&temp1!=0x0){
316                     temp2 = mostTotalSpender[j];
317                     mostTotalSpender[j]=temp1;
318                     mostTotalSpenderId[temp1]=j;
319                     temp1 = temp2;
320                     j++;
321                 }
322                 mostTotalSpender[i]=_citizen;
323                 mostTotalSpenderId[_citizen]=i;
324                 break;
325             }
326             i++;
327         }
328     }
329     
330     function addToHistory(address _sender,uint8 _prediction,bool _prediction_type, uint8 _result,bool _isWin, uint256 _amount, uint256 _payout, uint8 _unit) private{
331         History memory _history;
332         _history.player = _sender;
333         _history.prediction = _prediction;
334         _history.prediction_type = _prediction_type;
335         _history.result = _result;
336         _history.isWin = _isWin;
337         _history.amount = _amount;
338         _history.payout = _payout;
339         _history.unit = _unit;
340         _history.creationDate = now;
341         
342         uint256 tempRareWin;
343         if (_prediction_type){
344             tempRareWin = _prediction;
345         }else{
346             tempRareWin = 99-_prediction;
347         }
348         if (_isWin==true&&tempRareWin<10) _history.isRareWins = true;
349         if ((_unit==0&&_amount>HIGHROLLER)||(_unit==1&&_amount>HIGHROLLERTOKEN)) _history.isHighRoller = true;
350         
351         histoyLen = histoyLen+1;
352         // gameHistory.push(_history);
353         // myHistory[_sender].push(_history);
354         // if (_history.isHighRoller) isHighRollerHistory.push(_history);
355         // if (_history.isHighRoller) isRareWinsHistory.push(_history);
356         emit BetAGame(totalPayout, histoyLen, _sender, _prediction, _prediction_type, _result, _history.isHighRoller, _history.isRareWins, _isWin, _amount, _payout, _unit, _history.creationDate);
357     }
358     
359     function betByEth(bool _method,uint8 _prediction) public payable registered() {
360         address _sender = msg.sender;
361         uint256 _value = msg.value;
362         require(_value>=MIN&&_value<=MAX);
363         
364         // _method = True is roll under
365         // _method = False is roll over
366         uint64 _seed = getSeed();
367         uint8 _winnumber = uint8(Helper.getRandom(_seed, 100));
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
380                 addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,0);
381             } else {
382                 citizenContract.addGameEthSpendLose(_sender,_value);
383                 addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,0);
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
396                 addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,0);
397             } else {
398                 citizenContract.addGameEthSpendLose(_sender,_value);
399                 addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,0);
400             }
401         }
402         if (histoyLen%50==0){
403             sortMostSpend(_sender);
404         }
405     } 
406     
407     function betByToken(bool _method,uint8 _prediction, uint256 _value) public registered() {
408         address _sender = msg.sender;
409         DAAContract.citizenUseDeposit(_sender, _value);
410         require(_value>=MIN_TOKEN&&_value<=MAX_TOKEN);
411         
412         // _method = True is roll under
413         // _method = False is roll over
414         uint64 _seed = getSeed();
415         uint8 _winnumber = uint8(Helper.getRandom(_seed, 100));
416         uint256 _valueForRef = _value*15/1000;
417         uint256 _win_value;
418         if(_method){
419             require(_prediction>0&&_prediction<96);
420             citizenSpendToken[_sender] = _value.add(citizenSpendToken[_sender]);
421             citizenContract.addGameTokenSpend(_sender,_value);
422             DAAContract.pushGameRefIncome(_sender,0,_valueForRef);
423             if (_winnumber<_prediction){
424                 _win_value = _value.mul(MULTIPLIES).div(10).div(_prediction);
425                 DAAContract.payOut(_sender,1,_win_value,_value);
426                 addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,1);
427             } else {
428                 addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,1);
429             }
430             
431         }else{
432             require(_prediction>3&&_prediction<99);
433             citizenSpendToken[_sender] = _value.add(citizenSpendToken[_sender]);
434             citizenContract.addGameTokenSpend(_sender,_value);
435             DAAContract.pushGameRefIncome(_sender,0,_valueForRef);
436             if (_winnumber>_prediction){
437                 _win_value = _value.mul(MULTIPLIES).div(10).div(99-_prediction);
438                 DAAContract.payOut(_sender,1,_win_value,_value);
439                 addToHistory(_sender,_prediction,_method,_winnumber,true,_value,_win_value,1);
440             } else {
441                 addToHistory(_sender,_prediction,_method,_winnumber,false,_value,0,1);
442             }
443         }
444     }
445     
446     function updateHIGHROLLER(uint256 _value) onlyAdmin() public{
447         HIGHROLLER = _value;
448     }
449     
450     function updateHIGHROLLERTOKEN(uint256 _value) onlyAdmin() public{
451         HIGHROLLERTOKEN = _value;
452     }
453     
454     function updateMinEth(uint256 _value) onlyAdmin() public{
455         MIN = _value;
456     }
457     
458     function updateMaxEth(uint256 _value) onlyAdmin() public {
459         MAX = _value;
460     }
461     
462     function updateMinToken(uint256 _value) onlyAdmin() public{
463         MIN_TOKEN = _value;
464     }
465     
466     function updateMaxToken(uint256 _value) onlyAdmin() public{
467         MAX_TOKEN = _value;
468     }
469     
470     function getSeed()
471         public
472         view
473         returns (uint64)
474     {
475         if (citizenSeed[msg.sender]==0){
476             return uint64(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender, privateKey)));
477         }
478         return uint64(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, citizenSeed[msg.sender])));
479     }
480     
481     
482 }