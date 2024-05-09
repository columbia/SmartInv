1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 
8 contract ERC20 {
9 
10   uint public totalSupply;
11   uint public decimals;
12 
13   function balanceOf(address who) constant returns (uint);
14   function allowance(address owner, address spender) constant returns (uint);
15 
16   function transfer(address to, uint value) returns (bool ok);
17   function transferFrom(address from, address to, uint value) returns (bool ok);
18   function approve(address spender, uint value) returns (bool ok);
19 
20   event Transfer(address indexed from, address indexed to, uint value);
21   event Approval(address indexed owner, address indexed spender, uint value);
22 
23 }
24 
25 
26 /**
27  * @title Ownable
28  * The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   /* Current Owner */
33   address public owner;
34 
35   /* New owner which can be set in future */
36   address public newOwner;
37 
38   /* event to indicate finally ownership has been succesfully transferred and accepted */
39   event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41   /**
42    * The Ownable constructor sets the original `owner` of the contract to the sender account.
43    */
44   function Ownable() {
45     owner = msg.sender;
46   }
47 
48   /**
49    * Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   /**
57    * Allows the current owner to transfer control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address _newOwner) onlyOwner {
61     require(_newOwner != address(0));
62     newOwner = _newOwner;
63   }
64 
65   /**
66    * Allows the new owner toaccept ownership
67    */
68   function acceptOwnership() {
69     require(msg.sender == newOwner);
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /*
77 *This library is used to do mathematics safely
78 */
79 contract SafeMathLib {
80   function safeMul(uint a, uint b) returns (uint) {
81     uint c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function safeSub(uint a, uint b) returns (uint) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   function safeAdd(uint a, uint b) returns (uint) {
92     uint c = a + b;
93     assert(c>=a);
94     return c;
95   }
96 }
97 
98 
99 /**
100  * Upgrade agent interface inspired by Lunyr.
101  * Taken and inspired from https://tokenmarket.net
102  *
103  * Upgrade agent transfers tokens to a new version of a token contract.
104  * Upgrade agent can be set on a token by the upgrade master.
105  *
106  * Steps are
107  * - Upgradeabletoken.upgradeMaster calls UpgradeableToken.setUpgradeAgent()
108  * - Individual token holders can now call UpgradeableToken.upgrade()
109  *   -> This results to call UpgradeAgent.upgradeFrom() that issues new tokens
110  *   -> UpgradeableToken.upgrade() reduces the original total supply based on amount of upgraded tokens
111  *
112  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
113  */
114 contract UpgradeAgent {
115 
116   uint public originalSupply;
117 
118   /** Interface marker */
119   function isUpgradeAgent() public constant returns (bool) {
120     return true;
121   }
122 
123   /**
124    * Upgrade amount of tokens to a new version.
125    *
126    * Only callable by UpgradeableToken.
127    *
128    * @param _tokenHolder Address that wants to upgrade its tokens
129    * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.
130    */
131   function upgradeFrom(address _tokenHolder, uint256 _amount) external;
132 }
133 
134 
135 /**
136  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
137  *
138  * Based on code by FirstBlood:
139  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, SafeMathLib {
142 
143   /* Actual balances of token holders */
144   mapping(address => uint) balances;
145 
146   /* approve() allowances */
147   mapping (address => mapping (address => uint)) allowed;
148 
149   function transfer(address _to, uint _value) returns (bool success) {
150 
151       // SafMaths will automatically handle the overflow checks
152       balances[msg.sender] = safeSub(balances[msg.sender],_value);
153       balances[_to] = safeAdd(balances[_to],_value);
154       Transfer(msg.sender, _to, _value);
155       return true;
156 
157   }
158 
159   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
160 
161     uint _allowance = allowed[_from][msg.sender];
162 
163     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
164     balances[_to] = safeAdd(balances[_to],_value);
165     balances[_from] = safeSub(balances[_from],_value);
166     allowed[_from][msg.sender] = safeSub(_allowance,_value);
167     Transfer(_from, _to, _value);
168     return true;
169 
170   }
171 
172   function balanceOf(address _owner) constant returns (uint balance) {
173     return balances[_owner];
174   }
175 
176   function approve(address _spender, uint _value) returns (bool success) {
177 
178     // To change the approve amount you first have to reduce the addresses`
179     //  allowance to zero by calling `approve(_spender, 0)` if it is not
180     //  already 0 to mitigate the race condition described here:
181     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
183 
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   function allowance(address _owner, address _spender) constant returns (uint remaining) {
190     return allowed[_owner][_spender];
191   }
192 
193 }
194 
195 
196 /**
197  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
198  * First envisioned by Golem and Lunyr projects.
199  * Taken and inspired from https://tokenmarket.net
200  */
201 contract CMBUpgradeableToken is StandardToken {
202 
203   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
204   address public upgradeMaster;
205 
206   /** The next contract where the tokens will be migrated. */
207   UpgradeAgent public upgradeAgent;
208 
209   /** How many tokens we have upgraded by now. */
210   uint256 public totalUpgraded;
211 
212   /**
213    * Upgrade states.
214    *
215    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
216    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
217    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
218    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
219    *
220    */
221   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
222 
223   /**
224    * Somebody has upgraded some of his tokens.
225    */
226   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
227 
228   /**
229    * New upgrade agent available.
230    */
231   event UpgradeAgentSet(address agent);
232 
233   /**
234    * Do not allow construction without upgrade master set.
235    */
236   function CMBUpgradeableToken(address _upgradeMaster) {
237     upgradeMaster = _upgradeMaster;
238   }
239 
240   /**
241    * Allow the token holder to upgrade some of their tokens to a new contract.
242    */
243   function upgrade(uint256 value) public {
244 
245       UpgradeState state = getUpgradeState();
246       require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
247 
248       // Validate input value.
249       require(value != 0);
250 
251       balances[msg.sender] = safeSub(balances[msg.sender], value);
252 
253       // Take tokens out from circulation
254       totalSupply = safeSub(totalSupply, value);
255       totalUpgraded = safeAdd(totalUpgraded, value);
256 
257       // Upgrade agent reissues the tokens
258       upgradeAgent.upgradeFrom(msg.sender, value);
259       Upgrade(msg.sender, upgradeAgent, value);
260   }
261 
262   /**
263    * Set an upgrade agent that handles
264    */
265   function setUpgradeAgent(address agent) external {
266 
267 
268       // The token is not yet in a state that we could think upgrading
269       require(canUpgrade());
270 
271       require(agent != 0x0);
272       // Only a master can designate the next agent
273       require(msg.sender == upgradeMaster);
274       // Upgrade has already begun for an agent
275       require(getUpgradeState() != UpgradeState.Upgrading);
276 
277       upgradeAgent = UpgradeAgent(agent);
278 
279       // Bad interface
280       require(upgradeAgent.isUpgradeAgent());
281       // Make sure that token supplies match in source and target
282       require(upgradeAgent.originalSupply() == totalSupply);
283 
284       UpgradeAgentSet(upgradeAgent);
285   }
286 
287   /**
288    * Get the state of the token upgrade.
289    */
290   function getUpgradeState() public constant returns(UpgradeState) {
291     if(!canUpgrade()) return UpgradeState.NotAllowed;
292     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
293     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
294     else return UpgradeState.Upgrading;
295   }
296 
297   /**
298    * Change the upgrade master.
299    *
300    * This allows us to set a new owner for the upgrade mechanism.
301    */
302   function setUpgradeMaster(address master) public {
303       require(master != 0x0);
304       require(msg.sender == upgradeMaster);
305       upgradeMaster = master;
306   }
307 
308   /**
309    * Child contract can enable to provide the condition when the upgrade can begun.
310    */
311   function canUpgrade() public constant returns(bool) {
312      return true;
313   }
314 
315 }
316 
317 
318 /**
319  * Define interface for releasing the token transfer after a successful crowdsale.
320  * Taken and inspired from https://tokenmarket.net
321  */
322 contract ReleasableToken is ERC20, Ownable {
323 
324   /* The finalizer contract that allows unlift the transfer limits on this token */
325   address public releaseAgent;
326 
327   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
328   bool public released = false;
329 
330   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
331   mapping (address => bool) public transferAgents;
332 
333   /**
334    * Limit token transfer until the crowdsale is over.
335    *
336    */
337   modifier canTransfer(address _sender) {
338 
339     if(!released) {
340         require(transferAgents[_sender]);
341     }
342 
343     _;
344   }
345 
346   /**
347    * Set the contract that can call release and make the token transferable.
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
373     require(releaseState == released);
374     _;
375   }
376 
377   /** The function can be called only by a whitelisted release agent. */
378   modifier onlyReleaseAgent() {
379     require(msg.sender == releaseAgent);
380     _;
381   }
382 
383 
384   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
385     // Call StandardToken.transfer()
386    return super.transfer(_to, _value);
387   }
388 
389   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
390     // Call StandardToken.transferFrom()
391     return super.transferFrom(_from, _to, _value);
392   }
393 
394 }
395 
396 
397 contract Coin is CMBUpgradeableToken, ReleasableToken {
398 
399   event UpdatedTokenInformation(string newName, string newSymbol);
400 
401   /* name of the token */
402   string public name = "Creatanium";
403 
404   /* symbol of the token */
405   string public symbol = "CMB";
406 
407   /* token decimals to handle fractions */
408   uint public decimals = 18;
409 
410 /* initial token supply */
411   uint public totalSupply = 2000000000 * (10 ** decimals);
412   uint public onSaleTokens = 30000000 * (10 ** decimals);
413 
414   uint256 pricePerToken = 295898260100000; //1 Eth = 276014352700000 CMB (0.2 USD = 1 CMB)
415 
416 
417   uint minETH = 0 * 10**decimals;
418   uint maxETH = 500 * 10**decimals; 
419 
420 
421   //Crowdsale running
422   bool public isCrowdsaleOpen=false;
423   
424 
425   uint tokensForPublicSale = 0;
426 
427   address contractAddress;
428 
429   
430 
431   function Coin() CMBUpgradeableToken(msg.sender) {
432 
433     owner = msg.sender;
434     contractAddress = address(this);
435     //tokens are kept in contract address rather than owner
436     balances[contractAddress] = totalSupply;
437   }
438 
439   /* function to update token name and symbol */
440   function updateTokenInformation(string _name, string _symbol) onlyOwner {
441     name = _name;
442     symbol = _symbol;
443     UpdatedTokenInformation(name, symbol);
444   }
445 
446 
447   function sendTokensToOwner(uint _tokens) onlyOwner returns (bool ok){
448       require(balances[contractAddress] >= _tokens);
449       balances[contractAddress] = safeSub(balances[contractAddress],_tokens);
450       balances[owner] = safeAdd(balances[owner],_tokens);
451       return true;
452   }
453 
454 
455   /* single address */
456   function sendTokensToInvestors(address _investor, uint _tokens) onlyOwner returns (bool ok){
457       require(balances[contractAddress] >= _tokens);
458       onSaleTokens = safeSub(onSaleTokens, _tokens);
459       balances[contractAddress] = safeSub(balances[contractAddress],_tokens);
460       balances[_investor] = safeAdd(balances[_investor],_tokens);
461       return true;
462   }
463 
464 
465 
466   /* A dispense feature to allocate some addresses with CMB tokens
467   * calculation done using token count
468   *  Can be called only by owner
469   */
470   function dispenseTokensToInvestorAddressesByValue(address[] _addresses, uint[] _value) onlyOwner returns (bool ok){
471      require(_addresses.length == _value.length);
472      for(uint256 i=0; i<_addresses.length; i++){
473         onSaleTokens = safeSub(onSaleTokens, _value[i]);
474         balances[_addresses[i]] = safeAdd(balances[_addresses[i]], _value[i]);
475         balances[contractAddress] = safeSub(balances[contractAddress], _value[i]);
476      }
477      return true;
478   }
479 
480 
481   function startCrowdSale() onlyOwner {
482      isCrowdsaleOpen=true;
483   }
484 
485    function stopCrowdSale() onlyOwner {
486      isCrowdsaleOpen=false;
487   }
488 
489 
490  function setPublicSaleParams(uint _tokensForPublicSale, uint _min, uint _max, bool _crowdsaleStatus ) onlyOwner {
491     require(_tokensForPublicSale != 0);
492     require(_tokensForPublicSale <= onSaleTokens);
493     tokensForPublicSale = _tokensForPublicSale;
494     isCrowdsaleOpen=_crowdsaleStatus;
495     require(_min >= 0);
496     require(_max > _min+1);
497     minETH = _min;
498     maxETH = _max;
499  }
500 
501 
502  function setTotalTokensForPublicSale(uint _value) onlyOwner{
503       require(_value != 0);
504       tokensForPublicSale = _value;
505   }
506 
507   function setMinAndMaxEthersForPublicSale(uint _min, uint _max) onlyOwner{
508       require(_min >= 0);
509       require(_max > _min+1);
510       minETH = _min;
511       maxETH = _max;
512   }
513 
514   function updateTokenPrice(uint _value) onlyOwner{
515       require(_value != 0);
516       pricePerToken = _value;
517   }
518 
519 
520   function updateOnSaleSupply(uint _newSupply) onlyOwner{
521       require(_newSupply != 0);
522       onSaleTokens = _newSupply;
523   }
524 
525 
526   function buyTokens() public payable returns(uint tokenAmount) {
527 
528     uint _tokenAmount;
529     uint multiplier = (10 ** decimals);
530     uint weiAmount = msg.value;
531 
532     require(isCrowdsaleOpen);
533     //require(whitelistedAddress[msg.sender]);
534 
535     require(weiAmount >= minETH);
536     require(weiAmount <= maxETH);
537 
538     _tokenAmount =  safeMul(weiAmount,multiplier) / pricePerToken;
539 
540     require(_tokenAmount > 0);
541 
542     //safe sub will automatically handle overflows
543     tokensForPublicSale = safeSub(tokensForPublicSale, _tokenAmount);
544     onSaleTokens = safeSub(onSaleTokens, _tokenAmount);
545     balances[contractAddress] = safeSub(balances[contractAddress],_tokenAmount);
546     //assign tokens
547     balances[msg.sender] = safeAdd(balances[msg.sender], _tokenAmount);
548 
549     //send money to the owner
550     require(owner.send(weiAmount));
551 
552     return _tokenAmount;
553 
554   }
555 
556   // There is no need for vesting. It will be done manually by manually releasing tokens to certain addresses
557 
558   function() payable {
559       buyTokens();
560   }
561 
562   function destroyToken() public onlyOwner {
563       selfdestruct(msg.sender);
564   }
565 
566 }