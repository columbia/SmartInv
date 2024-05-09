1 pragma solidity 0.4.23;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/zacharykilgore/src/flexa/smart-contracts/contracts/Flexacoin.sol
6 // flattened :  Saturday, 05-Jan-19 14:38:33 UTC
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract UpgradeAgent {
85 
86   uint public originalSupply;
87 
88   /** Interface methods */
89   function isUpgradeAgent() public view returns (bool);
90   function upgradeFrom(address _from, uint256 _value) public;
91 
92 }
93 
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 contract Pausable is Ownable {
102   event Pause();
103   event Unpause();
104 
105   bool public paused = false;
106 
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is not paused.
110    */
111   modifier whenNotPaused() {
112     require(!paused);
113     _;
114   }
115 
116   /**
117    * @dev Modifier to make a function callable only when the contract is paused.
118    */
119   modifier whenPaused() {
120     require(paused);
121     _;
122   }
123 
124   /**
125    * @dev called by the owner to pause, triggers stopped state
126    */
127   function pause() onlyOwner whenNotPaused public {
128     paused = true;
129     emit Pause();
130   }
131 
132   /**
133    * @dev called by the owner to unpause, returns to normal state
134    */
135   function unpause() onlyOwner whenPaused public {
136     paused = false;
137     emit Unpause();
138   }
139 }
140 
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   uint256 totalSupply_;
154 
155   /**
156   * @dev total number of tokens in existence
157   */
158   function totalSupply() public view returns (uint256) {
159     return totalSupply_;
160   }
161 
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[msg.sender]);
170 
171     balances[msg.sender] = balances[msg.sender].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     emit Transfer(msg.sender, _to, _value);
174     return true;
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param _owner The address to query the the balance of.
180   * @return An uint256 representing the amount owned by the passed address.
181   */
182   function balanceOf(address _owner) public view returns (uint256) {
183     return balances[_owner];
184   }
185 
186 }
187 
188 contract Claimable is Ownable {
189   address public pendingOwner;
190 
191   /**
192    * @dev Modifier throws if called by any account other than the pendingOwner.
193    */
194   modifier onlyPendingOwner() {
195     require(msg.sender == pendingOwner);
196     _;
197   }
198 
199   /**
200    * @dev Allows the current owner to set the pendingOwner address.
201    * @param newOwner The address to transfer ownership to.
202    */
203   function transferOwnership(address newOwner) onlyOwner public {
204     pendingOwner = newOwner;
205   }
206 
207   /**
208    * @dev Allows the pendingOwner address to finalize the transfer.
209    */
210   function claimOwnership() onlyPendingOwner public {
211     emit OwnershipTransferred(owner, pendingOwner);
212     owner = pendingOwner;
213     pendingOwner = address(0);
214   }
215 }
216 
217 contract StandardToken is ERC20, BasicToken {
218 
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amount of tokens to be transferred
227    */
228   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
229     require(_to != address(0));
230     require(_value <= balances[_from]);
231     require(_value <= allowed[_from][msg.sender]);
232 
233     balances[_from] = balances[_from].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236     emit Transfer(_from, _to, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
242    *
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param _spender The address which will spend the funds.
248    * @param _value The amount of tokens to be spent.
249    */
250   function approve(address _spender, uint256 _value) public returns (bool) {
251     allowed[msg.sender][_spender] = _value;
252     emit Approval(msg.sender, _spender, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens that an owner allowed to a spender.
258    * @param _owner address The address which owns the funds.
259    * @param _spender address The address which will spend the funds.
260    * @return A uint256 specifying the amount of tokens still available for the spender.
261    */
262   function allowance(address _owner, address _spender) public view returns (uint256) {
263     return allowed[_owner][_spender];
264   }
265 
266   /**
267    * @dev Increase the amount of tokens that an owner allowed to a spender.
268    *
269    * approve should be called when allowed[_spender] == 0. To increment
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _addedValue The amount of tokens to increase the allowance by.
275    */
276   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
277     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
293     uint oldValue = allowed[msg.sender][_spender];
294     if (_subtractedValue > oldValue) {
295       allowed[msg.sender][_spender] = 0;
296     } else {
297       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
298     }
299     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303 }
304 
305 library SafeERC20 {
306   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
307     assert(token.transfer(to, value));
308   }
309 
310   function safeTransferFrom(
311     ERC20 token,
312     address from,
313     address to,
314     uint256 value
315   )
316     internal
317   {
318     assert(token.transferFrom(from, to, value));
319   }
320 
321   function safeApprove(ERC20 token, address spender, uint256 value) internal {
322     assert(token.approve(spender, value));
323   }
324 }
325 
326 contract PausableToken is StandardToken, Pausable {
327 
328   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
329     return super.transfer(_to, _value);
330   }
331 
332   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
333     return super.transferFrom(_from, _to, _value);
334   }
335 
336   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
337     return super.approve(_spender, _value);
338   }
339 
340   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
341     return super.increaseApproval(_spender, _addedValue);
342   }
343 
344   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
345     return super.decreaseApproval(_spender, _subtractedValue);
346   }
347 }
348 
349 contract CanReclaimToken is Ownable {
350   using SafeERC20 for ERC20Basic;
351 
352   /**
353    * @dev Reclaim all ERC20Basic compatible tokens
354    * @param token ERC20Basic The address of the token contract
355    */
356   function reclaimToken(ERC20Basic token) external onlyOwner {
357     uint256 balance = token.balanceOf(this);
358     token.safeTransfer(owner, balance);
359   }
360 
361 }
362 
363 contract Recoverable is CanReclaimToken, Claimable {
364   using SafeERC20 for ERC20Basic;
365 
366   /**
367    * @dev Transfer all ether held by the contract to the contract owner.
368    */
369   function reclaimEther() external onlyOwner {
370     owner.transfer(address(this).balance);
371   }
372 
373 }
374 
375 contract UpgradeableToken is StandardToken, Recoverable {
376 
377   /** The contract that will handle the upgrading the tokens. */
378   UpgradeAgent public upgradeAgent;
379 
380   /** How many tokens have been upgraded. */
381   uint256 public totalUpgraded = 0;
382 
383   /**
384    * Upgrade states.
385    *
386    * - `Unknown`: Zero state to prevent erroneous state reporting. Should never be returned
387    * - `NotAllowed`: The child contract has not reached a condition where the upgrade can begin
388    * - `WaitingForAgent`: Allowed to upgrade, but agent has not been set
389    * - `ReadyToUpgrade`: The agent is set, but no tokens has been upgraded yet
390    * - `Upgrading`: Upgrade agent is set, and balance holders are upgrading their tokens
391    */
392   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
393 
394 
395   /**
396    * Event to track that a token holder has upgraded some of their tokens.
397    * @param from Address of the token holder
398    * @param to Address of the upgrade agent
399    * @param value Number of tokens upgraded
400    */
401   event Upgrade(address indexed from, address indexed to, uint256 value);
402 
403   /**
404    * Event to signal that an upgrade agent contract has been set.
405    * @param upgradeAgent Address of the new upgrade agent
406    */
407   event UpgradeAgentSet(address upgradeAgent);
408 
409 
410   /**
411    * @notice Allow the token holder to upgrade some of their tokens to the new
412    * contract.
413    * @param _value The amount of tokens to upgrade
414    */
415   function upgrade(uint256 _value) public {
416     UpgradeState _state = getUpgradeState();
417     require(
418       _state == UpgradeState.ReadyToUpgrade || _state == UpgradeState.Upgrading,
419       "State must be correct for upgrade"
420     );
421     require(_value > 0, "Upgrade value must be greater than zero");
422 
423     // Take tokens out of circulation
424     balances[msg.sender] = balances[msg.sender].sub(_value);
425     totalSupply_ = totalSupply_.sub(_value);
426 
427     totalUpgraded = totalUpgraded.add(_value);
428 
429     // Hand control to upgrade agent to process new tokens for the sender
430     upgradeAgent.upgradeFrom(msg.sender, _value);
431 
432     emit Upgrade(msg.sender, upgradeAgent, _value);
433   }
434 
435   /**
436    * @notice Set an upgrade agent contract to process the upgrade.
437    * @dev The _upgradeAgent contract address must satisfy the UpgradeAgent
438    * interface.
439    * @param _upgradeAgent The address of the new UpgradeAgent smart contract
440    */
441   function setUpgradeAgent(UpgradeAgent _upgradeAgent) external onlyOwner {
442     require(canUpgrade(), "Ensure the token is upgradeable in the first place");
443     require(_upgradeAgent != address(0), "Ensure upgrade agent address is not blank");
444     require(getUpgradeState() != UpgradeState.Upgrading, "Ensure upgrade has not started");
445 
446     upgradeAgent = _upgradeAgent;
447 
448     require(upgradeAgent.isUpgradeAgent(), "New upgradeAgent must be UpgradeAgent");
449     require(
450       upgradeAgent.originalSupply() == totalSupply_,
451       "Make sure that token supplies match in source and target token contracts"
452     );
453 
454     emit UpgradeAgentSet(upgradeAgent);
455   }
456 
457   /**
458    * @notice Get the state of the token upgrade.
459    */
460   function getUpgradeState() public view returns(UpgradeState) {
461     if(!canUpgrade()) return UpgradeState.NotAllowed;
462     else if(address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;
463     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
464     else return UpgradeState.Upgrading;
465   }
466 
467   /**
468    * @notice Can the contract be upgradead?
469    * @dev Child contract must implement and provide the condition when the upgrade
470    * can begin.
471    * @return true if the contract can be upgraded, false if not
472    */
473   function canUpgrade() public view returns(bool);
474 
475 }
476 
477 contract Flexacoin is PausableToken, UpgradeableToken {
478 
479   string public constant name = "Flexacoin";
480   string public constant symbol = "FXC";
481   uint8 public constant decimals = 18;
482 
483   uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
484 
485 
486   /**
487     * @notice Flexacoin (ERC20 Token) contract constructor.
488     * @dev Assigns all tokens to contract creator.
489     */
490   constructor() public {
491     totalSupply_ = INITIAL_SUPPLY;
492     balances[msg.sender] = INITIAL_SUPPLY;
493     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
494   }
495 
496   /**
497    * @dev Allow UpgradeableToken functionality only if contract is not paused.
498    */
499   function canUpgrade() public view returns(bool) {
500     return !paused;
501   }
502 
503 }