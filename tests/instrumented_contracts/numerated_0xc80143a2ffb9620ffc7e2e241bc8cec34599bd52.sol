1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender)
63         public view returns (uint256);
64 
65     function transferFrom(address from, address to, uint256 value)
66         public returns (bool);
67 
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(
70         address indexed owner,
71         address indexed spender,
72         uint256 value
73     );
74 }
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81     using SafeMath for uint256;
82 
83     mapping(address => uint256) balances;
84 
85     uint256 totalSupply_;
86 
87   /**
88   * @dev Total number of tokens in existence
89   */
90     function totalSupply() public view returns (uint256) {
91         return totalSupply_;
92     }
93 
94   /**
95   * @dev Transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         emit Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114     function balanceOf(address _owner) public view returns (uint256) {
115         return balances[_owner];
116     }
117 }
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * https://github.com/ethereum/EIPs/issues/20
124  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128     mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137     function transferFrom(
138         address _from,
139         address _to,
140         uint256 _value
141     )
142     public
143     returns (bool)
144     {
145         require(_to != address(0));
146         require(_value <= balances[_from]);
147         require(_value <= allowed[_from][msg.sender]);
148 
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         emit Transfer(_from, _to, _value);
153         return true;
154     }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165     function approve(address _spender, uint256 _value) public returns (bool) {
166         allowed[msg.sender][_spender] = _value;
167         emit Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177     function allowance(
178         address _owner,
179         address _spender
180     )
181     public
182     view
183     returns (uint256)
184     {
185         return allowed[_owner][_spender];
186     }
187 
188   /**
189    * @dev Increase the amount of tokens that an owner allowed to a spender.
190    * approve should be called when allowed[_spender] == 0. To increment
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _addedValue The amount of tokens to increase the allowance by.
196    */
197     function increaseApproval(
198         address _spender,
199         uint256 _addedValue
200     )
201     public
202     returns (bool)
203     {
204         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
205         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    * approve should be called when allowed[_spender] == 0. To decrement
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _subtractedValue The amount of tokens to decrease the allowance by.
217    */
218     function decreaseApproval(
219         address _spender,
220         uint256 _subtractedValue
221     )
222     public
223     returns (bool)
224     {
225         uint256 oldValue = allowed[msg.sender][_spender];
226         if (_subtractedValue > oldValue) {
227             allowed[msg.sender][_spender] = 0;
228         } else {
229             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
230         }
231         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232         return true;
233     }
234 }
235 
236 /**
237  * @title TMTGOwnable
238  *
239  * @dev Due to ownable change in zeppelin, the authorities in TMTGOwnable include hiddenOwner,
240  *      superOwner, owner, centerBanker, and operator. 
241  *      Each authority has different roles.
242  */
243 contract TMTGOwnable {
244     address public owner;
245     address public centralBanker;
246     address public superOwner;
247     address public hiddenOwner;
248     
249     enum Role { owner, centralBanker, superOwner, hiddenOwner }
250 
251     mapping(address => bool) public operators;
252     
253     
254     event TMTG_RoleTransferred(
255         Role indexed ownerType,
256         address indexed previousOwner,
257         address indexed newOwner
258     );
259     
260     event TMTG_SetOperator(address indexed operator); 
261     event TMTG_DeletedOperator(address indexed operator);
262     
263     modifier onlyOwner() {
264         require(msg.sender == owner);
265         _;
266     }
267     
268     modifier onlyOwnerOrOperator() {
269         require(msg.sender == owner || operators[msg.sender]);
270         _;
271     }
272     
273     modifier onlyNotBankOwner(){
274         require(msg.sender != centralBanker);
275         _;
276     }
277     
278     modifier onlyBankOwner(){
279         require(msg.sender == centralBanker);
280         _;
281     }
282     
283     modifier onlySuperOwner() {
284         require(msg.sender == superOwner);
285         _;
286     }
287     
288     modifier onlyhiddenOwner(){
289         require(msg.sender == hiddenOwner);
290         _;
291     }
292     
293     constructor() public {
294         owner = msg.sender;     
295         centralBanker = msg.sender;
296         superOwner = msg.sender; 
297         hiddenOwner = msg.sender;
298     }
299 
300     /**
301     * @dev Set the address to operator
302     * @param _operator has the ability to pause transaction, has the ability to blacklisting & unblacklisting. 
303     */
304     function setOperator(address _operator) external onlySuperOwner {
305         operators[_operator] = true;
306         emit TMTG_SetOperator(_operator);
307     }
308 
309     /**
310     * @dev Remove the address from operator
311     * @param _operator has the ability to pause transaction, has the ability to blacklisting & unblacklisting. 
312     */
313     function delOperator(address _operator) external onlySuperOwner {
314         operators[_operator] = false;
315         emit TMTG_DeletedOperator(_operator);
316     }
317 
318     /**
319     * @dev It is possible to hand over owner’s authority. Only superowner is available.
320     * @param newOwner  
321     */
322     function transferOwnership(address newOwner) public onlySuperOwner {
323         emit TMTG_RoleTransferred(Role.owner, owner, newOwner);
324         owner = newOwner;
325     }
326 
327     /**
328     * @dev It is possible to hand over centerBanker’s authority. Only superowner is available.
329     * @param newBanker centerBanker is a kind of a central bank, transaction is impossible.
330     * The amount of money to deposit is determined in accordance with cash reserve ratio and the amount of currency in circulation
331     * To withdraw money out of a wallet and give it to owner, audit is inevitable 
332     */
333     function transferBankOwnership(address newBanker) public onlySuperOwner {
334         emit TMTG_RoleTransferred(Role.centralBanker, centralBanker, newBanker);
335         centralBanker = newBanker;
336     }
337 
338     /**
339     * @dev It is possible to hand over superOwner’s authority. Only hiddenowner is available.  
340     * @param newSuperOwner  SuperOwner manages all authorities except for hiddenOwner and superOwner
341     */
342     function transferSuperOwnership(address newSuperOwner) public onlyhiddenOwner {
343         emit TMTG_RoleTransferred(Role.superOwner, superOwner, newSuperOwner);
344         superOwner = newSuperOwner;
345     }
346     
347     /**
348     * @dev It is possible to hand over hiddenOwner’s authority. Only hiddenowner is available
349     * @param newhiddenOwner NewhiddenOwner and hiddenOwner don’t have many functions, 
350     * but they can set and remove authorities of superOwner and hiddenOwner.
351     */
352     function changeHiddenOwner(address newhiddenOwner) public onlyhiddenOwner {
353         emit TMTG_RoleTransferred(Role.hiddenOwner, hiddenOwner, newhiddenOwner);
354         hiddenOwner = newhiddenOwner;
355     }
356 }
357 
358 /**
359  * @title TMTGPausable
360  *
361  * @dev It is used to stop trading in emergency situation
362  */
363 contract TMTGPausable is TMTGOwnable {
364     event TMTG_Pause();
365     event TMTG_Unpause();
366 
367     bool public paused = false;
368 
369     modifier whenNotPaused() {
370         require(!paused);
371         _;
372     }
373 
374     modifier whenPaused() {
375         require(paused);
376         _;
377     }
378     /**
379     * @dev Block trading. Only owner and operator are available.
380     */
381     function pause() onlyOwnerOrOperator whenNotPaused public {
382         paused = true;
383         emit TMTG_Pause();
384     }
385   
386     /**
387     * @dev Unlock limit for trading. Owner and operator are available and this function can be operated in paused mode.
388     */
389     function unpause() onlyOwnerOrOperator whenPaused public {
390         paused = false;
391         emit TMTG_Unpause();
392     }
393 }
394 
395 /**
396  * @title TMTGBlacklist
397  *
398  * @dev Block trading of the suspicious account address.
399  */
400 contract TMTGBlacklist is TMTGOwnable {
401     mapping(address => bool) blacklisted;
402     
403     event TMTG_Blacklisted(address indexed blacklist);
404     event TMTG_Whitelisted(address indexed whitelist);
405 
406     modifier whenPermitted(address node) {
407         require(!blacklisted[node]);
408         _;
409     }
410     
411     /**
412     * @dev Check a certain node is in a blacklist
413     * @param node  Check whether the user at a certain node is in a blacklist
414     */
415     function isPermitted(address node) public view returns (bool) {
416         return !blacklisted[node];
417     }
418 
419     /**
420     * @dev Process blacklisting
421     * @param node Process blacklisting. Put the user in the blacklist.   
422     */
423     function blacklist(address node) public onlyOwnerOrOperator {
424         blacklisted[node] = true;
425         emit TMTG_Blacklisted(node);
426     }
427 
428     /**
429     * @dev Process unBlacklisting. 
430     * @param node Remove the user from the blacklist.   
431     */
432     function unblacklist(address node) public onlyOwnerOrOperator {
433         blacklisted[node] = false;
434         emit TMTG_Whitelisted(node);
435     }
436 }
437 
438 /**
439  * @title HasNoEther
440  */
441 contract HasNoEther is TMTGOwnable {
442     
443     /**
444   * @dev Constructor that rejects incoming Ether
445   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
446   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
447   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
448   * we could use assembly to access msg.value.
449   */
450     constructor() public payable {
451         require(msg.value == 0);
452     }
453     
454     /**
455    * @dev Disallows direct send by settings a default function without the `payable` flag.
456    */
457     function() external {
458     }
459     
460     /**
461    * @dev Transfer all Ether held by the contract to the owner.
462    */
463     function reclaimEther() external onlyOwner {
464         owner.transfer(address(this).balance);
465     }
466 }
467 
468 /**
469  * @title TMTGBaseToken - Major functions such as authority setting on tockenlock are registered.
470  */
471 contract TMTGBaseToken is StandardToken, TMTGPausable, TMTGBlacklist, HasNoEther {
472     uint256 public openingTime;
473     
474     struct investor {
475         uint256 _sentAmount;
476         uint256 _initialAmount;
477         uint256 _limit;
478     }
479 
480     mapping(address => investor) public searchInvestor;
481     mapping(address => bool) public superInvestor;
482     mapping(address => bool) public CEx;
483     mapping(address => bool) public investorList;
484     
485     event TMTG_SetCEx(address indexed CEx); 
486     event TMTG_DeleteCEx(address indexed CEx);
487     
488     event TMTG_SetSuperInvestor(address indexed SuperInvestor); 
489     event TMTG_DeleteSuperInvestor(address indexed SuperInvestor);
490     
491     event TMTG_SetInvestor(address indexed investor); 
492     event TMTG_DeleteInvestor(address indexed investor);
493     
494     event TMTG_Stash(uint256 _value);
495     event TMTG_Unstash(uint256 _value);
496 
497     event TMTG_TransferFrom(address indexed owner, address indexed spender, address indexed to, uint256 value);
498     event TMTG_Burn(address indexed burner, uint256 value);
499     
500     /**
501     * @dev Register the address as a cex address
502     * @param _CEx  Register the address as a cex address 
503     */
504     function setCEx(address _CEx) external onlySuperOwner {   
505         CEx[_CEx] = true;
506         
507         emit TMTG_SetCEx(_CEx);
508     }
509 
510     /**
511     * @dev Remove authorities of the address used in Exchange
512     * @param _CEx Remove authorities of the address used in Exchange   
513     */
514     function delCEx(address _CEx) external onlySuperOwner {   
515         CEx[_CEx] = false;
516         
517         emit TMTG_DeleteCEx(_CEx);
518     }
519 
520     /**
521     * @dev Register the address as a superinvestor address
522     * @param _super Register the address as a superinvestor address   
523     */
524     function setSuperInvestor(address _super) external onlySuperOwner {
525         superInvestor[_super] = true;
526         
527         emit TMTG_SetSuperInvestor(_super);
528     }
529 
530     /** 
531     * @param _super Remove authorities of the address as a superinvestor  
532     */
533     function delSuperInvestor(address _super) external onlySuperOwner {
534         superInvestor[_super] = false;
535         
536         emit TMTG_DeleteSuperInvestor(_super);
537     }
538 
539     /**
540     * @param _addr  Remove authorities of the address as a investor .   
541     */
542     function delInvestor(address _addr) onlySuperOwner public {
543         investorList[_addr] = false;
544         searchInvestor[_addr] = investor(0,0,0);
545         emit TMTG_DeleteInvestor(_addr);
546     }
547 
548     function setOpeningTime() onlyOwner public returns(bool) {
549         openingTime = block.timestamp;
550 
551     }
552 
553     /**
554     * @dev  After one month, the amount will be 1, which means 10% of the coins can be used. 
555     * After 7 months, 70% of the amount can be used.
556     */
557     function getLimitPeriod() external view returns (uint256) {
558         uint256 presentTime = block.timestamp;
559         uint256 timeValue = presentTime.sub(openingTime);
560         uint256 result = timeValue.div(31 days);
561         return result;
562     }
563 
564     /**
565     * @dev Check the latest limit
566     * @param who Check the latest limit. 
567     * Return the limit value of the user at the present moment. After 3 months, _result value will be 30% of initialAmount 
568     */
569     function _timelimitCal(address who) internal view returns (uint256) {
570         uint256 presentTime = block.timestamp;
571         uint256 timeValue = presentTime.sub(openingTime);
572         uint256 _result = timeValue.div(31 days);
573 
574         return _result.mul(searchInvestor[who]._limit);
575     }
576 
577     /**
578     * @dev In case of investor transfer, values will be limited by timelock
579     * @param _to address to send
580     * @param _value tmtg's amount
581     */
582     function _transferInvestor(address _to, uint256 _value) internal returns (bool ret) {
583         uint256 addedValue = searchInvestor[msg.sender]._sentAmount.add(_value);
584 
585         require(_timelimitCal(msg.sender) >= addedValue);
586         
587         searchInvestor[msg.sender]._sentAmount = addedValue;        
588         ret = super.transfer(_to, _value);
589         if (!ret) {
590         searchInvestor[msg.sender]._sentAmount = searchInvestor[msg.sender]._sentAmount.sub(_value);
591         }
592     }
593 
594     /**
595     * @dev When the transfer function is run, 
596     * there are two different types; transfer from superinvestors to investor and to non-investors. 
597     * In the latter case, the non-investors will be investor and 10% of the initial amount will be allocated. 
598     * And when investor operates the transfer function, the values will be limited by timelock.
599     * @param _to address to send
600     * @param _value tmtg's amount
601     */
602     function transfer(address _to, uint256 _value) public
603     whenPermitted(msg.sender) whenPermitted(_to) whenNotPaused onlyNotBankOwner
604     returns (bool) {   
605         
606         if(investorList[msg.sender]) {
607             return _transferInvestor(_to, _value);
608         
609         } else {
610             if (superInvestor[msg.sender]) {
611                 require(_to != owner);
612                 require(!superInvestor[_to]);
613                 require(!CEx[_to]);
614 
615                 if(!investorList[_to]){
616                     investorList[_to] = true;
617                     searchInvestor[_to] = investor(0, _value, _value.div(10));
618                     emit TMTG_SetInvestor(_to); 
619                 }
620             }
621             return super.transfer(_to, _value);
622         }
623     }
624     
625     /**
626     * @dev If investor is from in transforFrom, values will be limited by timelock
627     * @param _from send amount from this address 
628     * @param _to address to send
629     * @param _value tmtg's amount
630     */
631     function _transferFromInvestor(address _from, address _to, uint256 _value)
632     public returns(bool ret) {
633         uint256 addedValue = searchInvestor[_from]._sentAmount.add(_value);
634         require(_timelimitCal(_from) >= addedValue);
635         searchInvestor[_from]._sentAmount = addedValue;
636         ret = super.transferFrom(_from, _to, _value);
637 
638         if (!ret) {
639             searchInvestor[_from]._sentAmount = searchInvestor[_from]._sentAmount.sub(_value);
640         }else {
641             emit TMTG_TransferFrom(_from, msg.sender, _to, _value);
642         }
643     }
644 
645     /**
646     * @dev If from is superinvestor in transforFrom, the function can’t be used because of limit in Approve. 
647     * And if from is investor, the amount of coins to send is limited by timelock.
648     * @param _from send amount from this address 
649     * @param _to address to send
650     * @param _value tmtg's amount
651     */
652     function transferFrom(address _from, address _to, uint256 _value)
653     public whenNotPaused whenPermitted(_from) whenPermitted(_to) whenPermitted(msg.sender)
654     returns (bool ret)
655     {   
656         if(investorList[_from]) {
657             return _transferFromInvestor(_from, _to, _value);
658         } else {
659             ret = super.transferFrom(_from, _to, _value);
660             emit TMTG_TransferFrom(_from, msg.sender, _to, _value);
661         }
662     }
663 
664     function approve(address _spender, uint256 _value) public
665     whenPermitted(msg.sender) whenPermitted(_spender)
666     whenNotPaused onlyNotBankOwner
667     returns (bool) {
668         require(!superInvestor[msg.sender]);
669         return super.approve(_spender,_value);     
670     }
671     
672     function increaseApproval(address _spender, uint256 _addedValue) public 
673     whenNotPaused onlyNotBankOwner
674     whenPermitted(msg.sender) whenPermitted(_spender)
675     returns (bool) {
676         require(!superInvestor[msg.sender]);
677         return super.increaseApproval(_spender, _addedValue);
678     }
679     
680     function decreaseApproval(address _spender, uint256 _subtractedValue) public
681     whenNotPaused onlyNotBankOwner
682     whenPermitted(msg.sender) whenPermitted(_spender)
683     returns (bool) {
684         require(!superInvestor[msg.sender]);
685         return super.decreaseApproval(_spender, _subtractedValue);
686     }
687 
688     function _burn(address _who, uint256 _value) internal {
689         require(_value <= balances[_who]);
690 
691         balances[_who] = balances[_who].sub(_value);
692         totalSupply_ = totalSupply_.sub(_value);
693 
694         emit Transfer(_who, address(0), _value);
695         emit TMTG_Burn(_who, _value);
696     }
697 
698     function burn(uint256 _value) onlyOwner public returns (bool) {
699         _burn(msg.sender, _value);
700         return true;
701     }
702     
703     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool) {
704         require(_value <= allowed[_from][msg.sender]);
705         
706         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
707         _burn(_from, _value);
708         
709         return true;
710     }
711     
712     /**
713     * @dev onlyOwner is available and the amount of coins can be deposited in centerBanker.
714     * @param _value tmtg's amount
715     */
716     function stash(uint256 _value) public onlyOwner {
717         require(balances[owner] >= _value);
718         
719         super.transfer(centralBanker, _value);
720         
721         emit TMTG_Stash(_value);        
722     }
723     /**
724     * @dev Only centerBanker is available and withdrawal of the amount of coins to owner is possible. But audit is inevitable.
725     * @param _value tmtg's amount
726     */
727     function unstash(uint256 _value) public onlyBankOwner {
728         require(balances[centralBanker] >= _value);
729         
730         super.transfer(owner, _value);
731         
732         emit TMTG_Unstash(_value);
733     }
734     
735     function reclaimToken() external onlyOwner {
736         transfer(owner, balanceOf(this));
737     }
738     
739     function destory() onlyhiddenOwner public {
740         selfdestruct(superOwner);
741     } 
742 
743 }
744 
745 contract TMTG is TMTGBaseToken {
746     string public constant name = "The Midas Touch Gold";
747     string public constant symbol = "TMTG";
748     uint8 public constant decimals = 18;
749     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals));
750 
751     constructor() public {
752         totalSupply_ = INITIAL_SUPPLY;
753         balances[msg.sender] = INITIAL_SUPPLY;
754         openingTime = block.timestamp;
755 
756         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
757     }
758 }