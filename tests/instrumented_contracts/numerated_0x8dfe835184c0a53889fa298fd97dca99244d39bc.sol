1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   
13   event Transfer(address indexed _from, address indexed _to, uint _value);
14   //event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances. 
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of. 
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) public constant returns (uint256);
101   function transferFrom(address from, address to, uint256 value) public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   
104   event Approval(address indexed _owner, address indexed _spender, uint _value);
105   //event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * @dev https://github.com/ethereum/EIPs/issues/20
113  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amout of tokens to be transfered
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     var _allowance = allowed[_from][msg.sender];
128 
129     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
130     // require (_value <= _allowance);
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     //balances[_from] = balances[_from].sub(_value); // this was removed
135     allowed[_from][msg.sender] = _allowance.sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146 
147     // To change the approve amount you first have to reduce the addresses`
148     //  allowance to zero by calling `approve(_spender, 0)` if it is not
149     //  already 0 to mitigate the race condition described here:
150     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
152 
153     allowed[msg.sender][_spender] = _value;
154     Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifing the amount of tokens still avaible for the spender.
163    */
164   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
165     return allowed[_owner][_spender];
166   }
167 
168 }
169 
170 /**
171  * @title Ownable
172  * @dev The Ownable contract has an owner address, and provides basic authorization control
173  * functions, this simplifies the implementation of "user permissions".
174  */
175 contract Ownable {
176   address public owner;
177 
178 
179   /**
180    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
181    * account.
182    */
183   function Ownable() public {
184     owner = msg.sender;
185   }
186 
187 
188   /**
189    * @dev Throws if called by any account other than the owner.
190    */
191   modifier onlyOwner() {
192     require(msg.sender == owner);
193     _;
194   }
195 
196 
197   /**
198    * @dev Allows the current owner to transfer control of the contract to a newOwner.
199    * @param newOwner The address to transfer ownership to.
200    */
201   function transferOwnership(address newOwner) public onlyOwner {
202     if (newOwner != address(0)) {
203       owner = newOwner;
204     }
205   }
206 
207 }
208 
209 contract BigbomPrivateSaleList is Ownable {
210     mapping(address=>uint) public addressCap;
211 
212     function BigbomPrivateSaleList() public  {}
213 
214     event ListAddress( address _user, uint _amount, uint _time );
215 
216     // Owner can delist by setting amount = 0.
217     // Onwer can also change it at any time
218     function listAddress( address _user, uint _amount ) public onlyOwner {
219         require(_user != address(0x0));
220 
221         addressCap[_user] = _amount;
222         ListAddress( _user, _amount, now );
223     }
224 
225     // an optimization in case of network congestion
226     function listAddresses( address[] _users, uint[] _amount ) public onlyOwner {
227         require(_users.length == _amount.length );
228         for( uint i = 0 ; i < _users.length ; i++ ) {
229             listAddress( _users[i], _amount[i] );
230         }
231     }
232 
233     function getCap( address _user ) public constant returns(uint) {
234         return addressCap[_user];
235     }
236 
237 }
238 
239 contract BigbomToken is StandardToken, Ownable {
240     
241     string  public  constant name = "Bigbom";
242     string  public  constant symbol = "BBO";
243     uint    public  constant decimals = 18;
244     uint    public   totalSupply = 2000000000 * 1e18; //2,000,000,000
245 
246     uint    public  constant founderAmount = 200000000 * 1e18; // 200,000,000
247     uint    public  constant coreStaffAmount = 60000000 * 1e18; // 60,000,000
248     uint    public  constant advisorAmount = 140000000 * 1e18; // 140,000,000
249     uint    public  constant networkGrowthAmount = 600000000 * 1e18; //600,000,000
250     uint    public  constant reserveAmount = 635000000 * 1e18; // 635,000,000
251     uint    public  constant bountyAmount = 40000000 * 1e18; // 40,000,000
252     uint    public  constant publicSaleAmount = 275000000 * 1e18; // 275,000,000
253 
254     address public   bbFounderCoreStaffWallet ;
255     address public   bbAdvisorWallet;
256     address public   bbAirdropWallet;
257     address public   bbNetworkGrowthWallet;
258     address public   bbReserveWallet;
259     address public   bbPublicSaleWallet;
260 
261     uint    public  saleStartTime;
262     uint    public  saleEndTime;
263 
264     address public  tokenSaleContract;
265     BigbomPrivateSaleList public privateSaleList;
266 
267     mapping (address => bool) public frozenAccount;
268     mapping (address => uint) public frozenTime;
269     mapping (address => uint) public maxAllowedAmount;
270 
271     /* This generates a public event on the blockchain that will notify clients */
272     event FrozenFunds(address target, bool frozen, uint _seconds);
273    
274 
275     function checkMaxAllowed(address target)  public constant  returns (uint) {
276         var maxAmount  = balances[target];
277         if(target == bbFounderCoreStaffWallet){
278             maxAmount = 10000000 * 1e18;
279         }
280         if(target == bbAdvisorWallet){
281             maxAmount = 10000000 * 1e18;
282         }
283         if(target == bbAirdropWallet){
284             maxAmount = 40000000 * 1e18;
285         }
286         if(target == bbNetworkGrowthWallet){
287             maxAmount = 20000000 * 1e18;
288         }
289         if(target == bbReserveWallet){
290             maxAmount = 6350000 * 1e18;
291         }
292         return maxAmount;
293     }
294 
295     function selfFreeze(bool freeze, uint _seconds) public {
296         // selfFreeze cannot more than 7 days
297         require(_seconds <= 7 * 24 * 3600);
298         // if unfreeze
299         if(!freeze){
300             // get End time of frozenAccount
301             var frozenEndTime = frozenTime[msg.sender];
302             // if now > frozenEndTime
303             require (now >= frozenEndTime);
304             // unfreeze account
305             frozenAccount[msg.sender] = freeze;
306             // set time to 0
307             _seconds = 0;           
308         }else{
309             frozenAccount[msg.sender] = freeze;
310             
311         }
312         // set endTime = now + _seconds to freeze
313         frozenTime[msg.sender] = now + _seconds;
314         FrozenFunds(msg.sender, freeze, _seconds);
315         
316     }
317 
318     function freezeAccount(address target, bool freeze, uint _seconds) onlyOwner public {
319         
320         // if unfreeze
321         if(!freeze){
322             // get End time of frozenAccount
323             var frozenEndTime = frozenTime[target];
324             // if now > frozenEndTime
325             require (now >= frozenEndTime);
326             // unfreeze account
327             frozenAccount[target] = freeze;
328             // set time to 0
329             _seconds = 0;           
330         }else{
331             frozenAccount[target] = freeze;
332             
333         }
334         // set endTime = now + _seconds to freeze
335         frozenTime[target] = now + _seconds;
336         FrozenFunds(target, freeze, _seconds);
337         
338     }
339 
340     modifier validDestination( address to ) {
341         require(to != address(0x0));
342         require(to != address(this) );
343         require(!frozenAccount[to]);                       // Check if recipient is frozen
344         _;
345     }
346     modifier validFrom(address from){
347         require(!frozenAccount[from]);                     // Check if sender is frozen
348         _;
349     }
350     modifier onlyWhenTransferEnabled() {
351         if( now <= saleEndTime && now >= saleStartTime ) {
352             require( msg.sender == tokenSaleContract );
353         }
354         _;
355     }
356     modifier onlyPrivateListEnabled(address _to){
357         require(now <= saleStartTime);
358         uint allowcap = privateSaleList.getCap(_to);
359         require (allowcap > 0);
360         _;
361     }
362     function setPrivateList(BigbomPrivateSaleList _privateSaleList)   onlyOwner public {
363         require(_privateSaleList != address(0x0));
364         privateSaleList = _privateSaleList;
365 
366     }
367     
368     function BigbomToken(uint startTime, uint endTime, address admin, address _bbFounderCoreStaffWallet, address _bbAdvisorWallet,
369         address _bbAirdropWallet,
370         address _bbNetworkGrowthWallet,
371         address _bbReserveWallet, 
372         address _bbPublicSaleWallet
373         ) public {
374 
375         require(admin!=address(0x0));
376         require(_bbAirdropWallet!=address(0x0));
377         require(_bbAdvisorWallet!=address(0x0));
378         require(_bbReserveWallet!=address(0x0));
379         require(_bbNetworkGrowthWallet!=address(0x0));
380         require(_bbFounderCoreStaffWallet!=address(0x0));
381         require(_bbPublicSaleWallet!=address(0x0));
382 
383         // Mint all tokens. Then disable minting forever.
384         balances[msg.sender] = totalSupply;
385         Transfer(address(0x0), msg.sender, totalSupply);
386         // init internal amount limit
387         // set address when deploy
388         bbAirdropWallet = _bbAirdropWallet;
389         bbAdvisorWallet = _bbAdvisorWallet;
390         bbReserveWallet = _bbReserveWallet;
391         bbNetworkGrowthWallet = _bbNetworkGrowthWallet;
392         bbFounderCoreStaffWallet = _bbFounderCoreStaffWallet;
393         bbPublicSaleWallet = _bbPublicSaleWallet;
394         
395         saleStartTime = startTime;
396         saleEndTime = endTime;
397         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
398     }
399 
400     function setTimeSale(uint startTime, uint endTime) onlyOwner public {
401         require (now < saleStartTime || now > saleEndTime);
402         require (now < startTime);
403         require ( startTime < endTime);
404         saleStartTime = startTime;
405         saleEndTime = endTime;
406     }
407 
408     function setTokenSaleContract(address _tokenSaleContract) onlyOwner public {
409         // check address ! 0
410         require(_tokenSaleContract != address(0x0));
411         // do not allow run when saleStartTime <= now <= saleEndTime
412         require (now < saleStartTime || now > saleEndTime);
413 
414         tokenSaleContract = _tokenSaleContract;
415     }
416     function transfer(address _to, uint _value)
417         onlyWhenTransferEnabled
418         validDestination(_to)
419         validFrom(msg.sender)
420         public 
421         returns (bool) {
422         if (msg.sender == bbFounderCoreStaffWallet || msg.sender == bbAdvisorWallet|| 
423             msg.sender == bbAirdropWallet|| msg.sender == bbNetworkGrowthWallet|| msg.sender == bbReserveWallet){
424 
425             // check maxAllowedAmount
426             var withdrawAmount =  maxAllowedAmount[msg.sender]; 
427             var defaultAllowAmount = checkMaxAllowed(msg.sender);
428             var maxAmount = defaultAllowAmount - withdrawAmount;
429             // _value transfer must <= maxAmount
430             require(maxAmount >= _value); // 
431 
432             // if maxAmount = 0, need to block this msg.sender
433             if(maxAmount==_value){
434                
435                 var isTransfer = super.transfer(_to, _value);
436                  // freeze account
437                 selfFreeze(true, 24 * 3600); // temp freeze account 24h
438                 maxAllowedAmount[msg.sender] = 0;
439                 return isTransfer;
440             }else{
441                 // set max withdrawAmount
442                 maxAllowedAmount[msg.sender] = maxAllowedAmount[msg.sender].add(_value); // 
443                 
444             }
445         }
446         return  super.transfer(_to, _value);
447             
448     }
449 
450     function transferPrivateSale(address _to, uint _value)
451         onlyOwner
452         onlyPrivateListEnabled(_to) 
453         public 
454         returns (bool) {
455          return transfer( _to,  _value);
456     }
457 
458     function transferFrom(address _from, address _to, uint _value)
459         onlyWhenTransferEnabled
460         validDestination(_to)
461         validFrom(_from)
462         public 
463         returns (bool) {
464             if (_from == bbFounderCoreStaffWallet || _from == bbAdvisorWallet|| 
465                 _from == bbAirdropWallet|| _from == bbNetworkGrowthWallet|| _from == bbReserveWallet){
466 
467                   // check maxAllowedAmount
468                 var withdrawAmount =  maxAllowedAmount[_from]; 
469                 var defaultAllowAmount = checkMaxAllowed(_from);
470                 var maxAmount = defaultAllowAmount - withdrawAmount; 
471                 // _value transfer must <= maxAmount
472                 require(maxAmount >= _value); 
473 
474                 // if maxAmount = 0, need to block this _from
475                 if(maxAmount==_value){
476                    
477                     var isTransfer = super.transfer(_to, _value);
478                      // freeze account
479                     selfFreeze(true, 24 * 3600); 
480                     maxAllowedAmount[_from] = 0;
481                     return isTransfer;
482                 }else{
483                     // set max withdrawAmount
484                     maxAllowedAmount[_from] = maxAllowedAmount[_from].add(_value); 
485                     
486                 }
487             }
488             return super.transferFrom(_from, _to, _value);
489     }
490 
491     event Burn(address indexed _burner, uint _value);
492 
493     function burn(uint _value) onlyWhenTransferEnabled
494         public 
495         returns (bool){
496         balances[msg.sender] = balances[msg.sender].sub(_value);
497         totalSupply = totalSupply.sub(_value);
498         Burn(msg.sender, _value);
499         Transfer(msg.sender, address(0x0), _value);
500         return true;
501     }
502 
503     // save some gas by making only one contract call
504     function burnFrom(address _from, uint256 _value) onlyWhenTransferEnabled
505         public 
506         returns (bool) {
507         assert( transferFrom( _from, msg.sender, _value ) );
508         return burn(_value);
509     }
510 
511     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
512         token.transfer( owner, amount );
513     }
514 }
515 
516 contract BigbomTokenExtended is BigbomToken {
517     BigbomToken public  bigbomToken;
518     function BigbomTokenExtended(uint startTime, uint endTime, address admin, address _bbFounderCoreStaffWallet, address _bbAdvisorWallet,
519         address _bbAirdropWallet,
520         address _bbNetworkGrowthWallet,
521         address _bbReserveWallet, 
522         address _bbPublicSaleWallet,
523         BigbomToken _bigbomToken
524         ) public BigbomToken(startTime, endTime, admin, _bbFounderCoreStaffWallet, _bbAdvisorWallet,
525          _bbAirdropWallet,
526          _bbNetworkGrowthWallet,
527          _bbReserveWallet, 
528          _bbPublicSaleWallet
529         ){
530             bigbomToken = _bigbomToken;
531     }
532         
533     
534     event TokenDrop( address receiver, uint amount );
535     function airDrop(address[] recipients) public onlyOwner {
536         for(uint i = 0 ; i < recipients.length ; i++){
537             uint amount = bigbomToken.balanceOf(recipients[i]);
538             if (amount > 0){
539                 //
540                 transfer(recipients[i], amount);
541                 TokenDrop( recipients[i], amount );
542             }
543         }
544     }
545 
546     modifier validFrozenAccount(address target) {
547         if(frozenAccount[target]){
548             require(now >= frozenTime[target]);
549         }
550         _;
551     }
552 
553     function selfFreeze(bool freeze, uint _seconds) 
554     validFrozenAccount(msg.sender) 
555     public {
556         // selfFreeze cannot more than 7 days
557         require(_seconds <= 7 * 24 * 3600);
558         // if unfreeze
559         if(!freeze){
560             // get End time of frozenAccount
561             var frozenEndTime = frozenTime[msg.sender];
562             // if now > frozenEndTime
563             require (now >= frozenEndTime);
564             // unfreeze account
565             frozenAccount[msg.sender] = freeze;
566             // set time to 0
567             _seconds = 0;           
568         }else{
569             frozenAccount[msg.sender] = freeze;
570             
571         }
572         // set endTime = now + _seconds to freeze
573         frozenTime[msg.sender] = now + _seconds;
574         FrozenFunds(msg.sender, freeze, _seconds);
575         
576     }
577 
578     function freezeAccount(address target, bool freeze, uint _seconds) 
579     onlyOwner
580     validFrozenAccount(target)
581     public {
582         
583         // if unfreeze
584         if(!freeze){
585             // get End time of frozenAccount
586             var frozenEndTime = frozenTime[target];
587             // if now > frozenEndTime
588             require (now >= frozenEndTime);
589             // unfreeze account
590             frozenAccount[target] = freeze;
591             // set time to 0
592             _seconds = 0;           
593         }else{
594             frozenAccount[target] = freeze;
595             
596         }
597         // set endTime = now + _seconds to freeze
598         frozenTime[target] = now + _seconds;
599         FrozenFunds(target, freeze, _seconds);
600         
601     }
602 
603     
604 }
605 
606 contract BigbomContributorWhiteList is Ownable {
607     mapping(address=>uint) public addressMinCap;
608     mapping(address=>uint) public addressMaxCap;
609 
610     function BigbomContributorWhiteList() public  {}
611 
612     event ListAddress( address _user, uint _mincap, uint _maxcap, uint _time );
613 
614     // Owner can delist by setting cap = 0.
615     // Onwer can also change it at any time
616     function listAddress( address _user, uint _mincap, uint _maxcap ) public onlyOwner {
617         require(_mincap <= _maxcap);
618         require(_user != address(0x0));
619 
620         addressMinCap[_user] = _mincap;
621         addressMaxCap[_user] = _maxcap;
622         ListAddress( _user, _mincap, _maxcap, now );
623     }
624 
625     // an optimization in case of network congestion
626     function listAddresses( address[] _users, uint[] _mincap, uint[] _maxcap ) public  onlyOwner {
627         require(_users.length == _mincap.length );
628         require(_users.length == _maxcap.length );
629         for( uint i = 0 ; i < _users.length ; i++ ) {
630             listAddress( _users[i], _mincap[i], _maxcap[i] );
631         }
632     }
633 
634     function getMinCap( address _user ) public constant returns(uint) {
635         return addressMinCap[_user];
636     }
637     function getMaxCap( address _user ) public constant returns(uint) {
638         return addressMaxCap[_user];
639     }
640 
641 }
642 
643 contract BigbomCrowdSale{
644     address             public admin;
645     address             public bigbomMultiSigWallet;
646     BigbomTokenExtended         public token;
647     uint                public raisedWei;
648     bool                public haltSale;
649     uint                public openSaleStartTime;
650     uint                public openSaleEndTime;
651     
652     uint                public minGasPrice;
653     uint                public maxGasPrice;
654 
655     BigbomContributorWhiteList public list;
656 
657     mapping(address=>uint)    public participated;
658     mapping(string=>uint)     depositTxMap;
659     mapping(string=>uint)     erc20Rate;
660 
661     using SafeMath for uint;
662 
663     function BigbomCrowdSale( address _admin,
664                               address _bigbomMultiSigWallet,
665                               BigbomContributorWhiteList _whilteListContract,
666                               uint _publicSaleStartTime,
667                               uint _publicSaleEndTime,
668                               BigbomTokenExtended _token) public       
669     {
670         require (_publicSaleStartTime < _publicSaleEndTime);
671         require (_admin != address(0x0));
672         require (_bigbomMultiSigWallet != address(0x0));
673         require (_whilteListContract != address(0x0));
674         require (_token != address(0x0));
675 
676         admin = _admin;
677         bigbomMultiSigWallet = _bigbomMultiSigWallet;
678         list = _whilteListContract;
679         openSaleStartTime = _publicSaleStartTime;
680         openSaleEndTime = _publicSaleEndTime;
681         token = _token;
682     }
683     
684     function saleEnded() public constant returns(bool) {
685         return now > openSaleEndTime;
686     }
687 
688     function setMinGasPrice(uint price) public {
689         require (msg.sender == admin);
690         minGasPrice = price;
691     }
692     function setMaxGasPrice(uint price) public {
693         require (msg.sender == admin);
694         maxGasPrice = price;
695     }
696 
697     function saleStarted() public constant returns(bool) {
698         return now >= openSaleStartTime;
699     }
700 
701     function setHaltSale( bool halt ) public {
702         require( msg.sender == admin );
703         haltSale = halt;
704     }
705     // this is a seperate function so user could query it before crowdsale starts
706     function contributorMinCap( address contributor ) public constant returns(uint) {
707         return list.getMinCap( contributor );
708     }
709     function contributorMaxCap( address contributor, uint amountInWei ) public constant returns(uint) {
710         uint cap = list.getMaxCap( contributor );
711         if( cap == 0 ) return 0;
712         uint remainedCap = cap.sub( participated[ contributor ] );
713         if( remainedCap > amountInWei ) return amountInWei;
714         else return remainedCap;
715     }
716 
717     function checkMaxCap( address contributor, uint amountInWei ) internal returns(uint) {
718         if( now > ( openSaleStartTime + 2 * 24 * 3600))
719             return 100e18;
720         else{
721             uint result = contributorMaxCap( contributor, amountInWei );
722             participated[contributor] = participated[contributor].add( result );
723             return result;
724         }
725         
726     }
727 
728     function() payable public {
729         buy( msg.sender );
730     }
731 
732 
733 
734     function getBonus(uint _tokens) public pure returns (uint){
735         return _tokens.mul(10).div(100);
736     }
737 
738     event Buy( address _buyer, uint _tokens, uint _payedWei, uint _bonus );
739     function buy( address recipient ) payable public returns(uint){
740         require( tx.gasprice <= maxGasPrice );
741         require( tx.gasprice >= minGasPrice );
742 
743         require( ! haltSale );
744         require( saleStarted() );
745         require( ! saleEnded() );
746 
747         uint mincap = contributorMinCap(recipient);
748 
749         uint maxcap = checkMaxCap(recipient, msg.value );
750         uint allowValue = msg.value;
751         require( mincap > 0 );
752 
753         require( maxcap > 0 );
754         // fail if msg.value < mincap
755         require (msg.value >= mincap);
756         // send to msg.sender, not to recipient if value > maxcap
757         if(now <= openSaleStartTime + 2 * 24 * 3600) {
758             if( msg.value > maxcap ) {
759                 allowValue = maxcap;
760                 //require (allowValue >= mincap);
761                 msg.sender.transfer( msg.value.sub( maxcap ) );
762             }
763         }
764        
765 
766         // send payment to wallet
767         sendETHToMultiSig(allowValue);
768         raisedWei = raisedWei.add( allowValue );
769         // 1ETH = 20000 BBO
770         uint recievedTokens = allowValue.mul( 20000 );
771         // TODO bounce
772         uint bonus = getBonus(recievedTokens);
773         
774         recievedTokens = recievedTokens.add(bonus);
775         assert( token.transfer( recipient, recievedTokens ) );
776         //
777 
778         Buy( recipient, recievedTokens, allowValue, bonus );
779 
780         return msg.value;
781     }
782 
783     function sendETHToMultiSig( uint value ) internal {
784         bigbomMultiSigWallet.transfer( value );
785     }
786 
787     event FinalizeSale();
788     // function is callable by everyone
789     function finalizeSale() public {
790         require( saleEnded() );
791         //require( msg.sender == admin );
792 
793         // burn remaining tokens
794         token.burn(token.balanceOf(this));
795 
796         FinalizeSale();
797     }
798 
799     // ETH balance is always expected to be 0.
800     // but in case something went wrong, we use this function to extract the eth.
801     function emergencyDrain(ERC20 anyToken) public returns(bool){
802         require( msg.sender == admin );
803         require( saleEnded() );
804 
805         if( this.balance > 0 ) {
806             sendETHToMultiSig( this.balance );
807         }
808 
809         if( anyToken != address(0x0) ) {
810             assert( anyToken.transfer(bigbomMultiSigWallet, anyToken.balanceOf(this)) );
811         }
812 
813         return true;
814     }
815 
816     // just to check that funds goes to the right place
817     // tokens are not given in return
818     function debugBuy() payable public {
819         require( msg.value > 0 );
820         sendETHToMultiSig( msg.value );
821     }
822 
823     function getErc20Rate(string erc20Name) public constant returns(uint){
824         return erc20Rate[erc20Name];
825     }
826 
827     function setErc20Rate(string erc20Name, uint rate) public{
828         require (msg.sender == admin);
829         erc20Rate[erc20Name] = rate;
830     }
831 
832     function getDepositTxMap(string _tx) public constant returns(uint){
833         return depositTxMap[_tx];
834     }
835     event Erc20Buy( address _buyer, uint _tokens, uint _payedWei, uint _bonus, string depositTx );
836 
837     event Erc20Refund( address _buyer, uint _erc20RefundAmount, string _erc20Name );
838     function erc20Buy( address recipient, uint erc20Amount, string erc20Name, string depositTx )  public returns(uint){
839         require (msg.sender == admin);
840         //require( tx.gasprice <= 50000000000 wei );
841 
842         require( ! haltSale );
843         require( saleStarted() );
844         require( ! saleEnded() );
845         uint ethAmount = getErc20Rate(erc20Name) * erc20Amount / 1e18;
846         uint mincap = contributorMinCap(recipient);
847 
848         uint maxcap = checkMaxCap(recipient, ethAmount );
849         require (getDepositTxMap(depositTx) == 0);
850         require (ethAmount > 0);
851         uint allowValue = ethAmount;
852         require( mincap > 0 );
853         require( maxcap > 0 );
854         // fail if msg.value < mincap
855         require (ethAmount >= mincap);
856         // send to msg.sender, not to recipient if value > maxcap
857         if(now <= openSaleStartTime + 2 * 24 * 3600) {
858             if( ethAmount > maxcap  ) {
859                 allowValue = maxcap;
860                 //require (allowValue >= mincap);
861                 // send event refund
862                 // msg.sender.transfer( ethAmount.sub( maxcap ) );
863                 uint erc20RefundAmount = ethAmount.sub( maxcap ).mul(1e18).div(getErc20Rate(erc20Name));
864                 Erc20Refund(recipient, erc20RefundAmount, erc20Name);
865             }
866         }
867 
868         raisedWei = raisedWei.add( allowValue );
869         // 1ETH = 20000 BBO
870         uint recievedTokens = allowValue.mul( 20000 );
871         // TODO bounce
872         uint bonus = getBonus(recievedTokens);
873         
874         recievedTokens = recievedTokens.add(bonus);
875         assert( token.transfer( recipient, recievedTokens ) );
876         // set tx
877         depositTxMap[depositTx] = ethAmount;
878         //
879 
880         Erc20Buy( recipient, recievedTokens, allowValue, bonus, depositTx);
881 
882         return allowValue;
883     }
884 
885 }