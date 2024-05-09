1 pragma solidity ^0.4.16;
2 
3 /*
4 	@title GEEToken
5 */
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13 
14 
15     address owner;
16 
17     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
18 
19     function Ownable() {
20         owner = msg.sender;
21         OwnershipTransferred (address(0), owner);
22     }
23 
24     function transferOwnership(address _newOwner)
25         public
26         onlyOwner
27         notZeroAddress(_newOwner)
28     {
29         owner = _newOwner;
30         OwnershipTransferred(msg.sender, _newOwner);
31     }
32 
33     //Only owner can call function
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     modifier notZeroAddress(address _address) {
40         require(_address != address(0));
41         _;
42     }
43 
44 }
45 
46 /*
47 	Trustable saves trusted addresses
48 */
49 contract Trustable is Ownable {
50 
51 
52     //Only trusted addresses are able to transfer tokens during the Crowdsale
53     mapping (address => bool) trusted;
54 
55     event AddTrusted (address indexed _trustable);
56     event RemoveTrusted (address indexed _trustable);
57 
58     function Trustable() {
59         trusted[msg.sender] = true;
60         AddTrusted(msg.sender);
61     }
62 
63     //Add new trusted address
64     function addTrusted(address _address)
65         external
66         onlyOwner
67         notZeroAddress(_address)
68     {
69         trusted[_address] = true;
70         AddTrusted(_address);
71     }
72 
73     //Remove address from a trusted list
74     function removeTrusted(address _address)
75         external
76         onlyOwner
77         notZeroAddress(_address)
78     {
79         trusted[_address] = false;
80         RemoveTrusted(_address);
81     }
82 
83 }
84 
85 contract Pausable is Trustable {
86 
87 
88     //To check if Token is paused
89     bool public paused;
90     //Block number on pause
91     uint256 public pauseBlockNumber;
92     //Block number on resume
93     uint256 public resumeBlockNumber;
94 
95     event Pause(uint256 _blockNumber);
96     event Unpause(uint256 _blockNumber);
97 
98     function pause()
99         public
100         onlyOwner
101         whenNotPaused
102     {
103         paused = true;
104         pauseBlockNumber = block.number;
105         resumeBlockNumber = 0;
106         Pause(pauseBlockNumber);
107     }
108 
109     function unpause()
110         public
111         onlyOwner
112         whenPaused
113     {
114         paused = false;
115         resumeBlockNumber = block.number;
116         pauseBlockNumber = 0;
117         Unpause(resumeBlockNumber);
118     }
119 
120     modifier whenNotPaused {
121         require(!paused);
122         _;
123     }
124 
125     modifier whenPaused {
126         require(paused);
127         _;
128     }
129 
130 }
131 
132 /**
133  * @title SafeMath
134  * @dev Math operations with safety checks that throw on error
135  */
136 library SafeMath {
137 
138     /*
139         @return sum of a and b
140     */
141     function ADD (uint256 a, uint256 b) internal returns (uint256) {
142         uint256 c = a + b;
143         assert(c >= a);
144         return c;
145     }
146 
147     /*
148         @return difference of a and b
149     */
150     function SUB (uint256 a, uint256 b) internal returns (uint256) {
151         assert(a >= b);
152         return a - b;
153     }
154     
155 }
156 
157 /*
158 	ERC20 Token Standart
159 	https://github.com/ethereum/EIPs/issues/20
160 	https://theethereum.wiki/w/index.php/ERC20_Token_Standard
161 */
162 
163 contract ERC20 {
164 
165 
166     event Transfer(address indexed _from, address indexed _to, uint256 _value);
167 
168     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
169 
170     function totalSupply() external constant returns (uint);
171 
172     function balanceOf(address _owner) external constant returns (uint256);
173 
174     function transfer(address _to, uint256 _value) external returns (bool);
175 
176     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
177 
178     function approve(address _spender, uint256 _value) external returns (bool);
179 
180     function allowance(address _owner, address _spender) external constant returns (uint256);
181 
182 }
183 
184 /*
185 	Contract determines token
186 */
187 contract Token is ERC20, Pausable {
188 
189 
190     using SafeMath for uint256;
191 
192     //Total amount of Gee
193     uint256 _totalSupply = 100 * (10**6) * (10**8);
194 
195     //end of crowdsale
196     uint256 public crowdsaleEndBlock = 4695000;
197     //max end of crowdsale
198     uint256 public constant MAX_END_BLOCK_NUMBER = 4890000;
199 
200     //Balances for each account
201     mapping (address => uint256)  balances;
202     //Owner of the account approves the transfer of an amount to another account
203     mapping (address => mapping (address => uint256)) allowed;
204 
205     //Notifies users about the amount burnt
206     event Burn(address indexed _from, uint256 _value);
207     //Notifies users about end block change
208     event CrowdsaleEndChanged (uint256 _crowdsaleEnd, uint256 _newCrowdsaleEnd);
209 
210     //return _totalSupply of the Token
211     function totalSupply() external constant returns (uint256 totalTokenSupply) {
212         totalTokenSupply = _totalSupply;
213     }
214 
215     //What is the balance of a particular account?
216     function balanceOf(address _owner)
217         external
218         constant
219         returns (uint256 balance)
220     {
221         return balances[_owner];
222     }
223 
224     //Transfer the balance from owner's account to another account
225     function transfer(address _to, uint256 _amount)
226         external
227         notZeroAddress(_to)
228         whenNotPaused
229         canTransferOnCrowdsale(msg.sender)
230         returns (bool success)
231     {
232         balances[msg.sender] = balances[msg.sender].SUB(_amount);
233         balances[_to] = balances[_to].ADD(_amount);
234         Transfer(msg.sender, _to, _amount);
235         return true;
236     }
237 
238     // Send _value amount of tokens from address _from to address _to
239     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
240     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
241     // fees in sub-currencies; the command should fail unless the _from account has
242     // deliberately authorized the sender of the message via some mechanism; we propose
243     // these standardized APIs for approval:
244     function transferFrom(address _from, address _to, uint256 _amount)
245         external
246         notZeroAddress(_to)
247         whenNotPaused
248         canTransferOnCrowdsale(msg.sender)
249         canTransferOnCrowdsale(_from)
250         returns (bool success)
251     {
252         //Require allowance to be not too big
253         require(allowed[_from][msg.sender] >= _amount);
254         balances[_from] = balances[_from].SUB(_amount);
255         balances[_to] = balances[_to].ADD(_amount);
256         allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB(_amount);
257         Transfer(_from, _to, _amount);
258         return true;
259     }
260 
261     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
262     // If this function is called again it overwrites the current allowance with _value.
263     function approve(address _spender, uint256 _amount)
264         external
265         whenNotPaused
266         notZeroAddress(_spender)
267         returns (bool success)
268     {
269         allowed[msg.sender][_spender] = _amount;
270         Approval(msg.sender, _spender, _amount);
271         return true;
272     }
273 
274     //Return how many tokens left that you can spend from
275     function allowance(address _owner, address _spender)
276         external
277         constant
278         returns (uint256 remaining)
279     {
280         return allowed[_owner][_spender];
281     }
282 
283     /**
284      * To increment allowed value is better to use this function to avoid 2 calls
285      * From MonolithDAO Token.sol
286      */
287 
288     function increaseApproval(address _spender, uint256 _addedValue)
289         external
290         whenNotPaused
291         returns (bool success)
292     {
293         uint256 increased = allowed[msg.sender][_spender].ADD(_addedValue);
294         require(increased <= balances[msg.sender]);
295         //Cannot approve more coins then you have
296         allowed[msg.sender][_spender] = increased;
297         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298         return true;
299     }
300 
301     function decreaseApproval(address _spender, uint256 _subtractedValue)
302         external
303         whenNotPaused
304         returns (bool success)
305     {
306         uint256 oldValue = allowed[msg.sender][_spender];
307         if (_subtractedValue > oldValue) {
308             allowed[msg.sender][_spender] = 0;
309         } else {
310             allowed[msg.sender][_spender] = oldValue.SUB(_subtractedValue);
311         }
312         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313         return true;
314     }
315 
316     function burn(uint256 _value) external returns (bool success) {
317         require(trusted[msg.sender]);
318         //Subtract from the sender
319         balances[msg.sender] = balances[msg.sender].SUB(_value);
320         //Update _totalSupply
321         _totalSupply = _totalSupply.SUB(_value);
322         Burn(msg.sender, _value);
323         return true;
324     }
325 
326     function updateCrowdsaleEndBlock (uint256 _crowdsaleEndBlock) external onlyOwner {
327 
328         require(block.number <= crowdsaleEndBlock);                 //Crowdsale must be active
329         require(_crowdsaleEndBlock >= block.number);
330         require(_crowdsaleEndBlock <= MAX_END_BLOCK_NUMBER);        //Transfers can only be unlocked earlier
331 
332         uint256 currentEndBlockNumber = crowdsaleEndBlock;
333         crowdsaleEndBlock = _crowdsaleEndBlock;
334         CrowdsaleEndChanged (currentEndBlockNumber, _crowdsaleEndBlock);
335     }
336 
337     //Override transferOwnership()
338     function transferOwnership(address _newOwner) public afterCrowdsale {
339         super.transferOwnership(_newOwner);
340     }
341 
342     //Override pause()
343     function pause() public afterCrowdsale {
344         super.pause();
345     }
346 
347     modifier canTransferOnCrowdsale (address _address) {
348         if (block.number <= crowdsaleEndBlock) {
349             //Require the end of funding or msg.sender to be trusted
350             require(trusted[_address]);
351         }
352         _;
353     }
354 
355     //Some functions should work only after the Crowdsale
356     modifier afterCrowdsale {
357         require(block.number > crowdsaleEndBlock);
358         _;
359     }
360 
361 }
362 
363 /*
364 	Inspired by Civic and Golem
365 
366 */
367 
368 /*
369 	Interface of migrate agent contract (the new token contract)
370 */
371 contract MigrateAgent {
372 
373     function migrateFrom(address _tokenHolder, uint256 _amount) external returns (bool);
374 
375 }
376 
377 contract MigratableToken is Token {
378 
379     MigrateAgent public migrateAgent;
380 
381     //Total migrated tokens
382     uint256 public totalMigrated;
383 
384     /**
385      * Migrate states.
386      *
387      * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
388      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
389      * - ReadyToMigrate: The agent is set, but not a single token has been upgraded yet
390      * - Migrating: Upgrade agent is set and the balance holders can upgrade their tokens
391      *
392      */
393     enum MigrateState {Unknown, NotAllowed, WaitingForAgent, ReadyToMigrate, Migrating}
394     event Migrate (address indexed _from, address indexed _to, uint256 _value);
395     event MigrateAgentSet (address _agent);
396 
397     function migrate(uint256 _value) external {
398         MigrateState state = getMigrateState();
399         //Migrating has started
400         require(state == MigrateState.ReadyToMigrate || state == MigrateState.Migrating);
401         //Migrates user balance
402         balances[msg.sender] = balances[msg.sender].SUB(_value);
403         //Migrates total supply
404         _totalSupply = _totalSupply.SUB(_value);
405         //Counts migrated tokens
406         totalMigrated = totalMigrated.ADD(_value);
407         //Upgrade agent reissues the tokens
408         migrateAgent.migrateFrom(msg.sender, _value);
409         Migrate(msg.sender, migrateAgent, _value);
410     }
411 
412     /*
413         Set migrating agent and start migrating
414     */
415     function setMigrateAgent(MigrateAgent _agent)
416     external
417     onlyOwner
418     notZeroAddress(_agent)
419     afterCrowdsale
420     {
421         //cannot interrupt migrating
422         require(getMigrateState() != MigrateState.Migrating);
423         //set migrate agent
424         migrateAgent = _agent;
425         //Emit event
426         MigrateAgentSet(migrateAgent);
427     }
428 
429     /*
430         Migrating status
431     */
432     function getMigrateState() public constant returns (MigrateState) {
433         if (block.number <= crowdsaleEndBlock) {
434             //Migration is not allowed on funding
435             return MigrateState.NotAllowed;
436         } else if (address(migrateAgent) == address(0)) {
437             //Migrating address is not set
438             return MigrateState.WaitingForAgent;
439         } else if (totalMigrated == 0) {
440             //Migrating hasn't started yet
441             return MigrateState.ReadyToMigrate;
442         } else {
443             //Migrating
444             return MigrateState.Migrating;
445         }
446 
447     }
448 
449 }
450 
451 /*
452 	Contract defines specific token
453 */
454 contract GEEToken is MigratableToken {
455 
456     
457     //Name of the token
458     string public constant name = "Geens Platform Token";
459     //Symbol of the token
460     string public constant symbol = "GEE";
461     //Number of decimals of GEE
462     uint8 public constant decimals = 8;
463 
464     //Team allocation
465     //Team wallet that will be unlocked after ICO
466     address public constant TEAM0 = 0x9B4df4ac63B6049DD013090d3F639Fd2EA5A02d3;
467     //Team wallet that will be unlocked after 0.5 year after ICO
468     address public constant TEAM1 = 0x4df9348239f6C1260Fc5d0611755cc1EF830Ff6c;
469     //Team wallet that will be unlocked after 1 year after ICO
470     address public constant TEAM2 = 0x4902A52F95d9D47531Bed079B5B028c7F89ad47b;
471     //0.5 year after ICO
472     uint256 public constant UNLOCK_TEAM_1 = 1528372800;
473     //1 year after ICO
474     uint256 public constant UNLOCK_TEAM_2 = 1544184000;
475     //1st team wallet balance
476     uint256 public team1Balance;
477     //2nd team wallet balance
478     uint256 public team2Balance;
479 
480     //Community allocation
481     address public constant COMMUNITY = 0x265FC1d98f3C0D42e4273F542917525C3c3F925A;
482 
483     //2.4%
484     uint256 private constant TEAM0_THOUSANDTH = 24;
485     //3.6%
486     uint256 private constant TEAM1_THOUSANDTH = 36;
487     //6%
488     uint256 private constant TEAM2_THOUSANDTH = 60;
489     //67%
490     uint256 private constant ICO_THOUSANDTH = 670;
491     //21%
492     uint256 private constant COMMUNITY_THOUSANDTH = 210;
493     //100%
494     uint256 private constant DENOMINATOR = 1000;
495 
496     function GEEToken() {
497         //67% of _totalSupply
498         balances[msg.sender] = _totalSupply * ICO_THOUSANDTH / DENOMINATOR;
499         //2.4% of _totalSupply
500         balances[TEAM0] = _totalSupply * TEAM0_THOUSANDTH / DENOMINATOR;
501         //3.6% of _totalSupply
502         team1Balance = _totalSupply * TEAM1_THOUSANDTH / DENOMINATOR;
503         //6% of _totalSupply
504         team2Balance = _totalSupply * TEAM2_THOUSANDTH / DENOMINATOR;
505         //21% of _totalSupply
506         balances[COMMUNITY] =  _totalSupply * COMMUNITY_THOUSANDTH / DENOMINATOR;
507 
508         Transfer (this, msg.sender, balances[msg.sender]);
509         Transfer (this, TEAM0, balances[TEAM0]);
510         Transfer (this, COMMUNITY, balances[COMMUNITY]);
511 
512     }
513 
514     //Check if team wallet is unlocked
515     function unlockTeamTokens(address _address) external onlyOwner {
516         if (_address == TEAM1) {
517             require(UNLOCK_TEAM_1 <= now);
518             require (team1Balance > 0);
519             balances[TEAM1] = team1Balance;
520             team1Balance = 0;
521             Transfer (this, TEAM1, balances[TEAM1]);
522         } else if (_address == TEAM2) {
523             require(UNLOCK_TEAM_2 <= now);
524             require (team2Balance > 0);
525             balances[TEAM2] = team2Balance;
526             team2Balance = 0;
527             Transfer (this, TEAM2, balances[TEAM2]);
528         }
529     }
530 
531 }