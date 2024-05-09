1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) return 0;
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44 
45     uint256 public totalSupply;
46 
47     function balanceOf(address who) public view returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51 }
52 
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 is ERC20Basic {
59 
60     function allowance(address owner, address spender) public view returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73 
74     using SafeMath for uint256;
75 
76     mapping(address => uint256) balances;
77 
78     /**
79      * @dev transfer token for a specified address
80      * @param _to The address to transfer to.
81      * @param _value The amount to be transferred.
82      */
83     function transfer(address _to, uint256 _value) public returns (bool) {
84         require(_to != address(0));
85         require(_value <= balances[msg.sender]);
86 
87         // SafeMath.sub will throw if there is not enough balance.
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     /**
95      * @dev Gets the balance of the specified address.
96      * @param _owner The address to query the the balance of.
97      * @return An uint256 representing the amount owned by the passed address.
98      */
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103 }
104 
105 
106 /**
107  * @title Ownable
108  * @dev The Ownable contract has an owner address, and provides basic authorization control
109  * functions, this simplifies the implementation of "user permissions".
110  */
111 contract Ownable {
112 
113     address public owner;
114 
115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116 
117     /**
118      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
119      * account.
120      */
121     function Ownable() public {
122         owner = msg.sender;
123     }
124 
125     /**
126      * @dev Throws if called by any account other than the owner.
127      */
128     modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132 
133     /**
134      * @dev Allows the current owner to transfer control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function transferOwnership(address newOwner) public onlyOwner {
138         require(newOwner != address(0));
139         OwnershipTransferred(owner, newOwner);
140         owner = newOwner;
141     }
142 
143 }
144 
145 
146 /**
147  * @title Standard ERC20 token
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154     mapping (address => mapping (address => uint256)) internal allowed;
155 
156     /**
157      * @dev Transfer tokens from one address to another
158      * @param _from address The address which you want to send tokens from
159      * @param _to address The address which you want to transfer to
160      * @param _value uint256 the amount of tokens to be transferred
161      */
162     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163         require(_to != address(0));
164         require(_value <= balances[_from]);
165         require(_value <= allowed[_from][msg.sender]);
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     /**
174      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175      *
176      * Beware that changing an allowance with this method brings the risk that someone may use both the old
177      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      * @param _spender The address which will spend the funds.
181      * @param _value The amount of tokens to be spent.
182     */
183     function approve(address _spender, uint256 _value) public returns (bool) {
184         allowed[msg.sender][_spender] = _value;
185         Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 
189     /**
190      * @dev Function to check the amount of tokens that an owner allowed to a spender.
191      * @param _owner address The address which owns the funds.
192      * @param _spender address The address which will spend the funds.
193      * @return A uint256 specifying the amount of tokens still available for the spender.
194      */
195     function allowance(address _owner, address _spender) public view returns (uint256) {
196         return allowed[_owner][_spender];
197     }
198 
199     /**
200      * @dev Increase the amount of tokens that an owner allowed to a spender.
201      *
202      * approve should be called when allowed[_spender] == 0. To increment
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * @param _spender The address which will spend the funds.
207      * @param _addedValue The amount of tokens to increase the allowance by.
208      */
209     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212         return true;
213     }
214 
215     /**
216      * @dev Decrease the amount of tokens that an owner allowed to a spender.
217      *
218      * approve should be called when allowed[_spender] == 0. To decrement
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * @param _spender The address which will spend the funds.
223      * @param _subtractedValue The amount of tokens to decrease the allowance by.
224      */
225     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226         uint oldValue = allowed[msg.sender][_spender];
227         if (_subtractedValue > oldValue) {
228             allowed[msg.sender][_spender] = 0;
229         }
230         else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237 }
238 
239 
240 /**
241  * @title Pausable
242  * @dev Base contract which allows children to implement an emergency stop mechanism.
243  */
244 contract Pausable is Ownable {
245 
246     bool public paused = false;
247 
248     event Pause();
249     event Unpause();
250 
251     /**
252      * @dev Modifier to make a function callable only when the contract is not paused.
253      */
254     modifier whenNotPaused() {
255         require(!paused);
256         _;
257     }
258 
259     /**
260      * @dev Modifier to make a function callable only when the contract is paused.
261      */
262     modifier whenPaused() {
263         require(paused);
264         _;
265     }
266 
267     /**
268      * @dev called by the owner to pause, triggers stopped state
269      */
270     function pause() onlyOwner whenNotPaused public {
271         paused = true;
272         Pause();
273     }
274 
275     /**
276      * @dev called by the owner to unpause, returns to normal state
277      */
278     function unpause() onlyOwner whenPaused public {
279         paused = false;
280         Unpause();
281     }
282 
283 }
284 
285 
286 /**
287  * @title Pausable token
288  *
289  * @dev StandardToken modified with pausable transfers.
290  **/
291 contract PausableToken is StandardToken, Pausable {
292 
293     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
294         return super.transfer(_to, _value);
295     }
296 
297     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
298         return super.transferFrom(_from, _to, _value);
299     }
300 
301     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
302         return super.approve(_spender, _value);
303     }
304 
305     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
306         return super.increaseApproval(_spender, _addedValue);
307     }
308 
309     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
310         return super.decreaseApproval(_spender, _subtractedValue);
311     }
312 
313 }
314 
315 
316 /**
317  * @title Capped Mintable token
318  * @dev Simple ERC20 Token example, with mintable token creation
319  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
320  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
321  */
322 contract CappedMintableToken is PausableToken {
323 
324     uint256 public hard_cap;
325     // List of agents that are allowed to create new tokens
326     mapping (address => bool) mintAgents;
327 
328     event MintingAgentChanged(address addr, bool state);
329     event Mint(address indexed to, uint256 amount);
330 
331     /*
332      * @dev Modifier to check if `msg.sender` is an agent allowed to create new tokens
333      */
334     modifier onlyMintAgent() {
335         require(mintAgents[msg.sender]);
336         _;
337     }
338 
339     /**
340      * @dev Owner can allow a crowdsale contract to mint new tokens
341      */
342     function setMintAgent(address addr, bool state) onlyOwner whenNotPaused  public {
343         mintAgents[addr] = state;
344         MintingAgentChanged(addr, state);
345     }
346 
347     /**
348      * @dev Function to mint tokens
349      * @param _to The address that will receive the minted tokens.
350      * @param _amount The amount of tokens to mint.
351      * @return A boolean that indicates if the operation was successful.
352      */
353     function mint(address _to, uint256 _amount) onlyMintAgent whenNotPaused public returns (bool) {
354         require (totalSupply.add(_amount) <= hard_cap);
355         totalSupply = totalSupply.add(_amount);
356         balances[_to] = balances[_to].add(_amount);
357         Mint(_to, _amount);
358         Transfer(address(0), _to, _amount);
359         return true;
360     }
361 
362     /**
363      * @dev Gets if an specified address is allowed to mint tokens
364      * @param _user The address to query if is allowed to mint tokens
365      * @return An bool representing if the address passed is allowed to mint tokens 
366      */
367     function isMintAgent(address _user) public view returns (bool state) {
368         return mintAgents[_user];
369     }
370 
371 }
372 
373 
374 /**
375  * @title Platform Token
376  * @dev Contract that allows the Genbby platform to work properly and being scalable
377  */
378 contract PlatformToken is CappedMintableToken {
379 
380     mapping (address => bool) trustedContract;
381 
382     event TrustedContract(address addr, bool state);
383 
384     /**
385      * @dev Modifier that check that `msg.sender` is an trusted contract
386      */
387     modifier onlyTrustedContract() {
388         require(trustedContract[msg.sender]);
389         _;
390     }
391 
392     /**
393      * @dev The owner can set a contract as a trusted contract
394      */
395     function setTrustedContract(address addr, bool state) onlyOwner whenNotPaused public {
396         trustedContract[addr] = state;
397         TrustedContract(addr, state);
398     }
399 
400     /**
401      * @dev Function that trusted contracts can use to perform any buying that users do in the platform
402      */
403     function buy(address who, uint256 amount) onlyTrustedContract whenNotPaused public {
404         require (balances[who] >= amount);
405         balances[who] = balances[who].sub(amount);
406         totalSupply = totalSupply.sub(amount);
407     }
408 
409     /**
410      * @dev Function to check if a contract is marked as a trusted one
411      * @param _contract The address of the contract to query of
412      * @return A bool indicanting if the passed contract is considered as a trusted one
413      */
414     function isATrustedContract(address _contract) public view returns (bool state) {
415         return trustedContract[_contract];
416     }
417 
418 }
419 
420 
421 /**
422  * @title UpgradeAgent
423  * @dev Interface of a contract that transfers tokens to itself
424  * Inspired by Lunyr
425  */
426 contract UpgradeAgent {
427 
428     function upgradeBalance(address who, uint256 amount) public;
429     function upgradeAllowance(address _owner, address _spender, uint256 amount) public;
430     function upgradePendingExchange(address _owner, uint256 amount) public;
431 
432 }
433 
434 
435 /**
436  * @title UpgradableToken
437  * @dev Allows users to transfers their tokens to a new contract when the token is paused and upgrading 
438  * It is like a guard for unexpected situations 
439  */
440 contract UpgradableToken is PlatformToken {
441 
442     // The next contract where the tokens will be migrated
443     UpgradeAgent public upgradeAgent;
444     uint256 public totalSupplyUpgraded;
445     bool public upgrading = false;
446 
447     event UpgradeBalance(address who, uint256 amount);
448     event UpgradeAllowance(address owner, address spender, uint256 amount);
449     event UpgradePendingExchange(address owner, uint256 value);
450     event UpgradeStateChange(bool state);
451 
452 
453     /**
454      * @dev Modifier to make a function callable only when the contract is upgrading
455      */
456     modifier whenUpgrading() {
457         require(upgrading);
458         _;
459     }
460 
461     /**
462      * @dev Function that allows the `owner` to set the upgrade agent
463      */
464     function setUpgradeAgent(address addr) onlyOwner public {
465         upgradeAgent = UpgradeAgent(addr);
466     }
467 
468     /**
469      * @dev called by the owner when token is paused, triggers upgrading state
470      */
471     function startUpgrading() onlyOwner whenPaused public {
472         upgrading = true;
473         UpgradeStateChange(true);
474     }
475 
476     /**
477      * @dev called by the owner then token is paused and upgrading, returns to a non-upgrading state
478      */
479     function stopUpgrading() onlyOwner whenPaused whenUpgrading public {
480         upgrading = false;
481         UpgradeStateChange(false);
482     }
483 
484     /**
485      * @dev Allows anybody to upgrade tokens from these contract to the new one
486      */
487     function upgradeBalanceOf(address who) whenUpgrading public {
488         uint256 value = balances[who];
489         require (value != 0);
490         balances[who] = 0;
491         totalSupply = totalSupply.sub(value);
492         totalSupplyUpgraded = totalSupplyUpgraded.add(value);
493         upgradeAgent.upgradeBalance(who, value);
494         UpgradeBalance(who, value);
495     }
496 
497     /**
498      * @dev Allows anybody to upgrade allowances from these contract to the new one
499      */
500     function upgradeAllowance(address _owner, address _spender) whenUpgrading public {
501         uint256 value = allowed[_owner][_spender];
502         require (value != 0);
503         allowed[_owner][_spender] = 0;
504         upgradeAgent.upgradeAllowance(_owner, _spender, value);
505         UpgradeAllowance(_owner, _spender, value);
506     }
507 
508 }
509 
510 /**
511  * @title Genbby Token
512  * @dev Token setting
513  */
514 contract GenbbyToken is UpgradableToken {
515 
516     string public contactInformation;
517     string public name = "Genbby Token";
518     string public symbol = "GG";
519     uint256 public constant decimals = 18;
520     uint256 public constant factor = 10 ** decimals;
521 
522     event UpgradeTokenInformation(string newName, string newSymbol);
523 
524     function GenbbyToken() public {
525         hard_cap = (10 ** 9) * factor;
526         contactInformation = 'https://genbby.com/';
527     }
528 
529     function setTokenInformation(string _name, string _symbol) onlyOwner public {
530         name = _name;
531         symbol = _symbol;
532         UpgradeTokenInformation(name, symbol);
533     }
534 
535     function setContactInformation(string info) onlyOwner public {
536          contactInformation = info;
537     }
538 
539     /*
540      * @dev Do not allow direct deposits
541      */
542     function () public payable {
543         revert();
544     }
545 
546 }
547 
548 /**
549  * @title Crowdsale Phase 1
550  * @dev Crowdsale phase 1 smart contract used by https://ico.genbby.com/
551  */
552 contract CrowdsalePhase1 is Pausable {
553 
554     using SafeMath for uint256;
555 
556     GenbbyToken public token;
557 
558     uint256 public start;
559     uint256 public finish;
560     uint256 public tokens_sold;
561     uint256 public constant decimals = 18;
562     uint256 public constant factor = 10 ** decimals;
563     uint256 public constant total_tokens = 37500000 * factor; // 75% 5 % hard cap
564 
565     event TokensGiven(address to, uint256 amount);
566 
567     function CrowdsalePhase1(uint256 _start) public {
568         start = _start;
569         finish = start + 4 weeks;
570     }
571 
572     /**
573      * @dev The `owner` can set the token that uses the crowdsale
574      */
575     function setToken(address tokenAddress) onlyOwner public {
576         token = GenbbyToken(tokenAddress);
577     }
578 
579     /**
580      * @dev Throws if called when the crowdsale is not running 
581      */
582     modifier whenRunning() {
583         require(start <= now && now <= finish);
584         _;
585     }
586 
587     /**
588      * @dev Function to give tokens to others users who have bought Genbby tokens
589      * @param _to The address that will receive the tokens
590      * @param _amount The amount of tokens to give
591      * @return A boolean that indicates if the operation was successful
592      */
593     function giveTokens(address _to, uint256 _amount) onlyOwner whenNotPaused whenRunning public returns (bool) {
594         require (tokens_sold.add(_amount) <= total_tokens);
595         token.mint(_to, _amount);
596         tokens_sold = tokens_sold.add(_amount);
597         TokensGiven(_to, _amount);
598         return true;
599     }
600 
601     /*
602      * @dev Do not allow direct deposits
603      */
604     function () public payable {
605         revert();
606     }
607 
608 }