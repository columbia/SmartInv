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
256 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
257 
258 contract ST20Token is Owned, BurnableToken {
259 
260     string public name = "SUREBANQA PERSONAL e-SHARE";
261     string public symbol = "ST20";
262     uint8 public decimals = 2;
263     
264     uint256 public initialSupply = 1000000 * (10 ** uint256(decimals));
265     uint256 public totalSupply = 1000000 * (10 ** uint256(decimals));
266     uint256 public externalAuthorizePurchase = 0;
267 
268     
269     /* in timestamp  */
270     mapping (address => uint) public userLockinPeriod;
271 
272     /* type 1 => 2 years , 2 => 10 years   */
273     mapping (address => uint) public userLockinPeriodType;
274 
275     mapping (address => bool) public frozenAccount;
276     mapping(address => uint8) authorizedCaller;
277     
278     bool public kycEnabled = true;
279     bool public authorizedTransferOnly = true; /* to Enable authorized user for transfer*/
280     
281     
282     mapping(address => mapping(bytes32 => bool)) private transferRequestStatus;
283     
284     struct fundReceiver{
285         address _to;
286         uint _value;
287     }
288     
289     mapping(address => mapping(bytes32 => fundReceiver)) private transferRequestReceiver;
290 
291     KYCVerification public kycVerification;
292 
293     event KYCMandateUpdate(bool _kycEnabled);
294     event KYCContractAddressUpdate(KYCVerification _kycAddress);
295 
296     /* This generates a public event on the blockchain that will notify clients */
297     event FrozenFunds(address target, bool frozen);
298     
299     /* Events */
300     event AuthorizedCaller(address caller);
301     event DeAuthorizedCaller(address caller);
302 
303     event LockinPeriodUpdated(address _guy,uint _userLockinPeriodType, uint _userLockinPeriod);
304     
305     event TransferAuthorizationOverride(bool _authorize);
306     event TransferRequested(address _from, address _to, uint _value,bytes32 _signature);
307     event TransferRequestFulfilled(address _from, address _to, uint _value,bytes32 _signature);
308     
309     
310     modifier onlyAuthCaller(){
311         require(authorizedCaller[msg.sender] == 1 || msg.sender == owner);
312         _;
313     }
314     
315     modifier kycVerified(address _guy) {
316       if(kycEnabled == true){
317           if(kycVerification.isVerified(_guy) == false)
318           {
319               revert("KYC Not Verified");
320           }
321       }
322       _;
323     }
324     
325     modifier frozenVerified(address _guy) {
326         if(frozenAccount[_guy] == true)
327         {
328             revert("Account is freeze");
329         }
330         _;
331     }
332     
333     modifier transferAuthorized(address _guy) {
334         
335         if(authorizedTransferOnly == true)
336         {
337             if(authorizedCaller[msg.sender] == 0 || msg.sender != owner)
338             {
339                 revert();
340             }
341         }
342         _;
343     }
344 
345 
346     /* Initializes contract with initial supply tokens to the creator of the contract */
347     constructor() public {
348         owner = msg.sender;
349         balances[0xBcd5B67aaeBb9765beE438e4Ce137B9aE2181898] = totalSupply;
350         
351         authorizedCaller[msg.sender] = 1;
352         emit AuthorizedCaller(msg.sender);
353     }
354      
355     function updateKycContractAddress(KYCVerification _kycAddress) public onlyOwner returns(bool)
356     {
357       kycVerification = _kycAddress;
358 
359       emit KYCContractAddressUpdate(_kycAddress);
360 
361       return true;
362     }
363 
364     function updateKycMandate(bool _kycEnabled) public onlyAuthCaller returns(bool)
365     {
366         kycEnabled = _kycEnabled;
367         emit KYCMandateUpdate(_kycEnabled);
368 
369         return true;
370     }
371 
372     function overrideUserLockinPeriod(address _guy,uint _userLockinPeriodType, uint _userLockinPeriod) public onlyAuthCaller
373     {
374         userLockinPeriodType[_guy] = _userLockinPeriodType;
375         userLockinPeriod[_guy] = _userLockinPeriod;
376 
377         emit LockinPeriodUpdated(_guy,_userLockinPeriodType, _userLockinPeriod);
378     }
379     
380     function overrideTransferAuthorization(bool _authorize) public onlyAuthCaller
381     {
382         authorizedTransferOnly = _authorize;
383         emit TransferAuthorizationOverride(_authorize);
384     }
385         
386     /* authorize caller */
387     function authorizeCaller(address _caller) public onlyOwner returns(bool) 
388     {
389         authorizedCaller[_caller] = 1;
390         emit AuthorizedCaller(_caller);
391         return true;
392     }
393     
394     /* deauthorize caller */
395     function deAuthorizeCaller(address _caller) public onlyOwner returns(bool) 
396     {
397         authorizedCaller[_caller] = 0;
398         emit DeAuthorizedCaller(_caller);
399         return true;
400     }
401     
402     function () payable public {
403         revert();
404     }
405     
406 
407     /* Internal transfer, only can be called by this contract */
408     function _transfer(address _from, address _to, uint _value) internal transferAuthorized(msg.sender) {
409         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
410         require (balances[_from] > _value);                // Check if the sender has enough
411         require (balances[_to].add(_value) > balances[_to]); // Check for overflow
412         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
413         balances[_to] = balances[_to].add(_value);                           // Add the same to the recipient
414         emit Transfer(_from, _to, _value);
415     }
416 
417     /// @notice Create `mintedAmount` tokens and send it to `target`
418     /// @param target Address to receive the tokens
419     /// @param mintedAmount the amount of tokens it will receive
420     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
421         balances[target] = balances[target].add(mintedAmount);
422         totalSupply = totalSupply.add(mintedAmount);
423         emit Transfer(0, this, mintedAmount);
424         emit Transfer(this, target, mintedAmount);
425     }
426 
427     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
428     /// @param target Address to be frozen
429     /// @param freeze either to freeze it or not
430     function freezeAccount(address target, bool freeze) onlyOwner public {
431         frozenAccount[target] = freeze;
432         emit FrozenFunds(target, freeze);
433     }
434 
435 
436     function purchaseToken(address _receiver, uint _tokens, uint _userLockinPeriod, uint _userLockinPeriodType) onlyAuthCaller public  {
437         require(_tokens > 0);
438         require(initialSupply > _tokens);
439         
440         initialSupply = initialSupply.sub(_tokens);
441         _transfer(owner, _receiver, _tokens);              // makes the transfers
442         externalAuthorizePurchase = externalAuthorizePurchase.add(_tokens);
443 
444         /*  Check if lockin period and lockin period type is to be set  */
445         if(_userLockinPeriod != 0 && _userLockinPeriodType != 0)
446         {
447             userLockinPeriod[_receiver] = _userLockinPeriod;
448             userLockinPeriodType[_receiver] = _userLockinPeriodType;
449 
450             emit LockinPeriodUpdated(_receiver,_userLockinPeriodType, _userLockinPeriod);
451         }
452     }
453 
454     /**
455       * @dev transfer token for a specified address sender and receiver must be KYC verified 
456       * @param _to The address to transfer to.
457       * @param _value The amount to be transferred.
458     */
459     function transfer(address _to, uint256 _value) public kycVerified(msg.sender) frozenVerified(msg.sender) returns (bool) {
460 
461         /*  KYC Update Check  */
462         if(kycEnabled == true){
463             /*  KYC For Receiver   */
464             if(kycVerification.isVerified(_to) == false)
465             {
466                 revert("KYC Not Verified for Receiver");
467             }
468         }
469 
470         _transfer(msg.sender,_to,_value);
471         return true;
472     }
473     
474     /*
475         Please make sure before calling this function from UI, Sender has sufficient balance for 
476         All transfers and receiver qty max 25 and KYC verified
477     */
478     function multiTransfer(address[] _to,uint[] _value) public kycVerified(msg.sender) frozenVerified(msg.sender) returns (bool) {
479         require(_to.length == _value.length, "Length of Destination should be equal to value");
480         require(_to.length <= 25, "Max 25 Senders allowed" );        
481 
482         for(uint _interator = 0;_interator < _to.length; _interator++ )
483         {
484             /*  KYC Update Check  */
485             if(kycEnabled == true){
486                 /*  KYC For Receiver   */
487                 if(kycVerification.isVerified(_to[_interator]) == false)
488                 {
489                     revert("KYC Not Verified for Receiver");
490                 }
491             }
492         }
493 
494 
495         for(_interator = 0;_interator < _to.length; _interator++ )
496         {
497             _transfer(msg.sender,_to[_interator],_value[_interator]);
498         }
499         
500         return true;    
501     }
502     
503     function requestTransfer(address _to, uint _value, bytes32 _signature) public returns(bool)
504     {
505         require(transferRequestStatus[msg.sender][_signature] == false,"Signature already processed");
506         require (balances[msg.sender] > _value,"Insufficient Sender Balance");
507         
508         transferRequestReceiver[msg.sender][_signature] = fundReceiver(_to,_value);
509         
510         emit TransferRequested(msg.sender, _to, _value,_signature);
511         
512         return true;
513     }
514 
515     function batchRequestTransfer(address[] _to, uint[] _value, bytes32[] _signature) public returns(bool)
516     {
517         require(_to.length == _value.length ,"Length for to, value should be equal");
518         require(_to.length == _signature.length ,"Length for to, signature should be equal");
519         
520 
521         for(uint _interator = 0; _interator < _to.length ; _interator++)
522         {
523             require(transferRequestStatus[msg.sender][_signature[_interator]] == false,"Signature already processed");
524             
525             transferRequestReceiver[msg.sender][_signature[_interator]] = fundReceiver(_to[_interator],_value[_interator]);
526             
527             emit TransferRequested(msg.sender, _to[_interator], _value[_interator],_signature[_interator]);
528         }
529 
530         
531         
532         return true;
533     }
534     
535     function fullTransferRequest(address _from, bytes32 _signature) public onlyAuthCaller returns(bool) 
536     {
537         require(transferRequestStatus[_from][_signature] == false);
538         
539         fundReceiver memory _tmpHolder = transferRequestReceiver[_from][_signature];
540 
541         _transfer(_from,_tmpHolder._to,_tmpHolder._value);
542         
543         transferRequestStatus[_from][_signature] == true;
544         
545         emit TransferRequestFulfilled(_from, _tmpHolder._to, _tmpHolder._value,_signature);
546         
547         return true;
548     }
549 
550     function batchFullTransferRequest(address[] _from, bytes32[] _signature) public onlyAuthCaller returns(bool) 
551     {
552 
553         /* Check if Any Signature is previously used */
554         for(uint _interator = 0; _interator < _from.length ; _interator++)
555         {
556             require(transferRequestStatus[_from[_interator]][_signature[_interator]] == false);
557             
558             fundReceiver memory _tmpHolder = transferRequestReceiver[_from[_interator]][_signature[_interator]];
559         
560             /* Check Balance */
561             require (_tmpHolder._value < balances[_from[_interator]],"Insufficient Sender Balance");
562             
563             _transfer(_from[_interator],_tmpHolder._to,_tmpHolder._value);
564             
565             transferRequestStatus[_from[_interator]][_signature[_interator]] == true;
566             
567             emit TransferRequestFulfilled(_from[_interator], _tmpHolder._to, _tmpHolder._value,_signature[_interator]);
568         }
569         
570         
571         return true;
572     }
573     
574     function getTransferRequestStatus(address _from, bytes32 _signature) public view returns(bool _status)
575     {
576         return  transferRequestStatus[_from][_signature];
577         
578     }
579     
580     function getTransferRequestReceiver(address _from, bytes32 _signature) public view returns(address _to, uint _value)
581     {
582         fundReceiver memory _tmpHolder = transferRequestReceiver[_from][_signature];
583         
584         return (_tmpHolder._to, _tmpHolder._value);
585     }
586 }