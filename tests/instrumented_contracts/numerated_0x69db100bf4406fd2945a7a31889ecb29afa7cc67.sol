1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath 
8 {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37 
38   /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47    * @dev Adds two numbers, throws on overflow.
48    */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54   
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable 
63 {
64   address public owner;
65 
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104   
105 }
106 
107 
108 /**
109  * @title Pausable
110  * @dev Base contract which allows children to implement an emergency stop mechanism.
111  */
112 contract Pausable is Ownable 
113 {
114   event Pause();
115   event Unpause();
116 
117   bool public paused = false;
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is not paused.
121    */
122   modifier whenNotPaused() {
123     require(!paused);
124     _;
125   }
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is paused.
129    */
130   modifier whenPaused() {
131     require(paused);
132     _;
133   }
134 
135   /**
136    * @dev called by the owner to pause, triggers stopped state
137    */
138   function pause() onlyOwner whenNotPaused public {
139     paused = true;
140     emit Pause();
141   }
142 
143   /**
144    * @dev called by the owner to unpauseunpause, returns to normal state
145    */
146   function unpause() onlyOwner whenPaused public {
147     paused = false;
148     emit Unpause();
149   }
150 
151 }
152 
153 /**
154  * @title ERC20Basic
155  * @dev Simpler version of ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/179
157  */
158 contract ERC20Basic 
159 {
160   function totalSupply() public view returns (uint256);
161   function balanceOf(address who) public view returns (uint256);
162   function transfer(address to, uint256 value) public returns (bool);
163   event Transfer(address indexed from, address indexed to, uint256 value);
164 }
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic 
171 {
172   function allowance(address owner, address spender) public view returns (uint256);
173 
174   function transferFrom(address from, address to, uint256 value) public returns (bool);
175 
176   function approve(address spender, uint256 value) public returns (bool);
177   
178   event Approval(
179     address indexed owner,
180     address indexed spender,
181     uint256 value
182   );
183 
184 }
185 
186 /**
187  * @title Basic token
188  * @dev Basic version of StandardToken, with no allowances.
189  */
190 contract BasicToken is ERC20Basic 
191 {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   uint256 totalSupply_;
197 
198   /**
199   * @dev total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return totalSupply_;
203   }
204 
205   /**
206   * @dev transfer token for a specified address
207   * @param _to The address to transfer to.
208   * @param _value The amount to be transferred.
209   */
210   function transfer(address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[msg.sender]);
213 
214     balances[msg.sender] = balances[msg.sender].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     emit Transfer(msg.sender, _to, _value);
217     return true;
218   }
219 
220   /**
221   * @dev Gets the balance of the specified address.
222   * @param _owner The address to query the the balance of.
223   * @return An uint256 representing the amount owned by the passed address.
224   */
225   function balanceOf(address _owner) public view returns (uint256) {
226     return balances[_owner];
227   }
228 
229 }
230 
231 
232 /**
233  * @title Standard ERC20 token
234  * @dev Implementation of the basic standard token.
235  * @dev https://github.com/ethereum/EIPs/issues/20
236  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
237  */
238 contract StandardToken is ERC20, BasicToken 
239 {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243   /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[_from]);
252     require(_value <= allowed[_from][msg.sender]);
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     emit Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263    *
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
273     allowed[msg.sender][_spender] = _value;
274     emit Approval(msg.sender, _spender, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Function to check the amount of tokens that an owner allowed to a spender.
280    * @param _owner address The address which owns the funds.
281    * @param _spender address The address which will spend the funds.
282    * @return A uint256 specifying the amount of tokens still available for the spender.
283    */
284   function allowance(address _owner, address _spender) public view returns (uint256) {
285     return allowed[_owner][_spender];
286   }
287 
288   /**
289    * @dev Increase the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To increment
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _addedValue The amount of tokens to increase the allowance by.
297    */
298   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
299     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
315     uint256 oldValue = allowed[msg.sender][_spender];
316     if (_subtractedValue > oldValue) {
317       allowed[msg.sender][_spender] = 0;
318     } else {
319       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
320     }
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325 }
326 
327 
328 /**
329  * @title Pausable token
330  * @dev StandardToken modified with pausable transfers.
331  **/
332 contract PausableToken is StandardToken, Pausable 
333 {
334 
335   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
336     return super.transfer(_to, _value);
337   }
338 
339   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
340     return super.transferFrom(_from, _to, _value);
341   }
342 
343   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
344     return super.approve(_spender, _value);
345   }
346 
347   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
348     return super.increaseApproval(_spender, _addedValue);
349   }
350 
351   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
352     return super.decreaseApproval(_spender, _subtractedValue);
353   }
354 
355 }
356 
357 
358 /**
359  * @title Frozenable Token
360  * @dev Illegal address that can be frozened.
361  */
362 contract FrozenableToken is Ownable 
363 {
364     
365     mapping (address => bool) public frozenAccount;
366 
367     event FrozenFunds(address indexed to, bool frozen);
368 
369     modifier whenNotFrozen(address _who) {
370       require(!frozenAccount[msg.sender] && !frozenAccount[_who]);
371       _;
372     }
373 
374     function freezeAccount(address _to, bool _freeze) public onlyOwner {
375         require(_to != address(0));
376         frozenAccount[_to] = _freeze;
377         emit FrozenFunds(_to, _freeze);
378     }
379 
380 }
381 
382 
383 /**
384  * @title Colorbay Token
385  * @dev Global digital painting asset platform token.
386  * @author colorbay.org 
387  */
388 contract Colorbay is PausableToken, FrozenableToken 
389 {
390 
391     string public name = "Colorbay Token";
392     string public symbol = "CLOB";
393     uint256 public decimals = 18;
394     uint256 INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
395 
396     /**
397      * @dev Initializes the total release
398      */
399     constructor() public {
400         totalSupply_ = INITIAL_SUPPLY;
401         balances[msg.sender] = totalSupply_;
402         emit Transfer(address(0), msg.sender, totalSupply_);
403     }
404 
405     /**
406      * if ether is sent to this address, send it back.
407      */
408     function() public payable {
409         revert();
410     }
411 
412     /**
413      * @dev transfer token for a specified address
414      * @param _to The address to transfer to.
415      * @param _value The amount to be transferred.
416      */
417     function transfer(address _to, uint256 _value) public whenNotFrozen(_to) returns (bool) {
418         return super.transfer(_to, _value);
419     }
420 
421     /**
422      * @dev Transfer tokens from one address to another
423      * @param _from address The address which you want to send tokens from
424      * @param _to address The address which you want to transfer to
425      * @param _value uint256 the amount of tokens to be transferred
426      */
427     function transferFrom(address _from, address _to, uint256 _value) public whenNotFrozen(_from) returns (bool) {
428         return super.transferFrom(_from, _to, _value);
429     }        
430     
431 }
432 
433 /**
434  * @title SafeERC20
435  * @dev Wrappers around ERC20 operations that throw on failure.
436  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
437  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
438  */
439 library SafeERC20 {
440   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
441     require(token.transfer(to, value));
442   }
443 
444   function safeTransferFrom(
445     ERC20 token,
446     address from,
447     address to,
448     uint256 value
449   )
450     internal
451   {
452     require(token.transferFrom(from, to, value));
453   }
454 
455   function safeApprove(ERC20 token, address spender, uint256 value) internal {
456     require(token.approve(spender, value));
457   }
458 }
459 
460 
461 contract TokenVesting is Ownable {
462     using SafeMath for uint256;
463     using SafeERC20 for ERC20Basic;
464   
465     ERC20Basic public token;
466 
467     uint256 public planCount = 0;
468     uint256 public payPool = 0;
469     
470     //A token holder's plan
471     struct Plan {
472       //beneficiary of tokens after they are released
473       address beneficiary; 
474       
475       //Lock start time
476       uint256 startTime;
477       
478       //Lock deadline
479       uint256 locktoTime;
480       
481       //Number of installments of release time
482       uint256 releaseStages; 
483       
484       //Release completion time
485       uint256 endTime;
486       
487       //Allocated token balance
488       uint256 totalToken;
489       
490       //Current release quantity
491       uint256 releasedAmount;
492       
493       //Whether the token can be revoked
494       bool revocable;
495       
496       //Whether the token has been revoked
497       bool isRevoked;
498       
499       //Remarks for a plan
500       string remark;
501     }
502     
503     //Token holder's plan set
504     mapping (address => Plan) public plans;
505     
506     event Released(address indexed beneficiary, uint256 amount);
507     event Revoked(address indexed beneficiary, uint256 refund);
508     event AddPlan(address indexed beneficiary, uint256 startTime, uint256 locktoTime, uint256 releaseStages, uint256 endTime, uint256 totalToken, uint256 releasedAmount, bool revocable, bool isRevoked, string remark);
509     
510     /**
511      * @param _token ERC20 token which is being vested
512      */
513     constructor(address _token) public {
514         token = ERC20Basic(_token);
515     }
516 
517     /**
518      * @dev Check if the payment amount of the contract is sufficient
519      */
520     modifier checkPayPool(uint256 _totalToken) {
521         require(token.balanceOf(this) >= payPool.add(_totalToken));
522         payPool = payPool.add(_totalToken);
523         _;
524     }
525 
526     /**
527      * @dev Check if the plan exists
528      */
529     modifier whenPlanExist(address _beneficiary) {
530         require(_beneficiary != address(0));
531         require(plans[_beneficiary].beneficiary != address(0));
532         _;
533     }
534     
535     /**
536      * @dev Add a token holder's plan
537      */
538     function addPlan(address _beneficiary, uint256 _startTime, uint256 _locktoTime, uint256 _releaseStages, uint256 _endTime, uint256 _totalToken, bool _revocable, string _remark) public onlyOwner checkPayPool(_totalToken) {
539         require(_beneficiary != address(0));
540         require(plans[_beneficiary].beneficiary == address(0));
541 
542         require(_startTime > 0 && _locktoTime > 0 && _releaseStages > 0 && _totalToken > 0);
543         require(_locktoTime > block.timestamp && _locktoTime >= _startTime  && _endTime > _locktoTime);
544 
545         plans[_beneficiary] = Plan(_beneficiary, _startTime, _locktoTime, _releaseStages, _endTime, _totalToken, 0, _revocable, false, _remark);
546         planCount = planCount.add(1);
547         emit AddPlan(_beneficiary, _startTime, _locktoTime, _releaseStages, _endTime, _totalToken, 0, _revocable, false, _remark);
548     }
549     
550     /**
551     * @notice Transfers vested tokens to beneficiary.
552     */
553     function release(address _beneficiary) public whenPlanExist(_beneficiary) {
554 
555         require(!plans[_beneficiary].isRevoked);
556         
557         uint256 unreleased = releasableAmount(_beneficiary);
558 
559         if(unreleased > 0 && unreleased <= plans[_beneficiary].totalToken) {
560             plans[_beneficiary].releasedAmount = plans[_beneficiary].releasedAmount.add(unreleased);
561             payPool = payPool.sub(unreleased);
562             token.safeTransfer(_beneficiary, unreleased);
563             emit Released(_beneficiary, unreleased);
564         }        
565         
566     }
567     
568     /**
569      * @dev Calculates the amount that has already vested but hasn't been released yet.
570      */
571     function releasableAmount(address _beneficiary) public view whenPlanExist(_beneficiary) returns (uint256) {
572         return vestedAmount(_beneficiary).sub(plans[_beneficiary].releasedAmount);
573     }
574 
575     /**
576      * @dev Calculates the amount that has already vested.
577      */
578     function vestedAmount(address _beneficiary) public view whenPlanExist(_beneficiary) returns (uint256) {
579 
580         if (block.timestamp <= plans[_beneficiary].locktoTime) {
581             return 0;
582         } else if (plans[_beneficiary].isRevoked) {
583             return plans[_beneficiary].releasedAmount;
584         } else if (block.timestamp > plans[_beneficiary].endTime && plans[_beneficiary].totalToken == plans[_beneficiary].releasedAmount) {
585             return plans[_beneficiary].totalToken;
586         }
587         
588         uint256 totalTime = plans[_beneficiary].endTime.sub(plans[_beneficiary].locktoTime);
589         uint256 totalToken = plans[_beneficiary].totalToken;
590         uint256 releaseStages = plans[_beneficiary].releaseStages;
591         uint256 endTime = block.timestamp > plans[_beneficiary].endTime ? plans[_beneficiary].endTime : block.timestamp;
592         uint256 passedTime = endTime.sub(plans[_beneficiary].locktoTime);
593         
594         uint256 unitStageTime = totalTime.div(releaseStages);
595         uint256 unitToken = totalToken.div(releaseStages);
596         uint256 currStage = passedTime.div(unitStageTime);
597 
598         uint256 totalBalance = 0;        
599         if(currStage > 0 && releaseStages == currStage && (totalTime % releaseStages) > 0 && block.timestamp < plans[_beneficiary].endTime) {
600             totalBalance = unitToken.mul(releaseStages.sub(1));
601         } else if(currStage > 0 && releaseStages == currStage) {
602             totalBalance = totalToken;
603         } else if(currStage > 0) {
604             totalBalance = unitToken.mul(currStage);
605         }
606         return totalBalance;
607         
608     }
609     
610     /**
611      * @notice Allows the owner to revoke the vesting. Tokens already vested
612      * remain in the contract, the rest are returned to the owner.
613      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
614      */
615     function revoke(address _beneficiary) public onlyOwner whenPlanExist(_beneficiary) {
616 
617         require(plans[_beneficiary].revocable && !plans[_beneficiary].isRevoked);
618         
619         //Transfer the attribution token to the beneficiary before revoking.
620         release(_beneficiary);
621 
622         uint256 refund = revokeableAmount(_beneficiary);
623     
624         plans[_beneficiary].isRevoked = true;
625         payPool = payPool.sub(refund);
626         
627         token.safeTransfer(owner, refund);
628         emit Revoked(_beneficiary, refund);
629     }
630     
631     /**
632      * @dev Calculates the amount that recoverable token.
633      */
634     function revokeableAmount(address _beneficiary) public view whenPlanExist(_beneficiary) returns (uint256) {
635 
636         uint256 totalBalance = 0;
637         
638         if(plans[_beneficiary].isRevoked) {
639             totalBalance = 0;
640         } else if (block.timestamp <= plans[_beneficiary].locktoTime) {
641             totalBalance = plans[_beneficiary].totalToken;
642         } else {
643             totalBalance = plans[_beneficiary].totalToken.sub(vestedAmount(_beneficiary));
644         }
645         return totalBalance;
646     }
647     
648     /**
649      * Current token balance of the contract
650      */
651     function thisTokenBalance() public view returns (uint256) {
652         return token.balanceOf(this);
653     }
654 
655 }