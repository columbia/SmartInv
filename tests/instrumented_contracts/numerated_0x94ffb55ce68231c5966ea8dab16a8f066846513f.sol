1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 pragma solidity ^0.4.15;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 /**
43  * @title ERC20Basic
44  * @dev Simpler version of ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/179
46  */
47 contract ERC20Basic {
48   uint256 public totalSupply;
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) public view returns (uint256);
60   function transferFrom(address from, address to, uint256 value) public returns (bool);
61   function approve(address spender, uint256 value) public returns (bool);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 /**
66  * Upgrade agent interface inspired by Lunyr.
67  *
68  * Upgrade agent transfers tokens to a new contract.
69  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
70  */
71 contract UpgradeAgent {
72 
73   uint public originalSupply;
74 
75   /** Interface marker */
76   function isUpgradeAgent() public constant returns (bool) {
77     return true;
78   }
79 
80   function upgradeFrom(address _from, uint256 _value) public;
81 
82 }
83 
84 /**
85  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
86  *
87  * Based on code by FirstBlood:
88  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract StandardToken is ERC20 {
91   using SafeMath for uint;
92   /* Token supply got increased and a new owner received these tokens */
93   event Minted(address receiver, uint amount);
94 
95   /* Actual balances of token holders */
96   mapping(address => uint) balances;
97 
98   /* approve() allowances */
99   mapping (address => mapping (address => uint)) allowed;
100 
101   /* Interface declaration */
102   function isToken() public constant returns (bool weAre) {
103     return true;
104   }
105 
106   function transfer(address _to, uint _value) returns (bool success) {
107     balances[msg.sender] = balances[msg.sender].sub( _value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
114     uint _allowance = allowed[_from][msg.sender];
115 
116     balances[_to] = balances[_to].add(_value);
117     balances[_from] = balances[_from].sub(_value);
118     allowed[_from][msg.sender] = _allowance.sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function balanceOf(address _owner) constant returns (uint balance) {
124     return balances[_owner];
125   }
126 
127   function approve(address _spender, uint _value) returns (bool success) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) 
134       revert();
135 
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   function allowance(address _owner, address _spender) constant returns (uint remaining) {
142     return allowed[_owner][_spender];
143   }
144 
145 }
146 
147 
148 /**
149  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
150  *
151  * First envisioned by Golem and Lunyr projects.
152  */
153 contract UpgradeableToken is StandardToken {
154   using SafeMath for uint256;
155   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
156   address public upgradeMaster;
157 
158   /** The next contract where the tokens will be migrated. */
159   UpgradeAgent public upgradeAgent;
160 
161   /** How many tokens we have upgraded by now. */
162   uint256 public totalUpgraded;
163 
164   /**
165    * Upgrade states.
166    *
167    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
168    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
169    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
170    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
171    *
172    */
173   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
174 
175   /**
176    * Somebody has upgraded some of his tokens.
177    */
178   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
179 
180   /**
181    * New upgrade agent available.
182    */
183   event UpgradeAgentSet(address agent);
184 
185   /**
186    * Do not allow construction without upgrade master set.
187    */
188   function UpgradeableToken(address _upgradeMaster) {
189     upgradeMaster = _upgradeMaster;
190   }
191 
192   /**
193    * Allow the token holder to upgrade some of their tokens to a new contract.
194    */
195   function upgrade(uint256 value) public {
196 
197       UpgradeState state = getUpgradeState();
198       if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
199         // Called in a bad state
200         revert();
201       }
202 
203       // Validate input value.
204       if (value == 0) revert();
205 
206       balances[msg.sender] = balances[msg.sender].sub(value);
207 
208       // Take tokens out from circulation
209       totalSupply = totalSupply.sub(value);
210       totalUpgraded = totalUpgraded.add(value);
211 
212       // Upgrade agent reissues the tokens
213       upgradeAgent.upgradeFrom(msg.sender, value);
214       Upgrade(msg.sender, upgradeAgent, value);
215   }
216 
217   /**
218    * Set an upgrade agent that handles
219    */
220   function setUpgradeAgent(address agent) external {
221 
222       if(!canUpgrade()) {
223         // The token is not yet in a state that we could think upgrading
224         revert();
225       }
226 
227       if (agent == 0x0) revert();
228       // Only a master can designate the next agent
229       if (msg.sender != upgradeMaster) revert();
230       // Upgrade has already begun for an agent
231       if (getUpgradeState() == UpgradeState.Upgrading) revert();
232 
233       upgradeAgent = UpgradeAgent(agent);
234 
235       // Bad interface
236       if(!upgradeAgent.isUpgradeAgent()) revert();
237       // Make sure that token supplies match in source and target
238       if (upgradeAgent.originalSupply() != totalSupply) revert();
239 
240       UpgradeAgentSet(upgradeAgent);
241   }
242 
243   /**
244    * Get the state of the token upgrade.
245    */
246   function getUpgradeState() public constant returns(UpgradeState) {
247     if(!canUpgrade()) return UpgradeState.NotAllowed;
248     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
249     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
250     else return UpgradeState.Upgrading;
251   }
252 
253   /**
254    * Change the upgrade master.
255    *
256    * This allows us to set a new owner for the upgrade mechanism.
257    */
258   function setUpgradeMaster(address master) public {
259       if (master == 0x0) revert();
260       if (msg.sender != upgradeMaster) revert();
261       upgradeMaster = master;
262   }
263 
264   /**
265    * Child contract can enable to provide the condition when the upgrade can begun.
266    */
267   function canUpgrade() public constant returns(bool) {
268      return true;
269   }
270 
271 }
272 
273 /**
274  * @title Ownable
275  * @dev The Ownable contract has an owner address, and provides basic authorization control
276  * functions, this simplifies the implementation of "user permissions".
277  */
278 contract Ownable {
279   address public owner;
280 
281 
282   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284 
285   /**
286    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
287    * account.
288    */
289   function Ownable() public {
290     owner = msg.sender;
291   }
292 
293 
294   /**
295    * @dev Throws if called by any account other than the owner.
296    */
297   modifier onlyOwner() {
298     require(msg.sender == owner);
299     _;
300   }
301 
302 
303   /**
304    * @dev Allows the current owner to transfer control of the contract to a newOwner.
305    * @param newOwner The address to transfer ownership to.
306    */
307   function transferOwnership(address newOwner) public onlyOwner {
308     require(newOwner != address(0));
309     OwnershipTransferred(owner, newOwner);
310     owner = newOwner;
311   }
312 
313 }
314 
315 /**
316  * Define interface for releasing the token transfer after a successful crowdsale.
317  */
318 contract ReleasableToken is ERC20, Ownable {
319 
320   /* The finalizer contract that allows unlift the transfer limits on this token */
321   address public releaseAgent;
322 
323   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
324   bool public released = false;
325 
326   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
327   mapping (address => bool) public transferAgents;
328 
329   /**
330    * Limit token transfer until the crowdsale is over.
331    *
332    */
333   modifier canTransfer(address _sender) {
334 
335     if(!released) {
336         if(!transferAgents[_sender]) {
337             revert();
338         }
339     }
340 
341     _;
342   }
343 
344   /**
345    * Set the contract that can call release and make the token transferable.
346    *
347    * Design choice. Allow reset the release agent to fix fat finger mistakes.
348    */
349   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
350 
351     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
352     releaseAgent = addr;
353   }
354 
355   /**
356    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
357    */
358   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
359     transferAgents[addr] = state;
360   }
361 
362   /**
363    * One way function to release the tokens to the wild.
364    *
365    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
366    */
367   function releaseTokenTransfer() public onlyReleaseAgent {
368     released = true;
369   }
370 
371   /** The function can be called only before or after the tokens have been releasesd */
372   modifier inReleaseState(bool releaseState) {
373     if(releaseState != released) {
374         revert();
375     }
376     _;
377   }
378 
379   /** The function can be called only by a whitelisted release agent. */
380   modifier onlyReleaseAgent() {
381     if(msg.sender != releaseAgent) {
382         revert();
383     }
384     _;
385   }
386 
387   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
388     // Call StandardToken.transfer()
389    return super.transfer(_to, _value);
390   }
391 
392   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
393     // Call StandardToken.transferForm()
394     return super.transferFrom(_from, _to, _value);
395   }
396 
397 }
398 
399 
400 /**
401  * Centrally issued Ethereum token.
402  *
403  * We mix in burnable and upgradeable traits.
404  *
405  * Token supply is created in the token contract creation and allocated to owner.
406  * The owner can then transfer from its supply to crowdsale participants.
407  * The owner, or anybody, can burn any excessive tokens they are holding.
408  *
409  */
410 contract CentrallyIssuedToken is UpgradeableToken, ReleasableToken {
411 
412   string public name;
413   string public symbol;
414   uint public decimals;
415 
416   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals) UpgradeableToken(_owner) {
417     name = _name;
418     symbol = _symbol;
419     totalSupply = _totalSupply;
420     decimals = _decimals;
421 
422     balances[_owner] = _totalSupply;
423   }
424 }