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
27 	/**
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
85   address public owner;
86   address public newOwner;
87 
88   event OwnershipTransferred(address indexed _from, address indexed _to);
89   
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   constructor() public {
95     owner = msg.sender;
96   }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     assert(msg.sender == owner);
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address _newOwner) public onlyOwner {
111     assert(_newOwner != address(0));      
112     newOwner = _newOwner;
113   }
114 
115   /**
116    * @dev Accept transferOwnership.
117    */
118   function acceptOwnership() public {
119     if (msg.sender == newOwner) {
120       emit OwnershipTransferred(owner, newOwner);
121       owner = newOwner;
122     }
123   }
124 }
125 
126 
127 /**
128  * @title Agent contract - base contract with an agent
129  */
130 contract Agent is Ownable {
131 
132   address public defAgent;
133 
134   mapping(address => bool) public Agents;  
135 
136   event UpdatedAgent(address _agent, bool _status);
137 
138   constructor() public {
139     defAgent = msg.sender;
140     Agents[msg.sender] = true;
141   }
142   
143   modifier onlyAgent() {
144     assert(Agents[msg.sender]);
145     _;
146   }
147   
148   function updateAgent(address _agent, bool _status) public onlyOwner {
149     assert(_agent != address(0));
150     Agents[_agent] = _status;
151 
152     emit UpdatedAgent(_agent, _status);
153   }  
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
164     uint public refLevel1Fee = 1000;  // 10% from profit
165     uint public refLevel2Fee = 500;   //  5% from profit
166     uint public min = 1000000000000000;       // 0.001 ETH
167     uint public max = 1000000000000000000000;  // 1000 ETH
168 
169     uint256 public start = 0;         // Must be equal to the date of issue tokens
170     uint256 public period = 30 days;  // By default, the dividend accrual period is 30 days
171 
172     /** State
173      *
174      * - New: 0
175      * - Deleted: 1
176      * - OnGoing: 2
177      * - Closed: 3
178      */
179     enum State{New, Deleted, OnGoing, Closed}
180 
181     struct _duel {
182         address creator;
183         address responder;
184         uint bet;
185         uint blocknumber;
186         int refID;
187         State state;
188     }
189 
190     _duel[] public Duels;
191     mapping(int => address) public RefGroup;                 // RefGroup[id group] = address referrer
192     mapping(address => address) public RefAddr;              // RefAddr[address referal] = address referrer
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
215     event changeRefLevel1Fee(uint refLevel1Fee);
216     event changeRefLevel2Fee(uint refLevel2Fee);    
217     
218     event withdrawProfit(uint fee, address RefGroup);
219 
220     event UpdatedPeriod(uint _period);
221 
222     constructor() public {
223         RefGroup[0] = msg.sender;
224         emit changeRefGroup(0, msg.sender);
225     }
226 
227     function CreateDuel(address _responder) payable external {
228 
229         require(msg.value >= min && msg.value <= max);        
230 
231         Duels.push(_duel({
232             creator : msg.sender,
233             responder : _responder,
234             bet : msg.value,
235             blocknumber : 0,
236             state : State.New,
237             refID : 0
238             }));
239 
240         emit newDuel(Duels.length - 1, msg.sender, _responder, msg.value, 0);
241     }
242 
243     function CreateDuel(address _responder, int _refID) payable external {
244 
245         require(msg.value >= min && msg.value <= max);
246         require(RefGroup[_refID] != address(0));
247 
248         Duels.push(_duel({
249             creator : msg.sender,
250             responder : _responder,
251             bet : msg.value,
252             blocknumber : 0,
253             state : State.New,
254             refID : _refID
255             }));
256 
257         emit newDuel(Duels.length - 1, msg.sender, _responder, msg.value, _refID);
258     }
259 
260     function RespondDuel(uint _duelID) payable external {
261 
262         _duel storage duel = Duels[_duelID];
263 
264         require(duel.state == State.New);
265         require(duel.bet == msg.value);
266         require(duel.responder == msg.sender || duel.responder == address(0));
267 
268         duel.state = State.OnGoing;
269         duel.responder = msg.sender;
270         duel.blocknumber = block.number;
271 
272         emit respondDuel(_duelID, msg.sender);
273     }
274 
275 
276     function DeleteDuel(uint _duelID) external {
277 
278         _duel storage duel = Duels[_duelID];
279 
280         require(duel.creator == msg.sender);
281         require(duel.state == State.New);
282 
283         duel.state = State.Deleted;
284 
285         uint duel_fee = safePerc(duel.bet, fee);
286 
287         uint256 N = 1;
288         if (block.timestamp > start) {
289             N = (block.timestamp - start) / period + 1;
290         }
291 
292         reward[N] = safeAdd(reward[N], duel_fee);
293 
294         duel.creator.transfer(safeSub(duel.bet, duel_fee));
295 
296         emit deleteDuel(_duelID);
297     }
298 
299 
300     function GetWin(uint _duelID) external {
301 
302         _duel storage duel = Duels[_duelID];
303 
304         require(duel.state == State.OnGoing);
305         require(duel.creator == msg.sender || duel.responder == msg.sender);
306         require(block.number > duel.blocknumber + 1);
307 
308         duel.state = State.Closed;
309         uint duel_fee = 0;
310 
311         uint256 N = 1;
312         if (block.timestamp > start) {
313             N = (block.timestamp - start) / period + 1;
314         }
315 
316         if (blockhash(duel.blocknumber) == 0 || (block.number - duel.blocknumber) > 256) {
317 
318             duel_fee = safePerc(duel.bet, fee);
319 
320             duel.creator.transfer(safeSub(duel.bet, duel_fee));
321             duel.responder.transfer(safeSub(duel.bet, duel_fee));
322 
323             reward[N] = safeAdd(reward[N], safeMul(2, duel_fee));
324 
325             emit refundDuel(_duelID);
326 
327         } else {
328 
329             uint hash = uint(keccak256(abi.encodePacked(blockhash(duel.blocknumber + 1), duel.creator, duel.responder, duel.bet)));
330 
331             uint duel_bet_common = safeMul(2, duel.bet);
332             duel_fee = safePerc(duel_bet_common, fee);
333 
334             uint refFee = 0;
335             uint sum = safeSub(duel_bet_common, duel_fee);
336 
337             address winner;
338 
339             if (hash % 2 == 0) {
340                 duel.creator.transfer(sum);
341                 winner = duel.creator;
342                 emit resultDuel(_duelID, duel.creator, sum);
343 
344             } else {                
345                 duel.responder.transfer(sum);
346                 winner = duel.responder;
347                 emit resultDuel(_duelID, duel.responder, sum);
348             }
349 
350             // ref level 1
351             if (RefAddr[winner] != address(0)) {                
352                 refFee = refLevel1Fee;
353                 rewardAddr[RefAddr[winner]] = safeAdd(rewardAddr[RefAddr[winner]], safePerc(duel_fee, refLevel1Fee));
354 
355                 // ref level 2
356                 if (RefAddr[RefAddr[winner]] != address(0)) {
357                     refFee = safeAdd(refFee, refLevel2Fee);
358                     rewardAddr[RefAddr[RefAddr[winner]]] = safeAdd(rewardAddr[RefAddr[RefAddr[winner]]], safePerc(duel_fee, refLevel2Fee));
359                 }
360             }
361             
362             // ref group
363             if (duel.refID != 0) {
364                 refFee = safeSub(refGroupFee, refFee);
365                 rewardGroup[RefGroup[duel.refID]] = safeAdd(rewardGroup[RefGroup[duel.refID]], safePerc(duel_fee, refFee));
366                 reward[N] = safeAdd(reward[N], safeSub(duel_fee, safePerc(duel_fee, refGroupFee)));
367             } else {
368                 reward[N] = safeAdd(reward[N], safeSub(duel_fee, safePerc(duel_fee, refFee)));
369             }            
370         }
371     }
372 
373     function setMin(uint _min) external onlyOwner {
374         min = _min;
375         emit changeMin(_min);
376     }
377 
378     function setMax(uint _max) external onlyOwner {
379         max = _max;
380         emit changeMax(_max);
381     }
382 
383     function setFee(uint _fee) external onlyOwner {
384         fee = _fee;
385         emit changeFee(_fee);
386     }
387 
388     function setRefGroupFee(uint _refGroupFee) external onlyOwner {
389         refGroupFee = _refGroupFee;        
390         emit changeRefGroupFee(_refGroupFee);
391     }
392     
393     function setRefLevel1Fee(uint _refLevel1Fee) external onlyOwner {
394         refLevel1Fee = _refLevel1Fee;
395         emit changeRefLevel1Fee(_refLevel1Fee);
396     }
397 
398     function setRefLevel2Fee(uint _refLevel2Fee) external onlyOwner {
399         refLevel2Fee = _refLevel2Fee;
400         emit changeRefLevel2Fee(_refLevel2Fee);
401     }
402     
403     function setRefGroup(int _ID, address _referrer) external onlyAgent {
404         RefGroup[_ID] = _referrer;
405         emit changeRefGroup(_ID, _referrer);
406     }
407     
408     function setRefAddr(address _referral, address _referrer) external onlyAgent {
409         RefAddr[_referral] = _referrer;
410         emit changeRefAddr(_referral, _referrer);
411     }
412 
413     function withdraw() external onlyOwner returns (bool success) {        
414         uint256 N = 1;
415         if (block.timestamp > start) {
416             N = (block.timestamp - start) / period;
417         }
418 
419         if (!AlreadyReward[N]) {
420             uint amount = reward[N];
421             AlreadyReward[N] = true;
422             msg.sender.transfer(amount);
423             emit withdrawProfit(amount, msg.sender);
424             return true;
425         } else {
426             return false;
427         }
428     }
429     
430     function withdrawRefGroup() external returns (bool success) {
431         require(rewardGroup[msg.sender] > 0);
432         uint amount = rewardGroup[msg.sender];
433         rewardGroup[msg.sender] = 0;
434         msg.sender.transfer(amount);
435         emit withdrawProfit(amount, msg.sender);
436         return true;
437     }
438 
439     function withdrawRefAddr() external returns (bool success) {
440         require(rewardAddr[msg.sender] > 0);
441         uint amount = rewardAddr[msg.sender];
442         rewardAddr[msg.sender] = 0;
443         msg.sender.transfer(amount);
444         emit withdrawProfit(amount, msg.sender);
445         return true;
446     }
447 
448     function withdrawRefBoth() external returns (bool success) {
449         require(rewardAddr[msg.sender] > 0 || rewardGroup[msg.sender] > 0);
450         uint amount = safeAdd(rewardAddr[msg.sender], rewardGroup[msg.sender]);
451         rewardAddr[msg.sender] = 0;
452         rewardGroup[msg.sender] = 0;
453         msg.sender.transfer(amount);
454         emit withdrawProfit(amount, msg.sender);
455         return true;
456     }
457 
458     /**
459     * Owner can change period
460     */
461     function setPeriod(uint _period) external onlyOwner {
462         period = _period;
463         emit UpdatedPeriod(_period);
464     }
465 
466     /**
467     * Owner can change start
468     */
469     function setStart(uint _start) external onlyOwner {        
470         start = _start;
471     }
472 }