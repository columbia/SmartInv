1 pragma solidity 0.4.24;
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
72     function Ownable() public {
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
136         require(msg.data.length>=(2*32)+4);
137         require(_to != address(0));
138         require(_value <= balances[msg.sender]);
139 
140         // SafeMath.sub will throw if there is not enough balance.
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         emit Transfer (msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Gets the balance of the specified address.
149      * @param _owner The address to query the the balance of.
150      * @return An uint256 representing the amount owned by the passed address.
151      */
152     function balanceOf(address _owner) public view returns (uint256 balance) {
153         return balances[_owner];
154     }
155 
156 }
157 
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168     mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171     /**
172      * @dev Transfer tokens from one address to another
173      * @param _from address The address which you want to send tokens from
174      * @param _to address The address which you want to transfer to
175      * @param _value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178         require(_to != address(0));
179         require(_value <= balances[_from]);
180         require(_value <= allowed[_from][msg.sender]);
181 
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      *
192      * Beware that changing an allowance with this method brings the risk that someone may use both the old
193      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      * @param _spender The address which will spend the funds.
197      * @param _value The amount of tokens to be spent.
198      */
199     function approve(address _spender, uint256 _value) public returns (bool) {
200         require(_value==0||allowed[msg.sender][_spender]==0);
201         require(msg.data.length>=(2*32)+4);
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234      * @dev Decrease the amount of tokens that an owner allowed to a spender.
235      *
236      * approve should be called when allowed[_spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * @param _spender The address which will spend the funds.
241      * @param _subtractedValue The amount of tokens to decrease the allowance by.
242      */
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254 }
255 
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  */
260 contract Pausable is Ownable {
261     event Pause();
262     event Unpause();
263 
264     bool public paused = false;
265 
266 
267     /**
268      * @dev Modifier to make a function callable only when the contract is not paused.
269      */
270     modifier whenNotPaused() {
271         require(!paused);
272         _;
273     }
274 
275     /**
276      * @dev Modifier to make a function callable only when the contract is paused.
277      */
278     modifier whenPaused() {
279         require(paused);
280         _;
281     }
282 
283     /**
284      * @dev called by the owner to pause, triggers stopped state
285      */
286     function pause() onlyOwner whenNotPaused public {
287         paused = true;
288         emit Pause();
289     }
290 
291     /**
292      * @dev called by the owner to unpause, returns to normal state
293      */
294     function unpause() onlyOwner whenPaused public {
295         paused = false;
296         emit Unpause();
297     }
298 }
299 
300 
301 /**
302  * @title Pausable token
303  * @dev StandardToken modified with pausable transfers.
304  **/
305 contract PausableToken is StandardToken, Pausable {
306 
307     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
308         return super.transfer(_to, _value);
309     }
310 
311     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
312         return super.transferFrom(_from, _to, _value);
313     }
314 
315     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
316         return super.approve(_spender, _value);
317     }
318 
319     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
320         return super.increaseApproval(_spender, _addedValue);
321     }
322 
323     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
324         return super.decreaseApproval(_spender, _subtractedValue);
325     }
326 }
327 
328 /**
329  * @title Lock token
330  * @dev Lock  which is defined the lock logic
331  **/
332 contract  Lock is PausableToken{
333 
334     mapping(address => uint256) public teamLockTime; // Lock start time
335     mapping(address => uint256) public fundLockTime; // Lock start time
336     uint256 public issueDate =0 ;//issueDate
337     mapping(address => uint256) public teamLocked;// Total Team lock 
338     mapping(address => uint256) public fundLocked;// Total fund lock
339     mapping(address => uint256) public teamUsed;   // Team Used
340     mapping(address => uint256) public fundUsed;   // Fund Used
341     mapping(address => uint256) public teamReverse;   // Team reserve
342     mapping(address => uint256) public fundReverse;   // Fund reserve
343     
344 
345    /**
346     * @dev Calculate the number of Tokens available for teamAccount
347     * @param _to teamAccount's address
348    */
349     function teamAvailable(address _to) internal constant returns (uint256) {
350         require(teamLockTime[_to]>0);
351         //Cover the start time of the lock before the release is the issueDate
352         if(teamLockTime[_to] != issueDate)
353         {
354             teamLockTime[_to]= issueDate;
355         }
356         uint256 now1 = block.timestamp;
357         uint256 lockTime = teamLockTime[_to];
358         uint256 time = now1.sub(lockTime);
359         uint256 percent = 0;
360         if(time >= 30 days) {
361           percent =  (time.div(30 days)) .add(1);
362         }
363         percent = percent > 12 ? 12 : percent;
364         uint256 avail = teamLocked[_to];
365         require(avail>0);
366         avail = avail.mul(percent).div(12).sub(teamUsed[_to]);
367         return avail ;
368     }
369     
370     /**
371      * @dev Get the number of Tokens available for the current account private placement
372      * @param _to mainFundAccount's address
373     **/
374     function fundAvailable(address _to) internal constant returns (uint256) {
375         require(fundLockTime[_to]>0);
376         //Cover the start time of the lock before the release is the issueDate
377         if(fundLockTime[_to] != issueDate)
378         {
379             fundLockTime[_to]= issueDate;
380         }
381         //The start time of the lock position
382         uint256 lockTime = fundLockTime[_to];
383         //The interval between the current time and the start time of the lockout
384         uint256 time = block.timestamp.sub(lockTime);
385         //Unlocked 25%
386         uint256 percent = 250;
387         //After more than 30 days, 75% of the minutes and 150 days of unlocking 5/1000 per day
388         if(time >= 30 days) {
389             percent = percent.add( (((time.sub(30 days)).div (1 days)).add (1)).mul (5));
390         }
391         percent = percent > 1000 ? 1000 : percent;
392         uint256 avail = fundLocked[_to];
393         require(avail>0);
394         avail = avail.mul(percent).div(1000).sub(fundUsed[_to]);
395         return avail ;
396     }
397     /**
398       * @dev Team lock
399       * @param _to  team lock account's address
400       * @param _value the number of Token
401      */
402     function teamLock(address _to,uint256 _value) internal {
403         require(_value>0);
404         teamLocked[_to] = teamLocked[_to].add(_value);
405         teamReverse[_to] = teamReverse[_to].add(_value);
406         teamLockTime[_to] = block.timestamp;  // Lock start time
407     }
408     /**
409       * @dev  Privately offered fund lock
410       * @param _to  Privately offered fund account's address
411       * @param _value the number of Token
412      */
413     function fundLock(address _to,uint256 _value) internal {
414         require(_value>0);
415         fundLocked[_to] =fundLocked[_to].add(_value);
416         fundReverse[_to] = fundReverse[_to].add(_value);
417         if(fundLockTime[_to] == 0)
418           fundLockTime[_to] = block.timestamp;  // Lock start time
419     }
420 
421     /**
422      * @dev Team account transaction
423      * @param _to  The accept token address
424      * @param _value Number of transactions
425      */
426     function teamLockTransfer(address _to, uint256 _value) internal returns (bool) {
427         //The remaining part
428        uint256 availReverse = balances[msg.sender].sub((teamLocked[msg.sender].sub(teamUsed[msg.sender]))+(fundLocked[msg.sender].sub(fundUsed[msg.sender])));
429        uint256 totalAvail=0;
430        uint256 availTeam =0;
431        if(issueDate==0)
432         {
433              totalAvail = availReverse;
434         }
435         else{
436             //the number of Tokens available for teamAccount'Locked part
437              availTeam = teamAvailable(msg.sender);
438              //the number of Tokens available for teamAccount
439              totalAvail = availTeam.add(availReverse);
440         }
441         require(_value <= totalAvail);
442         bool ret = super.transfer(_to,_value);
443         if(ret == true && issueDate>0) {
444             //If over the teamAccount's released part
445             if(_value > availTeam){
446                 teamUsed[msg.sender] = teamUsed[msg.sender].add(availTeam);
447                  teamReverse[msg.sender] = teamReverse[msg.sender].sub(availTeam);
448           }
449             //If in the teamAccount's released part
450             else{
451                 teamUsed[msg.sender] = teamUsed[msg.sender].add(_value);
452                 teamReverse[msg.sender] = teamReverse[msg.sender].sub(_value);
453             }
454         }
455         if(teamUsed[msg.sender] >= teamLocked[msg.sender]){
456             delete teamLockTime[msg.sender];
457             delete teamReverse[msg.sender];
458         }
459         return ret;
460     }
461 
462     /**
463      * @dev Team account authorization transaction
464      * @param _from The give token address
465      * @param _to  The accept token address
466      * @param _value Number of transactions
467      */
468     function teamLockTransferFrom(address _from,address _to, uint256 _value) internal returns (bool) {
469        //The remaining part
470        uint256 availReverse = balances[_from].sub((teamLocked[_from].sub(teamUsed[_from]))+(fundLocked[_from].sub(fundUsed[_from])));
471        uint256 totalAvail=0;
472        uint256 availTeam =0;
473         if(issueDate==0)
474         {
475              totalAvail = availReverse;
476         }
477         else{
478             //the number of Tokens available for teamAccount'Locked part
479              availTeam = teamAvailable(_from);
480               //the number of Tokens available for teamAccount
481              totalAvail = availTeam.add(availReverse);
482         }
483        require(_value <= totalAvail);
484         bool ret = super.transferFrom(_from,_to,_value);
485         if(ret == true && issueDate>0) {
486             //If over the teamAccount's released part
487             if(_value > availTeam){
488                 teamUsed[_from] = teamUsed[_from].add(availTeam);
489                 teamReverse[_from] = teamReverse[_from].sub(availTeam);
490            }
491             //If in the teamAccount's released part
492             else{
493                 teamUsed[_from] = teamUsed[_from].add(_value);
494                 teamReverse[_from] = teamReverse[_from].sub(_value);
495             }
496         }
497         if(teamUsed[_from] >= teamLocked[_from]){
498             delete teamLockTime[_from];
499             delete teamReverse[_from];
500         }
501         return ret;
502     }
503 
504     /**
505      * @dev Privately Offered Fund Transfer Token
506      * @param _to The accept token address
507      * @param _value Number of transactions
508      */
509     function fundLockTransfer(address _to, uint256 _value) internal returns (bool) {
510       //The remaining part
511        uint256 availReverse = balances[msg.sender].sub((teamLocked[msg.sender].sub(teamUsed[msg.sender]))+(fundLocked[msg.sender].sub(fundUsed[msg.sender])));
512        uint256 totalAvail=0;
513        uint256 availFund = 0;
514         if(issueDate==0)
515         {
516              totalAvail = availReverse;
517         }
518         else{
519              require(now>issueDate);
520             //the number of Tokens available for mainFundAccount'Locked part
521              availFund = fundAvailable(msg.sender);
522              //the number of Tokens available for mainFundAccount
523              totalAvail = availFund.add(availReverse);
524         }
525         require(_value <= totalAvail);
526         bool ret = super.transfer(_to,_value);
527         if(ret == true && issueDate>0) {
528             //If over the mainFundAccount's released part
529             if(_value > availFund){
530                 fundUsed[msg.sender] = fundUsed[msg.sender].add(availFund);
531                 fundReverse[msg.sender] = fundReverse[msg.sender].sub(availFund);
532              }
533             //If in the mainFundAccount's released part
534             else{
535                 fundUsed[msg.sender] =  fundUsed[msg.sender].add(_value);
536                 fundReverse[msg.sender] = fundReverse[msg.sender].sub(_value);
537             }
538         }
539         if(fundUsed[msg.sender] >= fundLocked[msg.sender]){
540             delete fundLockTime[msg.sender];
541             delete fundReverse[msg.sender];
542         }
543         return ret;
544     }
545 
546 
547     /**
548      * @dev Privately Offered Fund Transfer Token
549      * @param _from The give token address
550      * @param _to The accept token address
551      * @param _value Number of transactions
552      */
553     function fundLockTransferFrom(address _from,address _to, uint256 _value) internal returns (bool) {
554          //The remaining part
555         uint256 availReverse =  balances[_from].sub((teamLocked[_from].sub(teamUsed[_from]))+(fundLocked[_from].sub(fundUsed[_from])));
556         uint256 totalAvail=0;
557         uint256 availFund = 0;
558         if(issueDate==0)
559          {
560              totalAvail = availReverse;
561         }
562         else{
563              require(now>issueDate);
564              //the number of Tokens available for mainFundAccount'Locked part
565              availFund = fundAvailable(_from);
566               //the number of Tokens available for mainFundAccount
567              totalAvail = availFund.add(availReverse);
568          }
569       
570         require(_value <= totalAvail);
571         bool ret = super.transferFrom(_from,_to,_value);
572         if(ret == true && issueDate>0) {
573            //If over the mainFundAccount's released part
574             if(_value > availFund){
575                 fundUsed[_from] = fundUsed[_from].add(availFund);
576                 fundReverse[_from] = fundReverse[_from].sub(availFund);
577             }
578             //If in the mainFundAccount's released part
579             else{
580                 fundUsed[_from] =  fundUsed[_from].add(_value);
581                 fundReverse[_from] = fundReverse[_from].sub(_value);
582             }
583         }
584         if(fundUsed[_from] >= fundLocked[_from]){
585             delete fundLockTime[_from];
586         }
587         return ret;
588     }
589 }
590 
591 /**
592  * @title HitToken
593  * @dev HitToken Contract
594  **/
595 contract HitToken is Lock {
596     string public name;
597     string public symbol;
598     uint8 public decimals;
599     // Proportional accuracy
600     uint256  public precentDecimal = 2;
601     // mainFundPrecent
602     uint256 public mainFundPrecent = 2650; 
603     //subFundPrecent
604     uint256 public subFundPrecent = 350; 
605     //devTeamPrecent
606     uint256 public devTeamPrecent = 1500;
607     //hitFoundationPrecent
608     uint256 public hitFoundationPrecent = 5500;
609     //mainFundBalance
610     uint256 public  mainFundBalance;
611     //subFundBalance
612     uint256 public subFundBalance;
613     //devTeamBalance
614     uint256 public  devTeamBalance;
615     //hitFoundationBalance
616     uint256 public hitFoundationBalance;
617     //subFundAccount
618     address public subFundAccount;
619     //mainFundAccount
620     address public mainFundAccount;
621     
622 
623     /**
624      *  @dev Contract constructor
625      *  @param _name token's name
626      *  @param _symbol token's symbol
627      *  @param _decimals token's decimals
628      *  @param _initialSupply token's initialSupply
629      *  @param _teamAccount  teamAccount
630      *  @param _subFundAccount subFundAccount
631      *  @param _mainFundAccount mainFundAccount
632      *  @param _hitFoundationAccount hitFoundationAccount
633     */
634     function HitToken(string _name, string _symbol, uint8 _decimals, uint256 _initialSupply,address _teamAccount,address _subFundAccount,address _mainFundAccount,address _hitFoundationAccount) public {
635         name = _name;
636         symbol = _symbol;
637         decimals = _decimals;
638         //Define a subFundAccount
639         subFundAccount = _subFundAccount;
640         //Define a mainFundAccount
641         mainFundAccount = _mainFundAccount;
642         //Calculated according to accuracy, if the precision is 18, it is _initialSupply x 10 to the power of 18
643         totalSupply_ = _initialSupply * 10 ** uint256(_decimals);
644         //Calculate the total value of mainFund
645         mainFundBalance =  totalSupply_.mul(mainFundPrecent).div(100* 10 ** precentDecimal) ;
646         //Calculate the total value of subFund
647         subFundBalance =  totalSupply_.mul(subFundPrecent).div(100* 10 ** precentDecimal);
648         //Calculate the total value of devTeamBalance
649         devTeamBalance =  totalSupply_.mul(devTeamPrecent).div(100* 10 ** precentDecimal);
650         //Calculate the total value of  hitFoundationBalance
651         hitFoundationBalance = totalSupply_.mul(hitFoundationPrecent).div(100* 10 ** precentDecimal) ;
652         //Initially put the hitFoundationBalance into the hitFoundationAccount
653         balances[_hitFoundationAccount] = hitFoundationBalance; 
654         //Initially put the devTeamBalance into the teamAccount
655         balances[_teamAccount] = devTeamBalance;
656         //Initially put the subFundBalance into the subFundAccount
657         balances[_subFundAccount] = subFundBalance;
658          //Initially put the mainFundBalance into the mainFundAccount
659         balances[_mainFundAccount]=mainFundBalance;
660         //Initially lock the team account
661         teamLock(_teamAccount,devTeamBalance);
662         
663     }
664 
665     /**
666       * @dev destroy the msg sender's token onlyOwner
667       * @param _value the number of the destroy token
668      */
669     function burn(uint256 _value) public onlyOwner returns (bool) {
670         balances[msg.sender] = balances[msg.sender].sub(_value);
671         balances[address(0)] = balances[address(0)].add(_value);
672         emit Transfer(msg.sender, address(0), _value);
673         return true;
674     }
675 
676     /**
677      * @dev Transfer token
678      * @param _to the accept token address
679      * @param _value the number of transfer token
680      */
681     function transfer(address _to, uint256 _value) public returns (bool) {
682         if(issueDate==0)
683         {
684              //the mainFundAccounts is not allowed to transfer before issued
685             require(msg.sender != mainFundAccount);
686         }
687 
688         if(teamLockTime[msg.sender] > 0){
689              return super.teamLockTransfer(_to,_value);
690             }else if(fundLockTime[msg.sender] > 0){
691                 return super.fundLockTransfer(_to,_value);
692             }else {
693                return super.transfer(_to, _value);
694             
695         }
696     }
697 
698     /**
699      * @dev Transfer token
700      * @param _from the give token address
701      * @param _to the accept token address
702      * @param _value the number of transfer token
703      */
704     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
705           if(issueDate==0)
706         {
707               //the mainFundAccounts is not allowed to transfer before issued
708             require(_from != mainFundAccount);
709         }
710       
711         if(teamLockTime[_from] > 0){
712             return super.teamLockTransferFrom(_from,_to,_value);
713         }else if(fundLockTime[_from] > 0 ){  
714             return super.fundLockTransferFrom(_from,_to,_value);
715         }else{
716             return super.transferFrom(_from, _to, _value);
717         }
718     }
719 
720     /**
721      *  @dev Privately offered Fund 
722      *  @param _to the accept token address
723      *  @param _value the number of transfer token
724      */
725     function mintFund(address _to, uint256 _value) public  returns (bool){
726         require(msg.sender==mainFundAccount);
727         require(mainFundBalance >0);
728         require(_value >0);
729         if(_value <= mainFundBalance){
730             super.transfer(_to,_value);
731             fundLock(_to,_value);
732             mainFundBalance = mainFundBalance.sub(_value);
733         }
734     }
735 
736      /**
737       * @dev Issue the token 
738      */
739      function issue() public onlyOwner  returns (uint){
740          //Only one time 
741          require(issueDate==0);
742          issueDate = now;
743          return now;
744      }
745      
746      /**avoid mis-transfer*/
747      function() public payable{
748          revert();
749      }
750      
751    
752 }