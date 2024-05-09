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
212 contract BigbomPrivateSaleList is Ownable {
213     mapping(address=>uint) public addressCap;
214 
215     function BigbomPrivateSaleList() public  {}
216 
217     event ListAddress( address _user, uint _amount, uint _time );
218 
219     // Owner can delist by setting amount = 0.
220     // Onwer can also change it at any time
221     function listAddress( address _user, uint _amount ) public onlyOwner {
222         require(_user != address(0x0));
223 
224         addressCap[_user] = _amount;
225         ListAddress( _user, _amount, now );
226     }
227 
228     // an optimization in case of network congestion
229     function listAddresses( address[] _users, uint[] _amount ) public onlyOwner {
230         require(_users.length == _amount.length );
231         for( uint i = 0 ; i < _users.length ; i++ ) {
232             listAddress( _users[i], _amount[i] );
233         }
234     }
235 
236     function getCap( address _user ) public constant returns(uint) {
237         return addressCap[_user];
238     }
239 
240 }
241 
242 contract BigbomToken is StandardToken, Ownable {
243     
244     string  public  constant name = "Bigbom";
245     string  public  constant symbol = "BBO";
246     uint    public  constant decimals = 18;
247     uint    public   totalSupply = 2000000000 * 1e18; //2,000,000,000
248 
249     uint    public  constant founderAmount = 200000000 * 1e18; // 200,000,000
250     uint    public  constant coreStaffAmount = 60000000 * 1e18; // 60,000,000
251     uint    public  constant advisorAmount = 140000000 * 1e18; // 140,000,000
252     uint    public  constant networkGrowthAmount = 600000000 * 1e18; //600,000,000
253     uint    public  constant reserveAmount = 635000000 * 1e18; // 635,000,000
254     uint    public  constant bountyAmount = 40000000 * 1e18; // 40,000,000
255     uint    public  constant publicSaleAmount = 275000000 * 1e18; // 275,000,000
256 
257     address public   bbFounderCoreStaffWallet ;
258     address public   bbAdvisorWallet;
259     address public   bbAirdropWallet;
260     address public   bbNetworkGrowthWallet;
261     address public   bbReserveWallet;
262     address public   bbPublicSaleWallet;
263 
264     uint    public  saleStartTime;
265     uint    public  saleEndTime;
266 
267     address public  tokenSaleContract;
268     BigbomPrivateSaleList public privateSaleList;
269 
270     mapping (address => bool) public frozenAccount;
271     mapping (address => uint) public frozenTime;
272     mapping (address => uint) public maxAllowedAmount;
273 
274     /* This generates a public event on the blockchain that will notify clients */
275     event FrozenFunds(address target, bool frozen, uint _seconds);
276    
277 
278     function checkMaxAllowed(address target)  public constant  returns (uint) {
279         var maxAmount  = balances[target];
280         if(target == bbFounderCoreStaffWallet){
281             maxAmount = 10000000 * 1e18;
282         }
283         if(target == bbAdvisorWallet){
284             maxAmount = 10000000 * 1e18;
285         }
286         if(target == bbAirdropWallet){
287             maxAmount = 40000000 * 1e18;
288         }
289         if(target == bbNetworkGrowthWallet){
290             maxAmount = 20000000 * 1e18;
291         }
292         if(target == bbReserveWallet){
293             maxAmount = 6350000 * 1e18;
294         }
295         return maxAmount;
296     }
297 
298     function selfFreeze(bool freeze, uint _seconds) public {
299         // selfFreeze cannot more than 7 days
300         require(_seconds <= 7 * 24 * 3600);
301         // if unfreeze
302         if(!freeze){
303             // get End time of frozenAccount
304             var frozenEndTime = frozenTime[msg.sender];
305             // if now > frozenEndTime
306             require (now >= frozenEndTime);
307             // unfreeze account
308             frozenAccount[msg.sender] = freeze;
309             // set time to 0
310             _seconds = 0;           
311         }else{
312             frozenAccount[msg.sender] = freeze;
313             
314         }
315         // set endTime = now + _seconds to freeze
316         frozenTime[msg.sender] = now + _seconds;
317         FrozenFunds(msg.sender, freeze, _seconds);
318         
319     }
320 
321     function freezeAccount(address target, bool freeze, uint _seconds) onlyOwner public {
322         
323         // if unfreeze
324         if(!freeze){
325             // get End time of frozenAccount
326             var frozenEndTime = frozenTime[target];
327             // if now > frozenEndTime
328             require (now >= frozenEndTime);
329             // unfreeze account
330             frozenAccount[target] = freeze;
331             // set time to 0
332             _seconds = 0;           
333         }else{
334             frozenAccount[target] = freeze;
335             
336         }
337         // set endTime = now + _seconds to freeze
338         frozenTime[target] = now + _seconds;
339         FrozenFunds(target, freeze, _seconds);
340         
341     }
342 
343     modifier validDestination( address to ) {
344         require(to != address(0x0));
345         require(to != address(this) );
346         require(!frozenAccount[to]);                       // Check if recipient is frozen
347         _;
348     }
349     modifier validFrom(address from){
350         require(!frozenAccount[from]);                     // Check if sender is frozen
351         _;
352     }
353     modifier onlyWhenTransferEnabled() {
354         if( now <= saleEndTime && now >= saleStartTime ) {
355             require( msg.sender == tokenSaleContract );
356         }
357         _;
358     }
359     modifier onlyPrivateListEnabled(address _to){
360         require(now <= saleStartTime);
361         uint allowcap = privateSaleList.getCap(_to);
362         require (allowcap > 0);
363         _;
364     }
365     function setPrivateList(BigbomPrivateSaleList _privateSaleList)   onlyOwner public {
366         require(_privateSaleList != address(0x0));
367         privateSaleList = _privateSaleList;
368 
369     }
370     
371     function BigbomToken(uint startTime, uint endTime, address admin, address _bbFounderCoreStaffWallet, address _bbAdvisorWallet,
372         address _bbAirdropWallet,
373         address _bbNetworkGrowthWallet,
374         address _bbReserveWallet, 
375         address _bbPublicSaleWallet
376         ) public {
377 
378         require(admin!=address(0x0));
379         require(_bbAirdropWallet!=address(0x0));
380         require(_bbAdvisorWallet!=address(0x0));
381         require(_bbReserveWallet!=address(0x0));
382         require(_bbNetworkGrowthWallet!=address(0x0));
383         require(_bbFounderCoreStaffWallet!=address(0x0));
384         require(_bbPublicSaleWallet!=address(0x0));
385 
386         // Mint all tokens. Then disable minting forever.
387         balances[msg.sender] = totalSupply;
388         Transfer(address(0x0), msg.sender, totalSupply);
389         // init internal amount limit
390         // set address when deploy
391         bbAirdropWallet = _bbAirdropWallet;
392         bbAdvisorWallet = _bbAdvisorWallet;
393         bbReserveWallet = _bbReserveWallet;
394         bbNetworkGrowthWallet = _bbNetworkGrowthWallet;
395         bbFounderCoreStaffWallet = _bbFounderCoreStaffWallet;
396         bbPublicSaleWallet = _bbPublicSaleWallet;
397         
398         saleStartTime = startTime;
399         saleEndTime = endTime;
400         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
401     }
402 
403     function setTimeSale(uint startTime, uint endTime) onlyOwner public {
404         require (now < saleStartTime || now > saleEndTime);
405         require (now < startTime);
406         require ( startTime < endTime);
407         saleStartTime = startTime;
408         saleEndTime = endTime;
409     }
410 
411     function setTokenSaleContract(address _tokenSaleContract) onlyOwner public {
412         // check address ! 0
413         require(_tokenSaleContract != address(0x0));
414         // do not allow run when saleStartTime <= now <= saleEndTime
415         require (now < saleStartTime || now > saleEndTime);
416 
417         tokenSaleContract = _tokenSaleContract;
418     }
419     function transfer(address _to, uint _value)
420         onlyWhenTransferEnabled
421         validDestination(_to)
422         validFrom(msg.sender)
423         public 
424         returns (bool) {
425         if (msg.sender == bbFounderCoreStaffWallet || msg.sender == bbAdvisorWallet|| 
426             msg.sender == bbAirdropWallet|| msg.sender == bbNetworkGrowthWallet|| msg.sender == bbReserveWallet){
427 
428             // check maxAllowedAmount
429             var withdrawAmount =  maxAllowedAmount[msg.sender]; 
430             var defaultAllowAmount = checkMaxAllowed(msg.sender);
431             var maxAmount = defaultAllowAmount - withdrawAmount;
432             // _value transfer must <= maxAmount
433             require(maxAmount >= _value); // 
434 
435             // if maxAmount = 0, need to block this msg.sender
436             if(maxAmount==_value){
437                
438                 var isTransfer = super.transfer(_to, _value);
439                  // freeze account
440                 selfFreeze(true, 24 * 3600); // temp freeze account 24h
441                 maxAllowedAmount[msg.sender] = 0;
442                 return isTransfer;
443             }else{
444                 // set max withdrawAmount
445                 maxAllowedAmount[msg.sender] = maxAllowedAmount[msg.sender].add(_value); // 
446                 
447             }
448         }
449         return  super.transfer(_to, _value);
450             
451     }
452 
453     function transferPrivateSale(address _to, uint _value)
454         onlyOwner
455         onlyPrivateListEnabled(_to) 
456         public 
457         returns (bool) {
458          return transfer( _to,  _value);
459     }
460 
461     function transferFrom(address _from, address _to, uint _value)
462         onlyWhenTransferEnabled
463         validDestination(_to)
464         validFrom(_from)
465         public 
466         returns (bool) {
467             if (_from == bbFounderCoreStaffWallet || _from == bbAdvisorWallet|| 
468                 _from == bbAirdropWallet|| _from == bbNetworkGrowthWallet|| _from == bbReserveWallet){
469 
470                   // check maxAllowedAmount
471                 var withdrawAmount =  maxAllowedAmount[_from]; 
472                 var defaultAllowAmount = checkMaxAllowed(_from);
473                 var maxAmount = defaultAllowAmount - withdrawAmount; 
474                 // _value transfer must <= maxAmount
475                 require(maxAmount >= _value); 
476 
477                 // if maxAmount = 0, need to block this _from
478                 if(maxAmount==_value){
479                    
480                     var isTransfer = super.transfer(_to, _value);
481                      // freeze account
482                     selfFreeze(true, 24 * 3600); 
483                     maxAllowedAmount[_from] = 0;
484                     return isTransfer;
485                 }else{
486                     // set max withdrawAmount
487                     maxAllowedAmount[_from] = maxAllowedAmount[_from].add(_value); 
488                     
489                 }
490             }
491             return super.transferFrom(_from, _to, _value);
492     }
493 
494     event Burn(address indexed _burner, uint _value);
495 
496     function burn(uint _value) onlyWhenTransferEnabled
497         public 
498         returns (bool){
499         balances[msg.sender] = balances[msg.sender].sub(_value);
500         totalSupply = totalSupply.sub(_value);
501         Burn(msg.sender, _value);
502         Transfer(msg.sender, address(0x0), _value);
503         return true;
504     }
505 
506     // save some gas by making only one contract call
507     function burnFrom(address _from, uint256 _value) onlyWhenTransferEnabled
508         public 
509         returns (bool) {
510         assert( transferFrom( _from, msg.sender, _value ) );
511         return burn(_value);
512     }
513 
514     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
515         token.transfer( owner, amount );
516     }
517 }
518 
519 contract BigbomTokenExtended is BigbomToken {
520     BigbomToken public  bigbomToken;
521     function BigbomTokenExtended(uint startTime, uint endTime, address admin, address _bbFounderCoreStaffWallet, address _bbAdvisorWallet,
522         address _bbAirdropWallet,
523         address _bbNetworkGrowthWallet,
524         address _bbReserveWallet, 
525         address _bbPublicSaleWallet,
526         BigbomToken _bigbomToken
527         ) public BigbomToken(startTime, endTime, admin, _bbFounderCoreStaffWallet, _bbAdvisorWallet,
528          _bbAirdropWallet,
529          _bbNetworkGrowthWallet,
530          _bbReserveWallet, 
531          _bbPublicSaleWallet
532         ){
533             bigbomToken = _bigbomToken;
534     }
535         
536     
537     event TokenDrop( address receiver, uint amount );
538     function airDrop(address[] recipients) public onlyOwner {
539         for(uint i = 0 ; i < recipients.length ; i++){
540             uint amount = bigbomToken.balanceOf(recipients[i]);
541             if (amount > 0){
542                 //
543                 transfer(recipients[i], amount);
544                 TokenDrop( recipients[i], amount );
545             }
546         }
547     }
548 
549     modifier validFrozenAccount(address target) {
550         if(frozenAccount[target]){
551             require(now >= frozenTime[target]);
552         }
553         _;
554     }
555 
556     function selfFreeze(bool freeze, uint _seconds) 
557     validFrozenAccount(msg.sender) 
558     public {
559         // selfFreeze cannot more than 7 days
560         require(_seconds <= 7 * 24 * 3600);
561         // if unfreeze
562         if(!freeze){
563             // get End time of frozenAccount
564             var frozenEndTime = frozenTime[msg.sender];
565             // if now > frozenEndTime
566             require (now >= frozenEndTime);
567             // unfreeze account
568             frozenAccount[msg.sender] = freeze;
569             // set time to 0
570             _seconds = 0;           
571         }else{
572             frozenAccount[msg.sender] = freeze;
573             
574         }
575         // set endTime = now + _seconds to freeze
576         frozenTime[msg.sender] = now + _seconds;
577         FrozenFunds(msg.sender, freeze, _seconds);
578         
579     }
580 
581     function freezeAccount(address target, bool freeze, uint _seconds) 
582     onlyOwner
583     validFrozenAccount(target)
584     public {
585         
586         // if unfreeze
587         if(!freeze){
588             // get End time of frozenAccount
589             var frozenEndTime = frozenTime[target];
590             // if now > frozenEndTime
591             require (now >= frozenEndTime);
592             // unfreeze account
593             frozenAccount[target] = freeze;
594             // set time to 0
595             _seconds = 0;           
596         }else{
597             frozenAccount[target] = freeze;
598             
599         }
600         // set endTime = now + _seconds to freeze
601         frozenTime[target] = now + _seconds;
602         FrozenFunds(target, freeze, _seconds);
603         
604     }
605 
606     
607 }