1 pragma solidity ^0.4.11;
2 
3 contract Controller {
4 
5 
6   // list of admins, council at first spot
7   address[] public admins;
8 
9   function Governable() {
10     admins.length = 1;
11     admins[0] = msg.sender;
12   }
13 
14   modifier onlyAdmins() {
15     bool isAdmin = false;
16     for (uint256 i = 0; i < admins.length; i++) {
17       if (msg.sender == admins[i]) {
18         isAdmin = true;
19       }
20     }
21     require(isAdmin == true);
22     _;
23   }
24 
25   function addAdmin(address _admin) public onlyAdmins {
26     for (uint256 i = 0; i < admins.length; i++) {
27       require(_admin != admins[i]);
28     }
29     require(admins.length < 10);
30     admins[admins.length++] = _admin;
31   }
32 
33   function removeAdmin(address _admin) public onlyAdmins {
34     uint256 pos = admins.length;
35     for (uint256 i = 0; i < admins.length; i++) {
36       if (_admin == admins[i]) {
37         pos = i;
38       }
39     }
40     require(pos < admins.length);
41     // if not last element, switch with last
42     if (pos < admins.length - 1) {
43       admins[pos] = admins[admins.length - 1];
44     }
45     // then cut off the tail
46     admins.length--;
47   }
48 
49   // State Variables
50   bool public paused;
51   function nutzAddr() constant returns (address);
52   function powerAddr() constant returns (address);
53   
54   function moveCeiling(uint256 _newPurchasePrice);
55   function moveFloor(uint256 _newPurchasePrice);
56 
57   // Nutz functions
58   function babzBalanceOf(address _owner) constant returns (uint256);
59   function activeSupply() constant returns (uint256);
60   function burnPool() constant returns (uint256);
61   function powerPool() constant returns (uint256);
62   function totalSupply() constant returns (uint256);
63   function allowance(address _owner, address _spender) constant returns (uint256);
64 
65   function approve(address _owner, address _spender, uint256 _amountBabz) public;
66   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public;
67   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public;
68 
69   // Market functions
70   function floor() constant returns (uint256);
71   function ceiling() constant returns (uint256);
72 
73   function purchase(address _sender, uint256 _value, uint256 _price) public returns (uint256);
74   function sell(address _from, uint256 _price, uint256 _amountBabz);
75 
76   // Power functions
77   function powerBalanceOf(address _owner) constant returns (uint256);
78   function outstandingPower() constant returns (uint256);
79   function authorizedPower() constant returns (uint256);
80   function powerTotalSupply() constant returns (uint256);
81 
82   function powerUp(address _sender, address _from, uint256 _amountBabz) public;
83   function downTick(address _owner, uint256 _now) public;
84   function createDownRequest(address _owner, uint256 _amountPower) public;
85   function downs(address _owner) constant public returns(uint256, uint256, uint256);
86   function downtime() constant returns (uint256);
87 
88   // this is called when NTZ are deposited into the burn pool
89   function dilutePower(uint256 _amountBabz, uint256 _amountPower);
90     function setMaxPower(uint256 _maxPower);
91     
92 
93   // withdraw excessive reserve - i.e. milestones
94   function allocateEther(uint256 _amountWei, address _beneficiary);
95 
96 }
97 
98 
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  */
104 library SafeMath {
105   function mul(uint256 a, uint256 b) internal returns (uint256) {
106     uint256 c = a * b;
107     assert(a == 0 || c / a == b);
108     return c;
109   }
110 
111   function div(uint256 a, uint256 b) internal returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   function sub(uint256 a, uint256 b) internal returns (uint256) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   function add(uint256 a, uint256 b) internal returns (uint256) {
124     uint256 c = a + b;
125     assert(c >= a);
126     return c;
127   }
128 }
129 
130 
131 /*
132  * ERC20Basic
133  * Simpler version of ERC20 interface
134  * see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20Basic {
137   function totalSupply() constant returns (uint256);
138   function balanceOf(address _owner) constant returns (uint256);
139   function transfer(address _to, uint256 _value) returns (bool);
140   event Transfer(address indexed from, address indexed to, uint value);
141 }
142 
143 
144 contract ERC223Basic is ERC20Basic {
145     function transfer(address to, uint value, bytes data) returns (bool);
146 }
147 
148 /*
149  * ERC20 interface
150  * see https://github.com/ethereum/EIPs/issues/20
151  */
152 contract ERC20 is ERC223Basic {
153   // active supply of tokens
154   function activeSupply() constant returns (uint256);
155   function allowance(address _owner, address _spender) constant returns (uint256);
156   function transferFrom(address _from, address _to, uint _value) returns (bool);
157   function approve(address _spender, uint256 _value);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 
163 contract PowerEvent {
164   using SafeMath for uint;
165 
166   // states
167   //   - waiting, initial state
168   //   - collecting, after waiting, before collection stopped
169   //   - failed, after collecting, if softcap missed
170   //   - closed, after collecting, if softcap reached
171   //   - complete, after closed or failed, when job done
172   enum EventState { Waiting, Collecting, Closed, Failed, Complete }
173   EventState public state;
174   uint256 public RATE_FACTOR = 1000000;
175 
176   // Terms
177   uint256 public startTime;
178   uint256 public minDuration;
179   uint256 public maxDuration;
180   uint256 public softCap;
181   uint256 public hardCap;
182   uint256 public discountRate; // if rate 30%, this will be 300,000
183   uint256 public amountPower;
184   address[] public milestoneRecipients;
185   uint256[] public milestoneShares;
186 
187   // Params
188   address public controllerAddr;
189   address public powerAddr;
190   address public nutzAddr;
191   uint256 public initialReserve;
192   uint256 public initialSupply;
193 
194   function PowerEvent(address _controllerAddr, uint256 _startTime, uint256 _minDuration, uint256 _maxDuration, uint256 _softCap, uint256 _hardCap, uint256 _discount, uint256 _amountPower, address[] _milestoneRecipients, uint256[] _milestoneShares)
195   areValidMileStones(_milestoneRecipients, _milestoneShares) {
196     require(_minDuration <= _maxDuration);
197     require(_softCap <= _hardCap);
198     controllerAddr = _controllerAddr;
199     startTime = _startTime;
200     minDuration = _minDuration;
201     maxDuration = _maxDuration;
202     softCap = _softCap;
203     hardCap = _hardCap;
204     discountRate = _discount;
205     amountPower = _amountPower;
206     state = EventState.Waiting;
207     milestoneRecipients = _milestoneRecipients;
208     milestoneShares = _milestoneShares;
209   }
210 
211   modifier isState(EventState _state) {
212     require(state == _state);
213     _;
214   }
215 
216   modifier areValidMileStones(address[] _milestoneRecipients, uint256[] _milestoneShares) {
217     require(checkMilestones(_milestoneRecipients, _milestoneShares));
218     _;
219   }
220 
221   function checkMilestones(address[] _milestoneRecipients, uint256[] _milestoneShares) internal returns (bool) {
222     require(_milestoneRecipients.length == _milestoneShares.length && _milestoneShares.length <= 4);
223     uint256 totalPercentage;
224     for(uint8 i = 0; i < _milestoneShares.length; i++) {
225       require(_milestoneShares[i] >= 0 && _milestoneShares[i] <= 1000000);
226       totalPercentage = totalPercentage.add(_milestoneShares[i]);
227     }
228     require(totalPercentage >= 0 && totalPercentage <= 1000000);
229     return true;
230   }
231 
232   function tick() public {
233     if (state == EventState.Waiting) {
234       startCollection();
235     } else if (state == EventState.Collecting) {
236       stopCollection();
237     } else if (state == EventState.Failed) {
238       completeFailed();
239     } else if (state == EventState.Closed) {
240       completeClosed();
241     } else {
242       throw;
243     }
244   }
245 
246   function startCollection() isState(EventState.Waiting) {
247     // check time
248     require(now > startTime);
249     // assert(now < startTime.add(minDuration));
250     // read initial values
251     var contr = Controller(controllerAddr);
252     powerAddr = contr.powerAddr();
253     nutzAddr = contr.nutzAddr();
254     initialSupply = contr.activeSupply().add(contr.powerPool()).add(contr.burnPool());
255     initialReserve = nutzAddr.balance;
256     uint256 ceiling = contr.ceiling();
257     // move ceiling
258     uint256 newCeiling = ceiling.mul(discountRate).div(RATE_FACTOR);
259     contr.moveCeiling(newCeiling);
260     // set state
261     state = EventState.Collecting;
262   }
263 
264   function stopCollection() isState(EventState.Collecting) {
265     uint256 collected = nutzAddr.balance.sub(initialReserve);
266     if (now > startTime.add(maxDuration)) {
267       if (collected >= softCap) {
268         // softCap reached, close
269         state = EventState.Closed;
270         return;
271       } else {
272         // softCap missed, fail
273         state = EventState.Failed;
274         return;
275       }
276     } else if (now > startTime.add(minDuration)) {
277       if (collected >= hardCap) {
278         // hardCap reached, close
279         state = EventState.Closed;
280         return;
281       } else {
282         // keep going
283         revert();
284       }
285     }
286     // keep going
287     revert();
288   }
289 
290   function completeFailed() isState(EventState.Failed) {
291     var contr = Controller(controllerAddr);
292     // move floor (set ceiling or max floor)
293     uint256 ceiling = contr.ceiling();
294     contr.moveFloor(ceiling);
295     // remove access
296     contr.removeAdmin(address(this));
297     // set state
298     state = EventState.Complete;
299   }
300 
301   function completeClosed() isState(EventState.Closed) {
302     var contr = Controller(controllerAddr);
303     // move ceiling
304     uint256 ceiling = contr.ceiling();
305     uint256 newCeiling = ceiling.mul(RATE_FACTOR).div(discountRate);
306     contr.moveCeiling(newCeiling);
307     // dilute power
308     uint256 totalSupply = contr.activeSupply().add(contr.powerPool()).add(contr.burnPool());
309     uint256 newSupply = totalSupply.sub(initialSupply);
310     contr.dilutePower(newSupply, amountPower);
311     // set max power
312     var PowerContract = ERC20(powerAddr);
313     uint256 authorizedPower = PowerContract.totalSupply();
314     contr.setMaxPower(authorizedPower);
315     // pay out milestone
316     uint256 collected = nutzAddr.balance.sub(initialReserve);
317     for (uint256 i = 0; i < milestoneRecipients.length; i++) {
318       uint256 payoutAmount = collected.mul(milestoneShares[i]).div(RATE_FACTOR);
319       contr.allocateEther(payoutAmount, milestoneRecipients[i]);
320     }
321     // remove access
322     contr.removeAdmin(address(this));
323     // set state
324     state = EventState.Complete;
325   }
326 
327 }