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
162   uint public fee = 100; // 1%
163   uint public referrerFee = 5000; // 50 %
164   uint public min = 10000000000000000;       // 0.01 ETH
165   uint public max = 1000000000000000000000;  // 1000 ETH
166 
167   /** State
168    *
169    * - New: 0 
170    * - Deleted: 1
171    * - OnGoing: 2
172    * - Closed: 3
173    */
174   enum State{New, Deleted, OnGoing, Closed}
175 
176   struct _duel {
177     address creator;
178     address responder;
179     uint bet;
180     uint blocknumber;
181     int referrerID;
182     State state;
183   }
184 
185   _duel[] public Duels;
186   mapping (int => address) public Referrer; 
187   mapping (address => uint) public reward; 
188 
189   event newDuel(uint duel, address indexed creator, address indexed responder, uint bet, int referrerID);
190   event deleteDuel(uint duel);
191   event respondDuel(uint duel, address indexed responder);
192 
193   event refundDuel(uint duel);
194   event resultDuel(uint duel, address indexed winner, uint sum);
195 
196   event changeMin(uint min);
197   event changeMax(uint max);
198 
199   event changeReferrerFee(uint referrerFee);
200   event changeReferrer(int referrerID, address referrerAddress);
201   
202   event changeFee(uint fee);
203   event withdrawFee(uint fee, address referrer);
204 
205   constructor() public {
206     Referrer[0] = msg.sender;
207     emit changeReferrer(0, msg.sender);
208   }
209 
210 
211   function CreateDuel(address _responder, int _referrerID) payable external {
212     
213     require(msg.value >= min && msg.value <= max);
214     require(Referrer[_referrerID] != address(0));
215     
216     Duels.push(_duel({
217       creator: msg.sender,
218       responder: _responder,
219       bet: msg.value,
220       blocknumber: 0,
221       state: State.New,
222       referrerID: _referrerID
223     }));
224 
225     emit newDuel(Duels.length-1, msg.sender, _responder, msg.value, _referrerID);
226   } 
227 
228 
229   function RespondDuel(uint _duelID) payable external {
230 
231     _duel storage duel = Duels[_duelID];
232 
233     require(duel.state == State.New);
234     require(duel.bet == msg.value);
235     require(duel.responder == msg.sender || duel.responder == address(0));
236 
237     duel.state = State.OnGoing;
238     duel.responder = msg.sender;
239     duel.blocknumber = block.number;    
240 
241     emit respondDuel(_duelID, msg.sender);
242   }
243 
244     
245   function DeleteDuel(uint _duelID) external {
246 
247     _duel storage duel = Duels[_duelID];
248 
249     require(duel.creator == msg.sender);
250     require(duel.state == State.New);
251 
252     duel.state = State.Deleted;
253 
254     uint duel_fee = safePerc(duel.bet, fee);
255     uint duel_fee_referrer = safePerc(duel_fee, referrerFee);
256     
257     reward[Referrer[0]] = safeAdd(reward[Referrer[0]], safeSub(duel_fee, duel_fee_referrer));
258     reward[Referrer[duel.referrerID]] = safeAdd(reward[Referrer[duel.referrerID]], duel_fee_referrer);
259     
260     duel.creator.transfer(safeSub(duel.bet, duel_fee));
261 
262     emit deleteDuel(_duelID);
263   }
264 
265 
266   function GetWin(uint _duelID) external {
267 
268     _duel storage duel = Duels[_duelID];
269 
270     require(duel.state == State.OnGoing);    
271     require(duel.creator == msg.sender || duel.responder == msg.sender);
272     require(block.number > duel.blocknumber+1);
273 
274     duel.state = State.Closed;
275     uint duel_fee = 0;
276     uint duel_fee_referrer = 0;
277     if (blockhash(duel.blocknumber) == 0 || (block.number - duel.blocknumber) > 256) {
278     
279       duel_fee = safePerc(duel.bet, fee);
280       
281       duel.creator.transfer(safeSub(duel.bet, duel_fee));
282       duel.responder.transfer(safeSub(duel.bet, duel_fee));
283       
284       duel_fee_referrer = safePerc(duel_fee, referrerFee);
285       
286       reward[Referrer[0]] = safeAdd(reward[Referrer[0]], safeMul(2, safeSub(duel_fee, duel_fee_referrer)));
287       reward[Referrer[duel.referrerID]] = safeAdd(reward[Referrer[duel.referrerID]], safeMul(2, duel_fee_referrer));
288 
289       emit refundDuel(_duelID);
290 
291     } else {
292 
293       uint hash = uint(keccak256(abi.encodePacked(blockhash(duel.blocknumber+1), duel.creator, duel.responder, duel.bet)));
294 
295       uint duel_bet_common = safeMul(2, duel.bet);
296       duel_fee = safePerc(duel_bet_common, fee);
297       duel_fee_referrer = safePerc(duel_fee, referrerFee);
298       
299       reward[Referrer[0]] = safeAdd(reward[Referrer[0]], safeSub(duel_fee, duel_fee_referrer));
300       reward[Referrer[duel.referrerID]] = safeAdd(reward[Referrer[duel.referrerID]], duel_fee_referrer);
301 
302       uint sum = safeSub(duel_bet_common, duel_fee);
303 
304       if (hash % 2 == 0) {        
305         duel.creator.transfer(sum);
306         emit resultDuel(_duelID, duel.creator, sum);
307       } else {
308         duel.responder.transfer(sum);
309         emit resultDuel(_duelID, duel.responder, sum);
310       }     
311 
312     }
313   }
314 
315   function setMin(uint _min) external onlyOwner {
316     min = _min;
317     emit changeMin(_min);
318   }
319 
320   function setMax(uint _max) external onlyOwner {
321     max = _max;
322     emit changeMax(_max);
323   }
324 
325   function setFee(uint _fee) external onlyOwner {
326     fee = _fee;
327     emit changeFee(_fee);
328   }
329 
330   function setReferrerFee(uint _referrerFee) external onlyOwner {
331     referrerFee = _referrerFee;
332     emit changeReferrerFee(_referrerFee);
333   }
334   
335   function setReferrer(int _referrerID, address _referrerAddress) external onlyOwner {
336     Referrer[_referrerID] = _referrerAddress;
337     emit changeReferrer(_referrerID, _referrerAddress);
338   }
339   
340   function withdraw(int _referrerID) external {
341     require(msg.sender == Referrer[_referrerID]);
342     uint sum = reward[msg.sender];
343     reward[msg.sender] = 0;
344     msg.sender.transfer(sum);
345     emit withdrawFee(sum, msg.sender);
346   }
347 }