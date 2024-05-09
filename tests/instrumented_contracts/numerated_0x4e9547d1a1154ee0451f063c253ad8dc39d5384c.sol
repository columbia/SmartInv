1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) constant returns (uint256);
85   function transferFrom(address from, address to, uint256 value) returns (bool);
86   function approve(address spender, uint256 value) returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still avaible for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 }
149 
150 
151 // Migration Agent interface
152 contract MigrationAgent {
153     function migrateFrom(address _from, uint _value);
154 }
155 
156 contract GVToken is StandardToken {
157     
158     // Constants
159     string public constant name = "Genesis Vision Token";
160     string public constant symbol = "GVT";
161     uint   public constant decimals = 18;
162     uint   constant TOKEN_LIMIT = 44 * 1e6 * 1e18; 
163     
164     address public ico;
165 
166     // GVT transfers are blocked until ICO is finished.
167     bool public isFrozen = true;
168 
169     // Token migration variables
170     address public migrationMaster;
171     address public migrationAgent;
172     uint public totalMigrated;
173 
174     event Migrate(address indexed _from, address indexed _to, uint _value);
175 
176     // Constructor
177     function GVToken(address _ico, address _migrationMaster) {
178         require(_ico != 0);
179         require(_migrationMaster != 0);
180         ico = _ico;
181         migrationMaster = _migrationMaster;
182     }
183 
184     // Create tokens
185     function mint(address holder, uint value) {
186         require(msg.sender == ico);
187         require(value > 0);
188         require(totalSupply + value <= TOKEN_LIMIT);
189 
190         balances[holder] += value;
191         totalSupply += value;
192         Transfer(0x0, holder, value);
193     }
194 
195     // Allow token transfer.
196     function unfreeze() {
197         require(msg.sender == ico);
198         isFrozen = false;
199     }
200 
201     // ERC20 functions
202     // =========================
203 
204     function transfer(address _to, uint _value) public returns (bool) {
205         require(_to != address(0));
206         require(!isFrozen);
207         return super.transfer(_to, _value);
208     }
209 
210     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
211         require(!isFrozen);
212         return super.transferFrom(_from, _to, _value);
213     }
214 
215     function approve(address _spender, uint _value) public returns (bool) {
216         require(!isFrozen);
217         return super.approve(_spender, _value);
218     }
219 
220     // Token migration
221     function migrate(uint value) external {
222         require(migrationAgent != 0);
223         require(value > 0);
224         require(value <= balances[msg.sender]);
225 
226         balances[msg.sender] -= value;
227         totalSupply -= value;
228         totalMigrated += value;
229         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
230         Migrate(msg.sender, migrationAgent, value);
231     }
232 
233     // Set address of migration contract
234     function setMigrationAgent(address _agent) external {
235         require(migrationAgent == 0);
236         require(msg.sender == migrationMaster);
237         migrationAgent = _agent;
238     }
239 
240     function setMigrationMaster(address _master) external {
241         require(msg.sender == migrationMaster);
242         require(_master != 0);
243         migrationMaster = _master;
244     }
245 }
246 
247 contract GVOptionToken is StandardToken {
248     
249     address public optionProgram;
250 
251     string public name;
252     string public symbol;
253     uint   public constant decimals = 18;
254 
255     uint TOKEN_LIMIT;
256 
257     // Modifiers
258     modifier optionProgramOnly { require(msg.sender == optionProgram); _; }
259 
260     // Constructor
261     function GVOptionToken(
262         address _optionProgram,
263         string _name,
264         string _symbol,
265         uint _TOKEN_LIMIT
266     ) {
267         require(_optionProgram != 0);        
268         optionProgram = _optionProgram;
269         name = _name;
270         symbol = _symbol;
271         TOKEN_LIMIT = _TOKEN_LIMIT;
272     }
273 
274     // Create tokens
275     function buyOptions(address buyer, uint value) optionProgramOnly {
276         require(value > 0);
277         require(totalSupply + value <= TOKEN_LIMIT);
278 
279         balances[buyer] += value;
280         totalSupply += value;
281         Transfer(0x0, buyer, value);
282     }
283     
284     function remainingTokensCount() returns(uint) {
285         return TOKEN_LIMIT - totalSupply;
286     }
287     
288     // Burn option tokens after execution during ICO
289     function executeOption(address addr, uint optionsCount) 
290         optionProgramOnly
291         returns (uint) {
292         if (balances[addr] < optionsCount) {
293             optionsCount = balances[addr];
294         }
295         if (optionsCount == 0) {
296             return 0;
297         }
298 
299         balances[addr] -= optionsCount;
300         totalSupply -= optionsCount;
301 
302         return optionsCount;
303     }
304 }
305 
306 contract GVOptionProgram {
307 
308     // Constants
309     uint constant option30perCent = 26 * 1e16; // GVOT30 tokens per usd cent during option purchase 
310     uint constant option20perCent = 24 * 1e16; // GVOT20 tokens per usd cent during option purchase
311     uint constant option10perCent = 22 * 1e16; // GVOT10 tokens per usd cent during option purchase
312     uint constant token30perCent  = 13684210526315800;  // GVT tokens per usd cent during execution of GVOT30
313     uint constant token20perCent  = 12631578947368500;  // GVT tokens per usd cent during execution of GVOT20
314     uint constant token10perCent  = 11578947368421100;  // GVT tokens per usd cent during execution of GVOT10
315 
316     string public constant option30name = "30% GVOT";
317     string public constant option20name = "20% GVOT";
318     string public constant option10name = "10% GVOT";
319 
320     string public constant option30symbol = "GVOT30";
321     string public constant option20symbol = "GVOT20";
322     string public constant option10symbol = "GVOT10";
323 
324     uint constant option30_TOKEN_LIMIT = 26 * 1e5 * 1e18;
325     uint constant option20_TOKEN_LIMIT = 36 * 1e5 * 1e18;
326     uint constant option10_TOKEN_LIMIT = 55 * 1e5 * 1e18;
327 
328     // Events
329     event BuyOptions(address buyer, uint amount, string tx, uint8 optionType);
330     event ExecuteOptions(address buyer, uint amount, string tx, uint8 optionType);
331 
332     // State variables
333     address public gvAgent; // payments bot account
334     address public team;    // team account
335     address public ico;     
336 
337     GVOptionToken public gvOptionToken30;
338     GVOptionToken public gvOptionToken20;
339     GVOptionToken public gvOptionToken10;
340 
341     // Modifiers
342     modifier icoOnly { require(msg.sender == ico); _; }
343     
344     // Constructor
345     function GVOptionProgram(address _ico, address _gvAgent, address _team) {
346         gvOptionToken30 = new GVOptionToken(this, option30name, option30symbol, option30_TOKEN_LIMIT);
347         gvOptionToken20 = new GVOptionToken(this, option20name, option20symbol, option20_TOKEN_LIMIT);
348         gvOptionToken10 = new GVOptionToken(this, option10name, option10symbol, option10_TOKEN_LIMIT);
349         gvAgent = _gvAgent;
350         team = _team;
351         ico = _ico;
352     }
353 
354     // Get remaining tokens for all types of option tokens
355     function getBalance() public returns (uint, uint, uint) {
356         return (gvOptionToken30.remainingTokensCount(), gvOptionToken20.remainingTokensCount(), gvOptionToken10.remainingTokensCount());
357     }
358 
359     // Execute options during the ICO token purchase. Priority: GVOT30 -> GVOT20 -> GVOT10
360     function executeOptions(address buyer, uint usdCents, string txHash) icoOnly
361         returns (uint executedTokens, uint remainingCents) {
362         require(usdCents > 0);
363 
364         (executedTokens, remainingCents) = executeIfAvailable(buyer, usdCents, txHash, gvOptionToken30, 0, token30perCent);
365         if (remainingCents == 0) {
366             return (executedTokens, 0);
367         }
368 
369         uint executed20;
370         (executed20, remainingCents) = executeIfAvailable(buyer, remainingCents, txHash, gvOptionToken20, 1, token20perCent);
371         if (remainingCents == 0) {
372             return (executedTokens + executed20, 0);
373         }
374 
375         uint executed10;
376         (executed10, remainingCents) = executeIfAvailable(buyer, remainingCents, txHash, gvOptionToken10, 2, token10perCent);
377         
378         return (executedTokens + executed20 + executed10, remainingCents);
379     }
380 
381     // Buy option tokens. Priority: GVOT30 -> GVOT20 -> GVOT10
382     function buyOptions(address buyer, uint usdCents, string txHash) icoOnly {
383         require(usdCents > 0);
384 
385         var remainUsdCents = buyIfAvailable(buyer, usdCents, txHash, gvOptionToken30, 0, option30perCent);
386         if (remainUsdCents == 0) {
387             return;
388         }
389 
390         remainUsdCents = buyIfAvailable(buyer, remainUsdCents, txHash, gvOptionToken20, 1, option20perCent);
391         if (remainUsdCents == 0) {
392             return;
393         }
394 
395         remainUsdCents = buyIfAvailable(buyer, remainUsdCents, txHash, gvOptionToken10, 2, option10perCent);
396     }   
397 
398     // Private functions
399     
400     function executeIfAvailable(address buyer, uint usdCents, string txHash,
401         GVOptionToken optionToken, uint8 optionType, uint optionPerCent)
402         private returns (uint executedTokens, uint remainingCents) {
403         
404         var optionsAmount = usdCents * optionPerCent;
405         executedTokens = optionToken.executeOption(buyer, optionsAmount);
406         remainingCents = usdCents - (executedTokens / optionPerCent);
407         if (executedTokens > 0) {
408             ExecuteOptions(buyer, executedTokens, txHash, optionType);
409         }
410         return (executedTokens, remainingCents);
411     }
412 
413     function buyIfAvailable(address buyer, uint usdCents, string txHash,
414         GVOptionToken optionToken, uint8 optionType, uint optionsPerCent)
415         private returns (uint) {
416         
417         var availableTokens = optionToken.remainingTokensCount(); 
418         if (availableTokens > 0) {
419             var tokens = usdCents * optionsPerCent;
420             if(availableTokens >= tokens) {
421                 optionToken.buyOptions(buyer, tokens);
422                 BuyOptions(buyer, tokens, txHash, optionType);
423                 return 0;
424             }
425             else {
426                 optionToken.buyOptions(buyer, availableTokens);
427                 BuyOptions(buyer, availableTokens, txHash, optionType);
428                 return usdCents - availableTokens / optionsPerCent;
429             }
430         }
431         return usdCents;
432     }
433 }
434 
435 contract Initable {
436     function init(address token);
437 }
438 
439 // Crowdfunding code for Genesis Vision Project
440 contract ICO {
441 
442     // Constants
443     uint public constant TOKENS_FOR_SALE = 33 * 1e6 * 1e18;
444 
445     // Events
446     event StartOptionsSelling();
447     event StartICOForOptionsHolders();
448     event RunIco();
449     event PauseIco();
450     event ResumeIco();
451     event FinishIco();
452 
453     event BuyTokens(address buyer, uint amount, string txHash);
454 
455     address public gvAgent; // payments bot account
456     address public team;    // team account
457 
458     GVToken public gvToken;
459     GVOptionProgram public optionProgram;
460     Initable public teamAllocator;
461     address public migrationMaster;
462 
463     // Modifiers
464     modifier teamOnly { require(msg.sender == team); _; }
465     modifier gvAgentOnly { require(msg.sender == gvAgent); _; }
466 
467     // Current total token supply
468     uint tokensSold = 0;
469 
470     bool public isPaused = false;
471     enum IcoState { Created, RunningOptionsSelling, RunningForOptionsHolders, Running, Finished }
472     IcoState public icoState = IcoState.Created;
473 
474     // Constructor
475     function ICO(address _team, address _gvAgent, address _migrationMaster, address _teamAllocator) {
476         gvAgent = _gvAgent;
477         team = _team;
478         teamAllocator = Initable(_teamAllocator);
479         migrationMaster = _migrationMaster;
480         gvToken = new GVToken(this, migrationMaster);
481     }
482 
483     // Initialize Option Program contract
484     function initOptionProgram() external teamOnly {
485         if (optionProgram == address(0)) {
486             optionProgram = new GVOptionProgram(this, gvAgent, team);
487         }
488     }
489 
490     // ICO and Option Program state management
491     function startOptionsSelling() external teamOnly {
492         require(icoState == IcoState.Created);
493         // Check if Option Program is initialized
494         require(optionProgram != address(0));    
495         icoState = IcoState.RunningOptionsSelling;
496         StartOptionsSelling();
497     }
498 
499     // Finish options selling and start ICO for the option holders
500     function startIcoForOptionsHolders() external teamOnly {
501         require(icoState == IcoState.RunningOptionsSelling);       
502         icoState = IcoState.RunningForOptionsHolders;
503         StartICOForOptionsHolders();
504     }
505 
506     function startIco() external teamOnly {
507         require(icoState == IcoState.RunningForOptionsHolders);
508         icoState = IcoState.Running;
509         RunIco();
510     }
511 
512     function pauseIco() external teamOnly {
513         require(!isPaused);
514         require(icoState == IcoState.Running || icoState == IcoState.RunningForOptionsHolders || icoState == IcoState.RunningOptionsSelling);
515         isPaused = true;
516         PauseIco();
517     }
518 
519     function resumeIco() external teamOnly {
520         require(isPaused);
521         require(icoState == IcoState.Running || icoState == IcoState.RunningForOptionsHolders || icoState == IcoState.RunningOptionsSelling);
522         isPaused = false;
523         ResumeIco();
524     }
525 
526     function finishIco(address _fund, address _bounty) external teamOnly {
527         require(icoState == IcoState.Running);
528         icoState = IcoState.Finished;
529 
530         uint mintedTokens = gvToken.totalSupply();
531         if (mintedTokens > 0) {
532             uint totalAmount = mintedTokens * 4 / 3;              // 75% of total tokens are for sale, get 100%
533             gvToken.mint(teamAllocator, 11 * totalAmount / 100);  // 11% for team to the time-locked wallet
534             gvToken.mint(_fund, totalAmount / 20);                // 5% for Genesis Vision fund
535             gvToken.mint(_bounty, 9 * totalAmount / 100);         // 9% for Advisers, Marketing, Bounty
536             gvToken.unfreeze();
537         }
538         
539         FinishIco();
540     }    
541 
542     // Buy GVT without options
543     function buyTokens(address buyer, uint usdCents, string txHash)
544         external gvAgentOnly returns (uint) {
545         require(icoState == IcoState.Running);
546         require(!isPaused);
547         return buyTokensInternal(buyer, usdCents, txHash);
548     }
549 
550     // Buy GVT for option holders. At first buy GVT with option execution, then buy GVT in regular way if ICO is running
551     function buyTokensByOptions(address buyer, uint usdCents, string txHash)
552         external gvAgentOnly returns (uint) {
553         require(!isPaused);
554         require(icoState == IcoState.Running || icoState == IcoState.RunningForOptionsHolders);
555         require(usdCents > 0);
556 
557         uint executedTokens; 
558         uint remainingCents;
559         // Execute options
560         (executedTokens, remainingCents) = optionProgram.executeOptions(buyer, usdCents, txHash);
561 
562         if (executedTokens > 0) {
563             require(tokensSold + executedTokens <= TOKENS_FOR_SALE);
564             tokensSold += executedTokens;
565             
566             gvToken.mint(buyer, executedTokens);
567             BuyTokens(buyer, executedTokens, txHash);
568         }
569 
570         //Buy GVT for remaining cents without options
571         if (icoState == IcoState.Running) {
572             return buyTokensInternal(buyer, remainingCents, txHash);
573         } else {
574             return remainingCents;
575         }
576     }
577 
578     // Buy GVOT during the Option Program
579     function buyOptions(address buyer, uint usdCents, string txHash)
580         external gvAgentOnly {
581         require(!isPaused);
582         require(icoState == IcoState.RunningOptionsSelling);
583         optionProgram.buyOptions(buyer, usdCents, txHash);
584     }
585 
586     // Internal buy GVT without options
587     function buyTokensInternal(address buyer, uint usdCents, string txHash)
588     private returns (uint) {
589         //ICO state is checked in external functions, which call this function        
590         require(usdCents > 0);
591         uint tokens = usdCents * 1e16;
592         require(tokensSold + tokens <= TOKENS_FOR_SALE);
593         tokensSold += tokens;
594             
595         gvToken.mint(buyer, tokens);
596         BuyTokens(buyer, tokens, txHash);
597 
598         return 0;
599     }
600 }