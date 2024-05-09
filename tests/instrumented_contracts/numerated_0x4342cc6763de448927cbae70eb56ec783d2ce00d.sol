1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title MultiOwnable
51  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
52  * functions, this simplifies the implementation of "users permissions".
53  */
54 contract MultiOwnable {
55     address public manager; // address used to set owners
56     address[] public owners;
57     mapping(address => bool) public ownerByAddress;
58 
59     event SetManager(address manager);
60     event SetOwners(address[] owners);
61 
62     modifier onlyOwner() {
63         require(ownerByAddress[msg.sender] == true);
64         _;
65     }
66 
67     modifier onlyManager() {
68         require(msg.sender == manager);
69         _;
70     }
71 
72     /**
73      * @dev MultiOwnable constructor sets the manager
74      */
75     constructor() public {
76         manager = msg.sender;
77     }
78 
79     /**
80      * @dev Function to set owners addresses
81      */
82     function setOwners(address[] _owners) onlyManager public {
83         _setOwners(_owners);
84     }
85 
86     function _setOwners(address[] _owners) internal {
87         for(uint256 i = 0; i < owners.length; i++) {
88             ownerByAddress[owners[i]] = false;
89         }
90 
91         for(uint256 j = 0; j < _owners.length; j++) {
92             ownerByAddress[_owners[j]] = true;
93         }
94         owners = _owners;
95         emit SetOwners(_owners);
96     }
97 
98     function getOwners() public constant returns (address[]) {
99         return owners;
100     }
101 
102     function setManager(address _manager) onlyManager public {
103         manager = _manager;
104         emit SetManager(_manager);
105     }
106 }
107 
108 
109 contract WorldCup is MultiOwnable, SafeMath {
110 
111     enum Result {Unknown, HomeWin, HomeDraw, HomeLoss}
112 
113     // Data Struct
114 
115     struct Match {
116         bool created;
117 
118         // Match Info
119         string team;
120         string teamDetail;
121         int32  pointSpread;
122         uint64 startTime;
123         uint64 endTime;
124 
125         // Current Stakes
126         uint256 stakesOfWin;
127         uint256 stakesOfDraw;
128         uint256 stakesOfLoss;
129 
130         // Result
131         Result result;
132     }
133 
134     struct Prediction {
135         Result result;
136         uint256 stake;
137         bool withdraw;
138     }
139 
140     // Storage
141 
142     uint public numMatches;
143     mapping(uint => Match) public matches;
144     mapping(uint => mapping(address => Prediction)) public predictions;
145     uint256 public rate;
146 
147     // Event
148 
149     event NewMatch(uint indexed id, string team, string detail, int32 spread, uint64 start, uint64 end);
150     event MatchInfo(uint indexed id, string detail);
151     event MatchResult(uint indexed id, Result result, uint256 fee);
152     event Bet(address indexed user, uint indexed id, Result result, uint256 stake,
153         uint256 stakesOfWin, uint256 stakesOfDraw, uint256 stakesOfLoss);
154     event Withdraw(address indexed user, uint indexed id, uint256 bonus);
155 
156     modifier validId(uint _id) {
157         require(matches[_id].created == true);
158         _;
159     }
160 
161     modifier validResult(Result _result) {
162         require(_result == Result.HomeWin || _result == Result.HomeDraw || _result == Result.HomeLoss);
163         _;
164     }
165 
166     constructor() public {
167         rate = 20; // 5%
168     }
169 
170     // For Owner & Manager
171 
172     function createMatch(uint _id, string _team, string _teamDetail, int32 _pointSpread, uint64 _startTime, uint64 _endTime)
173     onlyOwner
174     public {
175 
176         require(_startTime < _endTime);
177         require(matches[_id].created == false);
178 
179         // Create new match
180         Match memory _match = Match({
181             created:true,
182             team: _team,
183             teamDetail: _teamDetail,
184             pointSpread: _pointSpread,
185             startTime: _startTime,
186             endTime: _endTime,
187             stakesOfWin: 0,
188             stakesOfDraw: 0,
189             stakesOfLoss: 0,
190             result: Result.Unknown
191             });
192 
193         // Insert into matches
194         matches[_id] = _match;
195         numMatches++;
196 
197         // Set event
198         emit NewMatch(_id, _team, _teamDetail, _pointSpread, _startTime, _endTime);
199     }
200 
201     function updateMatchInfo(uint _id, string _teamDetail, uint64 _startTime, uint64 _endTime)
202     onlyOwner
203     validId(_id)
204     public {
205 
206         // Update match info
207         if (bytes(_teamDetail).length > 0) {
208             matches[_id].teamDetail = _teamDetail;
209         }
210         if (_startTime != 0) {
211             matches[_id].startTime = _startTime;
212         }
213         if (_endTime != 0) {
214             matches[_id].endTime = _endTime;
215         }
216 
217         // Set event
218         emit MatchInfo(_id, _teamDetail);
219     }
220 
221     function announceMatchResult(uint _id, Result _result)
222     onlyManager
223     validId(_id)
224     validResult(_result)
225     public {
226 
227         // Check current result
228         require(matches[_id].result == Result.Unknown);
229 
230         // Update result
231         matches[_id].result = _result;
232 
233         // Calculate bonus and fee
234         uint256 bonus;
235         uint256 fee;
236         Match storage _match = matches[_id];
237 
238         if (_result == Result.HomeWin) {
239             bonus = add(_match.stakesOfDraw, _match.stakesOfLoss);
240             if (_match.stakesOfWin > 0) {
241                 fee = div(bonus, rate);
242             } else {
243                 fee = bonus;
244             }
245         } else if (_result == Result.HomeDraw) {
246             bonus = add(_match.stakesOfWin, _match.stakesOfLoss);
247             if (_match.stakesOfDraw > 0) {
248                 fee = div(bonus, rate);
249             } else {
250                 fee = bonus;
251             }
252         } else if (_result == Result.HomeLoss) {
253             bonus = add(_match.stakesOfWin, _match.stakesOfDraw);
254             if (_match.stakesOfLoss > 0) {
255                 fee = div(bonus, rate);
256             } else {
257                 fee = bonus;
258             }
259         }
260 
261         address thiz = address(this);
262         require(thiz.balance >= fee);
263         manager.transfer(fee);
264 
265         // Set event
266         emit MatchResult(_id, _result, fee);
267     }
268 
269     // For Player
270 
271     function bet(uint _id, Result _result)
272     validId(_id)
273     validResult(_result)
274     public
275     payable {
276 
277         // Check value
278         require(msg.value > 0);
279 
280         // Check match state
281         Match storage _match = matches[_id];
282         require(_match.result == Result.Unknown);
283         require(_match.startTime <= now);
284         require(_match.endTime >= now);
285 
286         // Update matches
287         if (_result == Result.HomeWin) {
288             _match.stakesOfWin = add(_match.stakesOfWin, msg.value);
289         } else if (_result == Result.HomeDraw) {
290             _match.stakesOfDraw = add(_match.stakesOfDraw, msg.value);
291         } else if (_result == Result.HomeLoss) {
292             _match.stakesOfLoss = add(_match.stakesOfLoss, msg.value);
293         }
294 
295         // Update predictions
296         Prediction storage _prediction = predictions[_id][msg.sender];
297         if (_prediction.result == Result.Unknown) {
298             _prediction.stake = msg.value;
299             _prediction.result = _result;
300         } else {
301             require(_prediction.result == _result);
302             _prediction.stake = add(_prediction.stake, msg.value);
303         }
304 
305         // Set event
306         emit Bet(msg.sender, _id, _result, msg.value, _match.stakesOfWin, _match.stakesOfDraw, _match.stakesOfLoss);
307     }
308 
309     function getBonus(uint _id, address addr)
310     validId(_id)
311     public
312     view
313     returns (uint256) {
314 
315         // Get match state
316         Match storage _match = matches[_id];
317         if (_match.result == Result.Unknown) {
318             return 0;
319         }
320 
321         // Get prediction state
322         Prediction storage _prediction = predictions[_id][addr];
323         if (_prediction.result == Result.Unknown) {
324             return 0;
325         }
326 
327         // Check result
328         if (_match.result != _prediction.result) {
329             return 0;
330         }
331 
332         // Calculate bonus
333         uint256 bonus = _calcBouns(_match, _prediction);
334         bonus = add(bonus, _prediction.stake);
335 
336         return bonus;
337     }
338 
339     function withdraw(uint _id)
340     validId(_id)
341     public {
342         // Check match state
343         Match storage _match = matches[_id];
344         require(_match.result != Result.Unknown);
345 
346         // Check prediction state
347         Prediction storage _prediction = predictions[_id][msg.sender];
348         require(_prediction.result != Result.Unknown);
349         require(_prediction.stake > 0);
350         require(_prediction.withdraw == false);
351         _prediction.withdraw = true;
352 
353         // Check result
354         require(_prediction.result == _match.result);
355 
356         // Calc bonus
357         uint256 bonus = _calcBouns(_match, _prediction);
358         bonus = add(bonus, _prediction.stake);
359 
360         address thiz = address(this);
361         require(thiz.balance >= bonus);
362         msg.sender.transfer(bonus);
363 
364         // Set event
365         emit Withdraw(msg.sender, _id, bonus);
366     }
367 
368     function _calcBouns(Match storage _match, Prediction storage _prediction)
369     internal
370     view
371     returns (uint256) {
372 
373         uint256 bonus;
374 
375         if (_match.result != _prediction.result) {
376             return 0;
377         }
378 
379         if (_match.result == Result.HomeWin && _match.stakesOfWin > 0) {
380             bonus = add(_match.stakesOfDraw, _match.stakesOfLoss);
381             bonus = sub(bonus, div(bonus, rate));
382             bonus = div(mul(_prediction.stake, bonus), _match.stakesOfWin);
383         } else if (_match.result == Result.HomeDraw && _match.stakesOfDraw > 0 ) {
384             bonus = add(_match.stakesOfWin, _match.stakesOfLoss);
385             bonus = sub(bonus, div(bonus, rate));
386             bonus = div(mul(_prediction.stake, bonus), _match.stakesOfDraw);
387         } else if (_match.result == Result.HomeLoss && _match.stakesOfLoss > 0) {
388             bonus = add(_match.stakesOfWin, _match.stakesOfDraw);
389             bonus = sub(bonus, div(bonus, rate));
390             bonus = div(mul(_prediction.stake, bonus), _match.stakesOfLoss);
391         }
392 
393         return bonus;
394     }
395 }