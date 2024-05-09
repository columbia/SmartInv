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
360         //locks team account for 1 year
361         if(time >= 365 days) {
362           percent =  (time.div(30 days)) .add(1);
363         }
364         percent = percent > 12 ? 12 : percent;
365         uint256 avail = teamLocked[_to];
366         require(avail>0);
367         avail = avail.mul(percent).div(12).sub(teamUsed[_to]);
368         return avail ;
369     }
370     
371     /**
372      * @dev Get the number of Tokens available for the current private fund account 
373      * @param _to mainFundAccount's address
374     **/
375     function fundAvailable(address _to) internal constant returns (uint256) {
376         require(fundLockTime[_to]>0);
377         //Cover the start time of the lock before the release is the issueDate
378         if(fundLockTime[_to] != issueDate)
379         {
380             fundLockTime[_to]= issueDate;
381         }
382         //The start time of the lock position
383         uint256 lockTime = fundLockTime[_to];
384         //The interval between the current time and the start time of the lockout
385         uint256 time = block.timestamp.sub(lockTime);
386         //Unlocked 25%
387         uint256 percent = 250;
388         //After more than 30 days, 75% of the minutes and 150 days of unlocking 5/1000 per day
389         if(time >= 30 days) {
390             percent = percent.add( (((time.sub(30 days)).div (1 days)).add (1)).mul (5));
391         }
392         percent = percent > 1000 ? 1000 : percent;
393         uint256 avail = fundLocked[_to];
394         require(avail>0);
395         avail = avail.mul(percent).div(1000).sub(fundUsed[_to]);
396         return avail ;
397     }
398     /**
399       * @dev Team lock
400       * @param _to  team lock account's address
401       * @param _value the number of Token
402      */
403     function teamLock(address _to,uint256 _value) internal {
404         require(_value>0);
405         teamLocked[_to] = teamLocked[_to].add(_value);
406         teamReverse[_to] = teamReverse[_to].add(_value);
407         teamLockTime[_to] = block.timestamp;  // Lock start time
408     }
409     /**
410       * @dev  Privately offered fund lock
411       * @param _to  Privately offered fund account's address
412       * @param _value the number of Token
413      */
414     function fundLock(address _to,uint256 _value) internal {
415         require(_value>0);
416         fundLocked[_to] =fundLocked[_to].add(_value);
417         fundReverse[_to] = fundReverse[_to].add(_value);
418         if(fundLockTime[_to] == 0)
419           fundLockTime[_to] = block.timestamp;  // Lock start time
420     }
421 
422     /**
423      * @dev Team account transaction
424      * @param _to  The accept token address
425      * @param _value Number of transactions
426      */
427     function teamLockTransfer(address _to, uint256 _value) internal returns (bool) {
428         //The remaining part
429        uint256 availReverse = balances[msg.sender].sub((teamLocked[msg.sender].sub(teamUsed[msg.sender]))+(fundLocked[msg.sender].sub(fundUsed[msg.sender])));
430        uint256 totalAvail=0;
431        uint256 availTeam =0;
432        if(issueDate==0)
433         {
434              totalAvail = availReverse;
435         }
436         else{
437             //the number of Tokens available for teamAccount'Locked part
438              availTeam = teamAvailable(msg.sender);
439              //the number of Tokens available for teamAccount
440              totalAvail = availTeam.add(availReverse);
441         }
442         require(_value <= totalAvail);
443         bool ret = super.transfer(_to,_value);
444         if(ret == true && issueDate>0) {
445             //If over the teamAccount's released part
446             if(_value > availTeam){
447                 teamUsed[msg.sender] = teamUsed[msg.sender].add(availTeam);
448                  teamReverse[msg.sender] = teamReverse[msg.sender].sub(availTeam);
449           }
450             //If in the teamAccount's released part
451             else{
452                 teamUsed[msg.sender] = teamUsed[msg.sender].add(_value);
453                 teamReverse[msg.sender] = teamReverse[msg.sender].sub(_value);
454             }
455         }
456         if(teamUsed[msg.sender] >= teamLocked[msg.sender]){
457             delete teamLockTime[msg.sender];
458             delete teamReverse[msg.sender];
459         }
460         return ret;
461     }
462 
463     /**
464      * @dev Team account authorization transaction
465      * @param _from The give token address
466      * @param _to  The accept token address
467      * @param _value Number of transactions
468      */
469     function teamLockTransferFrom(address _from,address _to, uint256 _value) internal returns (bool) {
470        //The remaining part
471        uint256 availReverse = balances[_from].sub((teamLocked[_from].sub(teamUsed[_from]))+(fundLocked[_from].sub(fundUsed[_from])));
472        uint256 totalAvail=0;
473        uint256 availTeam =0;
474         if(issueDate==0)
475         {
476              totalAvail = availReverse;
477         }
478         else{
479             //the number of Tokens available for teamAccount'Locked part
480              availTeam = teamAvailable(_from);
481               //the number of Tokens available for teamAccount
482              totalAvail = availTeam.add(availReverse);
483         }
484        require(_value <= totalAvail);
485         bool ret = super.transferFrom(_from,_to,_value);
486         if(ret == true && issueDate>0) {
487             //If over the teamAccount's released part
488             if(_value > availTeam){
489                 teamUsed[_from] = teamUsed[_from].add(availTeam);
490                 teamReverse[_from] = teamReverse[_from].sub(availTeam);
491            }
492             //If in the teamAccount's released part
493             else{
494                 teamUsed[_from] = teamUsed[_from].add(_value);
495                 teamReverse[_from] = teamReverse[_from].sub(_value);
496             }
497         }
498         if(teamUsed[_from] >= teamLocked[_from]){
499             delete teamLockTime[_from];
500             delete teamReverse[_from];
501         }
502         return ret;
503     }
504 
505     /**
506      * @dev Privately Offered Fund Transfer Token
507      * @param _to The accept token address
508      * @param _value Number of transactions
509      */
510     function fundLockTransfer(address _to, uint256 _value) internal returns (bool) {
511       //The remaining part
512        uint256 availReverse = balances[msg.sender].sub((teamLocked[msg.sender].sub(teamUsed[msg.sender]))+(fundLocked[msg.sender].sub(fundUsed[msg.sender])));
513        uint256 totalAvail=0;
514        uint256 availFund = 0;
515         if(issueDate==0)
516         {
517              totalAvail = availReverse;
518         }
519         else{
520              require(now>issueDate);
521             //the number of Tokens available for mainFundAccount'Locked part
522              availFund = fundAvailable(msg.sender);
523              //the number of Tokens available for mainFundAccount
524              totalAvail = availFund.add(availReverse);
525         }
526         require(_value <= totalAvail);
527         bool ret = super.transfer(_to,_value);
528         if(ret == true && issueDate>0) {
529             //If over the mainFundAccount's released part
530             if(_value > availFund){
531                 fundUsed[msg.sender] = fundUsed[msg.sender].add(availFund);
532                 fundReverse[msg.sender] = fundReverse[msg.sender].sub(availFund);
533              }
534             //If in the mainFundAccount's released part
535             else{
536                 fundUsed[msg.sender] =  fundUsed[msg.sender].add(_value);
537                 fundReverse[msg.sender] = fundReverse[msg.sender].sub(_value);
538             }
539         }
540         if(fundUsed[msg.sender] >= fundLocked[msg.sender]){
541             delete fundLockTime[msg.sender];
542             delete fundReverse[msg.sender];
543         }
544         return ret;
545     }
546 
547 
548     /**
549      * @dev Privately Offered Fund Transfer Token
550      * @param _from The give token address
551      * @param _to The accept token address
552      * @param _value Number of transactions
553      */
554     function fundLockTransferFrom(address _from,address _to, uint256 _value) internal returns (bool) {
555          //The remaining part
556         uint256 availReverse =  balances[_from].sub((teamLocked[_from].sub(teamUsed[_from]))+(fundLocked[_from].sub(fundUsed[_from])));
557         uint256 totalAvail=0;
558         uint256 availFund = 0;
559         if(issueDate==0)
560          {
561              totalAvail = availReverse;
562         }
563         else{
564              require(now>issueDate);
565              //the number of Tokens available for mainFundAccount'Locked part
566              availFund = fundAvailable(_from);
567               //the number of Tokens available for mainFundAccount
568              totalAvail = availFund.add(availReverse);
569          }
570       
571         require(_value <= totalAvail);
572         bool ret = super.transferFrom(_from,_to,_value);
573         if(ret == true && issueDate>0) {
574            //If over the mainFundAccount's released part
575             if(_value > availFund){
576                 fundUsed[_from] = fundUsed[_from].add(availFund);
577                 fundReverse[_from] = fundReverse[_from].sub(availFund);
578             }
579             //If in the mainFundAccount's released part
580             else{
581                 fundUsed[_from] =  fundUsed[_from].add(_value);
582                 fundReverse[_from] = fundReverse[_from].sub(_value);
583             }
584         }
585         if(fundUsed[_from] >= fundLocked[_from]){
586             delete fundLockTime[_from];
587         }
588         return ret;
589     }
590 }
591 
592 /**
593  * @title HitToken
594  * @dev HitToken Contract
595  **/
596 contract HitToken is Lock {
597     string public name;
598     string public symbol;
599     uint8 public decimals;
600     // Proportional accuracy
601     uint256  public precentDecimal = 2;
602     // mainFundPrecent
603     uint256 public mainFundPrecent = 2650; 
604     //subFundPrecent
605     uint256 public subFundPrecent = 350; 
606     //devTeamPrecent
607     uint256 public devTeamPrecent = 1500;
608     //hitFoundationPrecent
609     uint256 public hitFoundationPrecent = 5500;
610     //mainFundBalance
611     uint256 public  mainFundBalance;
612     //subFundBalance
613     uint256 public subFundBalance;
614     //devTeamBalance
615     uint256 public  devTeamBalance;
616     //hitFoundationBalance
617     uint256 public hitFoundationBalance;
618     //subFundAccount
619     address public subFundAccount;
620     //mainFundAccount
621     address public mainFundAccount;
622     
623 
624     /**
625      *  @dev Contract constructor
626      *  @param _name token's name
627      *  @param _symbol token's symbol
628      *  @param _decimals token's decimals
629      *  @param _initialSupply token's initialSupply
630      *  @param _teamAccount  teamAccount
631      *  @param _subFundAccount subFundAccount
632      *  @param _mainFundAccount mainFundAccount
633      *  @param _hitFoundationAccount hitFoundationAccount
634     */
635     function HitToken(string _name, string _symbol, uint8 _decimals, uint256 _initialSupply,address _teamAccount,address _subFundAccount,address _mainFundAccount,address _hitFoundationAccount) public {
636         name = _name;
637         symbol = _symbol;
638         decimals = _decimals;
639         //Define a subFundAccount
640         subFundAccount = _subFundAccount;
641         //Define a mainFundAccount
642         mainFundAccount = _mainFundAccount;
643         //Calculated according to accuracy, if the precision is 18, it is _initialSupply x 10 to the power of 18
644         totalSupply_ = _initialSupply * 10 ** uint256(_decimals);
645         //Calculate the total value of mainFund
646         mainFundBalance =  totalSupply_.mul(mainFundPrecent).div(100* 10 ** precentDecimal) ;
647         //Calculate the total value of subFund
648         subFundBalance =  totalSupply_.mul(subFundPrecent).div(100* 10 ** precentDecimal);
649         //Calculate the total value of devTeamBalance
650         devTeamBalance =  totalSupply_.mul(devTeamPrecent).div(100* 10 ** precentDecimal);
651         //Calculate the total value of  hitFoundationBalance
652         hitFoundationBalance = totalSupply_.mul(hitFoundationPrecent).div(100* 10 ** precentDecimal) ;
653         //Initially put the hitFoundationBalance into the hitFoundationAccount
654         balances[_hitFoundationAccount] = hitFoundationBalance; 
655         //Initially put the devTeamBalance into the teamAccount
656         balances[_teamAccount] = devTeamBalance;
657         //Initially put the subFundBalance into the subFundAccount
658         balances[_subFundAccount] = subFundBalance;
659          //Initially put the mainFundBalance into the mainFundAccount
660         balances[_mainFundAccount]=mainFundBalance;
661         //Initially lock the team account
662         teamLock(_teamAccount,devTeamBalance);
663         
664     }
665 
666     /**
667       * @dev destroy the msg sender's token onlyOwner
668       * @param _value the number of the destroy token
669      */
670     function burn(uint256 _value) public onlyOwner returns (bool) {
671         balances[msg.sender] = balances[msg.sender].sub(_value);
672         balances[address(0)] = balances[address(0)].add(_value);
673         emit Transfer(msg.sender, address(0), _value);
674         return true;
675     }
676 
677     /**
678      * @dev Transfer token
679      * @param _to the accept token address
680      * @param _value the number of transfer token
681      */
682     function transfer(address _to, uint256 _value) public returns (bool) {
683         if(issueDate==0)
684         {
685              //the mainFundAccounts is not allowed to transfer before issued
686             require(msg.sender != mainFundAccount);
687         }
688 
689         if(teamLockTime[msg.sender] > 0){
690              return super.teamLockTransfer(_to,_value);
691             }else if(fundLockTime[msg.sender] > 0){
692                 return super.fundLockTransfer(_to,_value);
693             }else {
694                return super.transfer(_to, _value);
695             
696         }
697     }
698 
699     /**
700      * @dev Transfer token
701      * @param _from the give token address
702      * @param _to the accept token address
703      * @param _value the number of transfer token
704      */
705     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
706           if(issueDate==0)
707         {
708               //the mainFundAccounts is not allowed to transfer before issued
709             require(_from != mainFundAccount);
710         }
711       
712         if(teamLockTime[_from] > 0){
713             return super.teamLockTransferFrom(_from,_to,_value);
714         }else if(fundLockTime[_from] > 0 ){  
715             return super.fundLockTransferFrom(_from,_to,_value);
716         }else{
717             return super.transferFrom(_from, _to, _value);
718         }
719     }
720 
721     /**
722      *  @dev Privately offered Fund 
723      *  @param _to the accept token address
724      *  @param _value the number of transfer token
725      */
726     function mintFund(address _to, uint256 _value) public  returns (bool){
727         require(msg.sender==mainFundAccount);
728         require(mainFundBalance >0);
729         require(_value >0);
730         if(_value <= mainFundBalance){
731             super.transfer(_to,_value);
732             fundLock(_to,_value);
733             mainFundBalance = mainFundBalance.sub(_value);
734         }
735     }
736 
737      /**
738       * @dev Issue the token 
739      */
740      function issue() public onlyOwner  returns (uint){
741          //Only one time 
742          require(issueDate==0);
743          issueDate = now;
744          return now;
745      }
746      
747      /**avoid mis-transfer*/
748      function() public payable{
749          revert();
750      }
751      
752    
753 }