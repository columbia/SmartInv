1 pragma solidity ^0.4.18;
2 
3 pragma solidity ^0.4.18;
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11     uint256 public totalSupply;
12     function balanceOf(address who) public view returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 
52 /**
53  * @title Basic contracts
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 contract BasicToken is ERC20Basic {
57     using SafeMath for uint256;
58 
59     mapping(address => uint256) balances;
60 
61     /**
62     * @dev transfer contracts for a specified address
63     * @param _to The address to transfer to.
64     * @param _value The amount to be transferred.
65     */
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(_value <= balances[msg.sender]);
69 
70         // SafeMath.sub will throw if there is not enough balance.
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         emit Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     /**
78     * @dev Gets the balance of the specified address.
79     * @param _owner The address to query the the balance of.
80     * @return An uint256 representing the amount owned by the passed address.
81     */
82     function balanceOf(address _owner) public view returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86 }
87 
88 
89 /**
90  * @title Burnable Token
91  * @dev Token that can be irreversibly burned (destroyed).
92  */
93 contract BurnableToken is BasicToken {
94 
95     event Burn(address indexed burner, uint256 value);
96 
97     /**
98      * @dev Burns a specific amount of tokens.
99      * @param _value The amount of contracts to be burned.
100      */
101     function burn(uint256 _value) public {
102         require(_value <= balances[msg.sender]);
103         // no need to require value <= totalSupply, since that would imply the
104         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
105 
106         address burner = msg.sender;
107         balances[burner] = balances[burner].sub(_value);
108         totalSupply = totalSupply.sub(_value);
109         emit Burn(burner, _value);
110     }
111 }
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119     function allowance(address owner, address spender) public view returns (uint256);
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121     function approve(address spender, uint256 value) public returns (bool);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 /**
128  * @title Standard ERC20 contracts
129  *
130  * @dev Implementation of the basic standard contracts.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136     mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139     /**
140      * @dev Transfer tokens from one address to another
141      * @param _from address The address which you want to send tokens from
142      * @param _to address The address which you want to transfer to
143      * @param _value uint256 the amount of tokens to be transferred
144      */
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[_from]);
148         require(_value <= allowed[_from][msg.sender]);
149 
150         balances[_from] = balances[_from].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         emit Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159      *
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param _spender The address which will spend the funds.
165      * @param _value The amount of tokens to be spent.
166      */
167     function approve(address _spender, uint256 _value) public returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174      * @dev Function to check the amount of tokens that an owner allowed to a spender.
175      * @param _owner address The address which owns the funds.
176      * @param _spender address The address which will spend the funds.
177      * @return A uint256 specifying the amount of tokens still available for the spender.
178      */
179     function allowance(address _owner, address _spender) public view returns (uint256) {
180         return allowed[_owner][_spender];
181     }
182 
183     /**
184      * @dev Increase the amount of tokens that an owner allowed to a spender.
185      *
186      * approve should be called when allowed[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      *
202      * approve should be called when allowed[_spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * @param _spender The address which will spend the funds.
207      * @param _subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210         uint oldValue = allowed[msg.sender][_spender];
211         if (_subtractedValue > oldValue) {
212             allowed[msg.sender][_spender] = 0;
213         } else {
214             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215         }
216         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217         return true;
218     }
219 
220 }
221 
222 /**
223  * @title Ownable
224  * @dev The Ownable contract has an owner address, and provides basic authorization control
225  * functions, this simplifies the implementation of "user permissions".
226  */
227 contract Ownable {
228     address public owner;
229 
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233 
234     /**
235      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
236      * account.
237      */
238     function Ownable() public {
239         owner = msg.sender;
240     }
241 
242 
243     /**
244      * @dev Throws if called by any account other than the owner.
245      */
246     modifier onlyOwner() {
247         require(msg.sender == owner);
248         _;
249     }
250 
251 
252     /**
253      * @dev Allows the current owner to transfer control of the contract to a newOwner.
254      * @param newOwner The address to transfer ownership to.
255      */
256     function transferOwnership(address newOwner) public onlyOwner {
257         require(newOwner != address(0));
258         emit OwnershipTransferred(owner, newOwner);
259         owner = newOwner;
260     }
261 
262 }
263 
264 
265 
266 /**
267  * @title Pausable
268  * @dev Base contract which allows children to implement an emergency stop mechanism.
269  */
270 contract Pausable is Ownable {
271     event Pause();
272     event Unpause();
273 
274     bool public paused = false;
275 
276 
277     /**
278      * @dev Modifier to make a function callable only when the contract is not paused.
279      */
280     modifier whenNotPaused() {
281         require(!paused);
282         _;
283     }
284 
285     /**
286      * @dev Modifier to make a function callable only when the contract is paused.
287      */
288     modifier whenPaused() {
289         require(paused);
290         _;
291     }
292 
293     /**
294      * @dev called by the owner to pause, triggers stopped state
295      */
296     function pause() onlyOwner whenNotPaused public {
297         paused = true;
298         emit Pause();
299     }
300 
301     /**
302      * @dev called by the owner to unpause, returns to normal state
303      */
304     function unpause() onlyOwner whenPaused public {
305         paused = false;
306         emit Unpause();
307     }
308 }
309 
310 
311 /**
312  * @title Pausable token
313  *
314  * @dev StandardToken modified with pausable transfers.
315  **/
316 
317 contract PausableToken is StandardToken, Pausable {
318 
319     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
320         return super.transfer(_to, _value);
321     }
322 
323     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
324         return super.transferFrom(_from, _to, _value);
325     }
326 
327     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
328         return super.approve(_spender, _value);
329     }
330 
331     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
332         return super.increaseApproval(_spender, _addedValue);
333     }
334 
335     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
336         return super.decreaseApproval(_spender, _subtractedValue);
337     }
338 
339 }
340 
341 contract PAXToken is BurnableToken, PausableToken {
342 
343     using SafeMath for uint;
344 
345     string public constant name = "Pax Token";
346 
347     string public constant symbol = "PAX";
348 
349     uint32 public constant decimals = 10;
350 
351     uint256 public constant INITIAL_SUPPLY = 999500000 * (10 ** uint256(decimals));
352 
353     /**
354      * @dev Constructor that gives msg.sender all of existing tokens.
355      * @param _company address reserve tokens (300000000)
356      * @param _founders_1 address reserve tokens (300000000)
357      * @param _founders_2 address reserve tokens (50000000)
358      * @param _isPause bool (pause === true)
359      */
360     function PAXToken(address _company, address _founders_1, address _founders_2, bool _isPause) public {
361         require(_company != address(0) && _founders_1 != address(0) && _founders_2 != address(0));
362         paused = _isPause;
363         totalSupply = INITIAL_SUPPLY;
364         balances[msg.sender] = 349500000 * (10 ** uint256(decimals));
365         balances[_company] = 300000000 * (10 ** uint256(decimals));
366         balances[_founders_1] = 300000000 * (10 ** uint256(decimals));
367         balances[_founders_2] = 50000000 * (10 ** uint256(decimals));
368         emit Transfer(0x0, msg.sender, balances[msg.sender]);
369         emit Transfer(0x0, _company, balances[_company]);
370         emit Transfer(0x0, _founders_1, balances[_founders_1]);
371         emit Transfer(0x0, _founders_2, balances[_founders_2]);
372 
373     }
374 
375     /**
376     * @dev transfer contracts for a specified address, despite the pause state
377     * @param _to The address to transfer to.
378     * @param _value The amount to be transferred.
379     */
380     function ownersTransfer(address _to, uint256 _value) public onlyOwner returns (bool) {
381         return BasicToken.transfer(_to, _value);
382     }
383 }
384 
385 contract Crowdsale is Pausable {
386 
387     struct stageInfo {
388         uint start;
389         uint stop;
390         uint duration;
391         uint bonus;
392         uint limit;
393     }
394 
395     /**
396      * @dev Mapping with stageId = stageInfo
397      */
398     mapping (uint => stageInfo) public stages;
399 
400     /**
401      * @dev Mapping with adress = with balance
402      */
403     mapping(address => uint) public balances;
404 
405     /**
406      * @dev Softcap
407      */
408     uint public constant softcap = 2500 ether;
409 
410     /**
411      * @dev xDecimals
412      */
413     uint public constant decimals = 1E10;
414 
415     /**
416      * @dev ICO Period Number
417      */
418     uint public period = 5;
419 
420     /**
421      * @dev Total number of minted tokens
422      */
423     uint public hardcap;
424 
425     /**
426      * @dev Cost of the token
427      */
428     uint public rate;
429 
430     /**
431      * @dev Number of sold tokens
432      */
433     uint public totalSold = 0;
434 
435     /**
436      * @dev Assembled Eth
437      */
438     uint256 public sumWei;
439 
440     /**
441      * @dev ICO Status
442      */
443     bool public state;
444 
445     /**
446      * @dev Once call flag
447      */
448     bool public requireOnce = true;
449 
450     /**
451      * @dev Once burning flag
452      */
453     bool public isBurned;
454 
455     /**
456      * @dev Reserve tokens adress for company (300000000)
457      */
458     address public company;
459 
460     /**
461      * @dev Reserve tokens adress for founders first (300000000)
462      */
463     address public founders_1;
464 
465     /**
466      * @dev Reserve tokens adress for founders second (50000000)
467      */
468     address public founders_2;
469 
470     /**
471      * @dev The address to which the received ether will be sent
472      */
473     address public multisig;
474 
475     /**
476      * @dev Tokens classes
477      */
478     PAXToken public token;
479 
480     /**
481      * @dev Number of coins for the typical period
482      */
483     uint private constant typicalBonus = 100;
484 
485     /**
486      * @dev Sending tokens
487      */
488     uint private sendingTokens;
489 
490     /**
491      * @dev Time left
492      */
493     uint private timeLeft;
494 
495     /**
496      * @dev Pause date
497      */
498     uint private pauseDate;
499 
500     /**
501      * @dev Paused by value flag
502      */
503     bool private pausedByValue;
504 
505     /**
506      * @dev Manual pause flag
507      */
508     bool private manualPause;
509 
510 
511     event StartICO();
512 
513     event StopICO();
514 
515     event BurnUnsoldTokens();
516 
517     event NewWalletAddress(address _to);
518 
519     event Refund(address _wallet, uint _val);
520 
521     event DateMoved(uint value);
522 
523     using SafeMath for uint;
524 
525     modifier saleIsOn() {
526         require(state);
527         uint stageId = getStageId();
528         if (period != stageId || stageId == 5) {
529             usersPause();
530             (msg.sender).transfer(msg.value);
531         }
532         else
533             _;
534     }
535 
536     modifier isUnderHardCap() {
537         uint tokenBalance = token.balanceOf(this);
538         require(
539             tokenBalance <= hardcap &&
540             tokenBalance >= 500
541         );
542         _;
543     }
544 
545 
546     function Crowdsale(address _company, address _founders_1, address _founders_2, address _token) public {
547         multisig = owner;
548         rate = (uint)(1 ether).div(5000);
549 
550         stages[0] = stageInfo({
551             start: 0,
552             stop: 0,
553             duration: 14 days,
554             bonus: 130,
555             limit:  44500000 * decimals
556             });
557 
558         stages[1] = stageInfo({
559             start: 0,
560             stop: 0,
561             duration: 14 days,
562             bonus: 115,
563             limit:  85000000 * decimals
564             });
565 
566         stages[2] = stageInfo({
567             start: 0,
568             stop: 0,
569             duration: 14 days,
570             bonus: 110,
571             limit:  100000000 * decimals
572             });
573 
574         stages[3] = stageInfo({
575             start: 0,
576             stop: 0,
577             duration: 14 days,
578             bonus: 105,
579             limit:  120000000 * decimals
580             });
581 
582         hardcap = 349500000 * decimals;
583 
584         token = PAXToken(_token);
585 
586         company = _company;
587         founders_1 = _founders_1;
588         founders_2 = _founders_2;
589     }
590 
591 
592     /**
593      * @dev Fallback function
594      */
595     function() whenNotPaused saleIsOn external payable {
596         require (msg.value > 0);
597         sendTokens(msg.value, msg.sender);
598     }
599 
600     /**
601      * @dev Manual sending tokens
602      * @param _to address where sending tokens
603      * @param _value uint256 value tokens for sending
604      */
605     function manualSendTokens(address _to, uint256 _value) public onlyOwner returns(bool) {
606         uint tokens = _value;
607         uint avalibleTokens = token.balanceOf(this);
608 
609         if (tokens < avalibleTokens) {
610             if (tokens <= stages[3].limit) {
611                 stages[3].limit = (stages[3].limit).sub(tokens);
612             } else if (tokens <= (stages[3].limit).add(stages[2].limit)) {
613                 stages[2].limit = (stages[2].limit).sub(tokens.sub(stages[3].limit));
614                 stages[3].limit = 0;
615             } else if (tokens <= (stages[3].limit).add(stages[2].limit).add(stages[1].limit)) {
616                 stages[1].limit = (stages[1].limit).sub(tokens.sub(stages[3].limit).sub(stages[2].limit));
617                 stages[3].limit = 0;
618                 stages[2].limit = 0;
619             } else if (tokens <= (stages[3].limit).add(stages[2].limit).add(stages[1].limit).add(stages[0].limit)) {
620                 stages[0].limit = (stages[0].limit).sub(tokens.sub(stages[3].limit).sub(stages[2].limit).sub(stages[1].limit));
621                 stages[3].limit = 0;
622                 stages[2].limit = 0;
623                 stages[1].limit = 0;
624             }
625         } else {
626             tokens = avalibleTokens;
627             stages[3].limit = 0;
628             stages[2].limit = 0;
629             stages[1].limit = 0;
630             stages[0].limit = 0;
631         }
632 
633         sendingTokens = sendingTokens.add(tokens);
634         sumWei = sumWei.add(tokens.mul(rate).div(decimals));
635         totalSold = totalSold.add(tokens);
636         token.ownersTransfer(_to, tokens);
637 
638         return true;
639     }
640 
641     /**
642      * @dev Return Etherium all investors
643      */
644     function refund() public {
645         require(sumWei < softcap && !state);
646         uint value = balances[msg.sender];
647         balances[msg.sender] = 0;
648         emit Refund(msg.sender, value);
649         msg.sender.transfer(value);
650     }
651 
652     /**
653      * @dev Burning all tokens on mintAddress
654      */
655     function burnUnsoldTokens() onlyOwner public returns(bool) {
656         require(!state);
657         require(!isBurned);
658         isBurned = true;
659         emit BurnUnsoldTokens();
660         token.burn(token.balanceOf(this));
661         if (token.paused()) {
662             token.unpause();
663         }
664         return true;
665     }
666 
667     /**
668      * @dev Starting ICO
669      */
670     function startICO() public onlyOwner returns(bool) {
671         require(stages[0].start >= now);
672         require(requireOnce);
673         requireOnce = false;
674         state = true;
675         period = 0;
676         emit StartICO();
677         token.ownersTransfer(company, (uint)(300000000).mul(decimals));
678         token.ownersTransfer(founders_1, (uint)(300000000).mul(decimals));
679         token.ownersTransfer(founders_2, (uint)(50000000).mul(decimals));
680         return true;
681     }
682 
683     /**
684      * @dev Turning off the ICO
685      */
686     function stopICO() onlyOwner public returns(bool) {
687         state = false;
688         emit StopICO();
689         if (token.paused()) {
690             token.unpause();
691         }
692         return true;
693     }
694 
695     /**
696      * @dev called by the owner to pause, triggers stopped state
697      */
698     function pause() onlyOwner whenNotPaused public {
699         manualPause = true;
700         usersPause();
701     }
702 
703     /**
704      * @dev called by the owner to unpause, returns to normal state
705      */
706     function unpause() onlyOwner whenPaused public {
707         uint shift = now.sub(pauseDate);
708         dateMove(shift);
709         period = getStageId();
710         pausedByValue = false;
711         manualPause = false;
712         super.unpause();
713     }
714 
715     /**
716      * @dev Withdrawal Etherium from smart-contract
717      */
718     function withDrawal() public onlyOwner {
719         if(!state && sumWei >= softcap) {
720             multisig.transfer(address(this).balance);
721         }
722     }
723 
724     /**
725      * @dev Returns stage id
726      */
727     function getStageId() public view returns(uint) {
728         uint stageId;
729         uint today = now;
730 
731         if (today < stages[0].stop) {
732             stageId = 0;
733 
734         } else if (today >= stages[1].start &&
735         today < stages[1].stop ) {
736             stageId = 1;
737 
738         } else if (today >= stages[2].start &&
739         today < stages[2].stop ) {
740             stageId = 2;
741 
742         } else if (today >= stages[3].start &&
743         today < stages[3].stop ) {
744             stageId = 3;
745 
746         } else if (today >= stages[3].stop) {
747             stageId = 4;
748 
749         } else {
750             return 5;
751         }
752 
753         uint tempId = (stageId > period) ? stageId : period;
754         return tempId;
755     }
756 
757     /**
758      * @dev Returns Limit of coins for the period and Number of coins taking
759      * into account the bonus for the period
760      */
761     function getStageData() public view returns(uint tempLimit, uint tempBonus) {
762         uint stageId = getStageId();
763         tempBonus = stages[stageId].bonus;
764 
765         if (stageId == 0) {
766             tempLimit = stages[0].limit;
767 
768         } else if (stageId == 1) {
769             tempLimit = (stages[0].limit).add(stages[1].limit);
770 
771         } else if (stageId == 2) {
772             tempLimit = (stages[0].limit).add(stages[1].limit).add(stages[2].limit);
773 
774         } else if (stageId == 3) {
775             tempLimit = (stages[0].limit).add(stages[1].limit).add(stages[2].limit).add(stages[3].limit);
776 
777         } else {
778             tempLimit = token.balanceOf(this);
779             tempBonus = typicalBonus;
780             return;
781         }
782         tempLimit = tempLimit.sub(totalSold);
783         return;
784     }
785 
786     /**
787      * @dev Returns the amount for which you can redeem all tokens for the current period
788      */
789     function calculateStagePrice() public view returns(uint price) {
790         uint limit;
791         uint bonusCoefficient;
792         (limit, bonusCoefficient) = getStageData();
793 
794         price = limit.mul(rate).mul(100).div(bonusCoefficient).div(decimals);
795     }
796 
797     /**
798      * @dev Sending tokens to the recipient, based on the amount of ether that it sent
799      * @param _etherValue uint Amount of sent ether
800      * @param _to address The address which you want to transfer to
801      */
802     function sendTokens(uint _etherValue, address _to) internal isUnderHardCap {
803         uint limit;
804         uint bonusCoefficient;
805         (limit, bonusCoefficient) = getStageData();
806         uint tokens = (_etherValue).mul(bonusCoefficient).mul(decimals).div(100);
807         tokens = tokens.div(rate);
808         bool needPause;
809 
810         if (tokens > limit) {
811             needPause = true;
812             uint stageEther = calculateStagePrice();
813             period++;
814             if (period == 4) {
815                 balances[msg.sender] = balances[msg.sender].add(stageEther);
816                 sumWei = sumWei.add(stageEther);
817                 token.ownersTransfer(_to, limit);
818                 totalSold = totalSold.add(limit);
819                 _to.transfer(_etherValue.sub(stageEther));
820                 state = false;
821                 return;
822             }
823             balances[msg.sender] = balances[msg.sender].add(stageEther);
824             sumWei = sumWei.add(stageEther);
825             token.ownersTransfer(_to, limit);
826             totalSold = totalSold.add(limit);
827             sendTokens(_etherValue.sub(stageEther), _to);
828 
829         } else {
830             require(tokens <= token.balanceOf(this));
831             if (limit.sub(tokens) < 500) {
832                 needPause = true;
833                 period++;
834             }
835             balances[msg.sender] = balances[msg.sender].add(_etherValue);
836             sumWei = sumWei.add(_etherValue);
837             token.ownersTransfer(_to, tokens);
838             totalSold = totalSold.add(tokens);
839         }
840 
841         if (needPause) {
842             pausedByValue = true;
843             usersPause();
844         }
845     }
846 
847     /**
848      * @dev called by the contract to pause, triggers stopped state
849      */
850     function usersPause() private {
851         pauseDate = now;
852         paused = true;
853         emit Pause();
854     }
855 
856     /**
857      * @dev Moving date after the pause
858      * @param _shift uint Time in seconds
859      */
860     function dateMove(uint _shift) private returns(bool) {
861         require(_shift > 0);
862 
863         uint i;
864 
865         if (pausedByValue) {
866             stages[period].start = now;
867             stages[period].stop = (stages[period].start).add(stages[period].duration);
868 
869             for (i = period + 1; i < 4; i++) {
870                 stages[i].start = stages[i - 1].stop;
871                 stages[i].stop = (stages[i].start).add(stages[i].duration);
872             }
873 
874         } else {
875             if (manualPause) stages[period].stop = (stages[period].stop).add(_shift);
876 
877             for (i = period + 1; i < 4; i++) {
878                 stages[i].start = (stages[i].start).add(_shift);
879                 stages[i].stop = (stages[i].stop).add(_shift);
880             }
881         }
882 
883         emit DateMoved(_shift);
884 
885         return true;
886     }
887 
888     /**
889      * @dev Returns the total number of tokens available for sale
890      */
891     function tokensAmount() public view returns(uint) {
892         return token.balanceOf(this);
893     }
894 
895     /**
896      * @dev Returns number of supplied tokens
897      */
898     function tokensSupply() public view returns(uint) {
899         return token.totalSupply();
900     }
901 
902     /**
903      * @dev Set start date
904      * @param _start uint Time start
905      */
906     function setStartDate(uint _start) public onlyOwner returns(bool) {
907         require(_start > now);
908         require(requireOnce);
909 
910         stages[0].start = _start;
911         stages[0].stop = _start.add(stages[0].duration);
912         stages[1].start = stages[0].stop;
913         stages[1].stop = stages[1].start.add(stages[1].duration);
914         stages[2].start = stages[1].stop;
915         stages[2].stop = stages[2].start.add(stages[2].duration);
916         stages[3].start = stages[2].stop;
917         stages[3].stop = stages[3].start.add(stages[3].duration);
918 
919         return true;
920     }
921 
922     /**
923      * @dev Sets new multisig address to which the received ether will be sent
924      * @param _to address
925      */
926     function setMultisig(address _to) public onlyOwner returns(bool) {
927         require(_to != address(0));
928         multisig = _to;
929         emit NewWalletAddress(_to);
930         return true;
931     }
932 
933     /**
934      * @dev Change first adress with reserve(300000000 tokens)
935      * @param _company address
936      */
937     function setReserveForCompany(address _company) public onlyOwner {
938         require(_company != address(0));
939         require(requireOnce);
940         company = _company;
941     }
942 
943     /**
944      * @dev Change second adress with reserve(300000000 tokens)
945      * @param _founders_1 address
946      */
947     function setReserveForFoundersFirst(address _founders_1) public onlyOwner {
948         require(_founders_1 != address(0));
949         require(requireOnce);
950         founders_1 = _founders_1;
951     }
952 
953     /**
954      * @dev Change third adress with reserve(50000000 tokens)
955      * @param _founders_2 address
956      */
957     function setReserveForFoundersSecond(address _founders_2) public onlyOwner {
958         require(_founders_2 != address(0));
959         require(requireOnce);
960         founders_2 = _founders_2;
961     }
962 
963 }