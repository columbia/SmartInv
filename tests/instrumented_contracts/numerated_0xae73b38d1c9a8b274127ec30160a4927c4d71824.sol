1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 
19 
20 
21 /**
22  * @title ERC20Basic
23  * @dev Simpler version of ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/179
25  */
26 contract ERC20Basic {
27   uint256 public totalSupply;
28   function balanceOf(address who) constant returns (uint256);
29   function transfer(address to, uint256 value) returns (bool);
30   event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal constant returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances. 
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) returns (bool) {
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of. 
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 
100 
101 
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) constant returns (uint256);
110   function transferFrom(address from, address to, uint256 value) returns (bool);
111   function approve(address spender, uint256 value) returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amout of tokens to be transfered
134    */
135   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // require (_value <= _allowance);
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) returns (bool) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifing the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 
179 
180 /**
181  * Standard EIP-20 token with an interface marker.
182  *
183  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
184  *
185  */
186 contract StandardTokenExt is StandardToken {
187 
188   /* Interface declaration */
189   function isToken() public constant returns (bool weAre) {
190     return true;
191   }
192 }
193 
194 
195 contract BurnableToken is StandardTokenExt {
196 
197   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
198   address public constant BURN_ADDRESS = 0;
199 
200   /** How many tokens we burned */
201   event Burned(address burner, uint burnedAmount);
202 
203   /**
204    * Burn extra tokens from a balance.
205    *
206    */
207   function burn(uint burnAmount) {
208     address burner = msg.sender;
209     balances[burner] = balances[burner].sub(burnAmount);
210     totalSupply = totalSupply.sub(burnAmount);
211     Burned(burner, burnAmount);
212 
213     // Inform the blockchain explores that track the
214     // balances only by a transfer event that the balance in this
215     // address has decreased
216     Transfer(burner, BURN_ADDRESS, burnAmount);
217   }
218 }
219 
220 /**
221  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
222  *
223  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
224  */
225 
226 
227 
228 
229 /**
230  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
231  *
232  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
233  */
234 
235 
236 /**
237  * Upgrade agent interface inspired by Lunyr.
238  *
239  * Upgrade agent transfers tokens to a new contract.
240  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
241  */
242 contract UpgradeAgent {
243 
244   uint public originalSupply;
245 
246   /** Interface marker */
247   function isUpgradeAgent() public constant returns (bool) {
248     return true;
249   }
250 
251   function upgradeFrom(address _from, uint256 _value) public;
252 
253 }
254 
255 
256 /**
257  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
258  *
259  * First envisioned by Golem and Lunyr projects.
260  */
261 contract UpgradeableToken is StandardTokenExt {
262 
263   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
264   address public upgradeMaster;
265 
266   /** The next contract where the tokens will be migrated. */
267   UpgradeAgent public upgradeAgent;
268 
269   /** How many tokens we have upgraded by now. */
270   uint256 public totalUpgraded;
271 
272   /**
273    * Upgrade states.
274    *
275    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
276    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
277    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
278    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
279    *
280    */
281   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
282 
283   /**
284    * Somebody has upgraded some of his tokens.
285    */
286   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
287 
288   /**
289    * New upgrade agent available.
290    */
291   event UpgradeAgentSet(address agent);
292 
293   /**
294    * Do not allow construction without upgrade master set.
295    */
296   function UpgradeableToken(address _upgradeMaster) {
297     upgradeMaster = _upgradeMaster;
298   }
299 
300   /**
301    * Allow the token holder to upgrade some of their tokens to a new contract.
302    */
303   function upgrade(uint256 value) public {
304 
305       UpgradeState state = getUpgradeState();
306       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
307         // Called in a bad state
308         throw;
309       }
310 
311       // Validate input value.
312       if (value == 0) throw;
313 
314       balances[msg.sender] = balances[msg.sender].sub(value);
315 
316       // Take tokens out from circulation
317       totalSupply = totalSupply.sub(value);
318       totalUpgraded = totalUpgraded.add(value);
319 
320       // Upgrade agent reissues the tokens
321       upgradeAgent.upgradeFrom(msg.sender, value);
322       Upgrade(msg.sender, upgradeAgent, value);
323   }
324 
325   /**
326    * Set an upgrade agent that handles
327    */
328   function setUpgradeAgent(address agent) external {
329 
330       if(!canUpgrade()) {
331         // The token is not yet in a state that we could think upgrading
332         throw;
333       }
334 
335       if (agent == 0x0) throw;
336       // Only a master can designate the next agent
337       if (msg.sender != upgradeMaster) throw;
338       // Upgrade has already begun for an agent
339       if (getUpgradeState() == UpgradeState.Upgrading) throw;
340 
341       upgradeAgent = UpgradeAgent(agent);
342 
343       // Bad interface
344       if(!upgradeAgent.isUpgradeAgent()) throw;
345       // Make sure that token supplies match in source and target
346       if (upgradeAgent.originalSupply() != totalSupply) throw;
347 
348       UpgradeAgentSet(upgradeAgent);
349   }
350 
351   /**
352    * Get the state of the token upgrade.
353    */
354   function getUpgradeState() public constant returns(UpgradeState) {
355     if(!canUpgrade()) return UpgradeState.NotAllowed;
356     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
357     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
358     else return UpgradeState.Upgrading;
359   }
360 
361   /**
362    * Change the upgrade master.
363    *
364    * This allows us to set a new owner for the upgrade mechanism.
365    */
366   function setUpgradeMaster(address master) public {
367       if (master == 0x0) throw;
368       if (msg.sender != upgradeMaster) throw;
369       upgradeMaster = master;
370   }
371 
372   /**
373    * Child contract can enable to provide the condition when the upgrade can begun.
374    */
375   function canUpgrade() public constant returns(bool) {
376      return true;
377   }
378 
379 }
380 
381 
382 
383 /**
384  * Centrally issued Ethereum token.
385  *
386  * We mix in burnable and upgradeable traits.
387  *
388  * Token supply is created in the token contract creation and allocated to owner.
389  * The owner can then transfer from its supply to crowdsale participants.
390  * The owner, or anybody, can burn any excessive tokens they are holding.
391  *
392  */
393 contract CentrallyIssuedToken is BurnableToken, UpgradeableToken {
394 
395   // Token meta information
396   string public name;
397   string public symbol;
398   uint public decimals;
399 
400   // Token release switch
401   bool public released = false;
402 
403   // The date before the release must be finalized or upgrade path will be forced
404   uint public releaseFinalizationDate;
405 
406   /** Name and symbol were updated. */
407   event UpdatedTokenInformation(string newName, string newSymbol);
408 
409   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals, uint _releaseFinalizationDate)  UpgradeableToken(_owner) {
410     name = _name;
411     symbol = _symbol;
412     totalSupply = _totalSupply;
413     decimals = _decimals;
414 
415     // Allocate initial balance to the owner
416     balances[_owner] = _totalSupply;
417 
418     releaseFinalizationDate = _releaseFinalizationDate;
419   }
420 
421   /**
422    * Owner can update token information here.
423    *
424    * It is often useful to conceal the actual token association, until
425    * the token operations, like central issuance or reissuance have been completed.
426    * In this case the initial token can be supplied with empty name and symbol information.
427    *
428    * This function allows the token owner to rename the token after the operations
429    * have been completed and then point the audience to use the token contract.
430    */
431   function setTokenInformation(string _name, string _symbol) {
432 
433     if(msg.sender != upgradeMaster) {
434       throw;
435     }
436 
437     name = _name;
438     symbol = _symbol;
439     UpdatedTokenInformation(name, symbol);
440   }
441 
442 
443   /**
444    * Kill switch for the token in the case of distribution issue.
445    *
446    */
447   function transfer(address _to, uint _value) returns (bool success) {
448 
449     if(now > releaseFinalizationDate) {
450       if(!released) {
451         throw;
452       }
453     }
454 
455     return super.transfer(_to, _value);
456   }
457 
458   /**
459    * One way function to perform the final token release.
460    */
461   function releaseTokenTransfer() {
462     if(msg.sender != upgradeMaster) {
463       throw;
464     }
465 
466     released = true;
467   }
468 }