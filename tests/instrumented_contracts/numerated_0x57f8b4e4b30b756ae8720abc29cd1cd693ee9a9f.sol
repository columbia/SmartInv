1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   event OwnershipRenounced(address indexed previousOwner);
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipRenounced(owner);
48     owner = address(0);
49   }
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     if (a == 0) {
63       return 0;
64     }
65     c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return a / b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender)
111     public view returns (uint256);
112 
113   function transferFrom(address from, address to, uint256 value)
114     public returns (bool);
115 
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(
118     address indexed owner,
119     address indexed spender,
120     uint256 value
121   );
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) public balances;
132 
133   uint256 public totalSupply_;
134 
135   /**
136   * @dev total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     public
192 
193     returns (bool)
194   {
195     require(_to != address(0));
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201 
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     emit Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifying the amount of tokens still available for the spender.
229    */
230   function allowance(
231     address _owner,
232     address _spender
233    )
234     public
235     view
236     returns (uint256)
237   {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * @dev Increase the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To increment
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _addedValue The amount of tokens to increase the allowance by.
250    */
251   function increaseApproval(
252     address _spender,
253     uint256 _addedValue
254   )
255     public
256 
257     returns (bool)
258   {
259     allowed[msg.sender][_spender] = (
260       allowed[msg.sender][_spender].add(_addedValue));
261     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265   /**
266    * @dev Decrease the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To decrement
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _subtractedValue The amount of tokens to decrease the allowance by.
274    */
275   function decreaseApproval(
276     address _spender,
277     uint256 _subtractedValue
278   )
279     public
280 
281     returns (bool)
282   {
283     uint256 oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue > oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 contract Freeze is Ownable {
296   
297   using SafeMath for uint256;
298 
299   struct Group {
300     address[] holders;
301     uint until;
302   }
303   
304 	/**
305 	 * @dev number of groups
306 	 */
307   uint public groups;
308   
309   address[] public gofindAllowedAddresses;
310   
311 	/**
312 	 * @dev link group ID ---> Group structure
313 	 */
314   mapping (uint => Group) public lockup;
315   
316 	/**
317 	 * @dev Check if holder under lock up
318 	 */
319   modifier lockupEnded (address _holder, address _recipient) {
320     uint index = indexOf(_recipient, gofindAllowedAddresses);
321     if (index == 0) {
322       bool freezed;
323       uint groupId;
324       (freezed, groupId) = isFreezed(_holder);
325     
326       if (freezed) {
327         if (lockup[groupId-1].until < block.timestamp)
328           _;
329         else 
330           revert("Your holdings are freezed, wait until transfers become allowed");
331       }
332       else 
333         _;
334     }
335     else
336       _;
337   }
338   
339   function addGofindAllowedAddress (address _newAddress) public onlyOwner returns (bool) {
340     require(indexOf(_newAddress, gofindAllowedAddresses) == 0, "that address already exists");
341     gofindAllowedAddresses.push(_newAddress);
342     return true;
343   }
344 	
345 	/**
346 	 * @param _holder address of token holder to check
347 	 * @return bool - status of freezing and group
348 	 */
349   function isFreezed (address _holder) public view returns(bool, uint) {
350     bool freezed = false;
351     uint i = 0;
352     while (i < groups) {
353       uint index  = indexOf(_holder, lockup[i].holders);
354 
355       if (index == 0) {
356         if (checkZeroIndex(_holder, i)) {
357           freezed = true;
358           i++;
359           continue;
360         }  
361         else {
362           i++;
363           continue;
364         }
365       }
366       
367       if (index != 0) {
368         freezed = true;
369         i++;
370         continue;
371       }
372       i++;
373     }
374     if (!freezed) i = 0;
375     
376     return (freezed, i);
377   }
378   
379 	/**
380 	 * @dev internal usage to get index of holder in group
381 	 * @param element address of token holder to check
382 	 * @param at array of addresses that is group of holders
383 	 * @return index of holder at array
384 	 */
385   function indexOf (address element, address[] memory at) internal pure returns (uint) {
386     for (uint i=0; i < at.length; i++) {
387       if (at[i] == element) return i;
388     }
389     return 0;
390   }
391   
392 	/**
393 	 * @dev internal usage to check that 0 is 0 index or it means that address not exists
394 	 * @param _holder address of token holder to check
395 	 * @param lockGroup id of group to check address existance in it
396 	 * @return true if holder at zero index at group false if holder doesn't exists
397 	 */
398   function checkZeroIndex (address _holder, uint lockGroup) internal view returns (bool) {
399     if (lockup[lockGroup].holders[0] == _holder)
400       return true;
401         
402     else 
403       return false;
404   }
405   
406 	/**
407 	 * @dev Will set group of addresses that will be under lock. When locked address can't
408 	  		  do some actions with token
409 	 * @param _holders array of addresses to lock
410 	 * @param _until   timestamp until that lock up will last
411 	 * @return bool result of operation
412 	 */
413   function setGroup (address[] memory _holders, uint _until) public onlyOwner returns (bool) {
414     lockup[groups].holders = _holders;
415     lockup[groups].until   = _until;
416     
417     groups++;
418     return true;
419   }
420 }
421 
422 /**
423  * @dev This contract needed for inheritance of StandardToken interface,
424         but with freezing modifiers. So, it have exactly same methods, but with 
425         lockupEnded(msg.sender) modifier.
426  * @notice Inherit from it at SingleToken, to make freezing functionality works
427 */
428 contract PausableToken is StandardToken, Freeze {
429 
430   function transfer(
431     address _to,
432     uint256 _value
433   )
434     public
435     lockupEnded(msg.sender, _to)
436     returns (bool)
437   {
438     return super.transfer(_to, _value);
439   }
440 
441   function transferFrom(
442     address _from,
443     address _to,
444     uint256 _value
445   )
446     public
447     lockupEnded(msg.sender, _to)
448     returns (bool)
449   {
450     return super.transferFrom(_from, _to, _value);
451   }
452 
453   function approve(
454     address _spender,
455     uint256 _value
456   )
457     public
458     lockupEnded(msg.sender, _spender)
459     returns (bool)
460   {
461     return super.approve(_spender, _value);
462   }
463 
464   function increaseApproval(
465     address _spender,
466     uint256 _addedValue
467   )
468     public
469     lockupEnded(msg.sender, _spender)
470     returns (bool success)
471   {
472     return super.increaseApproval(_spender, _addedValue);
473   }
474 
475   function decreaseApproval(
476     address _spender,
477     uint256 _subtractedValue
478   )
479     public
480     lockupEnded(msg.sender, _spender)
481     returns (bool success)
482   {
483     return super.decreaseApproval(_spender, _subtractedValue);
484   }
485 }
486 
487 
488 contract SingleToken is PausableToken {
489 
490   string  public constant name      = "Gofind XR"; 
491 
492   string  public constant symbol    = "XR";
493 
494   uint32  public constant decimals  = 8;
495 
496   uint256 public constant maxSupply = 13E16;
497   
498   constructor() public {
499     totalSupply_ = totalSupply_.add(maxSupply);
500     balances[msg.sender] = balances[msg.sender].add(maxSupply);
501   }
502 }
503 contract Leasing is Ownable {
504     
505     using SafeMath for uint256;
506     
507     address XR = address(0); // testnet;
508     SingleToken token;
509     
510     struct Stakes {
511         uint256 stakingCurrency; // 0 for ETH 1 for XR
512         uint256 stakingAmount;
513         bytes coordinates;
514     }
515     
516     struct Tenant {
517         uint256 ids;
518         Stakes[] stakes;
519     }
520     
521     uint256 public tokenRate = 0;
522     address public companyWallet = 0x553654Ad7808625B36F6AB29DdB41140300E024F;
523     
524     mapping (address => Tenant) public tenants;
525     
526     
527     event Deposit(address indexed user, uint256 indexed amount, string indexed currency, uint256 timestamp);
528     event Withdraw(address indexed user, uint256 indexed amount, string indexed currency, uint256 timestamp);
529     
530     constructor (address _xr) public {
531         XR = _xr;
532     }
533     
534     function () payable external {
535         require(1 == 0);
536         
537     }
538     
539 
540     /**
541      * 0 - pre-ICO stage; Assuming 1 ETH = 150$; 1 ETH = 1500XR
542      * 1 - ICO stage; Assuming 1 ETH = 150$; 1 ETH = 1000XR
543      * 2 - post-ICO stage; Using price from exchange
544     */
545     function projectStage (uint256 _stage) public onlyOwner returns (bool) {
546         if (_stage == 0) 
547             tokenRate = 1500;
548         if (_stage == 1)
549             tokenRate = 1000;
550         if (_stage == 2)
551             tokenRate = 0;
552     }
553     
554 
555     /**
556      * @dev Back-end will call that function to set Price from exchange
557      * @param _rate the 1 ETH = _rate XR 
558     */
559     function oracleSetPrice (uint256 _rate) public onlyOwner returns (bool) {
560         tokenRate = _rate;
561         return true;
562     }
563     
564     
565     function stakeEth (bytes memory _coordinates) payable public returns (bool) {
566         require(msg.value != 0);
567         require(tokenRate != 0, "XR is on exchange, need to get price");
568         
569         uint256 fee = msg.value * 10 / 110;
570         address(0x553654Ad7808625B36F6AB29DdB41140300E024F).transfer(fee);
571         uint256 afterFee = msg.value - fee;
572         
573         Stakes memory stake = Stakes(0, afterFee, _coordinates);
574         tenants[msg.sender].stakes.push(stake);
575         
576         tenants[msg.sender].ids = tenants[msg.sender].ids.add(1);
577         
578         emit Deposit(msg.sender, afterFee, "ETH", block.timestamp);
579         return true;
580     }
581     
582     
583     function returnEth (uint256 _id) public returns (bool) {
584         require(_id != 0, "always invalid id");
585         require(tenants[msg.sender].ids != 0, "nothing to return");
586         require(tenants[msg.sender].ids >= _id, "no staking data with such id");
587         require(tenants[msg.sender].stakes[_id-1].stakingCurrency == 0, 'use returnXR');
588         require(tokenRate != 0, "XR is on exchange, need to get price");
589         
590         uint256 indexify = _id-1;
591         uint256 ethToReturn = tenants[msg.sender].stakes[indexify].stakingAmount;
592         
593         removeStakeById(indexify);
594 
595         ethToReturn = ethToReturn * 9 / 10;
596         uint256 tokenAmountToReturn = ethToReturn * tokenRate / 10E9;
597         
598         require(SingleToken(XR).transferFrom(companyWallet, msg.sender, tokenAmountToReturn), "can not transfer tokens");
599     
600         emit Withdraw(msg.sender, tokenAmountToReturn, "ETH", block.timestamp);
601         return true;
602     }
603     
604     
605     function returnTokens (uint256 _id) public returns (bool){
606         require(_id != 0, "always invalid id");
607         require(tenants[msg.sender].ids != 0, "nothing to return");
608         require(tenants[msg.sender].ids >= _id, "no staking data with such id");
609         require(tenants[msg.sender].stakes[_id-1].stakingCurrency == 1, 'use returnETH');
610 
611         uint256 indexify = _id-1;
612         uint256 tokensToReturn = tenants[msg.sender].stakes[indexify].stakingAmount;
613     
614         SingleToken _instance = SingleToken(XR);
615         
616         removeStakeById(indexify);
617         
618         _instance.transfer(msg.sender, tokensToReturn);
619         
620         emit Withdraw(msg.sender, tokensToReturn, "XR", block.timestamp);
621         return true;
622     }
623     
624    
625     function stakeTokens (uint256 amount, bytes memory _coordinates) public returns (bool) {
626         require(amount != 0, "staking can not be 0");
627         
628         Stakes memory stake = Stakes(1, amount, _coordinates);
629         tenants[msg.sender].stakes.push(stake);
630         
631         tenants[msg.sender].ids = tenants[msg.sender].ids.add(1);
632         
633         require(SingleToken(XR).transferFrom(msg.sender, address(this), amount), "can not transfer tokens");
634         
635         emit Deposit(msg.sender, amount, "XR", block.timestamp);
636         return true;
637     }
638     
639     
640     function removeStakeById (uint256 _id) internal returns (bool) {
641         for (uint256 i = _id; i < tenants[msg.sender].stakes.length-1; i++) {
642             tenants[msg.sender].stakes[i] = tenants[msg.sender].stakes[i+1];
643         }
644         tenants[msg.sender].stakes.length--;
645         tenants[msg.sender].ids = tenants[msg.sender].ids.sub(1);
646         
647         return true;
648     }
649     
650     
651     function getStakeById (uint256 _id) public view returns (string memory, uint256, bytes memory) {
652         require(_id != 0, "always invalid id");
653         require(tenants[msg.sender].ids != 0, "no staking data");
654         require(tenants[msg.sender].ids >= _id, "no staking data with such id");
655         
656         uint256 indexify = _id-1;
657         string memory currency;
658         if (tenants[msg.sender].stakes[indexify].stakingCurrency == 0)
659             currency = "ETH";
660         else 
661             currency = "XR";
662         
663         return (currency, tenants[msg.sender].stakes[indexify].stakingAmount, tenants[msg.sender].stakes[indexify].coordinates);
664     }
665     
666     
667     function getStakingStructLength () public view returns (uint256) {
668         return tenants[msg.sender].stakes.length;
669     }
670 }