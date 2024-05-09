1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8 
9     /**
10     * @dev Subtracts two numbers, reverts on overflow.
11     */
12     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
13         assert(y <= x);
14         uint256 z = x - y;
15         return z;
16     }
17 
18     /**
19     * @dev Adds two numbers, reverts on overflow.
20     */
21     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
22         uint256 z = x + y;
23         assert(z >= x);
24         return z;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, reverts on division by zero.
29     */
30     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
31         uint256 z = x / y;
32         return z;
33     }
34 
35     /**
36     * @dev Multiplies two numbers, reverts on overflow.
37     */
38     function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {
39         if (x == 0) {
40             return 0;
41         }
42 
43         uint256 z = x * y;
44         assert(z / x == y);
45         return z;
46     }
47 
48     /**
49     * @dev Returns the integer percentage of the number.
50     */
51     function safePerc(uint256 x, uint256 y) internal pure returns (uint256) {
52         if (x == 0) {
53             return 0;
54         }
55 
56         uint256 z = x * y;
57         assert(z / x == y);
58         z = z / 10000; // percent to hundredths
59         return z;
60     }
61 
62     /**
63     * @dev Returns the minimum value of two numbers.
64     */
65     function min(uint256 x, uint256 y) internal pure returns (uint256) {
66         uint256 z = x <= y ? x : y;
67         return z;
68     }
69 
70     /**
71     * @dev Returns the maximum value of two numbers.
72     */
73     function max(uint256 x, uint256 y) internal pure returns (uint256) {
74         uint256 z = x >= y ? x : y;
75         return z;
76     }
77 }
78 
79 
80 /**
81  * @title Ownable contract - base contract with an owner
82  */
83 contract Ownable {
84 
85     address public owner;
86     address public newOwner;
87 
88     event OwnershipTransferred(address indexed _from, address indexed _to);
89 
90     /**
91      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92      * account.
93      */
94     constructor() public {
95         owner = msg.sender;
96     }
97 
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101     modifier onlyOwner() {
102         assert(msg.sender == owner);
103         _;
104     }
105 
106     /**
107      * @dev Allows the current owner to transfer control of the contract to a newOwner.
108      * @param _newOwner The address to transfer ownership to.
109      */
110     function transferOwnership(address _newOwner) public onlyOwner {
111         assert(_newOwner != address(0));
112         newOwner = _newOwner;
113     }
114 
115     /**
116      * @dev Accept transferOwnership.
117      */
118     function acceptOwnership() public {
119         if (msg.sender == newOwner) {
120             emit OwnershipTransferred(owner, newOwner);
121             owner = newOwner;
122         }
123     }
124 }
125 
126 
127 /**
128  * @title Agent contract - base contract with an agent
129  */
130 contract Agent is Ownable {
131 
132     address public defAgent;
133 
134     mapping(address => bool) public Agents;
135 
136     event UpdatedAgent(address _agent, bool _status);
137 
138     constructor() public {
139         defAgent = msg.sender;
140         Agents[msg.sender] = true;
141     }
142 
143     modifier onlyAgent() {
144         assert(Agents[msg.sender]);
145         _;
146     }
147 
148     function updateAgent(address _agent, bool _status) public onlyOwner {
149         assert(_agent != address(0));
150         Agents[_agent] = _status;
151 
152         emit UpdatedAgent(_agent, _status);
153     }
154 }
155 
156 
157 /**
158  * @title CryptoDuel game
159  */
160 contract CryptoDuel is Agent, SafeMath {
161 
162     uint public fee = 100;            //  1% from bet
163     uint public refGroupFee = 5000;   // 50% from profit
164     uint public refUserFee = 1000;  // 10% from profit
165     uint public min = 1000000000000000;       // 0.001 ETH
166     uint public max = 1000000000000000000000;  // 1000 ETH
167 
168     uint256 public start = 0;         // Must be equal to the date of issue tokens
169     uint256 public period = 30 days;  // By default, the dividend accrual period is 30 days
170 
171     /** State
172      *
173      * - New: 0
174      * - Deleted: 1
175      * - OnGoing: 2
176      * - Closed: 3
177      */
178     enum State{New, Deleted, OnGoing, Closed}
179 
180     struct _duel {
181         address creator;
182         address responder;
183         uint bet;
184         uint blocknumber;
185         int refID;
186         State state;
187     }
188 
189     _duel[] public Duels;
190     mapping(int => address) public RefGroup;                 // RefGroup[id group] = address referrer
191     mapping(address => address) public RefAddr;              // RefAddr[address referal] = address referrer
192     mapping(uint => address) public duelWinner;              // for check who win
193 
194     mapping(uint => uint) public reward;                     // reward[period] = amount
195     mapping(address => uint) public rewardGroup;             // rewardGroup[address] = amount
196     mapping(address => uint) public rewardAddr;              // rewardAddr[address] = amount
197 
198     mapping(uint => bool) public AlreadyReward;              // AlreadyReward[period] = true/false
199 
200     event newDuel(uint duel, address indexed creator, address indexed responder, uint bet, int refID);
201     event deleteDuel(uint duel);
202     event respondDuel(uint duel, address indexed responder);
203 
204     event refundDuel(uint duel);
205     event resultDuel(uint duel, address indexed winner, uint sum);
206 
207     event changeMin(uint min);
208     event changeMax(uint max);
209 
210     event changeRefGroup(int ID, address referrer);
211     event changeRefAddr(address referal, address referrer);
212 
213     event changeFee(uint fee);
214     event changeRefGroupFee(uint refGroupFee);
215     event changeRefFee(uint refFee);
216 
217     event withdrawProfit(uint fee, address RefGroup);
218 
219     event UpdatedPeriod(uint _period);
220 
221     constructor() public {
222         RefGroup[0] = msg.sender;
223         emit changeRefGroup(0, msg.sender);
224     }
225 
226     function CreateDuel(address _responder) payable external {
227 
228         require(msg.value >= min && msg.value <= max);
229 
230         Duels.push(_duel({
231             creator : msg.sender,
232             responder : _responder,
233             bet : msg.value,
234             blocknumber : 0,
235             state : State.New,
236             refID : 0
237             }));
238 
239         emit newDuel(Duels.length - 1, msg.sender, _responder, msg.value, 0);
240     }
241 
242     function CreateDuel(address _responder, int _refID) payable external {
243 
244         require(msg.value >= min && msg.value <= max);
245         require(RefGroup[_refID] != address(0));
246 
247         Duels.push(_duel({
248             creator : msg.sender,
249             responder : _responder,
250             bet : msg.value,
251             blocknumber : 0,
252             state : State.New,
253             refID : _refID
254             }));
255 
256         emit newDuel(Duels.length - 1, msg.sender, _responder, msg.value, _refID);
257     }
258 
259     function RespondDuel(uint _duelID) payable external {
260 
261         _duel storage duel = Duels[_duelID];
262 
263         require(duel.state == State.New);
264         require(duel.bet == msg.value);
265         require(duel.responder == msg.sender || duel.responder == address(0));
266 
267         duel.state = State.OnGoing;
268         duel.responder = msg.sender;
269         duel.blocknumber = block.number;
270 
271         emit respondDuel(_duelID, msg.sender);
272     }
273 
274 
275     function DeleteDuel(uint _duelID) external {
276 
277         _duel storage duel = Duels[_duelID];
278 
279         require(duel.creator == msg.sender);
280         require(duel.state == State.New);
281 
282         duel.state = State.Deleted;
283 
284         uint duel_fee = safePerc(duel.bet, fee);
285 
286         uint256 N = 1;
287         if (block.timestamp > start) {
288             N = (block.timestamp - start) / period + 1;
289         }
290 
291         reward[N] = safeAdd(reward[N], duel_fee);
292 
293         duel.creator.transfer(safeSub(duel.bet, duel_fee));
294 
295         emit deleteDuel(_duelID);
296     }
297 
298 
299     function GetWin(uint _duelID) external {
300 
301         _duel storage duel = Duels[_duelID];
302 
303         require(duel.state == State.OnGoing);
304         require(duel.creator == msg.sender || duel.responder == msg.sender);
305         require(block.number > duel.blocknumber + 1);
306 
307         duel.state = State.Closed;
308         uint duel_fee = 0;
309 
310         uint256 N = 1;
311         if (block.timestamp > start) {
312             N = (block.timestamp - start) / period + 1;
313         }
314 
315         if (blockhash(duel.blocknumber) == 0 || (block.number - duel.blocknumber) > 256) {
316 
317             duel_fee = safePerc(duel.bet, fee);
318 
319             duel.creator.transfer(safeSub(duel.bet, duel_fee));
320             duel.responder.transfer(safeSub(duel.bet, duel_fee));
321 
322             reward[N] = safeAdd(reward[N], safeMul(2, duel_fee));
323 
324             emit refundDuel(_duelID);
325             duelWinner[_duelID] = address(0);
326 
327         } else {
328 
329             uint hash = uint(keccak256(abi.encodePacked(blockhash(duel.blocknumber + 1), duel.creator, duel.responder, duel.bet)));
330 
331             uint duel_bet_common = safeMul(2, duel.bet);
332             duel_fee = safePerc(duel_bet_common, fee);
333 
334             uint _refFee = 0;
335             uint sum = safeSub(duel_bet_common, duel_fee);
336 
337             address winner;
338 
339             if (hash % 2 == 0) {
340                 duel.creator.transfer(sum);
341                 winner = duel.creator;
342                 emit resultDuel(_duelID, duel.creator, sum);
343 
344 
345             } else {
346                 duel.responder.transfer(sum);
347                 winner = duel.responder;
348                 emit resultDuel(_duelID, duel.responder, sum);
349             }
350 
351             duelWinner[_duelID] = winner;
352             // ref level 1
353             if (RefAddr[winner] != address(0)) {
354                 _refFee = refUserFee;
355                 rewardAddr[RefAddr[winner]] = safeAdd(rewardAddr[RefAddr[winner]], safePerc(duel_fee, _refFee));
356             }
357 
358             // ref group
359             if (duel.refID != 0) {
360                 _refFee = safeSub(refGroupFee, _refFee);
361                 rewardGroup[RefGroup[duel.refID]] = safeAdd(rewardGroup[RefGroup[duel.refID]], safePerc(duel_fee, _refFee));
362                 reward[N] = safeAdd(reward[N], safeSub(duel_fee, safePerc(duel_fee, refGroupFee)));
363             } else {
364                 reward[N] = safeAdd(reward[N], safeSub(duel_fee, safePerc(duel_fee, _refFee)));
365             }
366         }
367     }
368 
369     function setMin(uint _min) external onlyOwner {
370         min = _min;
371         emit changeMin(_min);
372     }
373 
374     function setMax(uint _max) external onlyOwner {
375         max = _max;
376         emit changeMax(_max);
377     }
378 
379     function setFee(uint _fee) external onlyOwner {
380         fee = _fee;
381         emit changeFee(_fee);
382     }
383 
384     function setRefGroupFee(uint _refGroupFee) external onlyOwner {
385         refGroupFee = _refGroupFee;
386         emit changeRefGroupFee(_refGroupFee);
387     }
388 
389     function setRefUserFee(uint _refFee) external onlyOwner {
390         refUserFee = _refFee;
391         emit changeRefFee(_refFee);
392     }
393 
394 
395     function setRefGroup(int _ID, address _referrer) external onlyAgent {
396         RefGroup[_ID] = _referrer;
397         emit changeRefGroup(_ID, _referrer);
398     }
399 
400     function setRefAddr(address _referral, address _referrer) external onlyAgent {
401         RefAddr[_referral] = _referrer;
402         emit changeRefAddr(_referral, _referrer);
403     }
404 
405     function withdraw() external onlyOwner returns (bool success) {
406         uint256 N = 1;
407         if (block.timestamp > start) {
408             N = (block.timestamp - start) / period;
409         }
410 
411         if (!AlreadyReward[N]) {
412             uint amount = reward[N];
413             AlreadyReward[N] = true;
414             msg.sender.transfer(amount);
415             emit withdrawProfit(amount, msg.sender);
416             return true;
417         } else {
418             return false;
419         }
420     }
421 
422     function withdrawRefGroup() external returns (bool success) {
423         require(rewardGroup[msg.sender] > 0);
424         uint amount = rewardGroup[msg.sender];
425         rewardGroup[msg.sender] = 0;
426         msg.sender.transfer(amount);
427         emit withdrawProfit(amount, msg.sender);
428         return true;
429     }
430 
431     function withdrawRefAddr() external returns (bool success) {
432         require(rewardAddr[msg.sender] > 0);
433         uint amount = rewardAddr[msg.sender];
434         rewardAddr[msg.sender] = 0;
435         msg.sender.transfer(amount);
436         emit withdrawProfit(amount, msg.sender);
437         return true;
438     }
439 
440     function withdrawRefBoth() external returns (bool success) {
441         require(rewardAddr[msg.sender] > 0 || rewardGroup[msg.sender] > 0);
442         uint amount = safeAdd(rewardAddr[msg.sender], rewardGroup[msg.sender]);
443         rewardAddr[msg.sender] = 0;
444         rewardGroup[msg.sender] = 0;
445         msg.sender.transfer(amount);
446         emit withdrawProfit(amount, msg.sender);
447         return true;
448     }
449 
450     /**
451     * Owner can change period
452     */
453     function setPeriod(uint _period) external onlyOwner {
454         period = _period;
455         emit UpdatedPeriod(_period);
456     }
457 
458     /**
459     * Owner can change start
460     */
461     function setStart(uint _start) external onlyOwner {
462         start = _start;
463     }
464 }