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
28   function balanceOf(address who) public constant returns (uint256);
29   function transfer(address to, uint256 value) public returns (bool);
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
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83 
84     // SafeMath.sub will throw if there is not enough balance.
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 
103 
104 
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public constant returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140 
141     uint256 _allowance = allowed[_from][msg.sender];
142 
143     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144     // require (_value <= _allowance);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = _allowance.sub(_value);
149     Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    */
185   function increaseApproval (address _spender, uint _addedValue)
186     returns (bool success) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   function decreaseApproval (address _spender, uint _subtractedValue)
193     returns (bool success) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 }
205 
206 
207 
208 /**
209  * Standard EIP-20 token with an interface marker.
210  *
211  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
212  *
213  */
214 contract StandardTokenExt is StandardToken {
215 
216   /* Interface declaration */
217   function isToken() public constant returns (bool weAre) {
218     return true;
219   }
220 }
221 
222 
223 contract BurnableToken is StandardTokenExt {
224 
225   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
226   address public constant BURN_ADDRESS = 0;
227 
228   /** How many tokens we burned */
229   event Burned(address burner, uint burnedAmount);
230 
231   /**
232    * Burn extra tokens from a balance.
233    *
234    */
235   function burn(uint burnAmount) {
236     address burner = msg.sender;
237     balances[burner] = balances[burner].sub(burnAmount);
238     totalSupply = totalSupply.sub(burnAmount);
239     Burned(burner, burnAmount);
240 
241     // Inform the blockchain explores that track the
242     // balances only by a transfer event that the balance in this
243     // address has decreased
244     Transfer(burner, BURN_ADDRESS, burnAmount);
245   }
246 }
247 
248 /**
249  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
250  *
251  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
252  */
253 
254 
255 
256 
257 /**
258  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
259  *
260  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
261  */
262 
263 
264 /**
265  * Upgrade agent interface inspired by Lunyr.
266  *
267  * Upgrade agent transfers tokens to a new contract.
268  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
269  */
270 contract UpgradeAgent {
271 
272   uint public originalSupply;
273 
274   /** Interface marker */
275   function isUpgradeAgent() public constant returns (bool) {
276     return true;
277   }
278 
279   function upgradeFrom(address _from, uint256 _value) public;
280 
281 }
282 
283 
284 /**
285  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
286  *
287  * First envisioned by Golem and Lunyr projects.
288  */
289 contract UpgradeableToken is StandardTokenExt {
290 
291   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
292   address public upgradeMaster;
293 
294   /** The next contract where the tokens will be migrated. */
295   UpgradeAgent public upgradeAgent;
296 
297   /** How many tokens we have upgraded by now. */
298   uint256 public totalUpgraded;
299 
300   /**
301    * Upgrade states.
302    *
303    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
304    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
305    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
306    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
307    *
308    */
309   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
310 
311   /**
312    * Somebody has upgraded some of his tokens.
313    */
314   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
315 
316   /**
317    * New upgrade agent available.
318    */
319   event UpgradeAgentSet(address agent);
320 
321   /**
322    * Do not allow construction without upgrade master set.
323    */
324   function UpgradeableToken(address _upgradeMaster) {
325     upgradeMaster = _upgradeMaster;
326   }
327 
328   /**
329    * Allow the token holder to upgrade some of their tokens to a new contract.
330    */
331   function upgrade(uint256 value) public {
332 
333       UpgradeState state = getUpgradeState();
334       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
335         // Called in a bad state
336         throw;
337       }
338 
339       // Validate input value.
340       if (value == 0) throw;
341 
342       balances[msg.sender] = balances[msg.sender].sub(value);
343 
344       // Take tokens out from circulation
345       totalSupply = totalSupply.sub(value);
346       totalUpgraded = totalUpgraded.add(value);
347 
348       // Upgrade agent reissues the tokens
349       upgradeAgent.upgradeFrom(msg.sender, value);
350       Upgrade(msg.sender, upgradeAgent, value);
351   }
352 
353   /**
354    * Set an upgrade agent that handles
355    */
356   function setUpgradeAgent(address agent) external {
357 
358       if(!canUpgrade()) {
359         // The token is not yet in a state that we could think upgrading
360         throw;
361       }
362 
363       if (agent == 0x0) throw;
364       // Only a master can designate the next agent
365       if (msg.sender != upgradeMaster) throw;
366       // Upgrade has already begun for an agent
367       if (getUpgradeState() == UpgradeState.Upgrading) throw;
368 
369       upgradeAgent = UpgradeAgent(agent);
370 
371       // Bad interface
372       if(!upgradeAgent.isUpgradeAgent()) throw;
373       // Make sure that token supplies match in source and target
374       if (upgradeAgent.originalSupply() != totalSupply) throw;
375 
376       UpgradeAgentSet(upgradeAgent);
377   }
378 
379   /**
380    * Get the state of the token upgrade.
381    */
382   function getUpgradeState() public constant returns(UpgradeState) {
383     if(!canUpgrade()) return UpgradeState.NotAllowed;
384     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
385     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
386     else return UpgradeState.Upgrading;
387   }
388 
389   /**
390    * Change the upgrade master.
391    *
392    * This allows us to set a new owner for the upgrade mechanism.
393    */
394   function setUpgradeMaster(address master) public {
395       if (master == 0x0) throw;
396       if (msg.sender != upgradeMaster) throw;
397       upgradeMaster = master;
398   }
399 
400   /**
401    * Child contract can enable to provide the condition when the upgrade can begun.
402    */
403   function canUpgrade() public constant returns(bool) {
404      return true;
405   }
406 
407 }
408 
409 
410 
411 /**
412  * Centrally issued Ethereum token.
413  *
414  * We mix in burnable and upgradeable traits.
415  *
416  * Token supply is created in the token contract creation and allocated to owner.
417  * The owner can then transfer from its supply to crowdsale participants.
418  * The owner, or anybody, can burn any excessive tokens they are holding.
419  *
420  */
421 contract CentrallyIssuedToken is BurnableToken, UpgradeableToken {
422 
423   // Token meta information
424   string public name;
425   string public symbol;
426   uint public decimals;
427 
428   // Token release switch
429   bool public released = false;
430 
431   // The date before the release must be finalized or upgrade path will be forced
432   uint public releaseFinalizationDate;
433 
434   /** Name and symbol were updated. */
435   event UpdatedTokenInformation(string newName, string newSymbol);
436 
437   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals, uint _releaseFinalizationDate)  UpgradeableToken(_owner) {
438     name = _name;
439     symbol = _symbol;
440     totalSupply = _totalSupply;
441     decimals = _decimals;
442 
443     // Allocate initial balance to the owner
444     balances[_owner] = _totalSupply;
445 
446     releaseFinalizationDate = _releaseFinalizationDate;
447   }
448 
449   /**
450    * Owner can update token information here.
451    *
452    * It is often useful to conceal the actual token association, until
453    * the token operations, like central issuance or reissuance have been completed.
454    * In this case the initial token can be supplied with empty name and symbol information.
455    *
456    * This function allows the token owner to rename the token after the operations
457    * have been completed and then point the audience to use the token contract.
458    */
459   function setTokenInformation(string _name, string _symbol) {
460 
461     if(msg.sender != upgradeMaster) {
462       throw;
463     }
464 
465     if(bytes(name).length > 0 || bytes(symbol).length > 0) {
466       // Information already set
467       // Allow owner to set this information only once
468       throw;
469     }
470 
471     name = _name;
472     symbol = _symbol;
473     UpdatedTokenInformation(name, symbol);
474   }
475 
476 
477   /**
478    * Kill switch for the token in the case of distribution issue.
479    *
480    */
481   function transfer(address _to, uint _value) returns (bool success) {
482 
483     if(now > releaseFinalizationDate) {
484       if(!released) {
485         throw;
486       }
487     }
488 
489     return super.transfer(_to, _value);
490   }
491 
492   /**
493    * One way function to perform the final token release.
494    */
495   function releaseTokenTransfer() {
496     if(msg.sender != upgradeMaster) {
497       throw;
498     }
499 
500     released = true;
501   }
502 }