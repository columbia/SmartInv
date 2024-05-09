1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed _from, address indexed _to, uint _value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     if (newOwner != address(0)) {
51       owner = newOwner;
52     }
53   }
54 
55 }
56 
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 
103 
104 
105 
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public constant returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed _owner, address indexed _spender, uint _value);
117 }
118 
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amout of tokens to be transfered
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     var _allowance = allowed[_from][msg.sender];
141 
142     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143     // require (_value <= _allowance);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = _allowance.sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158 
159     // To change the approve amount you first have to reduce the addresses`
160     //  allowance to zero by calling `approve(_spender, 0)` if it is not
161     //  already 0 to mitigate the race condition described here:
162     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
164 
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifing the amount of tokens still avaible for the spender.
175    */
176   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
177     return allowed[_owner][_spender];
178   }
179 
180 }
181 
182 
183 
184 contract ElecTokenSmartContract is StandardToken, Ownable {
185     string  public  constant name = "ElectrifyAsia";
186     string  public  constant symbol = "ELEC";
187     uint8    public  constant decimals = 18;
188 
189     uint    public  saleStartTime;
190     uint    public  saleEndTime;
191     uint    public lockedDays = 0;
192 
193     address public  tokenSaleContract;
194     address public adminAddress;
195 
196     modifier onlyWhenTransferEnabled() {
197         if( now <= (saleEndTime + lockedDays * 1 days) && now >= saleStartTime ) {
198             require( msg.sender == tokenSaleContract || msg.sender == adminAddress );
199         }
200         _;
201     }
202 
203     modifier validDestination( address to ) {
204         require(to != address(0x0));
205         require(to != address(this) );
206         _;
207     }
208 
209     function ElecTokenSmartContract( uint tokenTotalAmount, uint startTime, uint endTime, uint lockedTime, address admin ) public {
210         // Mint all tokens. Then disable minting forever.
211         balances[msg.sender] = tokenTotalAmount;
212         totalSupply = tokenTotalAmount;
213         Transfer(address(0x0), msg.sender, tokenTotalAmount);
214 
215         saleStartTime = startTime;
216         saleEndTime = endTime;
217         lockedDays = lockedTime;
218 
219         tokenSaleContract = msg.sender;
220         adminAddress = admin;
221         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
222     }
223 
224     function transfer(address _to, uint _value)
225     public
226     onlyWhenTransferEnabled
227     validDestination(_to)
228     returns (bool) {
229         return super.transfer(_to, _value);
230     }
231 
232     function transferFrom(address _from, address _to, uint _value)
233     public
234     onlyWhenTransferEnabled
235     validDestination(_to)
236     returns (bool) {
237         return super.transferFrom(_from, _to, _value);
238     }
239 
240     event Burn(address indexed _burner, uint _value);
241 
242     function burn(uint _value) public onlyWhenTransferEnabled
243     returns (bool){
244         balances[msg.sender] = balances[msg.sender].sub(_value);
245         totalSupply = totalSupply.sub(_value);
246         Burn(msg.sender, _value);
247         Transfer(msg.sender, address(0x0), _value);
248         return true;
249     }
250 
251 
252     function emergencyERC20Drain( ERC20 token, uint amount ) public onlyOwner {
253         token.transfer( owner, amount );
254     }
255 }
256 
257 
258 
259 
260 
261 
262 
263 
264 /**
265  * @title SafeMath
266  * @dev Math operations with safety checks that throw on error
267  */
268 library SafeMath {
269   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
270     uint256 c = a * b;
271     assert(a == 0 || c / a == b);
272     return c;
273   }
274 
275   function div(uint256 a, uint256 b) internal pure returns (uint256) {
276     // assert(b > 0); // Solidity automatically throws when dividing by 0
277     uint256 c = a / b;
278     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
279     return c;
280   }
281 
282   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283     assert(b <= a);
284     return a - b;
285   }
286 
287   function add(uint256 a, uint256 b) internal pure returns (uint256) {
288     uint256 c = a + b;
289     assert(c >= a);
290     return c;
291   }
292 }
293 
294 
295 contract ElecApprover {
296     ElecWhitelist public list;
297     mapping(address=>uint)    public participated;
298 
299     uint                      public saleStartTime;
300     uint                      public firstRoundTime;
301     uint                      public saleEndTime;
302     uint                      public xtime = 5;/// multiply the cap
303 
304     using SafeMath for uint;
305 
306 
307     function ElecApprover( ElecWhitelist _whitelistContract,
308     uint                      _saleStartTime,
309     uint                      _firstRoundTime,
310     uint                      _saleEndTime ) public {
311         list = _whitelistContract;
312         saleStartTime = _saleStartTime;
313         firstRoundTime = _firstRoundTime;
314         saleEndTime = _saleEndTime;
315 
316         require( list != ElecWhitelist(0x0) );
317         require( saleStartTime < firstRoundTime );
318         require(  firstRoundTime < saleEndTime );
319     }
320 
321     // this is a seperate function so user could query it before crowdsale starts
322     function contributorCap( address contributor ) public constant returns(uint) {
323         uint  cap= list.getCap( contributor );
324         uint higherCap = cap;
325 
326         if ( now > firstRoundTime ) {
327             higherCap = cap.mul(xtime);
328         }
329         return higherCap;
330     }
331 
332 
333     function eligible( address contributor, uint amountInWei ) public constant returns(uint) {
334         if( now < saleStartTime ) return 0;
335         if( now >= saleEndTime ) return 0;
336 
337         uint cap = list.getCap( contributor );
338 
339         if( cap == 0 ) return 0;
340 
341         uint higherCap = cap;
342         if ( now > firstRoundTime ) {
343             higherCap = cap.mul(xtime);
344         }
345 
346         uint remainedCap = higherCap.sub(participated[ contributor ]);
347         if( remainedCap > amountInWei ) return amountInWei;
348               else return remainedCap;
349 
350     }
351 
352     function eligibleTestAndIncrement( address contributor, uint amountInWei ) internal returns(uint) {
353         uint result = eligible( contributor, amountInWei );
354         if ( result > 0) {
355             participated[contributor] = participated[contributor].add( result );
356         }
357         return result;
358     }
359 
360 
361     function contributedCap(address _contributor) public constant returns(uint) {
362         if (participated[_contributor] == 0 ) return 0;
363 
364         return participated[_contributor];
365     }
366 
367      function contributedInternalCap(address _contributor) view internal returns(uint) {
368          if (participated[_contributor] == 0 ) return 0;
369 
370         return participated[_contributor];
371     }
372 
373 
374     function saleEnded() public constant returns(bool) {
375         return now > saleEndTime;
376     }
377 
378     function saleStarted() public constant returns(bool) {
379         return now >= saleStartTime;
380     }
381 }
382 
383 
384 
385 
386 
387 contract ElecWhitelist is Ownable {
388     // cap is in wei. The value of 1 is just a stub.
389     // after kyc registration ends, we change it to the actual value with setUsersCap
390     /// Currenty we set the cap to 1 ETH and the owner is able to change it in the future by call function: setUsersCap
391     uint public communityusersCap = (10**18);
392     mapping(address=>uint) public addressCap;
393 
394     function ElecWhitelist() public {}
395 
396     event ListAddress( address _user, uint _cap, uint _time );
397 
398     // Owner can remove by setting cap = 0.
399     // Onwer can also change it at any time
400     function listAddress( address _user, uint _cap ) public onlyOwner {
401         addressCap[_user] = _cap;
402         ListAddress( _user, _cap, now );
403     }
404 
405     // an optimization in case of network congestion
406     function listAddresses( address[] _users, uint[] _cap ) public onlyOwner {
407         require(_users.length == _cap.length );
408         for( uint i = 0 ; i < _users.length ; i++ ) {
409             listAddress( _users[i], _cap[i] );
410         }
411     }
412 
413     function setUsersCap( uint _cap ) public  onlyOwner {
414         communityusersCap = _cap;
415     }
416 
417     function getCap( address _user ) public constant returns(uint) {
418         uint cap = addressCap[_user];
419         if( cap == 1 ) return communityusersCap;
420         else return cap;
421     }
422 
423     function destroy() public onlyOwner {
424         selfdestruct(owner);
425     }
426 }
427 
428 
429 contract ElecSaleSmartContract is ElecApprover{
430     address             public admin;
431     address             public multiSigWallet; // can be a single wallet
432     ElecTokenSmartContract public token;
433     uint                public raisedWei;
434     bool                public haltSale;
435     uint                constant toWei = (10**18);
436     uint                public minCap = toWei.div(2);
437 
438     mapping(bytes32=>uint) public proxyPurchases;
439 
440     function ElecSaleSmartContract( address _admin,
441     address _multiSigWallet,
442     ElecWhitelist _whiteListContract,
443     uint _totalTokenSupply,
444     uint _companyTokenSupply,
445     uint _saleStartTime,
446     uint _firstRoundTime,
447     uint _saleEndTime,
448     uint _lockedDays)
449 
450     public
451 
452     ElecApprover( _whiteListContract,
453     _saleStartTime,
454     _firstRoundTime,
455     _saleEndTime )
456     {
457         admin = _admin;
458         multiSigWallet = _multiSigWallet;
459 
460         token = new ElecTokenSmartContract( _totalTokenSupply,
461         _saleStartTime,
462         _saleEndTime,
463         _lockedDays, ///change depending on each project
464         _admin );
465 
466         // transfer preminted tokens to company wallet
467         token.transfer( multiSigWallet, _companyTokenSupply );
468     }
469 
470     function setHaltSale( bool halt ) public {
471         require( msg.sender == admin );
472         haltSale = halt;
473     }
474 
475     function() public payable {
476         buy( msg.sender );
477     }
478 
479     event ProxyBuy( bytes32 indexed _proxy, address _recipient, uint _amountInWei );
480     function proxyBuy( bytes32 proxy, address recipient ) public payable returns(uint){
481         uint amount = buy( recipient );
482         proxyPurchases[proxy] = proxyPurchases[proxy].add(amount);
483         ProxyBuy( proxy, recipient, amount );
484 
485 
486         return amount;
487     }
488 
489     event Buy( address _buyer, uint _tokens, uint _payedWei );
490     function buy( address recipient ) public payable returns(uint){
491         require( tx.gasprice <= 50000000000 wei );
492 
493         require( ! haltSale );
494         require( saleStarted() );
495         require( ! saleEnded() );
496 
497         // check min buy at least 0.5 ETH;
498         uint weiContributedCap = contributedInternalCap(recipient);
499 
500         if (weiContributedCap == 0 ) require( msg.value >= minCap);
501 
502 
503 
504         uint weiPayment = eligibleTestAndIncrement( recipient, msg.value );
505 
506         require( weiPayment > 0 );
507 
508 
509         // send to msg.sender, not to recipient
510         if( msg.value > weiPayment ) {
511             msg.sender.transfer( msg.value.sub( weiPayment ) );
512         }
513 
514         // send payment to wallet
515         sendETHToMultiSig( weiPayment );
516         raisedWei = raisedWei.add( weiPayment );
517         uint recievedTokens = weiPayment.mul( 11750 );
518 
519         assert( token.transfer( recipient, recievedTokens ) );
520 
521 
522         Buy( recipient, recievedTokens, weiPayment );
523 
524         return weiPayment;
525     }
526 
527     function sendETHToMultiSig( uint value ) internal {
528         multiSigWallet.transfer( value );
529     }
530 
531     event FinalizeSale();
532     // function is callable by everyone
533     function finalizeSale() public {
534         require( saleEnded() );
535         require( msg.sender == admin );
536 
537         // burn remaining tokens
538         token.burn(token.balanceOf(this));
539 
540         FinalizeSale();
541     }
542 
543     // ETH balance is always expected to be 0.
544     // but in case something went wrong, we use this function to extract the eth.
545     function emergencyDrain(ERC20 anyToken) public returns(bool){
546         require( msg.sender == admin );
547         require( saleEnded() );
548 
549         if( this.balance > 0 ) {
550             sendETHToMultiSig( this.balance );
551         }
552 
553         if( anyToken != address(0x0) ) {
554             assert( anyToken.transfer(multiSigWallet, anyToken.balanceOf(this)) );
555         }
556 
557         return true;
558     }
559 
560     // just to check that funds goes to the right place
561     // tokens are not given in return
562     /*function debugBuy() public payable {
563         require( msg.value == 123 );
564         sendETHToMultiSig( msg.value );
565     }*/
566 }