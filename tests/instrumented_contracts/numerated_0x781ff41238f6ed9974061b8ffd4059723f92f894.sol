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
239  * @dev zeppelin의 ownable의 변형으로 TMTGOwnable에서 권한은 hiddenOwner, superOwner, owner, centralBanker, operator가 있습니다.
240  * 각 권한마다 역할이 다릅니다.
241  */
242 contract TMTGOwnable {
243     address public owner;
244     address public centralBanker;
245     address public superOwner;
246     address public hiddenOwner;
247     
248     enum Role { owner, centralBanker, superOwner, hiddenOwner }
249 
250     mapping(address => bool) public operators;
251     
252     
253     event TMTG_RoleTransferred(
254         Role indexed ownerType,
255         address indexed previousOwner,
256         address indexed newOwner
257     );
258     
259     event TMTG_SetOperator(address indexed operator); 
260     event TMTG_DeletedOperator(address indexed operator);
261     
262     modifier onlyOwner() {
263         require(msg.sender == owner);
264         _;
265     }
266     
267     modifier onlyOwnerOrOperator() {
268         require(msg.sender == owner || operators[msg.sender]);
269         _;
270     }
271     
272     modifier onlyNotBankOwner(){
273         require(msg.sender != centralBanker);
274         _;
275     }
276     
277     modifier onlyBankOwner(){
278         require(msg.sender == centralBanker);
279         _;
280     }
281     
282     modifier onlySuperOwner() {
283         require(msg.sender == superOwner);
284         _;
285     }
286     
287     modifier onlyhiddenOwner(){
288         require(msg.sender == hiddenOwner);
289         _;
290     }
291     
292     constructor() public {
293         owner = msg.sender;     
294         centralBanker = msg.sender;
295         superOwner = msg.sender; 
296         hiddenOwner = msg.sender;
297     }
298 
299     /**
300     * @dev 해당 주소를 operator로 설정한다.
301     * @param _operator has the ability to pause transaction, has the ability to blacklisting & unblacklisting. 
302     */
303     function setOperator(address _operator) external onlySuperOwner {
304         operators[_operator] = true;
305         emit TMTG_SetOperator(_operator);
306     }
307 
308     /**
309     * @dev 해당 주소를 operator에서 해제한다.
310     * @param _operator has the ability to pause transaction, has the ability to blacklisting & unblacklisting. 
311     */
312     function delOperator(address _operator) external onlySuperOwner {
313         operators[_operator] = false;
314         emit TMTG_DeletedOperator(_operator);
315     }
316 
317     /**
318     * @dev owner의 권한을 넘겨 줄 수 있다. 단, superowner만 실행할 수 있다.
319     * @param newOwner  
320     */
321     function transferOwnership(address newOwner) public onlySuperOwner {
322         emit TMTG_RoleTransferred(Role.owner, owner, newOwner);
323         owner = newOwner;
324     }
325 
326     /**
327     * @dev centralBanker의 권한을 넘겨 줄 수 있다. 단, superOwner만 실행할 수 있다.
328     * @param newBanker centralBanker는 일종의 중앙은행으로 거래가 불가능하다. 
329     * 지급 준비율과 통화량에 따라 묶여있는 금액이 결정되어진다.
330     * 돈을 꺼내기 위해서는 감사를 거쳐서 owner쪽으로 인출이 가능하다. 
331     */
332     function transferBankOwnership(address newBanker) public onlySuperOwner {
333         emit TMTG_RoleTransferred(Role.centralBanker, centralBanker, newBanker);
334         centralBanker = newBanker;
335     }
336 
337     /**
338     * @dev superOwner의 권한을 넘겨 줄 수 있다. 단, hiddenOwner만 실행 할 수 있다.
339     * @param newSuperOwner  superOwner는 hiddenOwner와 superOwner를 제외한 모든 권한 여부를 관리한다.
340     */
341     function transferSuperOwnership(address newSuperOwner) public onlyhiddenOwner {
342         emit TMTG_RoleTransferred(Role.superOwner, superOwner, newSuperOwner);
343         superOwner = newSuperOwner;
344     }
345     
346     /**
347     * @dev hiddenOwner의 권한 을 넘겨 줄 수 있다. 단, hiddenOwner만 실행 할 수 있다.
348     * @param newhiddenOwner hiddenOwner는 별 다른 기능은 없지만 
349     * superOwner와 hiddenOwner의 권한에 대해 설정 및 해제가 가능하다.   
350     */
351     function changeHiddenOwner(address newhiddenOwner) public onlyhiddenOwner {
352         emit TMTG_RoleTransferred(Role.hiddenOwner, hiddenOwner, newhiddenOwner);
353         hiddenOwner = newhiddenOwner;
354     }
355 }
356 
357 /**
358  * @title TMTGPausable
359  *
360  * @dev 긴급한 상황에서 거래를 중지시킬때 사용한다.
361  */
362 contract TMTGPausable is TMTGOwnable {
363     event TMTG_Pause();
364     event TMTG_Unpause();
365 
366     bool public paused = false;
367 
368     modifier whenNotPaused() {
369         require(!paused);
370         _;
371     }
372 
373     modifier whenPaused() {
374         require(paused);
375         _;
376     }
377     /**
378     * @dev 거래를 할 수 없게 막는다. 단, owner 또는 operator만 실행 할 수 있다.
379     */
380     function pause() onlyOwnerOrOperator whenNotPaused public {
381         paused = true;
382         emit TMTG_Pause();
383     }
384   
385     /**
386     * @dev 거래를 할 수 있게 풀어준다. 단, owner 또는 operator만 실행 할 수 있으며 paused 상태일 때만 이용이 가능하다.
387     */
388     function unpause() onlyOwnerOrOperator whenPaused public {
389         paused = false;
390         emit TMTG_Unpause();
391     }
392 }
393 
394 /**
395  * @title TMTGBlacklist
396  *
397  * @dev 이상 징후가 있는 계정의 주소에 대해 거래를 할 수 없게 막는다.
398  */
399 contract TMTGBlacklist is TMTGOwnable {
400     mapping(address => bool) blacklisted;
401     
402     event TMTG_Blacklisted(address indexed blacklist);
403     event TMTG_Whitelisted(address indexed whitelist);
404 
405     modifier whenPermitted(address node) {
406         require(!blacklisted[node]);
407         _;
408     }
409     
410     /**
411     * @dev 블랙리스팅 여부를 확인한다.
412     * @param node  해당 사용자가 블랙리스트에 등록되었는가에 대한 유무를  확인한다.   
413     */
414     function isPermitted(address node) public view returns (bool) {
415         return !blacklisted[node];
416     }
417 
418     /**
419     * @dev 블랙리스팅 처리한다.
420     * @param node  해당 사용자를 블랙리스트에 등록한다.   
421     */
422     function blacklist(address node) public onlyOwnerOrOperator {
423         blacklisted[node] = true;
424         emit TMTG_Blacklisted(node);
425     }
426 
427     /**
428     * @dev 블랙리스트에서 해제한다.
429     * @param node  해당 사용자를 블랙리스트에서 제거한다.   
430     */
431     function unblacklist(address node) public onlyOwnerOrOperator {
432         blacklisted[node] = false;
433         emit TMTG_Whitelisted(node);
434     }
435 }
436 
437 /**
438  * @title HasNoEther
439  *
440  * @dev 이상 징후가 있는 계정의 주소에 대해 거래를 할 수 없게 막는다.
441  */
442 contract HasNoEther is TMTGOwnable {
443     
444     /**
445   * @dev Constructor that rejects incoming Ether
446   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
447   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
448   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
449   * we could use assembly to access msg.value.
450   */
451     constructor() public payable {
452         require(msg.value == 0);
453     }
454     
455     /**
456    * @dev Disallows direct send by settings a default function without the `payable` flag.
457    */
458     function() external {
459     }
460     
461     /**
462    * @dev Transfer all Ether held by the contract to the owner.
463    */
464     function reclaimEther() external onlyOwner {
465         owner.transfer(address(this).balance);
466     }
467 }
468 
469 /**
470  * @title TMTGBaseToken 토큰락과 권한 설정 등 주요함수가 등록되어 있다.
471  */
472 contract TMTGBaseToken is StandardToken, TMTGPausable, TMTGBlacklist, HasNoEther {
473     uint256 public openingTime;
474     
475     struct investor {
476         uint256 _sentAmount;
477         uint256 _initialAmount;
478         uint256 _limit;
479     }
480 
481     mapping(address => investor) public searchInvestor;
482     mapping(address => bool) public superInvestor;
483     mapping(address => bool) public CEx;
484     mapping(address => bool) public investorList;
485     
486     event TMTG_SetCEx(address indexed CEx); 
487     event TMTG_DeleteCEx(address indexed CEx);
488     
489     event TMTG_SetSuperInvestor(address indexed SuperInvestor); 
490     event TMTG_DeleteSuperInvestor(address indexed SuperInvestor);
491     
492     event TMTG_SetInvestor(address indexed investor); 
493     event TMTG_DeleteInvestor(address indexed investor);
494     
495     event TMTG_Stash(uint256 _value);
496     event TMTG_Unstash(uint256 _value);
497 
498     event TMTG_TransferFrom(address indexed owner, address indexed spender, address indexed to, uint256 value);
499     event TMTG_Burn(address indexed burner, uint256 value);
500     
501     /**
502     * @dev 거래소 주소를 등록한다.
503     * @param _CEx  해당 주소를 거래소 주소로 등록한다.   
504     */
505     function setCEx(address _CEx) external onlySuperOwner {   
506         CEx[_CEx] = true;
507         
508         emit TMTG_SetCEx(_CEx);
509     }
510 
511     /**
512     * @dev 거래소 주소를 해제한다.
513     * @param _CEx  해당 주소의 거래소 권한을 해제한다.   
514     */
515     function delCEx(address _CEx) external onlySuperOwner {   
516         CEx[_CEx] = false;
517         
518         emit TMTG_DeleteCEx(_CEx);
519     }
520 
521     /**
522     * @dev 수퍼투자자 주소를 등록한다.
523     * @param _super  해당 주소를 수퍼투자자 주소로 등록한다.   
524     */
525     function setSuperInvestor(address _super) external onlySuperOwner {
526         superInvestor[_super] = true;
527         
528         emit TMTG_SetSuperInvestor(_super);
529     }
530 
531     /**
532     * @dev 수퍼투자자 주소를 해제한다.
533     * @param _super  해당 주소의 수퍼투자자 권한을 해제한다.   
534     */
535     function delSuperInvestor(address _super) external onlySuperOwner {
536         superInvestor[_super] = false;
537         
538         emit TMTG_DeleteSuperInvestor(_super);
539     }
540 
541     /**
542     * @dev 투자자 주소를 해제한다.
543     * @param _addr  해당 주소를 투자자 주소로 해제한다.   
544     */
545     function delInvestor(address _addr) onlySuperOwner public {
546         investorList[_addr] = false;
547         searchInvestor[_addr] = investor(0,0,0);
548         emit TMTG_DeleteInvestor(_addr);
549     }
550 
551     /**
552     * @dev 투자자의 토큰락 시작 시점을 지정한다.   
553     */
554     function setOpeningTime() onlyOwner public returns(bool) {
555         openingTime = block.timestamp;
556 
557     }
558 
559     /**
560     * @dev 현재 투자자의 토큰락에 대해 초기 수퍼투자자로부터 받은 양의 몇 %를 받을 수 있는가를 확인 할 수 있다.
561     * 1달이 되었을때 1이 되며 10%를 사용이 가능하고, 7일 경우 70%의 값에 해당하는 코인을 자유롭게 사용이 가능하다.   
562     */
563     function getLimitPeriod() public view returns (uint256) {
564         uint256 presentTime = block.timestamp;
565         uint256 timeValue = presentTime.sub(openingTime);
566         uint256 result = timeValue.div(31 days);
567         return result;
568     }
569 
570     /**
571     * @dev 최신 리밋을 확인한다.
572     * @param who 해당 사용자의 현 시점에서의 리밋 값을 리턴한다. 3달이 지났을 경우, 
573     * _result 의 값은 수퍼투자자로부터 최초에 받은 30%가 사용이 가능하다. 
574     */
575     function _timelimitCal(address who) internal view returns (uint256) {
576         uint256 presentTime = block.timestamp;
577         uint256 timeValue = presentTime.sub(openingTime);
578         uint256 _result = timeValue.div(31 days);
579 
580         return _result.mul(searchInvestor[who]._limit);
581     }
582 
583     /**
584     * @dev 인베스터가 transfer하는 경우, 타임락에 따라 값을 제한한다.
585     * @param _to address to send
586     * @param _value tmtg's amount
587     */
588     function _transferInvestor(address _to, uint256 _value) internal returns (bool ret) {
589         uint256 addedValue = searchInvestor[msg.sender]._sentAmount.add(_value);
590 
591         require(_timelimitCal(msg.sender) >= addedValue);
592         
593         searchInvestor[msg.sender]._sentAmount = addedValue;        
594         ret = super.transfer(_to, _value);
595         if (!ret) {
596         searchInvestor[msg.sender]._sentAmount = searchInvestor[msg.sender]._sentAmount.sub(_value);
597         }
598     }
599 
600     /**
601     * @dev transfer 함수를 실행할 때, 수퍼인베스터가 인베스터에게 보내는 경우와 인베스터가 아닌 사람에게 보내는 경우로 나뉘어지며,
602     * 인베스터가 아닌 사람에게 보내는 경우, 해당 사용자를 인베스터로 만들며, 최초 보낸 금액의 10%가 limit으로 할당된다.
603     * 또한 인베스터가 transfer 함수를 실행하는 경우, 타임락에 따라 보내는 값이 제한된다.
604     * @param _to address to send
605     * @param _value tmtg's amount
606     */
607     function transfer(address _to, uint256 _value) public
608     whenPermitted(msg.sender) whenPermitted(_to) whenNotPaused onlyNotBankOwner
609     returns (bool) {   
610         
611         if(investorList[msg.sender]) {
612             return _transferInvestor(_to, _value);
613         
614         } else {
615             if (superInvestor[msg.sender]) {
616                 require(_to != owner);
617                 require(!superInvestor[_to]);
618                 require(!CEx[_to]);
619 
620                 if(!investorList[_to]){
621                     investorList[_to] = true;
622                     searchInvestor[_to] = investor(0, _value, _value.div(10));
623                     emit TMTG_SetInvestor(_to); 
624                 }
625             }
626             return super.transfer(_to, _value);
627         }
628     }
629     /**
630     * @dev 인베스터가 transferFrom에서 from 인 경우, 타임락에 따라 값을 제한한다.
631     * @param _from send amount from this address 
632     * @param _to address to send
633     * @param _value tmtg's amount
634     */
635     function _transferFromInvestor(address _from, address _to, uint256 _value)
636     public returns(bool ret) {
637         uint256 addedValue = searchInvestor[_from]._sentAmount.add(_value);
638         require(_timelimitCal(_from) >= addedValue);
639         searchInvestor[_from]._sentAmount = addedValue;
640         ret = super.transferFrom(_from, _to, _value);
641 
642         if (!ret) {
643             searchInvestor[_from]._sentAmount = searchInvestor[_from]._sentAmount.sub(_value);
644         }else {
645             emit TMTG_TransferFrom(_from, msg.sender, _to, _value);
646         }
647     }
648 
649     /**
650     * @dev transferFrom에서 superInvestor인 경우 approve에서 제한되므로 해당 함수를 사용하지 못한다. 또한 인베스터인 경우,
651     * 타임락에 따라 양이 제한된다.
652     * @param _from send amount from this address 
653     * @param _to address to send
654     * @param _value tmtg's amount
655     */
656     function transferFrom(address _from, address _to, uint256 _value)
657     public whenNotPaused whenPermitted(msg.sender) whenPermitted(_to) returns (bool ret)
658     {   
659         if(investorList[_from]) {
660             return _transferFromInvestor(_from, _to, _value);
661         } else {
662             ret = super.transferFrom(_from, _to, _value);
663             emit TMTG_TransferFrom(_from, msg.sender, _to, _value);
664         }
665     }
666 
667     function approve(address _spender, uint256 _value) public
668     whenPermitted(msg.sender) whenPermitted(_spender)
669     whenNotPaused onlyNotBankOwner
670     returns (bool) {
671         require(!superInvestor[msg.sender]);
672         return super.approve(_spender,_value);     
673     }
674     
675     function increaseApproval(address _spender, uint256 _addedValue) public 
676     whenNotPaused onlyNotBankOwner
677     whenPermitted(msg.sender) whenPermitted(_spender)
678     returns (bool) {
679         require(!superInvestor[msg.sender]);
680         return super.increaseApproval(_spender, _addedValue);
681     }
682     
683     function decreaseApproval(address _spender, uint256 _subtractedValue) public
684     whenNotPaused onlyNotBankOwner
685     whenPermitted(msg.sender) whenPermitted(_spender)
686     returns (bool) {
687         require(!superInvestor[msg.sender]);
688         return super.decreaseApproval(_spender, _subtractedValue);
689     }
690 
691     function _burn(address _who, uint256 _value) internal {
692         require(_value <= balances[_who]);
693 
694         balances[_who] = balances[_who].sub(_value);
695         totalSupply_ = totalSupply_.sub(_value);
696 
697         emit Transfer(_who, address(0), _value);
698         emit TMTG_Burn(_who, _value);
699     }
700 
701     function burn(uint256 _value) onlyOwner public returns (bool) {
702         _burn(msg.sender, _value);
703         return true;
704     }
705     
706     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool) {
707         require(_value <= allowed[_from][msg.sender]);
708         
709         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
710         _burn(_from, _value);
711         
712         return true;
713     }
714     
715     /**
716     * @dev owner만 실행이 가능하고, 해당 코인의 양만큼 centralBanker에 입금이 가능하다.
717     * @param _value tmtg's amount
718     */
719     function stash(uint256 _value) public onlyOwner {
720         require(balances[owner] >= _value);
721         
722         balances[owner] = balances[owner].sub(_value);
723         
724         balances[centralBanker] = balances[centralBanker].add(_value);
725         
726         emit TMTG_Stash(_value);        
727     }
728     /**
729     * @dev centralBanker만 실행이 가능하고, 해당 코인의 양만큼 owner에게 출금이 가능하다.
730     * 단, 검수를 거쳐서 실행된다.
731     * @param _value tmtg's amount
732     */
733     function unstash(uint256 _value) public onlyBankOwner {
734         require(balances[centralBanker] >= _value);
735         
736         balances[centralBanker] = balances[centralBanker].sub(_value);
737         
738         balances[owner] = balances[owner].add(_value);
739         
740         emit TMTG_Unstash(_value);
741     }
742     
743     function reclaimToken() external onlyOwner {
744         transfer(owner, balanceOf(this));
745     }
746     
747     function destory() onlyhiddenOwner public {
748         selfdestruct(superOwner);
749     } 
750 
751     /**
752     * @dev 투자자가 거래소에서 추가 금액을 샀을 경우, 추가여분은 10개월간 토큰락이 걸린다. 이 때, 관리자의 입회 하에 해당 금액을 옮기게 해줌
753     * @param _investor 
754     * @param _to 
755     * @param _amount 
756     */
757     function refreshInvestor(address _investor, address _to, uint _amount) onlyOwner public  {
758        require(investorList[_investor]);
759        require(_to != address(0));
760        require(_amount <= balances[_investor]);
761        balances[_investor] = balances[_investor].sub(_amount);
762        balances[_to] = balances[_to].add(_amount); 
763     }
764 }
765 
766 contract TMTG is TMTGBaseToken {
767     string public constant name = "The Midas Touch Gold";
768     string public constant symbol = "TMTG";
769     uint8 public constant decimals = 18;
770     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals));
771 
772     constructor() public {
773         totalSupply_ = INITIAL_SUPPLY;
774         balances[msg.sender] = INITIAL_SUPPLY;
775         openingTime = block.timestamp;
776 
777         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
778     }
779 }