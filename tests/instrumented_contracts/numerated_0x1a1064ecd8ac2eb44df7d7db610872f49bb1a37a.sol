1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) public view returns (uint256);
117   function transferFrom(address from, address to, uint256 value) public returns (bool);
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     emit Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     emit Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 
219 
220 /**
221  * @title Ownable
222  * @dev The Ownable contract has an owner address, and provides basic authorization control
223  * functions, this simplifies the implementation of "user permissions".
224  */
225 contract Ownable {
226   address public owner;
227 
228 
229   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
230 
231 
232   /**
233    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234    * account.
235    */
236   function Ownable() public {
237     owner = msg.sender;
238   }
239 
240   /**
241    * @dev Throws if called by any account other than the owner.
242    */
243   modifier onlyOwner() {
244     require(msg.sender == owner);
245     _;
246   }
247 
248   /**
249    * @dev Allows the current owner to transfer control of the contract to a newOwner.
250    * @param newOwner The address to transfer ownership to.
251    */
252   function transferOwnership(address newOwner) public onlyOwner {
253     require(newOwner != address(0));
254     emit OwnershipTransferred(owner, newOwner);
255     owner = newOwner;
256   }
257 
258 }
259 
260 
261 
262 /**
263  * @title Claimable
264  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
265  * This allows the new owner to accept the transfer.
266  */
267 contract Claimable is Ownable {
268   address public pendingOwner;
269 
270   /**
271    * @dev Modifier throws if called by any account other than the pendingOwner.
272    */
273   modifier onlyPendingOwner() {
274     require(msg.sender == pendingOwner);
275     _;
276   }
277 
278   /**
279    * @dev Allows the current owner to set the pendingOwner address.
280    * @param newOwner The address to transfer ownership to.
281    */
282   function transferOwnership(address newOwner) onlyOwner public {
283     pendingOwner = newOwner;
284   }
285 
286   /**
287    * @dev Allows the pendingOwner address to finalize the transfer.
288    */
289   function claimOwnership() onlyPendingOwner public {
290     emit OwnershipTransferred(owner, pendingOwner);
291     owner = pendingOwner;
292     pendingOwner = address(0);
293   }
294 }
295 
296 
297 
298 /**
299  @title Token77G
300 
301 */
302 
303 contract Token77G is Claimable, StandardToken {
304 
305     string constant public name = "GraphenTech";
306     string constant public symbol = "77G";
307     uint8 constant public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
308 
309     uint256 public graphenRestrictedDate;
310     //Contains restricted tokens that cannot be sold before graphenDeadLine
311     mapping (address => uint256) private restrictedTokens;
312     // This array contains the list of address to be used by DAO contract
313     address[] private addList;
314     address private icoadd;
315 
316     /**
317      @dev this event generates a public event on the blockchain that will notify clients
318     **/
319     event Transfer(address indexed from, address indexed to, uint256 value);
320 
321     /**
322      @dev this event notifies clients about the amount burnt
323     **/
324     event Burn(address indexed from, uint256 value);
325 
326      /**
327      @dev Constructor function
328           Initializes contract with initial supply tokens to the creator of the contract and
329           allocates restriceted amount of tokens to some addresses
330     */
331     function Token77G(
332     address _team,
333     address _reserve,
334     address _advisors,
335     uint _deadLine
336     )
337     public
338     {
339 
340         icoadd = msg.sender;
341         totalSupply_ = (19000000000) * 10 ** uint256(decimals);
342 
343         balances[_reserve] = balances[_reserve].add((1890500000) * 10 ** uint256(decimals));
344         addAddress(_reserve);
345         emit Transfer(icoadd, _reserve, (1890500000) * 10 ** uint256(decimals));
346 
347         allocateTokens(_team, (1330000000) * 10 ** uint256(decimals));
348         emit Transfer(icoadd, _team, (1330000000) * 10 ** uint256(decimals));
349 
350         balances[_advisors] = balances[_advisors].add((950000000) * 10 ** uint256(decimals));
351         addAddress(_advisors);
352         emit Transfer(icoadd, _advisors, (950000000) * 10 ** uint256(decimals));
353 
354         balances[icoadd] = (14829500000) * 10 **uint256(decimals);
355         graphenRestrictedDate = _deadLine;
356 
357     }
358 
359     /**
360      @dev Return number of restricted tokens from address
361 
362 
363       @param _add The address to check restricted tokens
364     */
365     function restrictedTokensOf(address _add) public view returns(uint restrctedTokens) {
366         return restrictedTokens[_add];
367     }
368 
369     /**
370      @dev Transfer tokens
371           Send `_value` tokens to `_to` from your account
372 
373       @param _to The address of the recipient
374       @param _value the amount to send
375     */
376     // solhint-disable-next-line
377     function transfer(address _to, uint256 _value) public returns (bool) {
378         uint256  tmpRestrictedDate;
379 
380         if (restrictedTokens[msg.sender] > 0) {
381             require((now < tmpRestrictedDate && _value <= (balances[msg.sender].sub(restrictedTokens[msg.sender])))||now >= tmpRestrictedDate);// solhint-disable-line
382         }
383         if (balances[_to] == 0) addAddress(_to);
384         _transfer(_to, _value);
385         return true;
386     }
387 
388     /**
389         @dev Transfer tokens from one address to another
390         @param _from address The address which you want to send tokens from
391         @param _to address The address which you want to transfer to
392         @param _value uint256 the amount of tokens to be transferred
393     */
394     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
395 
396         uint256 tmpRestrictedDate;
397 
398         if (restrictedTokens[msg.sender] > 0) {
399             require((now < tmpRestrictedDate && _value <= (balances[msg.sender]-restrictedTokens[msg.sender]))||now >= tmpRestrictedDate);// solhint-disable-line
400         }
401 
402         if (balances[_to] == 0)addAddress(_to);
403         super.transferFrom(_from, _to, _value);
404         return true;
405 
406     }
407      /**
408      @dev Destroy tokens
409      *
410      * Remove `_value` tokens from the system irreversibly
411      *
412      * @param _value the amount of money to burn
413      */
414     // solhint-disable-next-line
415     function burn(uint256 _value) public returns (bool success) {
416         require(balances[msg.sender] >= _value);   // Check if the sender has enough
417         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
418         totalSupply_ = totalSupply_.sub(_value);                      // Updates totalSupply_
419         emit Burn(msg.sender, _value);
420         emit Transfer(msg.sender, 0x0, _value);
421         return true;
422     }
423 
424      /**
425      @dev Returns address by position
426 
427      @param _index contains the position to find in addList
428      */
429     function getAddressFromList(uint256 _index)public view  returns (address add) {
430         require(_index < addList.length);
431         return addList[_index];
432     }
433 
434      /**
435      @dev Returns length of address list
436 
437      @return uint list size
438      */
439     function getAddListSize()public view  returns (uint) {
440         return addList.length;
441     }
442 
443      /**
444      @dev This function adds a number of tokes to an address and sets this tokens as restricted.
445 
446       @param _add The address to allocate restricted tokens
447       @param _value Number of tokens to be given
448     */
449     function allocateTokens(address _add, uint256 _value) private {
450         balances[_add] = balances[_add].add(_value);
451         restrictedTokens[_add] = restrictedTokens[_add].add(_value);
452         addAddress(_add);
453     }
454 
455      /**
456      @dev Internal transfer, only can be called by this contract.
457 
458       @param _to The address of the recipient
459       @param _value number of tokens to be transfered.
460      */
461     function _transfer(address _to, uint256 _value) private {
462         // Prevent transfer to 0x0 address. Use burn() instead
463         require(_to != 0x0);
464         // Check if the sender has enough
465         require(balances[msg.sender] >= _value);
466         // Check for overflows
467         require(balances[_to] + _value > balances[_to]);
468         // Save this for an assertion in the future
469         uint256 previousBalances = balances[msg.sender].add(balances[_to]);
470         // Subtract from the sender
471         balances[msg.sender] = balances[msg.sender].sub(_value);// Con libreria Maths
472         // Add the same to the recipient
473         balances[_to] = balances[_to].add(_value);
474         emit Transfer(msg.sender, _to, _value);
475         // Asserts are used to use static analysis to find bugs in your code. They should never fail
476         assert(balances[msg.sender] + balances[_to] == previousBalances);
477     }
478 
479    /**
480      @dev Adcd ..
481      cd a new address to list of address
482           Include `_add´ if doesn´t exist within addList
483 
484      @param _add contains the address to be included in the addList.
485      */
486     function addAddress(address _add) private {
487         addList.push(_add);
488     }
489 
490 
491 }
492 
493 
494 /**
495  @title ICO_Graphene
496 */
497 
498 contract ICO_Graphene is Claimable {
499 
500     using SafeMath for uint256;
501 
502     // Shows  number of tokens available for Private-ICO
503     uint256 public availablePrivateICO;
504     // Shows  number of tokens available for PRE-ICO
505     uint256 public availablePreICO;
506     // Shows  number of tokens available for ICO_w1
507     uint256 public availableICO_w1;
508     // Shows  number of tokens available for ICO_w2
509     uint256 public availableICO_w2;
510 
511     // Shows  number of tokens totals available for ICO
512     uint256 public availableICO;
513 
514     // Counts ETHs raised in the ICO
515     uint256 public amountRaised;
516     // Number of tokens sold within Private-ICO, PRE-ICO and ICO_w1 and ICO_w2
517     uint256 public tokensSold;
518     // Number of token decimals
519     uint256 private decimals;
520 
521     // Shows PrivateICO starting timestamp
522     uint256 public startPrivateICO = 1528329600; // 1528329600 Thursday, 07-Jun-18 00:00:00 UTC
523     // Shows PrivateICO ending timestamp
524     uint256 public endPrivateICO = 1532649599; // 1532649599 Thursday, 26-Jul-18 23:59:59 UTC
525 
526     // Shows Pre-ICO starting timestamp
527     uint256 public startPreICO = 1532649600; // 1532649600 Friday, 27-Jul-18 00:00:00 UTC
528     // Shows Pre-ICO ending timestamp
529     uint256 public endPreICO = 1535327999; // 1535327999 Sunday, 26-Aug-18 23:59:59 UTC
530 
531     // Shows ICO starting timestamp
532     uint256 public startICO_w1 = 1535328000; // 1535328000 Monday, 27-Aug-18 00:00:00 UTC
533     // Shows ICO ending timestamp
534     uint256 public endICO_w1 = 1538006399; // 1538006399 Thursday, 26-Sep-18 23:59:59 UTC
535 
536     // Shows ICO starting timestamp
537     uint256 public startICO_w2 = 1538006400; // 1538006400 Friday, 27-Sep-18 00:00:00 UTC
538     // Shows ICO ending timestamp
539     uint256 public endICO_w2 = 1540684799; // 1540684799 Wednesday, 27-Oct-18 23:59:59 UTC
540 
541     // ICO status list
542     enum StatusList { NotStarted, Running, Waiting, Closed, Paused}
543     // ICO current status
544     StatusList public status;
545     // ICO stages list
546     enum StagesList { N_A, PrivateICO, PreICO, ICO_w1, ICO_w2}
547     // ICO current status
548     StagesList public stage;
549     // Contains token price within each stage
550     uint256[5] private tokenPrice;
551     // Contains token contract
552     Token77G private tokenReward;
553 
554     // Some tokens cannot be sold before this date.
555     // 6 moths after finish ico
556     uint256 public restrictedTokensDate = 1550447999; // Sunday, 17-Feb-19 23:59:59 UTC
557 
558     // Contains token contract address
559     address public tokenAdd;
560 
561     // Shows purchase address and amount
562     mapping(address => uint256) public purchaseMap;
563     // Contains ETHs that cannot be sent to an address.
564     // mapping(address => uint256) public failToTranferList;
565 
566     // List of address
567 
568     // Token's delivery
569     address constant private TOKENSRESERVE = 0xA89779a50b3540677495e12eA09f02B6Bf09803F;
570     address constant private TEAM = 0x39E545F03d26334d735815Bb9882423cE46d8326;
571     address constant private ADVISORS = 0x96DFaBbD575C48d82e5bCC92f64E0349Da60712a;
572 
573     // Eth's delivery
574     address constant private SALARIES = 0x99330754059f1348296526a52AA4F787a7648B46;
575     address constant private MARKETINGandBUSINESS = 0x824663D62c22f2592c5a3DC37638C09907adE7Ec;
576     address constant private RESEARCHandDEVELOPMENT = 0x7156023Cd4579Eb6a7A171062A44574809B353C8;
577     address constant private RESERVE = 0xAE55c485Fe70Ce6E547A30f5F4b28F32D9c1c093;
578     address constant private FACTORIES = 0x30CF1d5F0c561118fA017f15B86f914ef5C078e6;
579     address constant private PLANEQUIPMENT = 0xC74c83d8eC7c6233715b0aD8Ba4da8f72301fA24;
580     address constant private PRODUCTION = 0xEa0553a23469cb7140190d443762d70664a36343;
581 
582 
583     /**
584      @dev This event notifies a tokens purchase
585     **/
586     event Purchase(address _from, uint _amount, uint _tokens);
587 
588     /**
589      @dev Checks if ICO is active
590      @param _status StatusList condition to compare with current status
591     **/
592     modifier onlyInState (StatusList _status) {
593         require(_status == status);
594         _;
595     }
596 
597     /**
598      @dev Checks if ICO status is not PAUSED
599     **/
600     modifier onlyIfNotPaused() {
601         require(status != StatusList.Paused);
602         _;
603     }
604 
605      /**
606      @dev Constructor. Creates ICO_Graphene tokens and define PrivateICO, PreICO, ICO tokens.
607           ICO status and stages are set to initial values.
608     */
609     function ICO_Graphene() public {
610 
611         tokenReward = new Token77G(TEAM, TOKENSRESERVE, ADVISORS, restrictedTokensDate);
612 
613         tokenAdd = tokenReward;
614         decimals = tokenReward.decimals();
615         status = StatusList.NotStarted;
616         stage = StagesList.N_A;
617         amountRaised = 0;
618         tokensSold = 0;
619 
620         availablePrivateICO = (1729000000) * 10 ** uint256(decimals);
621         availablePreICO = (3325000000) * 10 ** uint256(decimals);
622         availableICO_w1 = (5120500000) * 10 ** uint256(decimals);
623         availableICO_w2 = (4655000000) * 10 ** uint256(decimals);
624 
625         tokenPrice = [0, 13860000000000, 14850000000000, 17820000000000, 19800000000000];
626 
627     }
628 
629      /**
630 
631      @dev The function (Fallback) without name is the default function that is called whenever
632           anyone sends funds to a contract, this method starts purchase process.
633      */
634     function () public payable onlyIfNotPaused {
635         updateStatus();
636         if (stage == StagesList.PrivateICO) {
637             require(msg.value >= 1000000000000000000 wei);
638         }
639         _transfer();
640         updateStatusViaTokens();
641     }
642 
643       /**
644      @dev Standar function to kill ICO contract and return ETHs to owner.
645     */
646     function kill()
647     external onlyOwner onlyInState(StatusList.Closed) {
648         selfdestruct(owner);
649     }
650 
651     /**
652      @dev Public function to be call by owner that changes ICO status to Pause.
653           No other function will be available if status is Pause but unpause()
654      */
655     function pause() public onlyOwner {
656         updateStatus();
657         require(status != StatusList.Closed);
658         status = StatusList.Paused;
659     }
660 
661     /**
662      @dev Public function to be call by owner when ICO status is Paused, it changes ICO status to the right status
663           based on ICO dates.
664      */
665     function unpause() public onlyOwner onlyInState(StatusList.Paused) {
666         updateStatus();
667         updateStatusViaTokens();
668     }
669 
670     /**
671      @dev PRE-ICO and ICO times can be changed with this function by the owner if ICO has not started.
672     *     This function changes startTimestamp time with _startingTime given.
673      @param     _startPrivateICO contains new starting date for PRE-ICO
674      @param     _endPrivateICO contains new ending date for PRE-ICO
675      @param     _startPreICO contains new starting date for ICO
676      @param     _endPreICO contains new ending date for ICO
677      @param     _startICO_w1 contains new starting date for PRE-ICO
678      @param     _endICO_w1 contains new ending date for PRE-ICO
679      @param     _startICO_w2 contains new starting date for ICO
680      @param     _endICO_w2 contains new ending date for ICO
681     */
682     function setNewICOTime(
683     uint _startPrivateICO,
684     uint _endPrivateICO,
685     uint _startPreICO,
686     uint _endPreICO,
687     uint _startICO_w1,
688     uint _endICO_w1,
689     uint _startICO_w2,
690     uint _endICO_w2
691     )
692     public
693     onlyOwner onlyInState(StatusList.NotStarted) {
694         require(now < startPrivateICO && startPrivateICO < endPrivateICO && startPreICO < endPreICO && startICO_w1 < endICO_w1 && startICO_w2 < endICO_w2); // solhint-disable-line
695         startPrivateICO = _startPrivateICO;
696         endPrivateICO = _endPrivateICO;
697         startPreICO = _startPreICO;
698         endPreICO = _endPreICO;
699         startICO_w1 = _startICO_w1;
700         endICO_w1 = _endICO_w1;
701         startICO_w2 = _startICO_w2;
702         endICO_w2 = _endICO_w2;
703     }
704 
705     /**
706      @dev This function can be call by owner to close the ICO if status is closed .
707     *     Transfer the excess tokens to RESERVE if there are available tokens
708     */
709      function closeICO() public onlyOwner {
710         updateStatus();
711         require(status == StatusList.Closed);
712         transferExcessTokensToReserve();
713     }
714 
715     function transferExcessTokensToReserve() internal {
716       availableICO = tokenReward.balanceOf(this);
717       if (availableICO > 0) {
718         tokenReward.transfer(TOKENSRESERVE, availableICO);
719       }
720     }
721 
722     /**
723      @dev Internal function to manage ICO status, as described in the withepaper
724           ICO is available for purchases if date & time is within the PRE-ICO or ICO dates.
725      */
726     function updateStatus() internal {
727         if (now >= endICO_w2) {// solhint-disable-line
728             status = StatusList.Closed;
729         } else {
730             // solhint-disable-next-line
731             if ((now > endPrivateICO && now < startPreICO) || (now > endPreICO && now < startICO_w1)) {
732                 status = StatusList.Waiting;
733             } else {
734                 if (now < startPrivateICO) {// solhint-disable-line
735                     status = StatusList.NotStarted;
736                 } else {
737                     status = StatusList.Running;
738                     updateStages();
739                 }
740             }
741         }
742     }
743 
744     /**
745      @dev Internal function to manage ICO status when tokens are sold out.
746           ICO has a number of limmited tokens to be sold within PrivateICO, PRE-ICO and ICO stages,
747           this method changes status to WaitingICO if PRE-ICO tokens are sold out or
748           Closed when ICO tokens are sold out.
749      */
750     function updateStatusViaTokens() internal {
751         availableICO = tokenReward.balanceOf(this);
752         if (availablePrivateICO == 0 && stage == StagesList.PrivateICO) status = StatusList.Waiting;
753         if (availablePreICO == 0 && stage == StagesList.PreICO) status = StatusList.Waiting;
754         if (availableICO_w1 == 0 && stage == StagesList.ICO_w1) status = StatusList.Waiting;
755         if (availableICO_w2 == 0 && stage == StagesList.ICO_w2) status = StatusList.Waiting;
756         if (availableICO == 0) status = StatusList.Closed;
757     }
758 
759     /**
760      @dev Internal function to manage ICO stages.
761           Stage is used in order to calculate the proper token price.
762      */
763     function updateStages() internal onlyInState(StatusList.Running) {
764         if (now <= endPrivateICO && now > startPrivateICO) { stage = StagesList.PrivateICO; return;}// solhint-disable-line
765         if (now <= endPreICO && now > startPreICO) { stage = StagesList.PreICO; return;}// solhint-disable-line
766         if (now <= endICO_w1 && now > startICO_w1) { stage = StagesList.ICO_w1; return;}// solhint-disable-line
767         if (now <= endICO_w2 && now > startICO_w2) { stage = StagesList.ICO_w2; return;}// solhint-disable-lin
768         stage = StagesList.N_A;
769     }
770 
771      /**
772       @dev Private function to manage GrapheneTech purchases by calculating the right number
773            of tokens based on the value sent.
774            Includes any purchase within a mapping to track address and amount spent.
775            Tracks the number of tokens sold. and ICO amount raised
776            Transfer tokens to the buyer address.
777            Calculates refound value if applais.
778      */
779     function _transfer() private onlyInState(StatusList.Running) {
780         uint amount = msg.value;
781         uint amountToReturn = 0;
782         uint tokens = 0;
783         (tokens, amountToReturn) = getTokens(amount);
784         purchaseMap[msg.sender] = purchaseMap[msg.sender].add(amount);
785         tokensSold = tokensSold.add(tokens);
786         amount = amount.sub(amountToReturn);
787         amountRaised = amountRaised.add(amount);
788         if (stage == StagesList.PrivateICO) availablePrivateICO = availablePrivateICO.sub(tokens);
789         if (stage == StagesList.PreICO) availablePreICO = availablePreICO.sub(tokens);
790         if (stage == StagesList.ICO_w1) availableICO_w1 = availableICO_w1.sub(tokens);
791         if (stage == StagesList.ICO_w2) availableICO_w2 = availableICO_w2.sub(tokens);
792         tokenReward.transfer(msg.sender, tokens);
793         sendETH(amount);
794 
795         if (amountToReturn > 0) {
796             bool refound = msg.sender.send(amountToReturn);
797             require(refound);
798         }
799 
800         emit Purchase(msg.sender, amount, tokens);
801     }
802 
803      /**
804       @dev Returns the number of tokens based on the ETH sent and token price.
805 
806       @param _value this contais the ETHs sent and it is used to calculate the right number of tokens to be transfered.
807       @return number of tokens based on the ETH sent and token price.
808      */
809     function getTokens(uint256 _value)
810     private view
811     onlyInState(StatusList.Running)
812     returns(uint256 numTokens, uint256 amountToReturn) {
813 
814         uint256 eths = _value.mul(10**decimals);//Adding decimals to get an acurate number of tokens
815         numTokens = 0;
816         uint256 tokensAvailable = 0;
817         numTokens = eths.div(tokenPrice[uint256(stage)]);
818 
819         if (stage == StagesList.PrivateICO) {
820             tokensAvailable = availablePrivateICO;
821         } else if (stage == StagesList.PreICO) {
822             tokensAvailable = availablePreICO;
823         } else if (stage == StagesList.ICO_w1) {
824             tokensAvailable = availableICO_w1;
825         } else if (stage == StagesList.ICO_w2) {
826             tokensAvailable = availableICO_w2;
827         }
828 
829         if (tokensAvailable >= numTokens) {
830             amountToReturn = 0;
831         } else {
832             numTokens = tokensAvailable;
833             amountToReturn = _value.sub(numTokens.div(10**decimals).mul(tokenPrice[uint256(stage)]));
834         }
835 
836         return (numTokens, amountToReturn);
837     }
838 
839     /**
840      @dev This function sends ETHs to the list of address SALARIES, MARKETINGandBUSINESS, RESEARCHandDEVELOPMENT, RESERVE, FACTORIES, PLANEQUIPMENT, PRODUCTION
841      @param _amount this are the ETHs that have to be send between different address.
842 
843     */
844     function sendETH(uint _amount)  private {
845 
846         uint paymentSALARIES = _amount.mul(3).div(100);
847         uint paymentMARKETINGandBUSINESS = _amount.mul(4).div(100);
848         uint paymentRESEARCHandDEVELOPMENT = _amount.mul(14).div(100);
849         uint paymentRESERVE = _amount.mul(18).div(100);
850         uint paymentFACTORIES = _amount.mul(24).div(100);
851         uint paymentPLANEQUIPMENT = _amount.mul(19).div(100);
852         uint paymentPRODUCTION = _amount.mul(18).div(100);
853 
854         SALARIES.transfer(paymentSALARIES);
855         MARKETINGandBUSINESS.transfer(paymentMARKETINGandBUSINESS);
856         RESEARCHandDEVELOPMENT.transfer(paymentRESEARCHandDEVELOPMENT);
857         RESERVE.transfer(paymentRESERVE);
858         FACTORIES.transfer(paymentFACTORIES);
859         PLANEQUIPMENT.transfer(paymentPLANEQUIPMENT);
860         PRODUCTION.transfer(paymentPRODUCTION);
861 
862     }
863 
864 }