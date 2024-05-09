1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 pragma solidity ^0.4.6;
8 
9 // import "./UpgradeableToken.sol";
10 /**
11  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
12  *
13  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
14  */
15 
16 // pragma solidity ^0.4.15;
17 
18 // import "zeppelin-solidity/contracts/token/ERC20.sol";
19 // pragma solidity ^0.4.18;
20 
21 
22 // import './ERC20Basic.sol';
23 // pragma solidity ^0.4.18;
24 
25 
26 /**
27  * @title ERC20Basic
28  * @dev Simpler version of ERC20 interface
29  * @dev see https://github.com/ethereum/EIPs/issues/179
30  */
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public view returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 // import './StandardToken.sol';
50 /**
51  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
52  *
53  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
54  */
55 
56 // pragma solidity ^0.4.15;
57 
58 
59 // import 'zeppelin-solidity/contracts/token/ERC20.sol';
60 // import "zeppelin-solidity/contracts/math/SafeMath.sol";
61 // pragma solidity ^0.4.18;
62 
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   function div(uint256 a, uint256 b) internal pure returns (uint256) {
79     // assert(b > 0); // Solidity automatically throws when dividing by 0
80     uint256 c = a / b;
81     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82     return c;
83   }
84 
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 
98 /**
99  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
100  *
101  * Based on code by FirstBlood:
102  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20 {
105   using SafeMath for uint;
106   /* Token supply got increased and a new owner received these tokens */
107   event Minted(address receiver, uint amount);
108 
109   /* Actual balances of token holders */
110   mapping(address => uint) balances;
111 
112   /* approve() allowances */
113   mapping (address => mapping (address => uint)) allowed;
114 
115   /* Interface declaration */
116   function isToken() public constant returns (bool weAre) {
117     return true;
118   }
119 
120   function transfer(address _to, uint _value) returns (bool success) {
121     balances[msg.sender] = balances[msg.sender].sub( _value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
128     uint _allowance = allowed[_from][msg.sender];
129 
130     balances[_to] = balances[_to].add(_value);
131     balances[_from] = balances[_from].sub(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   function balanceOf(address _owner) constant returns (uint balance) {
138     return balances[_owner];
139   }
140 
141   function approve(address _spender, uint _value) returns (bool success) {
142 
143     // To change the approve amount you first have to reduce the addresses`
144     //  allowance to zero by calling `approve(_spender, 0)` if it is not
145     //  already 0 to mitigate the race condition described here:
146     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) 
148       revert();
149 
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   function allowance(address _owner, address _spender) constant returns (uint remaining) {
156     return allowed[_owner][_spender];
157   }
158 
159 }
160 
161 // import "./UpgradeAgent.sol";
162 /**
163  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
164  *
165  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
166  */
167 
168 // pragma solidity ^0.4.15;
169 
170 /**
171  * Upgrade agent interface inspired by Lunyr.
172  *
173  * Upgrade agent transfers tokens to a new contract.
174  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
175  */
176 contract UpgradeAgent {
177 
178   uint public originalSupply;
179 
180   /** Interface marker */
181   function isUpgradeAgent() public constant returns (bool) {
182     return true;
183   }
184 
185   function upgradeFrom(address _from, uint256 _value) public;
186 
187 }
188 
189 
190 /**
191  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
192  *
193  * First envisioned by Golem and Lunyr projects.
194  */
195 contract UpgradeableToken is StandardToken {
196   using SafeMath for uint256;
197   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
198   address public upgradeMaster;
199 
200   /** The next contract where the tokens will be migrated. */
201   UpgradeAgent public upgradeAgent;
202 
203   /** How many tokens we have upgraded by now. */
204   uint256 public totalUpgraded;
205 
206   /**
207    * Upgrade states.
208    *
209    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
210    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
211    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
212    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
213    *
214    */
215   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
216 
217   /**
218    * Somebody has upgraded some of his tokens.
219    */
220   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
221 
222   /**
223    * New upgrade agent available.
224    */
225   event UpgradeAgentSet(address agent);
226 
227   /**
228    * Do not allow construction without upgrade master set.
229    */
230   function UpgradeableToken(address _upgradeMaster) {
231     upgradeMaster = _upgradeMaster;
232   }
233 
234   /**
235    * Allow the token holder to upgrade some of their tokens to a new contract.
236    */
237   function upgrade(uint256 value) public {
238 
239       UpgradeState state = getUpgradeState();
240       if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
241         // Called in a bad state
242         revert();
243       }
244 
245       // Validate input value.
246       if (value == 0) revert();
247 
248       balances[msg.sender] = balances[msg.sender].sub(value);
249 
250       // Take tokens out from circulation
251       totalSupply = totalSupply.sub(value);
252       totalUpgraded = totalUpgraded.add(value);
253 
254       // Upgrade agent reissues the tokens
255       upgradeAgent.upgradeFrom(msg.sender, value);
256       Upgrade(msg.sender, upgradeAgent, value);
257   }
258 
259   /**
260    * Set an upgrade agent that handles
261    */
262   function setUpgradeAgent(address agent) external {
263 
264       if(!canUpgrade()) {
265         // The token is not yet in a state that we could think upgrading
266         revert();
267       }
268 
269       if (agent == 0x0) revert();
270       // Only a master can designate the next agent
271       if (msg.sender != upgradeMaster) revert();
272       // Upgrade has already begun for an agent
273       if (getUpgradeState() == UpgradeState.Upgrading) revert();
274 
275       upgradeAgent = UpgradeAgent(agent);
276 
277       // Bad interface
278       if(!upgradeAgent.isUpgradeAgent()) revert();
279       // Make sure that token supplies match in source and target
280       if (upgradeAgent.originalSupply() != totalSupply) revert();
281 
282       UpgradeAgentSet(upgradeAgent);
283   }
284 
285   /**
286    * Get the state of the token upgrade.
287    */
288   function getUpgradeState() public constant returns(UpgradeState) {
289     if(!canUpgrade()) return UpgradeState.NotAllowed;
290     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
291     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
292     else return UpgradeState.Upgrading;
293   }
294 
295   /**
296    * Change the upgrade master.
297    *
298    * This allows us to set a new owner for the upgrade mechanism.
299    */
300   function setUpgradeMaster(address master) public {
301       if (master == 0x0) revert();
302       if (msg.sender != upgradeMaster) revert();
303       upgradeMaster = master;
304   }
305 
306   /**
307    * Child contract can enable to provide the condition when the upgrade can begun.
308    */
309   function canUpgrade() public constant returns(bool) {
310      return true;
311   }
312 
313 }
314 
315 // import "./ReleasableToken.sol";
316 /**
317  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
318  *
319  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
320  */
321 
322 // pragma solidity ^0.4.15;
323 
324 // import "zeppelin-solidity/contracts/ownership/Ownable.sol";
325 // pragma solidity ^0.4.18;
326 
327 
328 /**
329  * @title Ownable
330  * @dev The Ownable contract has an owner address, and provides basic authorization control
331  * functions, this simplifies the implementation of "user permissions".
332  */
333 contract Ownable {
334   address public owner;
335 
336 
337   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
338 
339 
340   /**
341    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
342    * account.
343    */
344   function Ownable() public {
345     owner = msg.sender;
346   }
347 
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357 
358   /**
359    * @dev Allows the current owner to transfer control of the contract to a newOwner.
360    * @param newOwner The address to transfer ownership to.
361    */
362   function transferOwnership(address newOwner) public onlyOwner {
363     require(newOwner != address(0));
364     OwnershipTransferred(owner, newOwner);
365     owner = newOwner;
366   }
367 
368 }
369 // import "zeppelin-solidity/contracts/token/ERC20.sol";
370 
371 
372 /**
373  * Define interface for releasing the token transfer after a successful crowdsale.
374  */
375 contract ReleasableToken is ERC20, Ownable {
376 
377   /* The finalizer contract that allows unlift the transfer limits on this token */
378   address public releaseAgent;
379 
380   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
381   bool public released = false;
382 
383   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
384   mapping (address => bool) public transferAgents;
385 
386   /**
387    * Limit token transfer until the crowdsale is over.
388    *
389    */
390   modifier canTransfer(address _sender) {
391 
392     if(!released) {
393         if(!transferAgents[_sender]) {
394             revert();
395         }
396     }
397 
398     _;
399   }
400 
401   /**
402    * Set the contract that can call release and make the token transferable.
403    *
404    * Design choice. Allow reset the release agent to fix fat finger mistakes.
405    */
406   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
407 
408     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
409     releaseAgent = addr;
410   }
411 
412   /**
413    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
414    */
415   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
416     transferAgents[addr] = state;
417   }
418 
419   /**
420    * One way function to release the tokens to the wild.
421    *
422    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
423    */
424   function releaseTokenTransfer() public onlyReleaseAgent {
425     released = true;
426   }
427 
428   /** The function can be called only before or after the tokens have been releasesd */
429   modifier inReleaseState(bool releaseState) {
430     if(releaseState != released) {
431         revert();
432     }
433     _;
434   }
435 
436   /** The function can be called only by a whitelisted release agent. */
437   modifier onlyReleaseAgent() {
438     if(msg.sender != releaseAgent) {
439         revert();
440     }
441     _;
442   }
443 
444   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
445     // Call StandardToken.transfer()
446    return super.transfer(_to, _value);
447   }
448 
449   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
450     // Call StandardToken.transferForm()
451     return super.transferFrom(_from, _to, _value);
452   }
453 
454 }
455 
456 // import "./PausableToken.sol";
457 // pragma solidity ^0.4.15;
458 
459 // import './StandardToken.sol';
460 // import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
461 // pragma solidity ^0.4.18;
462 
463 
464 // import "../ownership/Ownable.sol";
465 
466 
467 /**
468  * @title Pausable
469  * @dev Base contract which allows children to implement an emergency stop mechanism.
470  */
471 contract Pausable is Ownable {
472   event Pause();
473   event Unpause();
474 
475   bool public paused = false;
476 
477 
478   /**
479    * @dev Modifier to make a function callable only when the contract is not paused.
480    */
481   modifier whenNotPaused() {
482     require(!paused);
483     _;
484   }
485 
486   /**
487    * @dev Modifier to make a function callable only when the contract is paused.
488    */
489   modifier whenPaused() {
490     require(paused);
491     _;
492   }
493 
494   /**
495    * @dev called by the owner to pause, triggers stopped state
496    */
497   function pause() onlyOwner whenNotPaused public {
498     paused = true;
499     Pause();
500   }
501 
502   /**
503    * @dev called by the owner to unpause, returns to normal state
504    */
505   function unpause() onlyOwner whenPaused public {
506     paused = false;
507     Unpause();
508   }
509 }
510 
511 /**
512  * Pausable token
513  *
514  * Simple ERC20 Token example, with pausable token creation
515  **/
516 
517 contract PausableToken is StandardToken, Pausable {
518 
519   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
520     return super.transfer(_to, _value);
521   }
522 
523   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
524     return super.transferFrom(_from, _to, _value);
525   }
526 }
527 
528 
529 /**
530  * Centrally issued Ethereum token.
531  *
532  * We mix in burnable and upgradeable traits.
533  *
534  * Token supply is created in the token contract creation and allocated to owner.
535  * The owner can then transfer from its supply to crowdsale participants.
536  * The owner, or anybody, can burn any excessive tokens they are holding.
537  *
538  */
539 contract CentrallyIssuedToken is UpgradeableToken, ReleasableToken, PausableToken {
540 
541   string public name;
542   string public symbol;
543   uint public decimals;
544 
545   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
546     name = _name;
547     symbol = _symbol;
548     totalSupply = _totalSupply;
549     decimals = _decimals;
550 
551     // Allocate initial balance to the owner
552     balances[_owner] = _totalSupply;
553   }
554 }