1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Owned {
11     address public owner;
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 } 
22 
23 
24 
25 
26 
27 
28 
29 
30 
31 contract ERC20 is ERC20Basic {
32   // Optional token name
33   string  public  name = "zeosX";
34   string  public  symbol;
35   uint256  public  decimals = 18; // standard token precision. override to customize
36     
37   function allowance(address owner, address spender) public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50  
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111   function multiTransfer(address[] _to,uint[] _value) public returns (bool);
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     emit Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194 }
195 
196 contract BurnableToken is StandardToken {
197 
198   event Burn(address indexed burner, uint256 value);
199 
200   /**
201    * @dev Burns a specific amount of tokens.
202    * @param _value The amount of token to be burned.
203    */
204   function burn(uint256 _value) public {
205     require(_value <= balances[msg.sender]);
206     // no need to require value <= totalSupply, since that would imply the
207     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
208 
209     address burner = msg.sender;
210     balances[burner] = balances[burner].sub(_value);
211     totalSupply_ = totalSupply_.sub(_value);
212     emit Burn(burner, _value);
213     emit Transfer(burner, address(0), _value);
214   }
215 }
216 
217 
218 
219 
220 contract KYCVerification is Owned{
221     
222     mapping(address => bool) public kycAddress;
223     
224     event LogKYCVerification(address _kycAddress,bool _status);
225     
226     constructor () public {
227         owner = msg.sender;
228     }
229 
230     function updateVerifcationBatch(address[] _kycAddress,bool _status) onlyOwner public returns(bool)
231     {
232         for(uint tmpIndex = 0; tmpIndex < _kycAddress.length; tmpIndex++)
233         {
234             kycAddress[_kycAddress[tmpIndex]] = _status;
235             emit LogKYCVerification(_kycAddress[tmpIndex],_status);
236         }
237         
238         return true;
239     }
240     
241     function updateVerifcation(address _kycAddress,bool _status) onlyOwner public returns(bool)
242     {
243         kycAddress[_kycAddress] = _status;
244         
245         emit LogKYCVerification(_kycAddress,_status);
246         
247         return true;
248     }
249     
250     function isVerified(address _user) view public returns(bool)
251     {
252         return kycAddress[_user] == true; 
253     }
254 }
255 
256 
257 contract SAVERToken is Owned, BurnableToken {
258 
259     string public name = "SureSAVER PRIZE-LINKED REWARD SAVINGS ACCOUNT TOKEN";
260     string public symbol = "SAVER";
261     uint8 public decimals = 2;
262     bool public kycEnabled = true;
263     
264     uint256 public initialSupply = 81000000 * (10 ** uint256(decimals));
265     uint256 public totalSupply = 810000000 * (10 ** uint256(decimals));
266     uint256 public externalAuthorizePurchase = 0;
267     
268     mapping (address => bool) public frozenAccount;
269     mapping(address => uint8) authorizedCaller;
270     mapping(address => uint) public lockInPeriodForAccount;
271     mapping(address => uint) public lockInPeriodDurationForAccount;
272 
273     
274     KYCVerification public kycVerification;
275     
276     
277     /* Penalty Percent and Treasury Receiver */
278     address public OptOutPenaltyReceiver = 0x63a2311603aE55d1C7AC5DfA19225Ac2B7b5Cf6a;
279     uint public OptOutPenaltyPercent = 20; /* in percent*/
280     
281     
282     modifier onlyAuthCaller(){
283         require(authorizedCaller[msg.sender] == 1 || owner == msg.sender);
284         _;
285     }
286     
287     modifier kycVerified(address _guy) {
288       if(kycEnabled == true){
289           if(kycVerification.isVerified(_guy) == false)
290           {
291               revert("KYC Not Verified");
292           }
293       }
294       _;
295     }
296     
297     modifier frozenVerified(address _guy) {
298         if(frozenAccount[_guy] == true)
299         {
300             revert("Account is freeze");
301         }
302         _;
303     }
304 
305     
306     modifier isAccountLocked(address _guy) {
307         if((_guy != owner || authorizedCaller[_guy] != 1) && lockInPeriodForAccount[_guy] != 0)
308         {
309             if(now < lockInPeriodForAccount[_guy])
310             {
311                 revert("Account is Locked");
312             }
313         }
314         
315         _;
316     }
317     
318     
319     
320     /* KYC related events */    
321     event KYCMandateUpdate(bool _kycEnabled);
322     event KYCContractAddressUpdate(KYCVerification _kycAddress);
323 
324     /* This generates a public event on the blockchain that will notify clients */
325     event FrozenFunds(address target, bool frozen);
326     
327     /* Events */
328     event AuthorizedCaller(address caller);
329     event DeAuthorizedCaller(address caller);
330     
331     /* Opt out Lockin Event */
332     
333     event LockinPeriodUpdated(address _guy, uint _lockinPeriod,uint _lockinPeriodDuration);
334     event OptedOutLockinPeriod(address indexed _guy,uint indexed _optOutDate, uint _penaltyPercent,uint _penaltyAmt);
335     event LockinOptoutPenaltyPercentUpdated(address _guy, uint _percent);
336     event LockinOptoutPenaltyReceiverUpdated(address _newReceiver);
337 
338     
339 
340     /* Initializes contract with initial supply tokens to the creator of the contract */
341     constructor () public {
342         
343         owner = msg.sender;
344 
345         balances[0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898] = totalSupply;
346         
347         
348         authorizedCaller[msg.sender] = 1;
349         emit AuthorizedCaller(msg.sender);
350 
351         emit Transfer(address(0x0), address(this), totalSupply);
352         emit Transfer(address(this), address(0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898), totalSupply);
353         
354     }
355     
356     
357     
358     /****************  KYC Related Methods  *******************/
359 
360 
361     /**
362       * @dev update KYC Contract Address 
363       * @param _kycAddress  KYC Contract Address 
364       *  Can only be called by owner 
365       */
366 
367     function updateKycContractAddress(KYCVerification _kycAddress) public onlyOwner returns(bool)
368     {
369       kycVerification = _kycAddress;
370       emit KYCContractAddressUpdate(_kycAddress);
371       return true;
372     }
373 
374     /**
375       * @dev update KYC Mandate Status for this Contract  
376       * @param _kycEnabled  true/false
377       *  Can only be called by authorized caller  
378       */
379 
380     function updateKycMandate(bool _kycEnabled) public onlyAuthCaller
381     {
382         kycEnabled = _kycEnabled;
383         emit KYCMandateUpdate(_kycEnabled);
384     }
385     
386     /**************** authorization/deauthorization of  caller *****************/
387 
388     /**
389       * @dev authorize an address to perform action required elevated permissions  
390       * @param _caller  Caller Address 
391       *  Can only be called by authorized owner  
392       */
393     function authorizeCaller(address _caller) public onlyOwner returns(bool) 
394     {
395         authorizedCaller[_caller] = 1;
396         emit AuthorizedCaller(_caller);
397         return true;
398     }
399     
400     /**
401       * @dev deauthorize an address to perform action required elevated permissions  
402       * @param _caller  Caller Address 
403       *  Can only be called by authorized owner  
404       */
405     function deAuthorizeCaller(address _caller) public onlyOwner returns(bool) 
406     {
407         authorizedCaller[_caller] = 0;
408         emit DeAuthorizedCaller(_caller);
409         return true;
410     }
411     
412     
413     /**
414       * @dev Internal transfer, only can be called by this contract
415       * @param _from  Sender's Address 
416       * @param _to  Receiver's Address 
417       * @param _value  Amount in terms of Wei 
418       *  Can only be called internally  
419       */
420     function _transfer(address _from, address _to, uint _value) internal 
421     {
422         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
423         require (balances[_from] > _value);                // Check if the sender has enough
424         require (balances[_to].add(_value) > balances[_to]); // Check for overflow
425         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
426         balances[_to] = balances[_to].add(_value);                           // Add the same to the recipient
427         emit Transfer(_from, _to, _value);
428     }
429 
430     /*******************  General Related   **********************/
431 
432 
433     /**
434       * @dev Create `mintedAmount` tokens and send it to `target` with increase in totalsupply 
435       * @param _target  Target Account's Address 
436       * @param _mintedAmount  Amount in terms of Wei 
437       *  Can only be called internally  
438       */
439     function mintToken(address _target, uint256 _mintedAmount) onlyOwner public 
440     {
441         balances[_target] = balances[_target].add(_mintedAmount);
442         totalSupply = totalSupply.add(_mintedAmount);
443         emit Transfer(0, this, _mintedAmount);
444         emit Transfer(this, _target, _mintedAmount);
445     }
446     
447 
448     /**
449       * @dev `freeze? Prevent | Allow` `target` from sending & receiving tokens
450       * @param _target  Address to be frozen
451       * @param _freeze  either to freeze it or not
452       *  Can only be called by owner   
453       */
454     function freezeAccount(address _target, bool _freeze) onlyOwner public 
455     {
456         frozenAccount[_target] = _freeze;
457         emit FrozenFunds(_target, _freeze);
458     }
459 
460 
461     /**
462       * @dev Initiate Token Purchase Externally 
463       * @param _receiver  Address of receiver 
464       * @param _tokens  Tokens amount to be tranferred
465       * @param _lockinPeriod  Lockin Period if need to set else can be 0
466       *  Can only be called by authorized caller   
467       */
468     function purchaseToken(address _receiver, uint _tokens,uint _lockinPeriod,uint _lockinPeriodDuration) onlyAuthCaller public {
469         require(_tokens > 0);
470         require(initialSupply > _tokens);
471         
472         initialSupply = initialSupply.sub(_tokens);
473         _transfer(owner, _receiver, _tokens);              // makes the transfers
474         externalAuthorizePurchase = externalAuthorizePurchase.add(_tokens);
475         
476         /* Update Lockin Period */
477         if(_lockinPeriod != 0)
478         {
479             lockInPeriodForAccount[_receiver] = _lockinPeriod;
480             lockInPeriodDurationForAccount[_receiver] = _lockinPeriodDuration;
481             emit LockinPeriodUpdated(_receiver, _lockinPeriod,_lockinPeriodDuration);
482         }
483         
484     }
485     
486     
487 
488     
489 
490 
491     /**
492       * @dev transfer token for a specified address
493       * @param _to The address to transfer to.
494       * @param _value The amount to be transferred.
495       */
496     function transfer(address _to, uint256 _value) public kycVerified(msg.sender) isAccountLocked(msg.sender) frozenVerified(msg.sender) returns (bool) {
497         _transfer(msg.sender,_to,_value);
498         return true;
499     }
500     
501 
502     /**
503       * @dev mutiple transfer of token to multiple address with respective amounts
504       * @param _to The Array address to transfer to.
505       * @param _value The Array value to transfer to.
506       *  User should have KYC Verification Status true 
507       *       User should have Unlocked Account
508       *       make sure before calling this function from UI, Sender has sufficient balance for All transfers 
509       */
510     function multiTransfer(address[] _to,uint[] _value) public kycVerified(msg.sender) isAccountLocked(msg.sender) frozenVerified(msg.sender) returns (bool) {
511         require(_to.length == _value.length, "Length of Destination should be equal to value");
512         for(uint _interator = 0;_interator < _to.length; _interator++ )
513         {
514             _transfer(msg.sender,_to[_interator],_value[_interator]);
515         }
516         return true;    
517     }
518     
519     /**
520       * @dev enables to Opt of Lockin Period while attracting penalty
521       *  User should not be owner 
522       *  User should not be authorized caller  
523       *  User account should locked already  
524       *  User should have non zero balance All transfers 
525       */
526     function optOutLockinPeriod() public returns (bool)
527     {
528         /* Caller Cannot be Owner */
529         require(owner != msg.sender,"Owner Account Detected");
530         
531         /* Caller Cannot be Authorized */
532         require(authorizedCaller[msg.sender] != 1,"Owner Account Detected");
533         
534         /* Check if Already lockedIn */
535         require(now < lockInPeriodForAccount[msg.sender],"Account Already Unlocked");
536         
537         /* Check Available Balance */
538         require(balances[msg.sender] > 0,"Not sufficient balance available");
539         
540         /* Calculate Penalty */
541         uint _penaltyAmt = balances[msg.sender].mul(OptOutPenaltyPercent).div(100);
542         
543         /* transfer penalty funds */
544         _transfer(msg.sender,OptOutPenaltyReceiver,_penaltyAmt);
545         
546         /* update lockin period to day before */
547         lockInPeriodForAccount[msg.sender] = 0;     
548         lockInPeriodDurationForAccount[msg.sender] = 0;     
549         
550         /* Emit Event */
551         emit OptedOutLockinPeriod(msg.sender,now, OptOutPenaltyPercent,_penaltyAmt);
552         
553         return true;
554     }
555     
556     /**
557       * @dev enables to change Lockin Period Optout Percent
558       * @param _percent Percent to be updated .
559       *  Can only be called by authorized caller   
560       */
561     function updateLockinOptoutPenaltyPercent(uint _percent) onlyAuthCaller public returns(bool)
562     {
563         OptOutPenaltyPercent = _percent;
564 
565         emit LockinOptoutPenaltyPercentUpdated(msg.sender,_percent);
566 
567         return true;
568     }  
569 
570     /**
571       * @dev enables to change Lockin Period Optout Receiver
572       * @param _newReceiver Receiver to be updated .
573       *  Can only be called by authorized caller   
574       */
575     function updateLockinOptoutPenaltyReceiver(address _newReceiver) onlyAuthCaller public returns(bool)
576     {
577         OptOutPenaltyReceiver = _newReceiver;
578 
579         emit LockinOptoutPenaltyReceiverUpdated(_newReceiver);
580 
581         return true;
582     }  
583     
584 }