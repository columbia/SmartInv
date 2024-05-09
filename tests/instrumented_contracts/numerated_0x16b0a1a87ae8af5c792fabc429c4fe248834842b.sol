1 pragma solidity ^0.4.15;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  * Based on OpenZeppelin
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 // File: contracts/token/ERC20Basic.sol
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  *
43  * Based on OpenZeppelin
44  */
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: contracts/token/ERC20.sol
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  *
58  * Based on OpenZeppelin
59  */
60 
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public constant returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 // File: contracts/token/StandardToken.sol
69 
70 /**
71  * @title Standard ERC20 token
72  *
73  * @dev Implementation of the basic standard token.
74  * @dev https://github.com/ethereum/EIPs/issues/20
75  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
76  *
77  * Based on OpenZeppelin
78  */
79 contract StandardToken is ERC20 {
80 
81     using SafeMath for uint256;
82 
83     mapping(address => uint256) balances;
84 
85     mapping (address => mapping (address => uint256)) internal allowed;
86 
87     /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92     function transfer(address _to, uint256 _value) public returns (bool) {
93         require(_to != address(0));
94         require(_value <= balances[msg.sender]);
95 
96         // SafeMath.sub will throw if there is not enough balance.
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         Transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param _owner The address to query the the balance of.
106     * @return An uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address _owner) public constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     /**
113      * @dev Transfer tokens from one address to another
114      * @param _from address The address which you want to send tokens from
115      * @param _to address The address which you want to transfer to
116      * @param _value uint256 the amount of tokens to be transferred
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      *
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) public returns (bool) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param _owner address The address which owns the funds.
149      * @param _spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address _owner, address _spender) public constant returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155 
156     /**
157      * approve should be called when allowed[_spender] == 0. To increment
158      * allowed value is better to use this function to avoid 2 calls (and wait until
159      * the first transaction is mined)
160      * From MonolithDAO Token.sol
161      */
162     function increaseApproval (address _spender, uint _addedValue) public returns (bool) {
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool) {
169         uint oldValue = allowed[msg.sender][_spender];
170         if (_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0;
172         } else {
173             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174         }
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179 }
180 
181 // File: contracts/token/BurnableToken.sol
182 
183 /**
184  * @title Burnable Token
185  *
186  * @dev based on OpenZeppelin
187  */
188 contract BurnableToken is StandardToken {
189 
190     event Burn(address indexed burner, uint256 value);
191 
192     /**
193      * @dev Burns a specific amount of tokens.
194      * @param _value The amount of token to be burned.
195      */
196     function burn(uint256 _value) public {
197         require(_value > 0);
198         require(_value <= balances[msg.sender]);
199 
200         address burner = msg.sender;
201         balances[burner] = balances[burner].sub(_value);
202         totalSupply = totalSupply.sub(_value);
203         Burn(burner, _value);
204     }
205 }
206 
207 // File: contracts/ownership/Ownable.sol
208 
209 /**
210  * @title Ownable
211  * @dev The Ownable contract has an owner address, and provides basic authorization control
212  * functions, this simplifies the implementation of "user permissions".
213  * Based on OpenZeppelin
214  */
215 contract Ownable {
216   address public owner;
217 
218 
219   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
220 
221 
222   /**
223    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
224    * account.
225    */
226   function Ownable() {
227     owner = msg.sender;
228   }
229 
230 
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require(msg.sender == owner);
236     _;
237   }
238 
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) onlyOwner public {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 // File: contracts/ownership/Claimable.sol
253 
254 /**
255  * @title Claimable
256  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
257  * This allows the new owner to accept the transfer.
258  * Based on OpenZeppelin
259  */
260 contract Claimable is Ownable {
261     address public pendingOwner;
262 
263     /**
264      * @dev Modifier throws if called by any account other than the pendingOwner.
265      */
266     modifier onlyPendingOwner() {
267         require(msg.sender == pendingOwner);
268         _;
269     }
270 
271     /**
272      * @dev Allows the current owner to set the pendingOwner address.
273      * @param newOwner The address to transfer ownership to.
274      */
275     function transferOwnership(address newOwner) onlyOwner public {
276         pendingOwner = newOwner;
277     }
278 
279     /**
280      * @dev Allows the pendingOwner address to finalize the transfer.
281      */
282     function claimOwnership() onlyPendingOwner public {
283         OwnershipTransferred(owner, pendingOwner);
284         owner = pendingOwner;
285         pendingOwner = address(0);
286     }
287 }
288 
289 // File: contracts/token/ReleasableToken.sol
290 
291 /**
292  * Define interface for releasing the token transfer after a successful crowdsale.
293  *
294  */
295 contract ReleasableToken is ERC20, Claimable {
296 
297     /* The finalizer contract that allows unlift the transfer limits on this token */
298     address public releaseAgent;
299 
300     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
301     bool public released = false;
302 
303     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
304     mapping (address => bool) public transferAgents;
305 
306     /**
307      * Limit token transfer until the crowdsale is over.
308      *
309      */
310     modifier canTransfer(address _sender) {
311         if(!released) {
312             assert(transferAgents[_sender]);
313         }
314         _;
315     }
316 
317     /**
318      * Set the contract that can call release and make the token transferable.
319      *
320      * Design choice. Allow reset the release agent to fix fat finger mistakes.
321      */
322     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
323         require(addr != 0x0);
324         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
325         releaseAgent = addr;
326     }
327 
328     /**
329      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
330      */
331     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
332         require(addr != 0x0);
333         transferAgents[addr] = state;
334     }
335 
336     /**
337      * One way function to release the tokens to the wild.
338      *
339      * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
340      */
341     function releaseTokenTransfer() public onlyReleaseAgent {
342         released = true;
343     }
344 
345     /** The function can be called only before or after the tokens have been releasesd */
346     modifier inReleaseState(bool releaseState) {
347         require(releaseState == released);
348         _;
349     }
350 
351     /** The function can be called only by a whitelisted release agent. */
352     modifier onlyReleaseAgent() {
353         require(msg.sender == releaseAgent);
354         _;
355     }
356 
357     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
358         // Call StandardToken.transfer()
359         return super.transfer(_to, _value);
360     }
361 
362     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
363         // Call StandardToken.transferForm()
364         return super.transferFrom(_from, _to, _value);
365     }
366 
367 }
368 
369 // File: contracts/token/CrowdsaleToken.sol
370 
371 /**
372  * @title Base crowdsale token interface
373  */
374 contract CrowdsaleToken is BurnableToken, ReleasableToken {
375     uint public decimals;
376 }
377 
378 // File: contracts/token/UpgradeAgent.sol
379 
380 /**
381  * Upgrade agent interface inspired by Lunyr.
382  *
383  * Upgrade agent transfers tokens to a new contract.
384  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
385  *
386  */
387 contract UpgradeAgent {
388 
389     uint public originalSupply;
390 
391     /** Interface marker */
392     function isUpgradeAgent() public constant returns (bool) {
393         return true;
394     }
395 
396     function upgradeFrom(address _from, uint256 _value) public;
397 }
398 
399 // File: contracts/token/UpgradeableToken.sol
400 
401 /**
402  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
403  *
404  * First envisioned by Golem and Lunyr projects.
405  *
406  */
407 contract UpgradeableToken is StandardToken {
408 
409     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
410     address public upgradeMaster;
411 
412     /** The next contract where the tokens will be migrated. */
413     UpgradeAgent public upgradeAgent;
414 
415     /** How many tokens we have upgraded by now. */
416     uint256 public totalUpgraded;
417 
418     /**
419      * Upgrade states.
420      *
421      * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
422      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
423      * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
424      * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
425      *
426      */
427     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
428 
429     /**
430      * Somebody has upgraded some of his tokens.
431      */
432     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
433 
434     /**
435      * New upgrade agent available.
436      */
437     event UpgradeAgentSet(address agent);
438 
439     /**
440      * Do not allow construction without upgrade master set.
441      */
442     function UpgradeableToken(address _upgradeMaster) {
443         upgradeMaster = _upgradeMaster;
444     }
445 
446     /**
447      * Allow the token holder to upgrade some of their tokens to a new contract.
448      */
449     function upgrade(uint256 value) public {
450         require(value != 0);
451         UpgradeState state = getUpgradeState();
452         assert(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
453         assert(value <= balanceOf(msg.sender));
454 
455         balances[msg.sender] = balances[msg.sender].sub(value);
456 
457         // Take tokens out from circulation
458         totalSupply = totalSupply.sub(value);
459         totalUpgraded = totalUpgraded.add(value);
460 
461         // Upgrade agent reissues the tokens
462         upgradeAgent.upgradeFrom(msg.sender, value);
463         Upgrade(msg.sender, upgradeAgent, value);
464     }
465 
466     /**
467      * Set an upgrade agent that handles
468      */
469     function setUpgradeAgent(address agent) external {
470         require(agent != 0x0 && msg.sender == upgradeMaster);
471         assert(canUpgrade());
472         upgradeAgent = UpgradeAgent(agent);
473         assert(upgradeAgent.isUpgradeAgent());
474         assert(upgradeAgent.originalSupply() == totalSupply);
475         UpgradeAgentSet(upgradeAgent);
476     }
477 
478     /**
479      * Get the state of the token upgrade.
480      */
481     function getUpgradeState() public constant returns(UpgradeState) {
482         if(!canUpgrade()) return UpgradeState.NotAllowed;
483         else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
484         else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
485         else return UpgradeState.Upgrading;
486     }
487 
488     /**
489      * Change the upgrade master.
490      *
491      * This allows us to set a new owner for the upgrade mechanism.
492      */
493     function setUpgradeMaster(address master) public {
494         require(master != 0x0 && msg.sender == upgradeMaster);
495         upgradeMaster = master;
496     }
497 
498     /**
499      * Child contract can enable to provide the condition when the upgrade can begun.
500      */
501     function canUpgrade() public constant returns(bool) {
502         return true;
503     }
504 
505 }
506 
507 // File: contracts/token/AlgoryToken.sol
508 
509 /**
510  * @title Algory Token
511  *
512  * @dev based on OpenZeppelin
513  *
514  * Apache License, version 2.0 https://github.com/AlgoryProject/algory-ico/blob/master/LICENSE
515  */
516 contract AlgoryToken is UpgradeableToken, CrowdsaleToken {
517 
518     string public name = 'Algory';
519     string public symbol = 'ALG';
520     uint public decimals = 18;
521 
522     uint256 public INITIAL_SUPPLY = 75000000 * (10 ** uint256(decimals));
523 
524     event UpdatedTokenInformation(string newName, string newSymbol);
525 
526     function AlgoryToken() UpgradeableToken(msg.sender) {
527         owner = msg.sender;
528         totalSupply = INITIAL_SUPPLY;
529         balances[owner] = totalSupply;
530     }
531 
532     function canUpgrade() public constant returns(bool) {
533         return released && super.canUpgrade();
534     }
535 
536     function setTokenInformation(string _name, string _symbol) onlyOwner {
537         name = _name;
538         symbol = _symbol;
539         UpdatedTokenInformation(name, symbol);
540     }
541 
542 }