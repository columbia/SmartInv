1 pragma solidity ^0.4.24;
2 
3 //test rinkeby address: {ec8d36aec0ee4105b7a36b9aafaa2b6c18585637}
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8 */
9  
10 library SafeMath 
11 {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) 
13   {
14       if (a==0)
15       {
16           return 0;
17       }
18       
19     uint256 c = a * b;
20     assert(c / a == b); // assert on overflow
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) 
25   {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) 
33   {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256)
39   {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic
52 {
53   uint256 public totalSupply;
54   function balanceOf(address who) public constant returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic
65 {
66     // founder details
67     address public constant FOUNDER_ADDRESS1 = 0xcb8Fb8Bf927e748c0679375B26fb9f2F12f3D5eE;
68     address public constant FOUNDER_ADDRESS2 = 0x1Ebfe7c17a22E223965f7B80c02D3d2805DFbE5F;
69     address public constant FOUNDER_ADDRESS3 = 0x9C5076C3e95C0421699A6D9d66a219BF5Ba5D826;
70     
71     address public constant FOUNDER_FUND_1 = 9000000000;
72     address public constant FOUNDER_FUND_2 = 9000000000;
73     address public constant FOUNDER_FUND_3 = 7000000000;
74     
75     // deposit address for reserve / crowdsale
76     address public constant MEW_RESERVE_FUND = 0xD11ffBea1cE043a8d8dDDb85F258b1b164AF3da4; // multisig
77     address public constant MEW_CROWDSALE_FUND = 0x842C4EA879050742b42c8b2E43f1C558AD0d1741; // multisig
78     
79     uint256 public constant decimals = 18;
80     
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84   
85   // all initialised to false - do we want multi-state? maybe... 
86   mapping(address => uint256) public mCanSpend;
87   mapping(address => uint256) public mEtherSpent;
88   
89   int256 public mEtherValid;
90   int256 public mEtherInvalid;
91   
92   // real
93   // standard unlocked tokens will vest immediately on the prime vesting date
94   // founder tokens will vest at a rate per day
95   uint256 public constant TOTAL_RESERVE_FUND =  40 * (10**9) * 10**decimals;  // 40B reserve created before sale
96   uint256 public constant TOTAL_CROWDSALE_FUND =  60 * (10**9) * 10**decimals;  // 40B reserve created before sale
97   uint256 public PRIME_VESTING_DATE = 0xffffffffffffffff; // will set to rough dates then fix at end of sale
98   uint256 public FINAL_AML_DATE = 0xffffffffffffffff; // will set to rough date + 3 months then fix at end of sale
99   uint256 public constant FINAL_AML_DAYS = 90;
100   uint256 public constant DAYSECONDS = 24*60*60;//86400; // 1 day in seconds // 1 minute vesting
101   
102   mapping(address => uint256) public mVestingDays;  // number of days to fully vest
103   mapping(address => uint256) public mVestingBalance; // total balance which will vest
104   mapping(address => uint256) public mVestingSpent; // total spent
105   mapping(address => uint256) public mVestingBegins; // total spent
106   
107   mapping(address => uint256) public mVestingAllowed; // really just for checking
108   
109   // used to enquire about the ether spent to buy the tokens
110   function GetEtherSpent(address from) view public returns (uint256)
111   {
112       return mEtherSpent[from];
113   }
114   
115   // removes tokens and returns them to the main pool
116   // this is called if 
117   function RevokeTokens(address target) internal
118   {
119       //require(mCanSpend[from]==0),"Can only call this if AML hasn't been completed correctly");
120       // block this address from further spending
121       require(mCanSpend[target]!=9);
122       mCanSpend[target]=9;
123       
124       uint256 _value = balances[target];
125       
126       balances[target] = 0;//just wipe the balance
127       
128       balances[MEW_RESERVE_FUND] = balances[MEW_RESERVE_FUND].add(_value);
129       
130       // let the blockchain know its been revoked
131       emit Transfer(target, MEW_RESERVE_FUND, _value);
132   }
133   
134   function LockedCrowdSale(address target) view internal returns (bool)
135   {
136       if (mCanSpend[target]==0 && mEtherSpent[target]>0)
137       {
138           return true;
139       }
140       return false;
141   }
142   
143   function CheckRevoke(address target) internal returns (bool)
144   {
145       // roll vesting / dates and AML in to a single function
146       // this will stop coins being spent on new addresses until after 
147       // we know if they took part in the crowdsale by checking if they spent ether
148       if (LockedCrowdSale(target))
149       {
150          if (block.timestamp>FINAL_AML_DATE)
151          {
152              RevokeTokens(target);
153              return true;
154          }
155       }
156       
157       return false;
158   }
159   
160   function ComputeVestSpend(address target) public returns (uint256)
161   {
162       require(mCanSpend[target]==2); // only compute for vestable accounts
163       int256 vestingDays = int256(mVestingDays[target]);
164       int256 vestingProgress = (int256(block.timestamp)-int256(mVestingBegins[target]))/(int256(DAYSECONDS));
165       
166       // cap the vesting
167       if (vestingProgress>vestingDays)
168       {
169           vestingProgress=vestingDays;
170       }
171           
172       // whole day vesting e.g. day 0 nothing vested, day 1 = 1 day vested    
173       if (vestingProgress>0)
174       {
175               
176         int256 allowedVest = ((int256(mVestingBalance[target])*vestingProgress))/vestingDays;
177                   
178         int256 combined = allowedVest-int256(mVestingSpent[target]);
179         
180         // store the combined value so people can see their vesting (useful for debug too)
181         mVestingAllowed[target] = uint256(combined);
182         
183         return uint256(combined);
184       }
185       
186       // no vesting allowed
187       mVestingAllowed[target]=0;
188       
189       // cannot spend anything
190       return 0;
191   }
192   
193   // 0 locked 
194   // 1 unlocked
195   // 2 vestable
196   function canSpend(address from, uint256 amount) internal returns (bool permitted)
197   {
198       uint256 currentTime = block.timestamp;
199       
200       // refunded / blocked
201       if (mCanSpend[from]==8)
202       {
203           return false;
204       }
205       
206       // revoked / blocked
207       if (mCanSpend[from]==9)
208       {
209           return false;
210       }
211       
212       // roll vesting / dates and AML in to a single function
213       // this will stop coins being spent on new addresses until after 
214       if (LockedCrowdSale(from))
215       {
216           return false;
217       }
218       
219       if (mCanSpend[from]==1)
220       {
221           // tokens can only move when sale is finished
222           if (currentTime>PRIME_VESTING_DATE)
223           {
224              return true;
225           }
226           return false;
227       }
228       
229       // special vestable tokens
230       if (mCanSpend[from]==2)
231       {
232               
233         if (ComputeVestSpend(from)>=amount)
234             {
235               return true;
236             }
237             else
238             {
239               return false;   
240             }
241       }
242       
243       return false;
244   }
245   
246    // 0 locked 
247   // 1 unlocked
248   // 2 vestable
249   function canTake(address from) view public returns (bool permitted)
250   {
251       uint256 currentTime = block.timestamp;
252       
253       // refunded / blocked
254       if (mCanSpend[from]==8)
255       {
256           return false;
257       }
258       
259       // revoked / blocked
260       if (mCanSpend[from]==9)
261       {
262           return false;
263       }
264       
265       // roll vesting / dates and AML in to a single function
266       // this will stop coins being spent on new addresses until after 
267       if (LockedCrowdSale(from))
268       {
269           return false;
270       }
271       
272       if (mCanSpend[from]==1)
273       {
274           // tokens can only move when sale is finished
275           if (currentTime>PRIME_VESTING_DATE)
276           {
277              return true;
278           }
279           return false;
280       }
281       
282       // special vestable tokens
283       if (mCanSpend[from]==2)
284       {
285           return false;
286       }
287       
288       return true;
289   }
290   
291 
292   /**
293   * @dev transfer token for a specified address
294   * @param _to The address to transfer to.
295   * @param _value The amount to be transferred.
296   */
297   function transfer(address _to, uint256 _value) public returns (bool success) 
298   {
299        // check to see if we should revoke (and revoke if so)
300       if (CheckRevoke(msg.sender)||CheckRevoke(_to))
301       {
302           return false;
303       }
304      
305     require(canSpend(msg.sender, _value)==true);//, "Cannot spend this amount - AML or not vested")
306     require(canTake(_to)==true); // must be aml checked or unlocked wallet no vesting
307     
308     if (balances[msg.sender] >= _value) 
309     {
310       // deduct the spend first (this is unlikely attack vector as only a few people will have vesting tokens)
311       // special tracker for vestable funds - if have a date up
312       if (mCanSpend[msg.sender]==2)
313       {
314         mVestingSpent[msg.sender] = mVestingSpent[msg.sender].add(_value);
315       }
316       
317       balances[msg.sender] = balances[msg.sender].sub(_value);
318       balances[_to] = balances[_to].add(_value);
319       emit Transfer(msg.sender, _to, _value);
320       
321       
322       // set can spend on destination as it will be transferred from approved wallet
323       mCanSpend[_to]=1;
324       
325       return true;
326     } 
327     else
328     {
329       return false;
330     }
331   }
332   
333   // in the light of our sanity allow a utility to whole number of tokens and 1/10000 token transfer
334   function simpletransfer(address _to, uint256 _whole, uint256 _fraction) public returns (bool success) 
335   {
336     require(_fraction<10000);//, "Fractional part must be less than 10000");
337     
338     uint256 main = _whole.mul(10**decimals); // works fine now i've removed the retarded divide by 0 assert in safemath
339     uint256 part = _fraction.mul(10**14);
340     uint256 value = main + part;
341     
342     // just call the transfer
343     return transfer(_to, value);
344   }
345 
346   /**
347   * @dev Gets the balance of the specified address.
348   * @param _owner The address to query the the balance of.
349   * @return An uint256 representing the amount owned by the passed address.
350   */
351   function balanceOf(address _owner) public constant returns (uint256 returnbalance) 
352   {
353     return balances[_owner];
354   }
355 
356 }
357 
358 /**
359  * @title ERC20 interface
360  * @dev see https://github.com/ethereum/EIPs/issues/20
361  */
362 contract ERC20 is ERC20Basic 
363 {
364   function allowance(address owner, address spender) public constant returns (uint256);
365   function transferFrom(address from, address to, uint256 value) public returns (bool);
366   function approve(address spender, uint256 value) public returns (bool);
367   event Approval(address indexed owner, address indexed spender, uint256 value);
368 }
369 
370 
371 /**
372  * @title Standard ERC20 token
373  *
374  * @dev Implementation of the basic standard token.
375  * @dev https://github.com/ethereum/EIPs/issues/20
376  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
377  */
378 contract StandardToken is ERC20, BasicToken 
379 {
380   // need to add
381   // also need
382   // invalidate - used to drop all unauthorised buyers, return their tokens to reserve
383   // freespend - all transactions now allowed - this could be used to vest tokens?
384   mapping (address => mapping (address => uint256)) allowed;
385 
386   /**
387    * @dev Transfer tokens from one address to another
388    * @param _from address The address which you want to send tokens from
389    * @param _to address The address which you want to transfer to
390    * @param _value uint256 the amount of tokens to be transferred
391    */
392    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
393    {
394       // check to see if we should revoke (and revoke if so)
395       if (CheckRevoke(msg.sender)||CheckRevoke(_to))
396       {
397           return false;
398       }
399       
400       require(canSpend(_from, _value)== true);//, "Cannot spend this amount - AML or not vested")
401       require(canTake(_to)==true); // must be aml checked or unlocked wallet no vesting
402      
403     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) 
404     {
405       balances[_to] = balances[_to].add(_value);
406       balances[_from] = balances[_from].sub(_value);
407       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
408       emit Transfer(_from, _to, _value);
409       
410       
411       // set can spend on destination as it will be transferred from approved wallet
412       mCanSpend[_to]=1;
413       
414       // special tracker for vestable funds - if have a date set
415       if (mCanSpend[msg.sender]==2)
416       {
417         mVestingSpent[msg.sender] = mVestingSpent[msg.sender].add(_value);
418       }
419       return true;
420     } 
421     else 
422     {
423      //   endsigning();
424       return false;
425     }
426   }
427   
428   /**
429    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
430    *
431    * Beware that changing an allowance with this method brings the risk that someone may use both the old
432    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
433    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
434    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
435    * @param _spender The address which will spend the funds.
436    * @param _value The amount of tokens to be spent.
437    */
438   function approve(address _spender, uint256 _value) public returns (bool)
439   {
440       // check to see if we should revoke (and revoke if so)
441       if (CheckRevoke(msg.sender))
442       {
443           return false;
444       }
445       
446       require(canSpend(msg.sender, _value)==true);//, "Cannot spend this amount - AML or not vested");
447       
448     allowed[msg.sender][_spender] = _value;
449     emit Approval(msg.sender, _spender, _value);
450     return true;
451   }
452 
453   /**
454    * @dev Function to check the amount of tokens that an owner allowed to a spender.
455    * @param _owner address The address which owns the funds.
456    * @param _spender address The address which will spend the funds.
457    * @return A uint256 specifying the amount of tokens still available for the spender.
458    */
459   function allowance(address _owner, address _spender) public constant returns (uint256 remaining)
460   {
461     return allowed[_owner][_spender];
462   }
463 
464   /**
465    * approve should be called when allowed[_spender] == 0. To increment
466    * allowed value is better to use this function to avoid 2 calls (and wait until
467    * the first transaction is mined)
468    * From MonolithDAO Token.sol
469    */
470   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) 
471   {
472       // check to see if we should revoke (and revoke if so)
473       if (CheckRevoke(msg.sender))
474       {
475           return false;
476       }
477       require(canSpend(msg.sender, _addedValue)==true);//, "Cannot spend this amount - AML or not vested");
478       
479     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
480     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
481     return true;
482   }
483 
484   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success)
485   {
486       // check to see if we should revoke (and revoke if so)
487       if (CheckRevoke(msg.sender))
488       {
489           return false;
490       }
491     uint oldValue = allowed[msg.sender][_spender];
492     if (_subtractedValue > oldValue) {
493       allowed[msg.sender][_spender] = 0;
494     } else {
495       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
496     }
497     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
498     return true;
499   }
500 
501 }
502 
503 
504 /**
505  * @title Ownable
506  * @dev The Ownable contract has an owner address, and provides basic authorization control
507  * functions, this simplifies the implementation of 'user permissions'.
508  */
509 contract Ownable
510 {
511   address public owner;
512   address internal auxOwner;
513 
514   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
515 
516   /**
517    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
518    * account.
519    */
520   constructor() public
521   {
522       
523         address newOwner = msg.sender;
524         owner = 0;
525         owner = newOwner;
526     
527   }
528 
529 
530   /**
531    * @dev Throws if called by any account other than the owner.
532    */
533   modifier onlyOwner() 
534   {
535     require(msg.sender == owner || msg.sender==auxOwner);
536     _;
537   }
538 
539 
540   /**
541    * @dev Allows the current owner to transfer control of the contract to a newOwner.
542    * @param newOwner The address to transfer ownership to.
543    */
544   function transferOwnership(address newOwner) onlyOwner public 
545   {
546     require(newOwner != address(0));
547     emit OwnershipTransferred(owner, newOwner);
548     owner = newOwner;
549   }
550 
551 }
552 
553 
554 
555 /**
556  * @title Mintable token
557  * @dev Simple ERC20 Token example, with mintable token creation
558  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
559  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
560  */
561 
562 contract MintableToken is StandardToken, Ownable
563 {
564   event Mint(address indexed to, uint256 amount);
565   event MintFinished();
566 
567   bool public mintingFinished = false;
568   uint256 internal mCanPurchase = 1;
569   uint256 internal mSetupReserve = 0;
570   uint256 internal mSetupCrowd = 0;
571   
572   //test
573   uint256 public constant MINIMUM_ETHER_SPEND = (250 * 10**(decimals-3));
574   uint256 public constant MAXIMUM_ETHER_SPEND = 300 * 10**decimals;
575 
576   //real
577   //uint256 public constant MINIMUM_ETHER_SPEND = (250 * 10**(decimals-3));
578   //uint256 public constant MAXIMUM_ETHER_SPEND = 300 * 10**decimals;
579 
580 
581   modifier canMint() 
582   {
583     require(!mintingFinished);
584     _;
585   }
586   
587   function allocateVestable(address target, uint256 amount, uint256 vestdays, uint256 vestingdate) public onlyOwner
588   {
589       //require(msg.sender==CONTRACT_CREATOR, "You are not authorised to create vestable token users");
590       // check if we have permission to get in here
591       //checksigning();
592       
593       // prevent anyone except contract signatories from creating their own vestable
594       
595       // essentially set up a final vesting date
596       uint256 vestingAmount = amount * 10**decimals;
597     
598       // set up the vesting params
599       mCanSpend[target]=2;
600       mVestingBalance[target] = vestingAmount;
601       mVestingDays[target] = vestdays;
602       mVestingBegins[target] = vestingdate;
603       mVestingSpent[target] = 0;
604       
605       // load the balance of the actual token fund
606       balances[target] = vestingAmount;
607       
608       // if the tokensale is finalised then use the crowdsale fund which SHOULD be empty.
609       // this means we can create new vesting tokens if necessary but only if crowdsale fund has been preload with MEW using multisig wallet
610       if (mCanPurchase==0)
611       {
612         require(vestingAmount <= balances[MEW_CROWDSALE_FUND]);//, "Not enough MEW to allocate vesting post crowdsale");
613         balances[MEW_CROWDSALE_FUND] = balances[MEW_CROWDSALE_FUND].sub(vestingAmount); 
614         // log transfer
615         emit Transfer(MEW_CROWDSALE_FUND, target, vestingAmount);
616       }
617       else
618       {
619         // deduct tokens from reserve before crowdsale
620         require(vestingAmount <= balances[MEW_RESERVE_FUND]);//, "Not enough MEW to allocate vesting during setup");
621         balances[MEW_RESERVE_FUND] = balances[MEW_RESERVE_FUND].sub(vestingAmount);
622         // log transfer
623         emit Transfer(MEW_RESERVE_FUND, target, vestingAmount);
624       }
625   }
626   
627   function SetAuxOwner(address aux) onlyOwner public
628   {
629       require(auxOwner == 0);//, "Cannot replace aux owner once it has been set");
630       // sets the auxilliary owner as the contract owns this address not the creator
631       auxOwner = aux;
632   }
633  
634   function Purchase(address _to, uint256 _ether, uint256 _amount, uint256 exchange) onlyOwner public returns (bool) 
635   {
636     require(mCanSpend[_to]==0); // cannot purchase to a validated or vesting wallet (probably works but more debug checks)
637     require(mSetupCrowd==1);//, "Only purchase during crowdsale");
638     require(mCanPurchase==1);//,"Can only purchase during a sale");
639       
640     require( _amount >= MINIMUM_ETHER_SPEND * exchange);//, "Must spend at least minimum ether");
641     require( (_amount+balances[_to]) <= MAXIMUM_ETHER_SPEND * exchange);//, "Must not spend more than maximum ether");
642    
643     // bail if we're out of tokens (will be amazing if this happens but hey!)
644     if (balances[MEW_CROWDSALE_FUND]<_amount)
645     {
646          return false;
647     }
648 
649     // lock the tokens for AML - early to prevent transact hack
650     mCanSpend[_to] = 0;
651     
652     // add these ether to the invalid count unless checked
653     if (mCanSpend[_to]==0)
654     {
655         mEtherInvalid = mEtherInvalid + int256(_ether);
656     }
657     else
658     {
659         // valid AML checked ether
660         mEtherValid = mEtherValid + int256(_ether);
661     }
662     
663     // store how much ether was spent
664     mEtherSpent[_to] = _ether;
665       
666     // broken up to prevent recursive spend hacks (safemath probably does but just in case)
667     uint256 newBalance = balances[_to].add(_amount);
668     uint256 newCrowdBalance = balances[MEW_CROWDSALE_FUND].sub(_amount);
669     
670     balances[_to]=0;
671     balances[MEW_CROWDSALE_FUND] = 0;
672       
673     // add in to personal fund
674     balances[_to] = newBalance;
675     balances[MEW_CROWDSALE_FUND] = newCrowdBalance;
676    
677     emit Transfer(MEW_CROWDSALE_FUND, _to, _amount);
678     
679     return true;
680   }
681   
682   function Unlock_Tokens(address target) public onlyOwner
683   {
684       
685       require(mCanSpend[target]==0);//,"Unlocking would fail");
686       
687       // unlocks locked tokens - must be called on every token wallet after AML check
688       //unlocktokens(target);
689       
690       mCanSpend[target]=1;
691       
692       
693     // get how much ether this person spent on their tokens
694     uint256 etherToken = mEtherSpent[target];
695     
696     // if this is called the ether are now valid and can be spent
697     mEtherInvalid = mEtherInvalid - int256(etherToken);
698     mEtherValid = mEtherValid + int256(etherToken);
699     
700   }
701   
702   
703   function Revoke(address target) public onlyOwner
704   {
705       // revokes tokens and returns to the reserve
706       // designed to be used for refunds or to try to reverse theft via phishing etc
707       RevokeTokens(target);
708   }
709   
710   function BlockRefunded(address target) public onlyOwner
711   {
712       require(mCanSpend[target]!=8);
713       // clear the spent ether
714       //mEtherSpent[target]=0;
715       
716       // refund marker
717       mCanSpend[target]=8;
718       
719       // does not refund just blocks account from being used for tokens ever again
720       mEtherInvalid = mEtherInvalid-int256(mEtherSpent[target]);
721   }
722   
723   function SetupReserve(address multiSig) public onlyOwner
724   {
725       require(mSetupReserve==0);//, "Reserve has already been initialised");
726       require(multiSig>0);//, "Wallet is not valid");
727       
728       // address the mew reserve fund as the multisig wallet
729       //MEW_RESERVE_FUND = multiSig;
730       
731       // create the reserve
732       mint(MEW_RESERVE_FUND, TOTAL_RESERVE_FUND);
733      
734        // vesting allocates from the reserve fund
735       allocateVestable(FOUNDER_ADDRESS1, 9000000000, 365, PRIME_VESTING_DATE);
736       allocateVestable(FOUNDER_ADDRESS2, 9000000000, 365, PRIME_VESTING_DATE);
737       allocateVestable(FOUNDER_ADDRESS3, 7000000000, 365, PRIME_VESTING_DATE);
738   }
739   
740   function SetupCrowdSale() public onlyOwner
741   {
742       require(mSetupCrowd==0);//, "Crowdsale has already been initalised");
743       // create the reserve
744       mint(MEW_CROWDSALE_FUND, TOTAL_CROWDSALE_FUND);
745       
746       // crowd initialised
747       mSetupCrowd=1;
748   }
749   
750   function CloseSaleFund() public onlyOwner
751   {
752       uint256 remainingFund;
753       
754       remainingFund = balances[MEW_CROWDSALE_FUND];
755       
756       balances[MEW_CROWDSALE_FUND] = 0;
757       
758       balances[MEW_RESERVE_FUND] = balances[MEW_RESERVE_FUND].add(remainingFund);
759       
760       // notify the network
761       emit Transfer(MEW_CROWDSALE_FUND, MEW_RESERVE_FUND, remainingFund);
762       
763       // set up the prime vesting date - ie immediate
764       // set up the aml date
765       PRIME_VESTING_DATE = block.timestamp;
766       FINAL_AML_DATE = PRIME_VESTING_DATE + FINAL_AML_DAYS*DAYSECONDS;
767       
768       // update vesting date (sale end)
769       mVestingBegins[FOUNDER_ADDRESS1]=PRIME_VESTING_DATE;
770       mVestingBegins[FOUNDER_ADDRESS2]=PRIME_VESTING_DATE;
771       mVestingBegins[FOUNDER_ADDRESS3]=PRIME_VESTING_DATE;
772       
773       // block further token purchasing (forever)
774       mCanPurchase = 0;
775   }
776   
777   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) 
778   {
779     totalSupply = totalSupply.add(_amount);
780     balances[_to] = balances[_to].add(_amount);
781     
782     // allow this minted money to be spent immediately
783     mCanSpend[_to] = 1;
784     
785     emit Mint(_to, _amount);
786     emit Transfer(0x0, _to, _amount);
787     return true;
788   }
789 
790   /**
791    * @dev Function to stop minting new tokens.
792    * @return True if the operation was successful.
793    */
794   function finishMinting() onlyOwner public returns (bool) 
795   {
796     mintingFinished = true;
797     emit MintFinished();
798     return true;
799   }
800 }
801 
802 
803 contract MEWcoin is MintableToken 
804 {
805     string public constant name = "MEWcoin (Official vFloorplan Ltd 30/07/18)";
806     string public constant symbol = "MEW";
807     string public version = "1.0";
808 }