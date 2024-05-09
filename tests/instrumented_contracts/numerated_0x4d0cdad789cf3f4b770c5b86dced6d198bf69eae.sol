1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract ERC827 is ERC20 {
60 
61   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
62   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
63   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
64 
65 }
66 
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194 }
195 
196 contract ERC827Token is ERC827, StandardToken {
197 
198   /**
199      @dev Addition to ERC20 token methods. It allows to
200      approve the transfer of value and execute a call with the sent data.
201 
202      Beware that changing an allowance with this method brings the risk that
203      someone may use both the old and the new allowance by unfortunate
204      transaction ordering. One possible solution to mitigate this race condition
205      is to first reduce the spender's allowance to 0 and set the desired value
206      afterwards:
207      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208 
209      @param _spender The address that will spend the funds.
210      @param _value The amount of tokens to be spent.
211      @param _data ABI-encoded contract call to call `_to` address.
212 
213      @return true if the call function was executed successfully
214    */
215   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
216     require(_spender != address(this));
217 
218     super.approve(_spender, _value);
219 
220     require(_spender.call(_data));
221 
222     return true;
223   }
224 
225   /**
226      @dev Addition to ERC20 token methods. Transfer tokens to a specified
227      address and execute a call with the sent data on the same transaction
228 
229      @param _to address The address which you want to transfer to
230      @param _value uint256 the amout of tokens to be transfered
231      @param _data ABI-encoded contract call to call `_to` address.
232 
233      @return true if the call function was executed successfully
234    */
235   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
236     require(_to != address(this));
237 
238     super.transfer(_to, _value);
239 
240     require(_to.call(_data));
241     return true;
242   }
243 
244   /**
245      @dev Addition to ERC20 token methods. Transfer tokens from one address to
246      another and make a contract call on the same transaction
247 
248      @param _from The address which you want to send tokens from
249      @param _to The address which you want to transfer to
250      @param _value The amout of tokens to be transferred
251      @param _data ABI-encoded contract call to call `_to` address.
252 
253      @return true if the call function was executed successfully
254    */
255   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
256     require(_to != address(this));
257 
258     super.transferFrom(_from, _to, _value);
259 
260     require(_to.call(_data));
261     return true;
262   }
263 
264   /**
265    * @dev Addition to StandardToken methods. Increase the amount of tokens that
266    * an owner allowed to a spender and execute a call with the sent data.
267    *
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _addedValue The amount of tokens to increase the allowance by.
274    * @param _data ABI-encoded contract call to call `_spender` address.
275    */
276   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
277     require(_spender != address(this));
278 
279     super.increaseApproval(_spender, _addedValue);
280 
281     require(_spender.call(_data));
282 
283     return true;
284   }
285 
286   /**
287    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
288    * an owner allowed to a spender and execute a call with the sent data.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    * @param _data ABI-encoded contract call to call `_spender` address.
297    */
298   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
299     require(_spender != address(this));
300 
301     super.decreaseApproval(_spender, _subtractedValue);
302 
303     require(_spender.call(_data));
304 
305     return true;
306   }
307 
308 }
309 
310 contract MigratableToken is ERC827Token {
311 
312   event Migrate(address indexed _from, address indexed _to, uint256 _value);
313 
314   address public migrator;
315   address public migrationAgent;
316   uint256 public totalMigrated;
317 
318   function MigratableToken(address _migrator) public {
319     require(_migrator != address(0));
320     migrator = _migrator;
321   }
322 
323   modifier onlyMigrator() {
324     require(msg.sender == migrator);
325     _;
326   }
327 
328   function migrate(uint256 _value) external {
329     require(migrationAgent != address(0));
330     require(_value != 0);
331     require(_value <= balances[msg.sender]);
332 
333     balances[msg.sender] = balances[msg.sender].sub(_value);
334     totalSupply_ = totalSupply_.sub(_value);
335     totalMigrated = totalMigrated.add(_value);
336     MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
337     Migrate(msg.sender, migrationAgent, _value);
338   }
339 
340   function setMigrationAgent(address _agent) external onlyMigrator {
341     require(migrationAgent == address(0));
342     migrationAgent = _agent;
343   }
344 
345   function setMigrationMaster(address _master) external onlyMigrator {
346     require(_master != address(0));
347     migrator = _master;
348   }
349 
350 }
351 
352 contract Ownable {
353   address public owner;
354 
355 
356   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358 
359   /**
360    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
361    * account.
362    */
363   function Ownable() public {
364     owner = msg.sender;
365   }
366 
367   /**
368    * @dev Throws if called by any account other than the owner.
369    */
370   modifier onlyOwner() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Allows the current owner to transfer control of the contract to a newOwner.
377    * @param newOwner The address to transfer ownership to.
378    */
379   function transferOwnership(address newOwner) public onlyOwner {
380     require(newOwner != address(0));
381     OwnershipTransferred(owner, newOwner);
382     owner = newOwner;
383   }
384 
385 }
386 
387 contract PausableToken is ERC827Token, Ownable {
388 
389   bool public transfersEnabled;
390 
391   modifier ifTransferAllowed {
392     require(transfersEnabled || msg.sender == owner);
393     _;
394   }
395 
396   /**
397    * @dev Constructor that gives msg.sender all of existing tokens.
398    */
399   function PausableToken(bool _transfersEnabled) public {
400     transfersEnabled = _transfersEnabled;
401   }
402 
403   function setTransfersEnabled(bool _transfersEnabled) public onlyOwner {
404     transfersEnabled = _transfersEnabled;
405   }
406 
407   // ERC20 versions
408   function transferFrom(address _from, address _to, uint256 _value) public ifTransferAllowed returns (bool) {
409     return super.transferFrom(_from, _to, _value);
410   }
411 
412   function transfer(address _to, uint256 _value) public ifTransferAllowed returns (bool) {
413     return super.transfer(_to, _value);
414   }
415 
416   function approve(address _spender, uint256 _value) public ifTransferAllowed returns (bool) {
417     return super.approve(_spender, _value);
418   }
419 
420   function increaseApproval(address _spender, uint _addedValue) public ifTransferAllowed returns (bool) {
421     return super.increaseApproval(_spender, _addedValue);
422   }
423 
424   function decreaseApproval(address _spender, uint _subtractedValue) public ifTransferAllowed returns (bool) {
425     return super.decreaseApproval(_spender, _subtractedValue);
426   }
427 
428   // ERC827 versions
429   function approve(address _spender, uint256 _value, bytes _data) public ifTransferAllowed returns (bool) {
430     return super.approve(_spender, _value, _data);
431   }
432 
433   function transfer(address _to, uint256 _value, bytes _data) public ifTransferAllowed returns (bool) {
434     return super.transfer(_to, _value, _data);
435   }
436 
437   function transferFrom( address _from, address _to, uint256 _value, bytes _data) public ifTransferAllowed returns (bool) {
438     return super.transferFrom(_from, _to, _value, _data);
439   }
440 
441   function increaseApproval(address _spender, uint _addedValue, bytes _data) public ifTransferAllowed returns (bool) {
442     return super.increaseApproval(_spender, _addedValue, _data);
443   }
444 
445   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public ifTransferAllowed returns (bool) {
446     return super.decreaseApproval(_spender, _subtractedValue, _data);
447   }
448 
449 }
450 
451 contract Permissible is Ownable {
452 
453   event PermissionAdded(address indexed permitted);
454   event PermissionRemoved(address indexed permitted);
455 
456   mapping(address => bool) public permittedAddresses;
457 
458   modifier onlyPermitted() {
459     require(permittedAddresses[msg.sender]);
460     _;
461   }
462 
463   function addPermission(address _permitted) public onlyOwner {
464     permittedAddresses[_permitted] = true;
465     PermissionAdded(_permitted);
466   }
467 
468   function removePermission(address _permitted) public onlyOwner {
469     require(permittedAddresses[_permitted]);
470     permittedAddresses[_permitted] = false;
471     PermissionRemoved(_permitted);
472   }
473 }
474 
475 contract HyperToken is MigratableToken, PausableToken, Permissible {
476 
477   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
478   event ReputationChanged(address indexed _owner, int32 _amount, int32 _newRep);
479 
480   /* solhint-disable const-name-snakecase */
481   string public constant name = "HyperToken";
482   string public constant symbol = "HPR";
483   uint8 public constant decimals = 18;
484   /* solhint-enable */
485 
486   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
487 
488   mapping(address => int32) public reputation;
489 
490   function HyperToken(address _migrator, bool _transfersEnabled) public 
491     PausableToken(_transfersEnabled)
492     MigratableToken(_migrator) {
493     totalSupply_ = INITIAL_SUPPLY;
494     balances[msg.sender] = INITIAL_SUPPLY;
495   }
496 
497   function changeReputation(address _owner, int32 _amount) external onlyPermitted {
498     require(balances[_owner] > 0);
499     int32 oldRep = reputation[_owner];
500     int32 newRep = oldRep + _amount;
501     if (_amount < 0) {
502       require(newRep < oldRep);
503     } else {
504       require(newRep >= oldRep);
505     }
506     reputation[_owner] = newRep;
507     ReputationChanged(_owner, _amount, newRep);
508   }
509 
510   function reputationOf(address _owner) public view returns (int32) {
511     return reputation[_owner];
512   }
513 
514   function transferOwnershipAndToken(address newOwner) public onlyOwner {
515     transfer(newOwner, balanceOf(owner));
516     transferOwnership(newOwner);
517   }
518 
519   function claimTokens(address _token) public onlyOwner {
520     if (_token == 0x0) {
521       owner.transfer(this.balance);
522       return;
523     }
524 
525     ERC20Basic token = ERC20Basic(_token);
526     uint balance = token.balanceOf(this);
527     token.transfer(owner, balance);
528     ClaimedTokens(_token, owner, balance);
529   }
530 
531 }
532 
533 contract MigrationAgent {
534 
535   function migrateFrom(address _from, uint256 _value) public;
536 }