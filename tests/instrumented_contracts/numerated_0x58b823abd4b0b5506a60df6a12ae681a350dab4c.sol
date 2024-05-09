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
22 /* import "./oraclizeAPI_0.5.sol"; */
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
257 contract FEXToken is Owned, BurnableToken {
258 
259     string public name = "SUREBANQA UTILITY TOKEN";
260     string public symbol = "FEX";
261     uint8 public decimals = 5;
262     
263     uint256 public initialSupply = 450000000 * (10 ** uint256(decimals));
264     uint256 public totalSupply = 2100000000 * (10 ** uint256(decimals));
265     uint256 public externalAuthorizePurchase = 0;
266     
267     mapping (address => bool) public frozenAccount;
268     mapping(address => uint8) authorizedCaller;
269     
270     KYCVerification public kycVerification;
271     bool public kycEnabled = true;
272 
273     /*  Fund Allocation  */
274     uint allocatedEAPFund;
275     uint allocatedAirdropAndBountyFund;
276     uint allocatedMarketingFund;
277     uint allocatedCoreTeamFund;
278     uint allocatedTreasuryFund;
279     
280     uint releasedEAPFund;
281     uint releasedAirdropAndBountyFund;
282     uint releasedMarketingFund;
283     uint releasedCoreTeamFund;
284     uint releasedTreasuryFund;
285     
286     /* EAP Related Factors */
287     uint8 EAPMilestoneReleased = 0; /* Total 4 Milestones , one milestone each year */
288     uint8 EAPVestingPercent = 25; /* 25% */
289     
290     
291     /* Core Team Related Factors */
292     
293     uint8 CoreTeamMilestoneReleased = 0; /* Total 4 Milestones , one milestone each quater */
294     uint8 CoreTeamVestingPercent = 25; /* 25% */
295     
296     /* Distribution Address */
297     address public EAPFundReceiver = 0xD89c58BedFf2b59fcDDAE3D96aC32D777fa00bF4;
298     address public AirdropAndBountyFundReceiver = 0xE4bBCE2795e5C7fF4B7a40b91f7b611526B5613E;
299     address public MarketingFundReceiver = 0xbe4c8660ed5709dF4172936743e6868F11686DBe;
300     address public CoreTeamFundReceiver = 0x2c1Ab4B9E4dD402120ECe5DF08E35644d2efCd35;
301     address public TreasuryFundReceiver = 0xeB81295b4e60e52c60206B0D12C13F82a36Ac9B6;
302     
303     /* Token Vesting Events*/
304     
305     event EAPFundReleased(address _receiver,uint _amount,uint _milestone);
306     event CoreTeamFundReleased(address _receiver,uint _amount,uint _milestone);
307 
308     bool public initialFundDistributed;
309     uint public tokenVestingStartedOn; 
310 
311 
312     modifier onlyAuthCaller(){
313         require(authorizedCaller[msg.sender] == 1 || msg.sender == owner);
314         _;
315     }
316     
317     modifier kycVerified(address _guy) {
318       if(kycEnabled == true){
319           if(kycVerification.isVerified(_guy) == false)
320           {
321               revert("KYC Not Verified");
322           }
323       }
324       _;
325     }
326     
327     modifier frozenVerified(address _guy) {
328         if(frozenAccount[_guy] == true)
329         {
330             revert("Account is freeze");
331         }
332         _;
333     }
334     
335     /* KYC related events */    
336     event KYCMandateUpdate(bool _kycEnabled);
337     event KYCContractAddressUpdate(KYCVerification _kycAddress);
338 
339     /* This generates a public event on the blockchain that will notify clients */
340     event FrozenFunds(address target, bool frozen);
341     
342     /* Events */
343     event AuthorizedCaller(address caller);
344     event DeAuthorizedCaller(address caller);
345     
346     /* Initializes contract with initial supply tokens to the creator of the contract */
347     constructor () public {
348         
349         owner = msg.sender;
350         balances[0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898] = totalSupply;
351         
352         emit Transfer(address(0x0), address(this), totalSupply);
353         emit Transfer(address(this), address(0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898), totalSupply);
354 
355         authorizedCaller[msg.sender] = 1;
356         emit AuthorizedCaller(msg.sender);
357 
358         tokenVestingStartedOn = now;
359         initialFundDistributed = false;
360     }
361 
362     function initFundDistribution() public onlyOwner 
363     {
364         require(initialFundDistributed == false);
365         
366         /* Reserved for Airdrops/Bounty: 125 Million. */
367         
368         allocatedAirdropAndBountyFund = 125000000 * (10 ** uint256(decimals));
369         _transfer(0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898,address(AirdropAndBountyFundReceiver),allocatedAirdropAndBountyFund);
370         releasedAirdropAndBountyFund = allocatedAirdropAndBountyFund;
371         
372         /* Reserved for Marketing/Partnerships: 70 Million. */
373         
374         allocatedMarketingFund = 70000000 * (10 ** uint256(decimals));
375         _transfer(0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898,address(MarketingFundReceiver),allocatedMarketingFund);
376         releasedMarketingFund = allocatedMarketingFund;
377         
378         
379         /* Reserved for EAPs/SLIPs : 125 Million released every year at the rate of 25% per yr. */
380         
381         allocatedEAPFund = 125000000 * (10 ** uint256(decimals));
382         
383         /* Core Team: 21 Million. Released quarterly at the rate of 25% of 21 Million per quarter.  */
384         
385         allocatedCoreTeamFund = 21000000 * (10 ** uint256(decimals));
386 
387         /* Treasury: 2.1 Million Time Locked for 24 months */
388         
389         allocatedTreasuryFund = 2100000 * (10 ** uint256(decimals));
390         
391         initialFundDistributed = true;
392     }
393     
394     function updateKycContractAddress(KYCVerification _kycAddress) public onlyOwner returns(bool)
395     {
396       kycVerification = _kycAddress;
397       emit KYCContractAddressUpdate(_kycAddress);
398       return true;
399     }
400 
401     function updateKycMandate(bool _kycEnabled) public onlyAuthCaller returns(bool)
402     {
403         kycEnabled = _kycEnabled;
404         emit KYCMandateUpdate(_kycEnabled);
405         return true;
406     }
407     
408     /* authorize caller */
409     function authorizeCaller(address _caller) public onlyOwner returns(bool) 
410     {
411         authorizedCaller[_caller] = 1;
412         emit AuthorizedCaller(_caller);
413         return true;
414     }
415     
416     /* deauthorize caller */
417     function deAuthorizeCaller(address _caller) public onlyOwner returns(bool) 
418     {
419         authorizedCaller[_caller] = 0;
420         emit DeAuthorizedCaller(_caller);
421         return true;
422     }
423     
424     function () public payable {
425         revert();
426         // buy();
427     }
428     
429     /* Internal transfer, only can be called by this contract */
430     function _transfer(address _from, address _to, uint _value) internal {
431         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
432         require (balances[_from] > _value);                // Check if the sender has enough
433         require (balances[_to].add(_value) > balances[_to]); // Check for overflow
434         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
435         balances[_to] = balances[_to].add(_value);                           // Add the same to the recipient
436         emit Transfer(_from, _to, _value);
437     }
438 
439     /// @notice Create `mintedAmount` tokens and send it to `target`
440     /// @param target Address to receive the tokens
441     /// @param mintedAmount the amount of tokens it will receive
442     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
443         balances[target] = balances[target].add(mintedAmount);
444         totalSupply = totalSupply.add(mintedAmount);
445         emit Transfer(0, this, mintedAmount);
446         emit Transfer(this, target, mintedAmount);
447     }
448     
449     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
450     /// @param target Address to be frozen
451     /// @param freeze either to freeze it or not
452     function freezeAccount(address target, bool freeze) onlyOwner public {
453         frozenAccount[target] = freeze;
454         emit FrozenFunds(target, freeze);
455     }
456 
457     
458     function purchaseToken(address _receiver, uint _tokens) onlyAuthCaller public {
459         require(_tokens > 0);
460         require(initialSupply > _tokens);
461         
462         initialSupply = initialSupply.sub(_tokens);
463         _transfer(owner, _receiver, _tokens);              // makes the transfers
464         externalAuthorizePurchase = externalAuthorizePurchase.add(_tokens);
465     }
466     
467     /**
468       * @dev transfer token for a specified address
469       * @param _to The address to transfer to.
470       * @param _value The amount to be transferred.
471       */
472     function transfer(address _to, uint256 _value) public kycVerified(msg.sender) frozenVerified(msg.sender) returns (bool) {
473         _transfer(msg.sender,_to,_value);
474         return true;
475     }
476     
477     /*
478         Please make sure before calling this function from UI, Sender has sufficient balance for 
479         All transfers 
480     */
481     function multiTransfer(address[] _to,uint[] _value) public kycVerified(msg.sender) frozenVerified(msg.sender) returns (bool) {
482         require(_to.length == _value.length, "Length of Destination should be equal to value");
483         for(uint _interator = 0;_interator < _to.length; _interator++ )
484         {
485             _transfer(msg.sender,_to[_interator],_value[_interator]);
486         }
487         return true;    
488     }
489 
490 
491     /**
492       * @dev Release Treasury Fund Time Locked for 24 months   
493       *  Can only be called by authorized caller   
494       */
495     function releaseTreasuryFund() public onlyAuthCaller returns(bool)
496     {
497         require(now >= tokenVestingStartedOn.add(730 days));
498         require(allocatedTreasuryFund > 0);
499         require(releasedTreasuryFund <= 0);
500         
501         _transfer(address(this),TreasuryFundReceiver,allocatedTreasuryFund);   
502         
503         /* Complete funds are released */
504         releasedTreasuryFund = allocatedTreasuryFund;
505         
506         return true;
507     }
508     
509 
510     /**
511       * @dev Release EAPs/SLIPs Fund Time Locked releasable every year at the rate of 25% per yr   
512       *  Can only be called by authorized caller   
513       */
514     function releaseEAPFund() public onlyAuthCaller returns(bool)
515     {
516         /* Only 4 Milestone are to be released */
517         require(EAPMilestoneReleased <= 4);
518         require(allocatedEAPFund > 0);
519         require(releasedEAPFund <= allocatedEAPFund);
520         
521         uint toBeReleased = 0 ;
522         
523         if(now <= tokenVestingStartedOn.add(365 days))
524         {
525             toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);
526             EAPMilestoneReleased = 1;
527         }
528         else if(now <= tokenVestingStartedOn.add(730 days))
529         {
530             toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);
531             EAPMilestoneReleased = 2;
532         }
533         else if(now <= tokenVestingStartedOn.add(1095 days))
534         {
535             toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);
536             EAPMilestoneReleased = 3;
537         }
538         else if(now <= tokenVestingStartedOn.add(1460 days))
539         {
540             toBeReleased = allocatedEAPFund.mul(EAPVestingPercent).div(100);
541             EAPMilestoneReleased = 4;
542         }
543         /* If release request sent beyond 4 years , release remaining amount*/
544         else if(now > tokenVestingStartedOn.add(1460 days) && EAPMilestoneReleased != 4)
545         {
546             toBeReleased = allocatedEAPFund.sub(releasedEAPFund);
547             EAPMilestoneReleased = 4;
548         }
549         else
550         {
551             revert();
552         }
553         
554         if(toBeReleased > 0)
555         {
556             releasedEAPFund = releasedEAPFund.add(toBeReleased);
557             _transfer(address(this),EAPFundReceiver,toBeReleased);
558             
559             emit EAPFundReleased(EAPFundReceiver,toBeReleased,EAPMilestoneReleased);
560             
561             return true;
562         }
563         else
564         {
565             revert();
566         }
567     }
568     
569 
570     /**
571       * @dev Release Core Team's Fund Time Locked releasable  quarterly at the rate of 25%    
572       *  Can only be called by authorized caller   
573       */
574     function releaseCoreTeamFund() public onlyAuthCaller returns(bool)
575     {
576         /* Only 4 Milestone are to be released */
577         require(CoreTeamMilestoneReleased <= 4);
578         require(allocatedCoreTeamFund > 0);
579         require(releasedCoreTeamFund <= allocatedCoreTeamFund);
580         
581         uint toBeReleased = 0 ;
582         
583         if(now <= tokenVestingStartedOn.add(90 days))
584         {
585             toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);
586             CoreTeamMilestoneReleased = 1;
587         }
588         else if(now <= tokenVestingStartedOn.add(180 days))
589         {
590             toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);
591             CoreTeamMilestoneReleased = 2;
592         }
593         else if(now <= tokenVestingStartedOn.add(270 days))
594         {
595             toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);
596             CoreTeamMilestoneReleased = 3;
597         }
598         else if(now <= tokenVestingStartedOn.add(360 days))
599         {
600             toBeReleased = allocatedCoreTeamFund.mul(CoreTeamVestingPercent).div(100);
601             CoreTeamMilestoneReleased = 4;
602         }
603         /* If release request sent beyond 4 years , release remaining amount*/
604         else if(now > tokenVestingStartedOn.add(360 days) && CoreTeamMilestoneReleased != 4)
605         {
606             toBeReleased = allocatedCoreTeamFund.sub(releasedCoreTeamFund);
607             CoreTeamMilestoneReleased = 4;
608         }
609         else
610         {
611             revert();
612         }
613         
614         if(toBeReleased > 0)
615         {
616             releasedCoreTeamFund = releasedCoreTeamFund.add(toBeReleased);
617             _transfer(address(this),CoreTeamFundReceiver,toBeReleased);
618             
619             emit CoreTeamFundReleased(CoreTeamFundReceiver,toBeReleased,CoreTeamMilestoneReleased);
620             
621             return true;
622         }
623         else
624         {
625             revert();
626         }
627         
628     }
629 }