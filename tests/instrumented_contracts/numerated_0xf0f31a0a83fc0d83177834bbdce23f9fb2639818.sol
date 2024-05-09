1 pragma solidity ^0.4.0;
2 
3 /**
4  * ----------------
5  * Application-agnostic user permission (owner, manager) contract
6  * ----------------
7  */
8 contract withOwners {
9   uint public ownersCount = 0;
10   uint public managersCount = 0;
11 
12   /**
13    * Owner: full privilege
14    * Manager: lower privilege (set status, but not withdraw)
15    */
16   mapping (address => bool) public owners;
17   mapping (address => bool) public managers;
18 
19   modifier onlyOwners {
20     if (owners[msg.sender] != true) {
21       throw;
22     }
23     _;
24   }
25 
26   modifier onlyManagers {
27     if (owners[msg.sender] != true && managers[msg.sender] != true) {
28       throw;
29     }
30     _;
31   }
32 
33   function addOwner(address _candidate) public onlyOwners {
34     if (owners[_candidate] == true) {
35       throw; // already owner
36     }
37 
38     owners[_candidate] = true;
39     ++ownersCount;
40   }
41 
42   function removeOwner(address _candidate) public onlyOwners {
43     // Stop removing the only/last owner
44     if (ownersCount <= 1 || owners[_candidate] == false) {
45       throw;
46     }
47 
48     owners[_candidate] = false;
49     --ownersCount;
50   }
51 
52   function addManager(address _candidate) public onlyOwners {
53     if (managers[_candidate] == true) {
54       throw; // already manager
55     }
56 
57     managers[_candidate] = true;
58     ++managersCount;
59   }
60 
61   function removeManager(address _candidate) public onlyOwners {
62     if (managers[_candidate] == false) {
63       throw;
64     }
65 
66     managers[_candidate] = false;
67     --managersCount;
68   }
69 }
70 
71 
72 /**
73  * ----------------
74  * Application-agnostic user account contract
75  * ----------------
76  */
77 contract withAccounts is withOwners {
78   uint defaultTimeoutPeriod = 2 days; // if locked fund is not settled within timeout period, account holders can refund themselves
79 
80   struct AccountTx {
81     uint timeCreated;
82     address user;
83     uint amountHeld;
84     uint amountSpent;
85     uint8 state; // 1: on-hold/locked; 2: processed and refunded;
86   }
87 
88   uint public txCount = 0;
89   mapping (uint => AccountTx) public accountTxs;
90   //mapping (address => uint) public userTxs;
91 
92   /**
93    * Handling user account funds
94    */
95   uint public availableBalance = 0;
96   uint public onholdBalance = 0;
97   uint public spentBalance = 0; // total withdrawal balance by owner (service provider)
98 
99   mapping (address => uint) public availableBalances;
100   mapping (address => uint) public onholdBalances;
101   mapping (address => bool) public doNotAutoRefund;
102 
103   modifier handleDeposit {
104     deposit(msg.sender, msg.value);
105     _;
106   }
107 
108 /**
109  * ----------------------
110  * PUBLIC FUNCTIONS
111  * ----------------------
112  */
113 
114   /**
115    * Deposit into other's account
116    * Useful for services that you wish to not hold funds and not having to keep refunding after every tx and wasting gas
117    */
118   function depositFor(address _address) public payable {
119     deposit(_address, msg.value);
120   }
121 
122   /**
123    * Account owner withdraw funds
124    * leave blank at _amount to collect all funds on user's account
125    */
126   function withdraw(uint _amount) public {
127     if (_amount == 0) {
128       _amount = availableBalances[msg.sender];
129     }
130     if (_amount > availableBalances[msg.sender]) {
131       throw;
132     }
133 
134     incrUserAvailBal(msg.sender, _amount, false);
135     if (!msg.sender.call.value(_amount)()) {
136       throw;
137     }
138   }
139 
140   /**
141    * Checks if an AccountTx is timed out
142    * can be called by anyone, not only account owner or provider
143    * If an AccountTx is already timed out, return balance to the user's available balance.
144    */
145   function checkTimeout(uint _id) public {
146     if (
147       accountTxs[_id].state != 1 ||
148       (now - accountTxs[_id].timeCreated) < defaultTimeoutPeriod
149     ) {
150       throw;
151     }
152 
153     settle(_id, 0); // no money is spent, settle the tx
154 
155     // Specifically for Notification contract
156     // updateState(_id, 60, 0);
157   }
158 
159   /**
160    * Sets doNotAutoRefundTo of caller's account to:
161    * true: stops auto refund after every single transaction
162    * false: proceeds with auto refund after every single transaction
163    *
164    * Manually use withdraw() to withdraw available funds
165    */
166   function setDoNotAutoRefundTo(bool _option) public {
167     doNotAutoRefund[msg.sender] = _option;
168   }
169 
170   /**
171    * Update defaultTimeoutPeriod
172    */
173   function updateDefaultTimeoutPeriod(uint _defaultTimeoutPeriod) public onlyOwners {
174     if (_defaultTimeoutPeriod < 1 hours) {
175       throw;
176     }
177 
178     defaultTimeoutPeriod = _defaultTimeoutPeriod;
179   }
180 
181   /**
182    * Owner - collect spentBalance
183    */
184   function collectRev() public onlyOwners {
185     uint amount = spentBalance;
186     spentBalance = 0;
187 
188     if (!msg.sender.call.value(amount)()) {
189       throw;
190     }
191   }
192 
193   /**
194    * Owner: release availableBalance to account holder
195    * leave blank at _amount to release all
196    * set doNotAutoRefund to true to stop auto funds returning (keep funds on user's available balance account)
197    */
198   function returnFund(address _user, uint _amount) public onlyManagers {
199     if (doNotAutoRefund[_user] || _amount > availableBalances[_user]) {
200       throw;
201     }
202     if (_amount == 0) {
203       _amount = availableBalances[_user];
204     }
205 
206     incrUserAvailBal(_user, _amount, false);
207     if (!_user.call.value(_amount)()) {
208       throw;
209     }
210   }
211 
212 /**
213  * ----------------------
214  * INTERNAL FUNCTIONS
215  * ----------------------
216  */
217 
218   /**
219    * Deposit funds into account
220    */
221   function deposit(address _user, uint _amount) internal {
222     if (_amount > 0) {
223       incrUserAvailBal(_user, _amount, true);
224     }
225   }
226 
227   /**
228    * Creates a transaction
229    */
230   function createTx(uint _id, address _user, uint _amount) internal {
231     if (_amount > availableBalances[_user]) {
232       throw;
233     }
234 
235     accountTxs[_id] = AccountTx({
236       timeCreated: now,
237       user: _user,
238       amountHeld: _amount,
239       amountSpent: 0,
240       state: 1 // on hold
241     });
242 
243     incrUserAvailBal(_user, _amount, false);
244     incrUserOnholdBal(_user, _amount, true);
245   }
246 
247   function settle(uint _id, uint _amountSpent) internal {
248     if (accountTxs[_id].state != 1 || _amountSpent > accountTxs[_id].amountHeld) {
249       throw;
250     }
251 
252     // Deliberately not checking for timeout period
253     // because if provider has actual update, it should stand
254 
255     accountTxs[_id].amountSpent = _amountSpent;
256     accountTxs[_id].state = 2; // processed and refunded;
257 
258     spentBalance += _amountSpent;
259     uint changeAmount = accountTxs[_id].amountHeld - _amountSpent;
260 
261     incrUserOnholdBal(accountTxs[_id].user, accountTxs[_id].amountHeld, false);
262     incrUserAvailBal(accountTxs[_id].user, changeAmount, true);
263   }
264 
265   function incrUserAvailBal(address _user, uint _by, bool _increase) internal {
266     if (_increase) {
267       availableBalances[_user] += _by;
268       availableBalance += _by;
269     } else {
270       availableBalances[_user] -= _by;
271       availableBalance -= _by;
272     }
273   }
274 
275   function incrUserOnholdBal(address _user, uint _by, bool _increase) internal {
276     if (_increase) {
277       onholdBalances[_user] += _by;
278       onholdBalance += _by;
279     } else {
280       onholdBalances[_user] -= _by;
281       onholdBalance -= _by;
282     }
283   }
284 }
285 
286 
287 
288 contract Notifier is withOwners, withAccounts {
289   string public xIPFSPublicKey;
290   uint public minEthPerNotification = 0.02 ether;
291 
292   struct Task {
293     address sender;
294     uint8 state; // 10: pending
295                  // 20: processed, but tx still open
296                  // [ FINAL STATES >= 50 ]
297                  // 50: processed, costing done, tx settled
298                  // 60: rejected or error-ed, costing done, tx settled
299 
300     bool isxIPFS;  // true: IPFS-augmented call (xIPFS); false: on-chain call
301   }
302 
303   struct Notification {
304     uint8 transport; // 1: sms, 2: email
305     string destination;
306     string message;
307   }
308 
309   mapping(uint => Task) public tasks;
310   mapping(uint => Notification) public notifications;
311   mapping(uint => string) public xnotifications; // IPFS-augmented Notification (hash)
312   uint public tasksCount = 0;
313 
314   /**
315    * Events to be picked up by API
316    */
317   event TaskUpdated(uint id, uint8 state);
318 
319   function Notifier(string _xIPFSPublicKey) public {
320     xIPFSPublicKey = _xIPFSPublicKey;
321     ownersCount++;
322     owners[msg.sender] = true;
323   }
324 
325 /**
326  * --------------
327  * Main functions
328  * --------------
329  */
330 
331   /**
332    * Sends notification
333    */
334   function notify(uint8 _transport, string _destination, string _message) public payable handleDeposit {
335     if (_transport != 1 && _transport != 2) {
336       throw;
337     }
338 
339     uint id = tasksCount;
340     uint8 state = 10; // pending
341 
342     createTx(id, msg.sender, minEthPerNotification);
343     notifications[id] = Notification({
344       transport: _transport,
345       destination: _destination,
346       message: _message
347     });
348     tasks[id] = Task({
349       sender: msg.sender,
350       state: state,
351       isxIPFS: false // on-chain
352     });
353 
354     TaskUpdated(id, state);
355     ++tasksCount;
356   }
357 
358 /**
359  * --------------
360  * Extended functions, for
361  * - IPFS-augmented calls
362  * - Encrypted calls
363  * --------------
364  */
365 
366   function xnotify(string _hash) public payable handleDeposit {
367     uint id = tasksCount;
368     uint8 state = 10; // pending
369 
370     createTx(id, msg.sender, minEthPerNotification);
371     xnotifications[id] = _hash;
372     tasks[id] = Task({
373       sender: msg.sender,
374       state: state,
375       isxIPFS: true
376     });
377 
378     TaskUpdated(id, state);
379     ++tasksCount;
380   }
381 
382 /**
383  * --------------
384  * Owner-only functions
385  * ---------------
386  */
387 
388   function updateMinEthPerNotification(uint _newMin) public onlyManagers {
389     minEthPerNotification = _newMin;
390   }
391 
392   /**
393    * Mark task as processed, but no costing yet
394    * This is an optional state
395    */
396   function taskProcessedNoCosting(uint _id) public onlyManagers {
397     updateState(_id, 20, 0);
398   }
399 
400   /**
401    * Mark task as processed, and process funds + costings
402    * This is a FINAL state
403    */
404   function taskProcessedWithCosting(uint _id, uint _cost) public onlyManagers {
405     updateState(_id, 50, _cost);
406   }
407 
408   /**
409    * Mark task as rejected or error-ed,  and processed funds + costings
410    * This is a FINAL state
411    */
412   function taskRejected(uint _id, uint _cost) public onlyManagers {
413     updateState(_id, 60, _cost);
414   }
415 
416   /**
417    * Update public key for xIPFS
418    */
419   function updateXIPFSPublicKey(string _publicKey) public onlyOwners {
420     xIPFSPublicKey = _publicKey;
421   }
422 
423   function updateState(uint _id, uint8 _state, uint _cost) internal {
424     if (tasks[_id].state == 0 || tasks[_id].state >= 50) {
425       throw;
426     }
427 
428     tasks[_id].state = _state;
429 
430     // Cost settlement is done only for final states (>= 50)
431     if (_state >= 50) {
432       settle(_id, _cost);
433     }
434     TaskUpdated(_id, _state);
435   }
436 
437   /**
438    * Handle deposits
439    */
440   function () payable handleDeposit {
441   }
442 }