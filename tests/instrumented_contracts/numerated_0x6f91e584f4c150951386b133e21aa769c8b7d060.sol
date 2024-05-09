1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   uint256 public totalSupply;
54   function balanceOf(address who) public constant returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   
57   event Transfer(address indexed _from, address indexed _to, uint _value);
58   //event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public constant returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   
71   event Approval(address indexed _owner, address indexed _spender, uint _value);
72   //event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances. 
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of. 
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public constant returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119 
120   mapping (address => mapping (address => uint256)) allowed;
121 
122 
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint256 the amout of tokens to be transfered
128    */
129   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130     var _allowance = allowed[_from][msg.sender];
131 
132     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
133     // require (_value <= _allowance);
134 
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     //balances[_from] = balances[_from].sub(_value); // this was removed
138     allowed[_from][msg.sender] = _allowance.sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149 
150     // To change the approve amount you first have to reduce the addresses`
151     //  allowance to zero by calling `approve(_spender, 0)` if it is not
152     //  already 0 to mitigate the race condition described here:
153     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
155 
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifing the amount of tokens still avaible for the spender.
166    */
167   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
168     return allowed[_owner][_spender];
169   }
170 
171 }
172 
173 
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180   address public owner;
181 
182 
183   /**
184    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
185    * account.
186    */
187   function Ownable() public {
188     owner = msg.sender;
189   }
190 
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     require(msg.sender == owner);
197     _;
198   }
199 
200 
201   /**
202    * @dev Allows the current owner to transfer control of the contract to a newOwner.
203    * @param newOwner The address to transfer ownership to.
204    */
205   function transferOwnership(address newOwner) public onlyOwner {
206     if (newOwner != address(0)) {
207       owner = newOwner;
208     }
209   }
210 
211 }
212 
213 contract BigbomContributorWhiteList is Ownable {
214     mapping(address=>uint) public addressMinCap;
215     mapping(address=>uint) public addressMaxCap;
216 
217     function BigbomContributorWhiteList() public  {}
218 
219     event ListAddress( address _user, uint _mincap, uint _maxcap, uint _time );
220 
221     // Owner can delist by setting cap = 0.
222     // Onwer can also change it at any time
223     function listAddress( address _user, uint _mincap, uint _maxcap ) public onlyOwner {
224         require(_mincap <= _maxcap);
225         require(_user != address(0x0));
226 
227         addressMinCap[_user] = _mincap;
228         addressMaxCap[_user] = _maxcap;
229         ListAddress( _user, _mincap, _maxcap, now );
230     }
231 
232     // an optimization in case of network congestion
233     function listAddresses( address[] _users, uint[] _mincap, uint[] _maxcap ) public  onlyOwner {
234         require(_users.length == _mincap.length );
235         require(_users.length == _maxcap.length );
236         for( uint i = 0 ; i < _users.length ; i++ ) {
237             listAddress( _users[i], _mincap[i], _maxcap[i] );
238         }
239     }
240 
241     function getMinCap( address _user ) public constant returns(uint) {
242         return addressMinCap[_user];
243     }
244     function getMaxCap( address _user ) public constant returns(uint) {
245         return addressMaxCap[_user];
246     }
247 
248 }
249 
250 contract BigbomPrivateSaleList is Ownable {
251     mapping(address=>uint) public addressCap;
252 
253     function BigbomPrivateSaleList() public  {}
254 
255     event ListAddress( address _user, uint _amount, uint _time );
256 
257     // Owner can delist by setting amount = 0.
258     // Onwer can also change it at any time
259     function listAddress( address _user, uint _amount ) public onlyOwner {
260         require(_user != address(0x0));
261 
262         addressCap[_user] = _amount;
263         ListAddress( _user, _amount, now );
264     }
265 
266     // an optimization in case of network congestion
267     function listAddresses( address[] _users, uint[] _amount ) public onlyOwner {
268         require(_users.length == _amount.length );
269         for( uint i = 0 ; i < _users.length ; i++ ) {
270             listAddress( _users[i], _amount[i] );
271         }
272     }
273 
274     function getCap( address _user ) public constant returns(uint) {
275         return addressCap[_user];
276     }
277 
278 }
279 
280 contract BigbomToken is StandardToken, Ownable {
281     
282     string  public  constant name = "Bigbom";
283     string  public  constant symbol = "BBO";
284     uint    public  constant decimals = 18;
285     uint    public   totalSupply = 2000000000 * 1e18; //2,000,000,000
286 
287     uint    public  constant founderAmount = 200000000 * 1e18; // 200,000,000
288     uint    public  constant coreStaffAmount = 60000000 * 1e18; // 60,000,000
289     uint    public  constant advisorAmount = 140000000 * 1e18; // 140,000,000
290     uint    public  constant networkGrowthAmount = 600000000 * 1e18; //600,000,000
291     uint    public  constant reserveAmount = 635000000 * 1e18; // 635,000,000
292     uint    public  constant bountyAmount = 40000000 * 1e18; // 40,000,000
293     uint    public  constant publicSaleAmount = 275000000 * 1e18; // 275,000,000
294 
295     address public   bbFounderCoreStaffWallet ;
296     address public   bbAdvisorWallet;
297     address public   bbAirdropWallet;
298     address public   bbNetworkGrowthWallet;
299     address public   bbReserveWallet;
300     address public   bbPublicSaleWallet;
301 
302     uint    public  saleStartTime;
303     uint    public  saleEndTime;
304 
305     address public  tokenSaleContract;
306     BigbomPrivateSaleList public privateSaleList;
307 
308     mapping (address => bool) public frozenAccount;
309     mapping (address => uint) public frozenTime;
310     mapping (address => uint) public maxAllowedAmount;
311 
312     /* This generates a public event on the blockchain that will notify clients */
313     event FrozenFunds(address target, bool frozen, uint _seconds);
314    
315 
316     function checkMaxAllowed(address target)  public constant  returns (uint) {
317         var maxAmount  = balances[target];
318         if(target == bbFounderCoreStaffWallet){
319             maxAmount = 10000000 * 1e18;
320         }
321         if(target == bbAdvisorWallet){
322             maxAmount = 10000000 * 1e18;
323         }
324         if(target == bbAirdropWallet){
325             maxAmount = 40000000 * 1e18;
326         }
327         if(target == bbNetworkGrowthWallet){
328             maxAmount = 20000000 * 1e18;
329         }
330         if(target == bbReserveWallet){
331             maxAmount = 6350000 * 1e18;
332         }
333         return maxAmount;
334     }
335 
336     function selfFreeze(bool freeze, uint _seconds) public {
337         // selfFreeze cannot more than 7 days
338         require(_seconds <= 7 * 24 * 3600);
339         // if unfreeze
340         if(!freeze){
341             // get End time of frozenAccount
342             var frozenEndTime = frozenTime[msg.sender];
343             // if now > frozenEndTime
344             require (now >= frozenEndTime);
345             // unfreeze account
346             frozenAccount[msg.sender] = freeze;
347             // set time to 0
348             _seconds = 0;           
349         }else{
350             frozenAccount[msg.sender] = freeze;
351             
352         }
353         // set endTime = now + _seconds to freeze
354         frozenTime[msg.sender] = now + _seconds;
355         FrozenFunds(msg.sender, freeze, _seconds);
356         
357     }
358 
359     function freezeAccount(address target, bool freeze, uint _seconds) onlyOwner public {
360         
361         // if unfreeze
362         if(!freeze){
363             // get End time of frozenAccount
364             var frozenEndTime = frozenTime[target];
365             // if now > frozenEndTime
366             require (now >= frozenEndTime);
367             // unfreeze account
368             frozenAccount[target] = freeze;
369             // set time to 0
370             _seconds = 0;           
371         }else{
372             frozenAccount[target] = freeze;
373             
374         }
375         // set endTime = now + _seconds to freeze
376         frozenTime[target] = now + _seconds;
377         FrozenFunds(target, freeze, _seconds);
378         
379     }
380 
381     modifier validDestination( address to ) {
382         require(to != address(0x0));
383         require(to != address(this) );
384         require(!frozenAccount[to]);                       // Check if recipient is frozen
385         _;
386     }
387     modifier validFrom(address from){
388         require(!frozenAccount[from]);                     // Check if sender is frozen
389         _;
390     }
391     modifier onlyWhenTransferEnabled() {
392         if( now <= saleEndTime && now >= saleStartTime ) {
393             require( msg.sender == tokenSaleContract );
394         }
395         _;
396     }
397     modifier onlyPrivateListEnabled(address _to){
398         require(now <= saleStartTime);
399         uint allowcap = privateSaleList.getCap(_to);
400         require (allowcap > 0);
401         _;
402     }
403     function setPrivateList(BigbomPrivateSaleList _privateSaleList)   onlyOwner public {
404         require(_privateSaleList != address(0x0));
405         privateSaleList = _privateSaleList;
406 
407     }
408     
409     function BigbomToken(uint startTime, uint endTime, address admin, address _bbFounderCoreStaffWallet, address _bbAdvisorWallet,
410         address _bbAirdropWallet,
411         address _bbNetworkGrowthWallet,
412         address _bbReserveWallet, 
413         address _bbPublicSaleWallet
414         ) public {
415 
416         require(admin!=address(0x0));
417         require(_bbAirdropWallet!=address(0x0));
418         require(_bbAdvisorWallet!=address(0x0));
419         require(_bbReserveWallet!=address(0x0));
420         require(_bbNetworkGrowthWallet!=address(0x0));
421         require(_bbFounderCoreStaffWallet!=address(0x0));
422         require(_bbPublicSaleWallet!=address(0x0));
423 
424         // Mint all tokens. Then disable minting forever.
425         balances[msg.sender] = totalSupply;
426         Transfer(address(0x0), msg.sender, totalSupply);
427         // init internal amount limit
428         // set address when deploy
429         bbAirdropWallet = _bbAirdropWallet;
430         bbAdvisorWallet = _bbAdvisorWallet;
431         bbReserveWallet = _bbReserveWallet;
432         bbNetworkGrowthWallet = _bbNetworkGrowthWallet;
433         bbFounderCoreStaffWallet = _bbFounderCoreStaffWallet;
434         bbPublicSaleWallet = _bbPublicSaleWallet;
435         
436         saleStartTime = startTime;
437         saleEndTime = endTime;
438         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
439     }
440 
441     function setTimeSale(uint startTime, uint endTime) onlyOwner public {
442         require (now < saleStartTime || now > saleEndTime);
443         require (now < startTime);
444         require ( startTime < endTime);
445         saleStartTime = startTime;
446         saleEndTime = endTime;
447     }
448 
449     function setTokenSaleContract(address _tokenSaleContract) onlyOwner public {
450         // check address ! 0
451         require(_tokenSaleContract != address(0x0));
452         // do not allow run when saleStartTime <= now <= saleEndTime
453         require (now < saleStartTime || now > saleEndTime);
454 
455         tokenSaleContract = _tokenSaleContract;
456     }
457     function transfer(address _to, uint _value)
458         onlyWhenTransferEnabled
459         validDestination(_to)
460         validFrom(msg.sender)
461         public 
462         returns (bool) {
463         if (msg.sender == bbFounderCoreStaffWallet || msg.sender == bbAdvisorWallet|| 
464             msg.sender == bbAirdropWallet|| msg.sender == bbNetworkGrowthWallet|| msg.sender == bbReserveWallet){
465 
466             // check maxAllowedAmount
467             var withdrawAmount =  maxAllowedAmount[msg.sender]; 
468             var defaultAllowAmount = checkMaxAllowed(msg.sender);
469             var maxAmount = defaultAllowAmount - withdrawAmount;
470             // _value transfer must <= maxAmount
471             require(maxAmount >= _value); // 
472 
473             // if maxAmount = 0, need to block this msg.sender
474             if(maxAmount==_value){
475                
476                 var isTransfer = super.transfer(_to, _value);
477                  // freeze account
478                 selfFreeze(true, 24 * 3600); // temp freeze account 24h
479                 maxAllowedAmount[msg.sender] = 0;
480                 return isTransfer;
481             }else{
482                 // set max withdrawAmount
483                 maxAllowedAmount[msg.sender] = maxAllowedAmount[msg.sender].add(_value); // 
484                 
485             }
486         }
487         return  super.transfer(_to, _value);
488             
489     }
490 
491     function transferPrivateSale(address _to, uint _value)
492         onlyOwner
493         onlyPrivateListEnabled(_to) 
494         public 
495         returns (bool) {
496          return transfer( _to,  _value);
497     }
498 
499     function transferFrom(address _from, address _to, uint _value)
500         onlyWhenTransferEnabled
501         validDestination(_to)
502         validFrom(_from)
503         public 
504         returns (bool) {
505             if (_from == bbFounderCoreStaffWallet || _from == bbAdvisorWallet|| 
506                 _from == bbAirdropWallet|| _from == bbNetworkGrowthWallet|| _from == bbReserveWallet){
507 
508                   // check maxAllowedAmount
509                 var withdrawAmount =  maxAllowedAmount[_from]; 
510                 var defaultAllowAmount = checkMaxAllowed(_from);
511                 var maxAmount = defaultAllowAmount - withdrawAmount; 
512                 // _value transfer must <= maxAmount
513                 require(maxAmount >= _value); 
514 
515                 // if maxAmount = 0, need to block this _from
516                 if(maxAmount==_value){
517                    
518                     var isTransfer = super.transfer(_to, _value);
519                      // freeze account
520                     selfFreeze(true, 24 * 3600); 
521                     maxAllowedAmount[_from] = 0;
522                     return isTransfer;
523                 }else{
524                     // set max withdrawAmount
525                     maxAllowedAmount[_from] = maxAllowedAmount[_from].add(_value); 
526                     
527                 }
528             }
529             return super.transferFrom(_from, _to, _value);
530     }
531 
532     event Burn(address indexed _burner, uint _value);
533 
534     function burn(uint _value) onlyWhenTransferEnabled
535         public 
536         returns (bool){
537         balances[msg.sender] = balances[msg.sender].sub(_value);
538         totalSupply = totalSupply.sub(_value);
539         Burn(msg.sender, _value);
540         Transfer(msg.sender, address(0x0), _value);
541         return true;
542     }
543 
544     // save some gas by making only one contract call
545     function burnFrom(address _from, uint256 _value) onlyWhenTransferEnabled
546         public 
547         returns (bool) {
548         assert( transferFrom( _from, msg.sender, _value ) );
549         return burn(_value);
550     }
551 
552     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
553         token.transfer( owner, amount );
554     }
555 }
556 
557 contract BigbomTokenSale {
558     address             public admin;
559     address             public bigbomMultiSigWallet;
560     BigbomToken         public token;
561     uint                public raisedWei;
562     bool                public haltSale;
563     uint                      public openSaleStartTime;
564     uint                      public openSaleEndTime;
565     BigbomContributorWhiteList public list;
566 
567     mapping(address=>uint)    public participated;
568 
569     using SafeMath for uint;
570 
571     function BigbomTokenSale( address _admin,
572                               address _bigbomMultiSigWallet,
573                               BigbomContributorWhiteList _whilteListContract,
574                               uint _publicSaleStartTime,
575                               uint _publicSaleEndTime,
576                               BigbomToken _token) public       
577     {
578         require (_publicSaleStartTime < _publicSaleEndTime);
579         require (_admin != address(0x0));
580         require (_bigbomMultiSigWallet != address(0x0));
581         require (_whilteListContract != address(0x0));
582         require (_token != address(0x0));
583 
584         admin = _admin;
585         bigbomMultiSigWallet = _bigbomMultiSigWallet;
586         list = _whilteListContract;
587         openSaleStartTime = _publicSaleStartTime;
588         openSaleEndTime = _publicSaleEndTime;
589         token = _token;
590     }
591     
592     function saleEnded() public constant returns(bool) {
593         return now > openSaleEndTime;
594     }
595 
596     function saleStarted() public constant returns(bool) {
597         return now >= openSaleStartTime;
598     }
599 
600     function setHaltSale( bool halt ) public {
601         require( msg.sender == admin );
602         haltSale = halt;
603     }
604     // this is a seperate function so user could query it before crowdsale starts
605     function contributorMinCap( address contributor ) public constant returns(uint) {
606         return list.getMinCap( contributor );
607     }
608     function contributorMaxCap( address contributor, uint amountInWei ) public constant returns(uint) {
609         uint cap = list.getMaxCap( contributor );
610         if( cap == 0 ) return 0;
611         uint remainedCap = cap.sub( participated[ contributor ] );
612 
613         if( remainedCap > amountInWei ) return amountInWei;
614         else return remainedCap;
615     }
616 
617     function checkMaxCap( address contributor, uint amountInWei ) internal returns(uint) {
618         uint result = contributorMaxCap( contributor, amountInWei );
619         participated[contributor] = participated[contributor].add( result );
620         return result;
621     }
622 
623     function() payable public {
624         buy( msg.sender );
625     }
626 
627 
628 
629     function getBonus(uint _tokens) public view returns (uint){
630         if (now > openSaleStartTime && now <= (openSaleStartTime+3 days)){
631             return _tokens.mul(25).div(100);
632         }
633         else
634         {
635             return 0;
636         }
637     }
638 
639     event Buy( address _buyer, uint _tokens, uint _payedWei, uint _bonus );
640     function buy( address recipient ) payable public returns(uint){
641         //require( tx.gasprice <= 50000000000 wei );
642 
643         require( ! haltSale );
644         require( saleStarted() );
645         require( ! saleEnded() );
646 
647         uint mincap = contributorMinCap(recipient);
648 
649         uint maxcap = checkMaxCap(recipient, msg.value );
650         uint allowValue = msg.value;
651         require( mincap > 0 );
652         require( maxcap > 0 );
653         // fail if msg.value < mincap
654         require (msg.value >= mincap);
655         // send to msg.sender, not to recipient if value > maxcap
656         if( msg.value > maxcap  ) {
657             allowValue = maxcap;
658             //require (allowValue >= mincap);
659             msg.sender.transfer( msg.value.sub( maxcap ) );
660         }
661 
662         // send payment to wallet
663         sendETHToMultiSig(allowValue);
664         raisedWei = raisedWei.add( allowValue );
665         // 1ETH = 20000 BBO
666         uint recievedTokens = allowValue.mul( 20000 );
667         // TODO bounce
668         uint bonus = getBonus(recievedTokens);
669         
670         recievedTokens = recievedTokens.add(bonus);
671         assert( token.transfer( recipient, recievedTokens ) );
672         //
673 
674         Buy( recipient, recievedTokens, allowValue, bonus );
675 
676         return msg.value;
677     }
678 
679     function sendETHToMultiSig( uint value ) internal {
680         bigbomMultiSigWallet.transfer( value );
681     }
682 
683     event FinalizeSale();
684     // function is callable by everyone
685     function finalizeSale() public {
686         require( saleEnded() );
687         //require( msg.sender == admin );
688 
689         // burn remaining tokens
690         token.burn(token.balanceOf(this));
691 
692         FinalizeSale();
693     }
694 
695     // ETH balance is always expected to be 0.
696     // but in case something went wrong, we use this function to extract the eth.
697     function emergencyDrain(ERC20 anyToken) public returns(bool){
698         require( msg.sender == admin );
699         require( saleEnded() );
700 
701         if( this.balance > 0 ) {
702             sendETHToMultiSig( this.balance );
703         }
704 
705         if( anyToken != address(0x0) ) {
706             assert( anyToken.transfer(bigbomMultiSigWallet, anyToken.balanceOf(this)) );
707         }
708 
709         return true;
710     }
711 
712     // just to check that funds goes to the right place
713     // tokens are not given in return
714     function debugBuy() payable public {
715         require( msg.value > 0 );
716         sendETHToMultiSig( msg.value );
717     }
718 }