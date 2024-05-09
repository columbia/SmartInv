1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8 
9   uint public totalSupply;
10   uint public decimals;
11 
12   function balanceOf(address who) constant returns (uint);
13   function allowance(address owner, address spender) constant returns (uint);
14 
15   function transfer(address to, uint value) returns (bool ok);
16   function transferFrom(address from, address to, uint value) returns (bool ok);
17   function approve(address spender, uint value) returns (bool ok);
18 
19   event Transfer(address indexed from, address indexed to, uint value);
20   event Approval(address indexed owner, address indexed spender, uint value);
21 
22 }
23 
24 
25 /**
26  * @title Ownable
27  * The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31   /* Current Owner */
32   address public owner;
33 
34   /* New owner which can be set in future */
35   address public newOwner;
36 
37   /* event to indicate finally ownership has been succesfully transferred and accepted */
38   event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40   /**
41    * The Ownable constructor sets the original `owner` of the contract to the sender account.
42    */
43   function Ownable() {
44     owner = msg.sender;
45   }
46 
47   /**
48    * Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * Allows the current owner to transfer control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address _newOwner) onlyOwner {
60     require(_newOwner != address(0));
61     newOwner = _newOwner;
62   }
63 
64   /**
65    * Allows the new owner toaccept ownership
66    */
67   function acceptOwnership() {
68     require(msg.sender == newOwner);
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /*
76 *This library is used to do mathematics safely
77 */
78 contract SafeMathLib {
79   function safeMul(uint a, uint b) returns (uint) {
80     uint c = a * b;
81     assert(a == 0 || c / a == b);
82     return c;
83   }
84 
85   function safeSub(uint a, uint b) returns (uint) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   function safeAdd(uint a, uint b) returns (uint) {
91     uint c = a + b;
92     assert(c>=a);
93     return c;
94   }
95 }
96 
97 
98 /**
99  * Upgrade agent interface inspired by Lunyr.
100  * Taken and inspired from https://tokenmarket.net
101  *
102  * Upgrade agent transfers tokens to a new version of a token contract.
103  * Upgrade agent can be set on a token by the upgrade master.
104  *
105  * Steps are
106  * - Upgradeabletoken.upgradeMaster calls UpgradeableToken.setUpgradeAgent()
107  * - Individual token holders can now call UpgradeableToken.upgrade()
108  *   -> This results to call UpgradeAgent.upgradeFrom() that issues new tokens
109  *   -> UpgradeableToken.upgrade() reduces the original total supply based on amount of upgraded tokens
110  *
111  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
112  */
113 contract UpgradeAgent {
114 
115   uint public originalSupply;
116 
117   /** Interface marker */
118   function isUpgradeAgent() public constant returns (bool) {
119     return true;
120   }
121 
122   /**
123    * Upgrade amount of tokens to a new version.
124    *
125    * Only callable by UpgradeableToken.
126    *
127    * @param _tokenHolder Address that wants to upgrade its tokens
128    * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.
129    */
130   function upgradeFrom(address _tokenHolder, uint256 _amount) external;
131 }
132 
133 
134 /**
135  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
136  *
137  * Based on code by FirstBlood:
138  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, SafeMathLib {
141 
142   /* Actual balances of token holders */
143   mapping(address => uint) balances;
144 
145   /* approve() allowances */
146   mapping (address => mapping (address => uint)) allowed;
147 
148   function transfer(address _to, uint _value) returns (bool success) {
149 
150       // SafMaths will automatically handle the overflow checks
151       balances[msg.sender] = safeSub(balances[msg.sender],_value);
152       balances[_to] = safeAdd(balances[_to],_value);
153       Transfer(msg.sender, _to, _value);
154       return true;
155 
156   }
157 
158   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
159 
160     uint _allowance = allowed[_from][msg.sender];
161 
162     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
163     balances[_to] = safeAdd(balances[_to],_value);
164     balances[_from] = safeSub(balances[_from],_value);
165     allowed[_from][msg.sender] = safeSub(_allowance,_value);
166     Transfer(_from, _to, _value);
167     return true;
168 
169   }
170 
171   function balanceOf(address _owner) constant returns (uint balance) {
172     return balances[_owner];
173   }
174 
175   function approve(address _spender, uint _value) returns (bool success) {
176 
177     // To change the approve amount you first have to reduce the addresses`
178     //  allowance to zero by calling `approve(_spender, 0)` if it is not
179     //  already 0 to mitigate the race condition described here:
180     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
182 
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   function allowance(address _owner, address _spender) constant returns (uint remaining) {
189     return allowed[_owner][_spender];
190   }
191 
192 }
193 
194 
195 /**
196  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
197  * First envisioned by Golem and Lunyr projects.
198  * Taken and inspired from https://tokenmarket.net
199  */
200 contract XinfinUpgradeableToken is StandardToken {
201 
202   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
203   address public upgradeMaster;
204 
205   /** The next contract where the tokens will be migrated. */
206   UpgradeAgent public upgradeAgent;
207 
208   /** How many tokens we have upgraded by now. */
209   uint256 public totalUpgraded;
210 
211   /**
212    * Upgrade states.
213    *
214    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
215    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
216    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
217    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
218    *
219    */
220   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
221 
222   /**
223    * Somebody has upgraded some of his tokens.
224    */
225   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
226 
227   /**
228    * New upgrade agent available.
229    */
230   event UpgradeAgentSet(address agent);
231 
232   /**
233    * Do not allow construction without upgrade master set.
234    */
235   function XinfinUpgradeableToken(address _upgradeMaster) {
236     upgradeMaster = _upgradeMaster;
237   }
238 
239   /**
240    * Allow the token holder to upgrade some of their tokens to a new contract.
241    */
242   function upgrade(uint256 value) public {
243 
244       UpgradeState state = getUpgradeState();
245       require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
246 
247       // Validate input value.
248       require(value != 0);
249 
250       balances[msg.sender] = safeSub(balances[msg.sender], value);
251 
252       // Take tokens out from circulation
253       totalSupply = safeSub(totalSupply, value);
254       totalUpgraded = safeAdd(totalUpgraded, value);
255 
256       // Upgrade agent reissues the tokens
257       upgradeAgent.upgradeFrom(msg.sender, value);
258       Upgrade(msg.sender, upgradeAgent, value);
259   }
260 
261   /**
262    * Set an upgrade agent that handles
263    */
264   function setUpgradeAgent(address agent) external {
265 
266 
267       // The token is not yet in a state that we could think upgrading
268       require(canUpgrade());
269 
270       require(agent != 0x0);
271       // Only a master can designate the next agent
272       require(msg.sender == upgradeMaster);
273       // Upgrade has already begun for an agent
274       require(getUpgradeState() != UpgradeState.Upgrading);
275 
276       upgradeAgent = UpgradeAgent(agent);
277 
278       // Bad interface
279       require(upgradeAgent.isUpgradeAgent());
280       // Make sure that token supplies match in source and target
281       require(upgradeAgent.originalSupply() == totalSupply);
282 
283       UpgradeAgentSet(upgradeAgent);
284   }
285 
286   /**
287    * Get the state of the token upgrade.
288    */
289   function getUpgradeState() public constant returns(UpgradeState) {
290     if(!canUpgrade()) return UpgradeState.NotAllowed;
291     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
292     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
293     else return UpgradeState.Upgrading;
294   }
295 
296   /**
297    * Change the upgrade master.
298    *
299    * This allows us to set a new owner for the upgrade mechanism.
300    */
301   function setUpgradeMaster(address master) public {
302       require(master != 0x0);
303       require(msg.sender == upgradeMaster);
304       upgradeMaster = master;
305   }
306 
307   /**
308    * Child contract can enable to provide the condition when the upgrade can begun.
309    */
310   function canUpgrade() public constant returns(bool) {
311      return true;
312   }
313 
314 }
315 
316 
317 /**
318  * Define interface for releasing the token transfer after a successful crowdsale.
319  * Taken and inspired from https://tokenmarket.net
320  */
321 contract ReleasableToken is ERC20, Ownable {
322 
323   /* The finalizer contract that allows unlift the transfer limits on this token */
324   address public releaseAgent;
325 
326   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
327   bool public released = false;
328 
329   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
330   mapping (address => bool) public transferAgents;
331 
332   /**
333    * Limit token transfer until the crowdsale is over.
334    *
335    */
336   modifier canTransfer(address _sender) {
337 
338     if(!released) {
339         require(transferAgents[_sender]);
340     }
341 
342     _;
343   }
344 
345   /**
346    * Set the contract that can call release and make the token transferable.
347    */
348   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
349 
350     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
351     releaseAgent = addr;
352   }
353 
354   /**
355    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
356    */
357   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
358     transferAgents[addr] = state;
359   }
360 
361   /**
362    * One way function to release the tokens to the wild.
363    *
364    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
365    */
366   function releaseTokenTransfer() public onlyReleaseAgent {
367     released = true;
368   }
369 
370   /** The function can be called only before or after the tokens have been releasesd */
371   modifier inReleaseState(bool releaseState) {
372     require(releaseState == released);
373     _;
374   }
375 
376   /** The function can be called only by a whitelisted release agent. */
377   modifier onlyReleaseAgent() {
378     require(msg.sender == releaseAgent);
379     _;
380   }
381 
382 
383   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
384     // Call StandardToken.transfer()
385    return super.transfer(_to, _value);
386   }
387 
388   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
389     // Call StandardToken.transferFrom()
390     return super.transferFrom(_from, _to, _value);
391   }
392 
393 }
394 
395 
396 contract Coin is XinfinUpgradeableToken, ReleasableToken {
397 
398   event UpdatedTokenInformation(string newName, string newSymbol);
399 
400   /* name of the token */
401   string public name = "XinFin XDCE";
402 
403   /* symbol of the token */
404   string public symbol = "XDCE";
405 
406   /* token decimals to handle fractions */
407   uint public decimals = 18;
408 
409   //Crowdsale running
410   bool public isCrowdsaleOpen=false;
411 
412   /* initial token supply */
413   uint public totalSupply = 15000000000 * (10 ** decimals);
414   uint public onSaleTokens = 10000000000 * (10 ** decimals);
415 
416 
417   uint tokensForPublicSale = 0;
418 
419   address contractAddress;
420 
421   uint256 pricePerToken = 7518796992481; //1 Eth = 133000 XDCE
422 
423   uint minETH = 0 * 10**decimals; // 0 ether
424   uint maxETH = 15 * 10**decimals; // 15 ether
425 
426   function Coin() XinfinUpgradeableToken(msg.sender) {
427 
428     owner = msg.sender;
429     contractAddress = address(this);
430     //tokens are kept in contract address rather than owner
431     balances[contractAddress] = totalSupply;
432   }
433 
434   /* function to update token name and symbol */
435   function updateTokenInformation(string _name, string _symbol) onlyOwner {
436     name = _name;
437     symbol = _symbol;
438     UpdatedTokenInformation(name, symbol);
439   }
440 
441 
442   function sendTokensToOwner(uint _tokens) onlyOwner returns (bool ok){
443       require(balances[contractAddress] >= _tokens);
444       balances[contractAddress] = safeSub(balances[contractAddress],_tokens);
445       balances[owner] = safeAdd(balances[owner],_tokens);
446       return true;
447   }
448 
449 
450   /* single address */
451   function sendTokensToInvestors(address _investor, uint _tokens) onlyOwner returns (bool ok){
452       require(balances[contractAddress] >= _tokens);
453       onSaleTokens = safeSub(onSaleTokens, _tokens);
454       balances[contractAddress] = safeSub(balances[contractAddress],_tokens);
455       balances[_investor] = safeAdd(balances[_investor],_tokens);
456       return true;
457   }
458 
459 
460 
461   /* A dispense feature to allocate some addresses with Xinfin tokens
462   * calculation done using token count
463   *  Can be called only by owner
464   */
465   function dispenseTokensToInvestorAddressesByValue(address[] _addresses, uint[] _value) onlyOwner returns (bool ok){
466      require(_addresses.length == _value.length);
467      for(uint256 i=0; i<_addresses.length; i++){
468         onSaleTokens = safeSub(onSaleTokens, _value[i]);
469         balances[_addresses[i]] = safeAdd(balances[_addresses[i]], _value[i]);
470         balances[contractAddress] = safeSub(balances[contractAddress], _value[i]);
471      }
472      return true;
473   }
474 
475 
476   function startCrowdSale() onlyOwner {
477      isCrowdsaleOpen=true;
478   }
479 
480    function stopCrowdSale() onlyOwner {
481      isCrowdsaleOpen=false;
482   }
483 
484 
485  function setPublicSaleParams(uint _tokensForPublicSale, uint _min, uint _max, bool _crowdsaleStatus ) onlyOwner {
486     require(_tokensForPublicSale != 0);
487     require(_tokensForPublicSale <= onSaleTokens);
488     tokensForPublicSale = _tokensForPublicSale;
489     isCrowdsaleOpen=_crowdsaleStatus;
490     require(_min >= 0);
491     require(_max > 0);
492     minETH = _min;
493     maxETH = _max;
494  }
495 
496 
497  function setTotalTokensForPublicSale(uint _value) onlyOwner{
498       require(_value != 0);
499       tokensForPublicSale = _value;
500   }
501 
502  function increaseSupply(uint value) onlyOwner returns (bool) {
503   totalSupply = safeAdd(totalSupply, value);
504   balances[contractAddress] = safeAdd(balances[contractAddress], value);
505   Transfer(0x0, contractAddress, value);
506   return true;
507 }
508 
509 function decreaseSupply(uint value) onlyOwner returns (bool) {
510   balances[contractAddress] = safeSub(balances[contractAddress], value);
511   totalSupply = safeSub(totalSupply, value);
512   Transfer(contractAddress, 0x0, value);
513   return true;
514 }
515 
516   function setMinAndMaxEthersForPublicSale(uint _min, uint _max) onlyOwner{
517       require(_min >= 0);
518       require(_max > 0);
519       minETH = _min;
520       maxETH = _max;
521   }
522 
523   function updateTokenPrice(uint _value) onlyOwner{
524       require(_value != 0);
525       pricePerToken = _value;
526   }
527 
528 
529   function updateOnSaleSupply(uint _newSupply) onlyOwner{
530       require(_newSupply != 0);
531       onSaleTokens = _newSupply;
532   }
533 
534 
535   function buyTokens() public payable returns(uint tokenAmount) {
536 
537     uint _tokenAmount;
538     uint multiplier = (10 ** decimals);
539     uint weiAmount = msg.value;
540 
541     require(isCrowdsaleOpen);
542     //require(whitelistedAddress[msg.sender]);
543 
544     require(weiAmount >= minETH);
545     require(weiAmount <= maxETH);
546 
547     _tokenAmount =  safeMul(weiAmount,multiplier) / pricePerToken;
548 
549     require(_tokenAmount > 0);
550 
551     //safe sub will automatically handle overflows
552     tokensForPublicSale = safeSub(tokensForPublicSale, _tokenAmount);
553     onSaleTokens = safeSub(onSaleTokens, _tokenAmount);
554     balances[contractAddress] = safeSub(balances[contractAddress],_tokenAmount);
555     //assign tokens
556     balances[msg.sender] = safeAdd(balances[msg.sender], _tokenAmount);
557 
558     //send money to the owner
559     require(owner.send(weiAmount));
560 
561     return _tokenAmount;
562 
563   }
564 
565   // There is no need for vesting. It will be done manually by manually releasing tokens to certain addresses
566 
567   function() payable {
568       buyTokens();
569   }
570 
571   function destroyToken() public onlyOwner {
572       selfdestruct(msg.sender);
573   }
574 
575 }