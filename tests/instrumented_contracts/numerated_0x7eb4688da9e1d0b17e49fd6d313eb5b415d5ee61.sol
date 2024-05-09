1 pragma solidity 0.5.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 
49      
50 
51  
52 
53 }
54 
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62     address public owner;
63 
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67 
68     /**
69      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70      * account.
71      */
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83 
84 
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93     function totalSupply() public view returns (uint256);
94     function balanceOf(address who) public view returns (uint256);
95     function transfer(address to, uint256 value) public returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105     function allowance(address owner, address spender) public view returns (uint256);
106     function transferFrom(address from, address to, uint256 value) public returns (bool);
107     function approve(address spender, uint256 value) public returns (bool);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117     using SafeMath for uint256;
118 
119     mapping(address => uint256) balances;
120 
121     uint256 public totalSupply_;
122 
123     /**
124      * @dev total number of tokens in existence
125      */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129 
130     /**
131      * @dev transfer token for a specified address
132      * @param _to The address to transfer to.
133      * @param _value The amount to be transferred.
134      */
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[msg.sender]);
138 
139         // SafeMath.sub will throw if there is not enough balance.
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         emit Transfer (msg.sender, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Gets the balance of the specified address.
148      * @param _owner The address to query the the balance of.
149      * @return An uint256 representing the amount owned by the passed address.
150      */
151     function balanceOf(address _owner) public view returns (uint256 balance) {
152         return balances[_owner];
153     }
154 
155 }
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167     mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170     /**
171      * @dev Transfer tokens from one address to another
172      * @param _from address The address which you want to send tokens from
173      * @param _to address The address which you want to transfer to
174      * @param _value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         emit Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190      *
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         require(_value==0||allowed[msg.sender][_spender]==0);
200         allowed[msg.sender][_spender] = _value;
201         emit Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205     /**
206      * @dev Function to check the amount of tokens that an owner allowed to a spender.
207      * @param _owner address The address which owns the funds.
208      * @param _spender address The address which will spend the funds.
209      * @return A uint256 specifying the amount of tokens still available for the spender.
210      */
211     function allowance(address _owner, address _spender) public view returns (uint256) {
212         return allowed[_owner][_spender];
213     }
214 
215     /**
216      * @dev Increase the amount of tokens that an owner allowed to a spender.
217      *
218      * approve should be called when allowed[_spender] == 0. To increment
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * @param _spender The address which will spend the funds.
223      * @param _addedValue The amount of tokens to increase the allowance by.
224      */
225     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231     /**
232      * @dev Decrease the amount of tokens that an owner allowed to a spender.
233      *
234      * approve should be called when allowed[_spender] == 0. To decrement
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * @param _spender The address which will spend the funds.
239      * @param _subtractedValue The amount of tokens to decrease the allowance by.
240      */
241     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242         uint oldValue = allowed[msg.sender][_spender];
243         if (_subtractedValue > oldValue) {
244             allowed[msg.sender][_spender] = 0;
245         } else {
246             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247         }
248         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249         return true;
250     }
251 
252 }
253 
254 /**
255  * @title Pausable
256  * @dev Base contract which allows children to implement an emergency stop mechanism.
257  */
258 contract Pausable is Ownable {
259     event Pause();
260     event Unpause();
261 
262     bool public paused = false;
263 
264 
265     /**
266      * @dev Modifier to make a function callable only when the contract is not paused.
267      */
268     modifier whenNotPaused() {
269         require(!paused);
270         _;
271     }
272 
273     /**
274      * @dev Modifier to make a function callable only when the contract is paused.
275      */
276     modifier whenPaused() {
277         require(paused);
278         _;
279     }
280 
281     /**
282      * @dev called by the owner to pause, triggers stopped state
283      */
284     function pause() onlyOwner whenNotPaused public {
285         paused = true;
286         emit Pause();
287     }
288 
289     /**
290      * @dev called by the owner to unpause, returns to normal state
291      */
292     function unpause() onlyOwner whenPaused public {
293         paused = false;
294         emit Unpause();
295     }
296 }
297 
298 
299 /**
300  * @title Pausable token
301  * @dev StandardToken modified with pausable transfers.
302  **/
303 contract PausableToken is StandardToken, Pausable {
304 
305     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
306         return super.transfer(_to, _value);
307     }
308 
309     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
310         return super.transferFrom(_from, _to, _value);
311     }
312 
313     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
314         return super.approve(_spender, _value);
315     }
316 
317     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
318         return super.increaseApproval(_spender, _addedValue);
319     }
320 
321     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
322         return super.decreaseApproval(_spender, _subtractedValue);
323     }
324 }
325 
326 /**
327  * @title Lock token
328  * @dev Lock  which is defined the lock logic
329  **/
330 contract  Lock is PausableToken{
331 
332     mapping(address => uint256) public teamLockTime; // Lock start time
333     mapping(address => uint256) public fundLockTime; // Lock start time
334     uint256 public issueDate =0 ;//issueDate
335     mapping(address => uint256) public teamLocked;// Total Team lock 
336     mapping(address => uint256) public fundLocked;// Total fund lock
337     mapping(address => uint256) public teamUsed;   // Team Used
338     mapping(address => uint256) public fundUsed;   // Fund Used
339     mapping(address => uint256) public teamReverse;   // Team reserve
340     mapping(address => uint256) public fundReverse;   // Fund reserve
341     
342 
343    /**
344     * @dev Calculate the number of Tokens available for teamAccount
345     * @param _to teamAccount's address
346    */
347     function teamAvailable(address _to) internal view returns (uint256) {
348         require(teamLockTime[_to]>0);
349     
350         uint256 now1 = block.timestamp;
351         uint256 lockTime = teamLockTime[_to];
352         uint256 time = now1.sub(lockTime);
353         //Unlocked 20% first
354         uint256 percent = 20;
355         // 20% per 180 days after issue
356         if(time >= 180 days) {
357           percent =  (time.div(9 days)) .add(1);
358         }
359         percent = percent > 100 ? 100 : percent;
360         uint256 avail = teamLocked[_to];
361         require(avail>0);
362         avail = avail.mul(percent).div(100).sub(teamUsed[_to]);
363         return avail ;
364     }
365     
366     /**
367      * @dev Get the number of Tokens available for the current private fund account 
368      * @param _to SLGCFundAccount's address
369     **/
370     function fundAvailable(address _to) internal view returns (uint256) {
371         require(fundLockTime[_to]>0);
372 
373         //The start time of the lock position
374         uint256 lockTime = fundLockTime[_to];
375         //The interval between the current time and the start time of the lockout
376         uint256 time = block.timestamp.sub(lockTime);
377 
378         //Unlocked 5% first
379         uint256 percent = 5000;
380         //unlocking 58/100000 per day
381         if(time >= 1 days) {
382             percent = percent.add( (((time.sub(1 days)).div (1 days)).add (1)).mul (58));
383         }
384         percent = percent > 100000 ? 100000 : percent;
385         uint256 avail = fundLocked[_to];
386         require(avail>0);
387         avail = avail.mul(percent).div(100000).sub(fundUsed[_to]);
388         return avail ;
389     }
390 
391     /**
392       * @dev Team lock
393       * @param _to  team lock account's address
394       * @param _value the number of Token
395      */
396     function teamLock(address _to,uint256 _value) internal {
397         require(_value>0);
398         teamLocked[_to] = teamLocked[_to].add(_value);
399         teamReverse[_to] = teamReverse[_to].add(_value);
400         teamLockTime[_to] = block.timestamp;  // Lock start time
401     }
402 
403     /**
404       * @dev  Privately offered fund lock
405       * @param _to  Privately offered fund account's address
406       * @param _value the number of Token
407      */
408     function fundLock(address _to,uint256 _value) internal {
409         require(_value>0);
410         fundLocked[_to] =fundLocked[_to].add(_value);
411         fundReverse[_to] = fundReverse[_to].add(_value);
412         if(fundLockTime[_to] == 0)
413           fundLockTime[_to] = block.timestamp;  // Lock start time
414     }
415 
416     /**
417      * @dev Team account transaction
418      * @param _to  The accept token address
419      * @param _value Number of transactions
420      */
421     function teamLockTransfer(address _to, uint256 _value) internal returns (bool) {
422         //The remaining part
423        uint256 availReverse = balances[msg.sender].sub((teamLocked[msg.sender].sub(teamUsed[msg.sender]))+(fundLocked[msg.sender].sub(fundUsed[msg.sender])));
424        uint256 totalAvail=0;
425        uint256 availTeam =0;
426        if(issueDate==0)
427         {
428              totalAvail = availReverse;
429         }
430         else{
431             //the number of Tokens available for teamAccount'Locked part
432              availTeam = teamAvailable(msg.sender);
433              //the number of Tokens available for teamAccount
434              totalAvail = availTeam.add(availReverse);
435         }
436         require(_value <= totalAvail);
437         bool ret = super.transfer(_to,_value);
438         if(ret == true && issueDate>0) {
439             //If over the teamAccount's released part
440             if(_value > availTeam){
441                 teamUsed[msg.sender] = teamUsed[msg.sender].add(availTeam);
442                 teamReverse[msg.sender] = teamReverse[msg.sender].sub(availTeam);
443             }
444             //If in the teamAccount's released part
445             else{
446                 teamUsed[msg.sender] = teamUsed[msg.sender].add(_value);
447                 teamReverse[msg.sender] = teamReverse[msg.sender].sub(_value);
448             }
449         }
450         if(teamUsed[msg.sender] >= teamLocked[msg.sender]){
451             delete teamLockTime[msg.sender];
452             delete teamReverse[msg.sender];
453         }
454         return ret;
455     }
456 
457     /**
458      * @dev Team account authorization transaction
459      * @param _from The give token address
460      * @param _to  The accept token address
461      * @param _value Number of transactions
462      */
463     function teamLockTransferFrom(address _from,address _to, uint256 _value) internal returns (bool) {
464        //The remaining part
465        uint256 availReverse = balances[_from].sub((teamLocked[_from].sub(teamUsed[_from]))+(fundLocked[_from].sub(fundUsed[_from])));
466        uint256 totalAvail=0;
467        uint256 availTeam =0;
468         if(issueDate==0)
469         {
470              totalAvail = availReverse;
471         }
472         else{
473             //the number of Tokens available for teamAccount'Locked part
474              availTeam = teamAvailable(_from);
475               //the number of Tokens available for teamAccount
476              totalAvail = availTeam.add(availReverse);
477         }
478        require(_value <= totalAvail);
479         bool ret = super.transferFrom(_from,_to,_value);
480         if(ret == true && issueDate>0) {
481             //If over the teamAccount's released part
482             if(_value > availTeam){
483                 teamUsed[_from] = teamUsed[_from].add(availTeam);
484                 teamReverse[_from] = teamReverse[_from].sub(availTeam);
485            }
486             //If in the teamAccount's released part
487             else{
488                 teamUsed[_from] = teamUsed[_from].add(_value);
489                 teamReverse[_from] = teamReverse[_from].sub(_value);
490             }
491         }
492         if(teamUsed[_from] >= teamLocked[_from]){
493             delete teamLockTime[_from];
494             delete teamReverse[_from];
495         }
496         return ret;
497     }
498 
499     /**
500      * @dev Privately Offered Fund Transfer Token
501      * @param _to The accept token address
502      * @param _value Number of transactions
503      */
504     function fundLockTransfer(address _to, uint256 _value) internal returns (bool) {
505       //The remaining part
506        uint256 availReverse = balances[msg.sender].sub((teamLocked[msg.sender].sub(teamUsed[msg.sender]))+(fundLocked[msg.sender].sub(fundUsed[msg.sender])));
507        uint256 totalAvail=0;
508        uint256 availFund = 0;
509         if(issueDate==0)
510         {
511              totalAvail = availReverse;
512         }
513         else{
514              require(now>issueDate);
515             //the number of Tokens available for SLGCFundAccount'Locked part
516              availFund = fundAvailable(msg.sender);
517              //the number of Tokens available for SLGCFundAccount
518              totalAvail = availFund.add(availReverse);
519         }
520         require(_value <= totalAvail);
521         bool ret = super.transfer(_to,_value);
522         if(ret == true && issueDate>0) {
523             //If over the SLGCFundAccount's released part
524             if(_value > availFund){
525                 fundUsed[msg.sender] = fundUsed[msg.sender].add(availFund);
526                 fundReverse[msg.sender] = fundReverse[msg.sender].sub(availFund);
527              }
528             //If in the SLGCFundAccount's released part
529             else{
530                 fundUsed[msg.sender] =  fundUsed[msg.sender].add(_value);
531                 fundReverse[msg.sender] = fundReverse[msg.sender].sub(_value);
532             }
533         }
534         if(fundUsed[msg.sender] >= fundLocked[msg.sender]){
535             delete fundLockTime[msg.sender];
536             delete fundReverse[msg.sender];
537         }
538         return ret;
539     }
540 
541 
542     /**
543      * @dev Privately Offered Fund Transfer Token
544      * @param _from The give token address
545      * @param _to The accept token address
546      * @param _value Number of transactions
547      */
548     function fundLockTransferFrom(address _from,address _to, uint256 _value) internal returns (bool) {
549         //The remaining part
550         uint256 availReverse =  balances[_from].sub((teamLocked[_from].sub(teamUsed[_from]))+(fundLocked[_from].sub(fundUsed[_from])));
551         uint256 totalAvail=0;
552         uint256 availFund = 0;
553         if(issueDate==0)
554         {
555              totalAvail = availReverse;
556         }
557         else{
558              require(now>issueDate);
559              //the number of Tokens available for SLGCFundAccount'Locked part
560              availFund = fundAvailable(_from);
561               //the number of Tokens available for SLGCFundAccount
562              totalAvail = availFund.add(availReverse);
563         }
564       
565         require(_value <= totalAvail);
566         bool ret = super.transferFrom(_from,_to,_value);
567         if(ret == true && issueDate>0) {
568            //If over the SLGCFundAccount's released part
569             if(_value > availFund){
570                 fundUsed[_from] = fundUsed[_from].add(availFund);
571                 fundReverse[_from] = fundReverse[_from].sub(availFund);
572             }
573             //If in the SLGCFundAccount's released part
574             else{
575                 fundUsed[_from] =  fundUsed[_from].add(_value);
576                 fundReverse[_from] = fundReverse[_from].sub(_value);
577             }
578         }
579         if(fundUsed[_from] >= fundLocked[_from]){
580             delete fundLockTime[_from];
581         }
582         return ret;
583     }
584 }
585 
586 /**
587  * @title Simulation Game Coin
588  * @dev SLGC Contract
589  **/
590 contract SLGCToken is Lock {
591     bytes32 public name = "Simulation Game Coin";
592     bytes32 public symbol = "SLGC";
593     uint8 public decimals = 8;
594     // Proportional accuracy
595     uint256 public precentDecimal = 2;
596 
597     // firstFundPrecent
598     uint256 public firstFundPrecent = 500; 
599     // secondFundPrecent
600     uint256 public secondFundPrecent = 1000; 
601     //stableFundPrecent
602     uint256 public stableFundPrecent = 300; 
603     //ecologyFundPrecent
604     uint256 public ecologyFundPrecent = 1100; 
605     //devTeamPrecent
606     uint256 public devTeamPrecent = 600;
607     //SLGCFoundationPrecent
608     uint256 public SLGCFoundationPrecent = 6500;
609     //firstFundBalance
610     uint256 public firstFundBalance;
611     //secondFundBalance
612     uint256 public secondFundBalance;
613     //stableFundBalance
614     uint256 public stableFundBalance;
615     //ecologyFundBalance
616     uint256 public ecologyFundBalance;
617     //devTeamBalance
618     uint256 public devTeamBalance;
619     //SLGCFoundationBalance
620     uint256 public SLGCFoundationBalance;
621     //SLGCFundAccount
622     address public SLGCFundAccount;
623     
624 
625     /**
626      *  @dev Contract constructor
627      *  @param _initialSupply token's initialSupply
628      *  @param _teamAccount  teamAccount
629      *  @param _firstFundAccount firstFundAccount
630      *  @param _secondFundAccount secondFundAccount
631      *  @param _stableFundAccount stableFundAccount
632      *  @param _ecologyFundAccount ecologyFundAccount
633      *  @param _SLGCFoundationAccount SLGCFoundationAccount
634     */
635     constructor(uint256 _initialSupply,address _teamAccount,address _firstFundAccount,address _secondFundAccount,address _stableFundAccount,address _ecologyFundAccount,address _SLGCFoundationAccount) public {
636         //Define a SLGCFundAccount
637         SLGCFundAccount = _SLGCFoundationAccount;
638 
639         //Calculated according to accuracy, if the precision is 18, it is _initialSupply x 10 to the power of 18
640         totalSupply_ = _initialSupply * 10 ** uint256(decimals);
641 
642         //Calculate the total value of firstFund
643         firstFundBalance =  totalSupply_.mul(firstFundPrecent).div(100* 10 ** precentDecimal);
644         //Calculate the total value of secondFund
645         secondFundBalance =  totalSupply_.mul(secondFundPrecent).div(100* 10 ** precentDecimal);
646         //Calculate the total value of stableFund
647         stableFundBalance =  totalSupply_.mul(stableFundPrecent).div(100* 10 ** precentDecimal);
648         //Calculate the total value of ecologyFund
649         ecologyFundBalance =  totalSupply_.mul(ecologyFundPrecent).div(100* 10 ** precentDecimal);
650         //Calculate the total value of devTeamBalance
651         devTeamBalance =  totalSupply_.mul(devTeamPrecent).div(100* 10 ** precentDecimal);
652         //Calculate the total value of SLGCFoundationBalance
653         SLGCFoundationBalance = totalSupply_.mul(SLGCFoundationPrecent).div(100* 10 ** precentDecimal) ;
654         //Initially put the SLGCFoundationBalance into the SLGCFoundationAccount
655         balances[_SLGCFoundationAccount] = SLGCFoundationBalance; 
656 
657         //Initially put the devTeamBalance into the teamAccount
658         balances[_teamAccount] = devTeamBalance;
659 
660         //Initially put the firstFundBalance into the firstFundAccount
661         balances[_firstFundAccount]=firstFundBalance;
662 
663         //Initially put the secondFundBalance into the secondFundAccount
664         balances[_secondFundAccount]=secondFundBalance;
665 
666         //Initially put the stableFundBalance into the stableFundAccount
667         balances[_stableFundAccount]=stableFundBalance;
668 
669         //Initially put the ecologyFundBalance into the ecologyFundAccount
670         balances[_ecologyFundAccount]=ecologyFundBalance;
671 
672         //Initially lock the team account
673         teamLock(_teamAccount,devTeamBalance);
674         
675     }
676 
677     /**
678       * @dev destroy the msg sender's token onlyOwner
679       * @param _value the number of the destroy token
680      */
681     function burn(uint256 _value) public onlyOwner returns (bool) {
682         balances[msg.sender] = balances[msg.sender].sub(_value);
683         balances[address(0)] = balances[address(0)].add(_value);
684         emit Transfer(msg.sender, address(0), _value);
685         return true;
686     }
687 
688     /**
689      * @dev Transfer token
690      * @param _to the accept token address
691      * @param _value the number of transfer token
692      */
693     function transfer(address _to, uint256 _value) public returns (bool) {
694         if(issueDate==0)
695         {
696             //the SLGCFundAccounts is not allowed to transfer before issued
697             require(msg.sender != SLGCFundAccount);
698         }
699 
700         if(teamLockTime[msg.sender] > 0){
701             return super.teamLockTransfer(_to,_value);
702         }else if(fundLockTime[msg.sender] > 0){
703             return super.fundLockTransfer(_to,_value);
704         }else {
705             return super.transfer(_to, _value);    
706         }
707     }
708 
709     /**
710      * @dev Transfer token
711      * @param _from the give token address
712      * @param _to the accept token address
713      * @param _value the number of transfer token
714      */
715     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
716           if(issueDate==0)
717         {
718             //the SLGCFundAccounts is not allowed to transfer before issued
719             require(_from != SLGCFundAccount);
720         }
721       
722         if(teamLockTime[_from] > 0){
723             return super.teamLockTransferFrom(_from,_to,_value);
724         }else if(fundLockTime[_from] > 0 ){  
725             return super.fundLockTransferFrom(_from,_to,_value);
726         }else{
727             return super.transferFrom(_from, _to, _value);
728         }
729     }
730 
731     /**
732      *  @dev Privately offered Fund 
733      *  @param _to the accept token address
734      *  @param _value the number of transfer token
735      */
736     function mintFund(address _to, uint256 _value) public  returns (bool){
737         require(_value >0);
738         require(msg.sender==SLGCFundAccount);
739         require(SLGCFoundationBalance >0);
740         if(_value <= SLGCFoundationBalance){
741             super.transfer(_to,_value);
742             fundLock(_to,_value);
743             SLGCFoundationBalance = SLGCFoundationBalance.sub(_value);
744         }
745     }
746 
747     /**
748     * @dev Issue the token 
749     */
750     function issue() public onlyOwner  returns (uint){
751         //Only one time 
752         require(issueDate==0);
753         issueDate = now;
754         return now;
755     }
756      
757      /**avoid mis-transfer*/
758      function() external payable{
759          revert();
760      }
761 }