1 pragma solidity 0.4.19;
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 pragma solidity ^0.4.18;
52 
53 pragma solidity ^0.4.18;
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public view returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * CashBetCoin ERC20 token
82  * Based on the OpenZeppelin Standard Token
83  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
84  */
85 
86 contract MigrationSource {
87   function vacate(address _addr) public returns (uint256 o_balance,
88                                                  uint256 o_lock_value,
89                                                  uint256 o_lock_endTime,
90                                                  bytes32 o_operatorId,
91                                                  bytes32 o_playerId);
92 }
93 
94 contract CashBetCoin is MigrationSource, ERC20 {
95   using SafeMath for uint256;
96 
97   string public constant name = "CashBetCoin";
98   string public constant symbol = "CBC";
99   uint8 public constant decimals = 8;
100   uint internal totalSupply_;
101 
102   address public owner;
103 
104   mapping(bytes32 => bool) public operators;
105   mapping(address => User) public users;
106   mapping(address => mapping(bytes32 => bool)) public employees;
107   
108   MigrationSource public migrateFrom;
109   address public migrateTo;
110 
111   struct User {
112     uint256 balance;
113     uint256 lock_value;
114     uint256 lock_endTime;
115     bytes32 operatorId;
116     bytes32 playerId;
117       
118     mapping(address => uint256) authorized;
119   }
120 
121   modifier only_owner(){
122     require(msg.sender == owner);
123     _;
124   }
125 
126   modifier only_employees(address _user){
127     require(employees[msg.sender][users[_user].operatorId]);
128     _;
129   }
130 
131   // PlayerId may only be set if operatorId is set too.
132   modifier playerid_iff_operatorid(bytes32 _opId, bytes32 _playerId){
133     require(_opId != bytes32(0) || _playerId == bytes32(0));
134     _;
135   }
136 
137   // Value argument must be less than unlocked balance.
138   modifier value_less_than_unlocked_balance(address _user, uint256 _value){
139     User storage user = users[_user];
140     require(user.lock_endTime < block.timestamp ||
141             _value <= user.balance - user.lock_value);
142     require(_value <= user.balance);
143     _;
144   }
145 
146   event Approval(address indexed owner, address indexed spender, uint256 value);
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 
149   event LockIncrease(address indexed user, uint256 amount, uint256 time);
150   event LockDecrease(address indexed user, address employee,  uint256 amount, uint256 time);
151 
152   event Associate(address indexed user, address agent, bytes32 indexed operatorId, bytes32 playerId);
153   
154   event Burn(address indexed owner, uint256 value);
155 
156   event OptIn(address indexed owner, uint256 value);
157   event Vacate(address indexed owner, uint256 value);
158 
159   event Employee(address indexed empl, bytes32 indexed operatorId, bool allowed);
160   event Operator(bytes32 indexed operatorId, bool allowed);
161 
162   function CashBetCoin(uint _totalSupply) public {
163     totalSupply_ = _totalSupply;
164     owner = msg.sender;
165     User storage user = users[owner];
166     user.balance = totalSupply_;
167     user.lock_value = 0;
168     user.lock_endTime = 0;
169     user.operatorId = bytes32(0);
170     user.playerId = bytes32(0);
171     Transfer(0, owner, _totalSupply);
172   }
173 
174   function totalSupply() public view returns (uint256){
175     return totalSupply_;
176   }
177 
178   function balanceOf(address _addr) public view returns (uint256 balance) {
179     return users[_addr].balance;
180   }
181 
182   function transfer(address _to, uint256 _value) public value_less_than_unlocked_balance(msg.sender, _value) returns (bool success) {
183     User storage user = users[msg.sender];
184     user.balance = user.balance.sub(_value);
185     users[_to].balance = users[_to].balance.add(_value);
186     Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   function transferFrom(address _from, address _to, uint256 _value) public value_less_than_unlocked_balance(_from, _value) returns (bool success) {
191     User storage user = users[_from];
192     user.balance = user.balance.sub(_value);
193     users[_to].balance = users[_to].balance.add(_value);
194     user.authorized[msg.sender] = user.authorized[msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   function approve(address _spender, uint256 _value) public returns (bool success){
200     // To change the approve amount you first have to reduce the addresses`
201     //  allowance to zero by calling `approve(_spender, 0)` if it is not
202     //  already 0 to mitigate the race condition described here:
203     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204     require((_value == 0) || (users[msg.sender].authorized[_spender] == 0));
205     users[msg.sender].authorized[_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   function allowance(address _user, address _spender) public view returns (uint256){
211     return users[_user].authorized[_spender];
212   }
213 
214   // Returns the number of locked tokens at the specified address.
215   //
216   function lockedValueOf(address _addr) public view returns (uint256 value) {
217     User storage user = users[_addr];
218     // Is the lock expired?
219     if (user.lock_endTime < block.timestamp) {
220       // Lock is expired, no locked value.
221       return 0;
222     } else {
223       return user.lock_value;
224     }
225   }
226 
227   // Returns the unix time that the current token lock will expire.
228   //
229   function lockedEndTimeOf(address _addr) public view returns (uint256 time) {
230     return users[_addr].lock_endTime;
231   }
232 
233   // Lock the specified number of tokens until the specified unix
234   // time.  The locked value and expiration time are both absolute (if
235   // the account already had some locked tokens the count will be
236   // increased to this value.)  If the user already has locked tokens
237   // the locked token count and expiration time may not be smaller
238   // than the previous values.
239   //
240   function increaseLock(uint256 _value, uint256 _time) public returns (bool success) {
241     User storage user = users[msg.sender];
242 
243     // Is there a lock in effect?
244     if (block.timestamp < user.lock_endTime) {
245       // Lock in effect, ensure nothing gets smaller.
246       require(_value >= user.lock_value);
247       require(_time >= user.lock_endTime);
248       // Ensure something has increased.
249       require(_value > user.lock_value || _time > user.lock_endTime);
250     }
251 
252     // Things we always require.
253     require(_value <= user.balance);
254     require(_time > block.timestamp);
255 
256     user.lock_value = _value;
257     user.lock_endTime = _time;
258     LockIncrease(msg.sender, _value, _time);
259     return true;
260   }
261 
262   // Employees of CashBet may decrease the locked token value and/or
263   // decrease the locked token expiration date.  These values may not
264   // ever be increased by an employee.
265   //
266   function decreaseLock(uint256 _value, uint256 _time, address _user) public only_employees(_user) returns (bool success) {
267     User storage user = users[_user];
268 
269     // We don't modify expired locks (they are already 0)
270     require(user.lock_endTime > block.timestamp);
271     // Ensure nothing gets bigger.
272     require(_value <= user.lock_value);
273     require(_time <= user.lock_endTime);
274     // Ensure something has decreased.
275     require(_value < user.lock_value || _time < user.lock_endTime);
276 
277     user.lock_value = _value;
278     user.lock_endTime = _time;
279     LockDecrease(_user, msg.sender, _value, _time);
280     return true;
281   }
282 
283   function associate(bytes32 _opId, bytes32 _playerId) public playerid_iff_operatorid(_opId, _playerId) returns (bool success) {
284     User storage user = users[msg.sender];
285 
286     // Players can associate their playerId once while the token is
287     // locked.  They can't change this association until the lock
288     // expires ...
289     require(user.lock_value == 0 ||
290             user.lock_endTime < block.timestamp ||
291             user.playerId == 0);
292 
293     // OperatorId argument must be empty or in the approved operators set.
294     require(_opId == bytes32(0) || operators[_opId]);
295 
296     user.operatorId = _opId;
297     user.playerId = _playerId;
298     Associate(msg.sender, msg.sender, _opId, _playerId);
299     return true;
300   }
301 
302   function associationOf(address _addr) public view returns (bytes32 opId, bytes32 playerId) {
303     return (users[_addr].operatorId, users[_addr].playerId);
304   }
305 
306   function setAssociation(address _user, bytes32 _opId, bytes32 _playerId) public only_employees(_user) playerid_iff_operatorid(_opId, _playerId) returns (bool success) {
307     User storage user = users[_user];
308 
309     // Employees may only set opId to empty or something they are an
310     // employee of.
311     require(_opId == bytes32(0) || employees[msg.sender][_opId]);
312     
313     user.operatorId = _opId;
314     user.playerId = _playerId;
315     Associate(_user, msg.sender, _opId, _playerId);
316     return true;
317   }
318   
319   function setEmployee(address _addr, bytes32 _opId, bool _allowed) public only_owner {
320     employees[_addr][_opId] = _allowed;
321     Employee(_addr, _opId, _allowed);
322   }
323 
324   function setOperator(bytes32 _opId, bool _allowed) public only_owner {
325     operators[_opId] = _allowed;
326     Operator(_opId, _allowed);
327   }
328 
329   function setOwner(address _addr) public only_owner {
330     owner = _addr;
331   }
332 
333   function burnTokens(uint256 _value) public value_less_than_unlocked_balance(msg.sender, _value) returns (bool success) {
334     User storage user = users[msg.sender];
335     user.balance = user.balance.sub(_value);
336     totalSupply_ = totalSupply_.sub(_value);
337     Burn(msg.sender, _value);
338     return true;
339   }
340 
341   // Sets the contract address that this contract will migrate
342   // from when the optIn() interface is used.
343   //
344   function setMigrateFrom(address _addr) public only_owner {
345     require(migrateFrom == MigrationSource(0));
346     migrateFrom = MigrationSource(_addr);
347   }
348 
349   // Sets the contract address that is allowed to call vacate on this
350   // contract.
351   //
352   function setMigrateTo(address _addr) public only_owner {
353     migrateTo = _addr;
354   }
355 
356   // Called by a token holding address, this method migrates the
357   // tokens from an older version of the contract to this version.
358   // The migrated tokens are merged with any existing tokens in this
359   // version of the contract, resulting in the locked token count
360   // being set to the sum of locked tokens in the old and new
361   // contracts and the lock expiration being set the longest lock
362   // duration for this address in either contract.  The playerId is
363   // transferred unless it was already set in the new contract.
364   //
365   // NOTE - allowances (approve) are *not* transferred.  If you gave
366   // another address an allowance in the old contract you need to
367   // re-approve it in the new contract.
368   //
369   function optIn() public returns (bool success) {
370     require(migrateFrom != MigrationSource(0));
371     User storage user = users[msg.sender];
372     uint256 balance;
373     uint256 lock_value;
374     uint256 lock_endTime;
375     bytes32 opId;
376     bytes32 playerId;
377     (balance, lock_value, lock_endTime, opId, playerId) =
378         migrateFrom.vacate(msg.sender);
379 
380     OptIn(msg.sender, balance);
381     
382     user.balance = user.balance.add(balance);
383 
384     bool lockTimeIncreased = false;
385     user.lock_value = user.lock_value.add(lock_value);
386     if (user.lock_endTime < lock_endTime) {
387       user.lock_endTime = lock_endTime;
388       lockTimeIncreased = true;
389     }
390     if (lock_value > 0 || lockTimeIncreased) {
391       LockIncrease(msg.sender, user.lock_value, user.lock_endTime);
392     }
393 
394     if (user.operatorId == bytes32(0) && opId != bytes32(0)) {
395       user.operatorId = opId;
396       user.playerId = playerId;
397       Associate(msg.sender, msg.sender, opId, playerId);
398     }
399 
400     totalSupply_ = totalSupply_.add(balance);
401 
402     return true;
403   }
404 
405   // The vacate method is called by a newer version of the CashBetCoin
406   // contract to extract the token state for an address and migrate it
407   // to the new contract.
408   //
409   function vacate(address _addr) public returns (uint256 o_balance,
410                                                  uint256 o_lock_value,
411                                                  uint256 o_lock_endTime,
412                                                  bytes32 o_opId,
413                                                  bytes32 o_playerId) {
414     require(msg.sender == migrateTo);
415     User storage user = users[_addr];
416     require(user.balance > 0);
417 
418     o_balance = user.balance;
419     o_lock_value = user.lock_value;
420     o_lock_endTime = user.lock_endTime;
421     o_opId = user.operatorId;
422     o_playerId = user.playerId;
423 
424     totalSupply_ = totalSupply_.sub(user.balance);
425 
426     user.balance = 0;
427     user.lock_value = 0;
428     user.lock_endTime = 0;
429     user.operatorId = bytes32(0);
430     user.playerId = bytes32(0);
431 
432     Vacate(_addr, o_balance);
433   }
434 
435   // Don't accept ETH.
436   function () public payable {
437     revert();
438   }
439 }