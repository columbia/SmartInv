1 /*
2 https://lumberscout.io : aut viam inveniam aut faciam
3 */
4 
5 
6 pragma solidity ^0.4.19;
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) public view returns (uint256);
27   function transferFrom(address from, address to, uint256 value) public returns (bool);
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 
33 /**
34    @title ERC827 interface, an extension of ERC20 token standard
35    Interface of a ERC827 token, following the ERC20 standard with extra
36    methods to transfer value and data and execute calls in transfers and
37    approvals.
38  */
39 contract ERC827 is ERC20 {
40 
41   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
42   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
43   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
44 
45 }
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers, truncating the quotient.
68   */
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   /**
77   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   /**
85   * @dev Adds two numbers, throws on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   uint256 totalSupply_;
105 
106   /**
107   * @dev total number of tokens in existence
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     // SafeMath.sub will throw if there is not enough balance.
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) internal allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    *
174    * Beware that changing an allowance with this method brings the risk that someone may use both the old
175    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) public returns (bool) {
182     allowed[msg.sender][_spender] = _value;
183     Approval(msg.sender, _spender, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(address _owner, address _spender) public view returns (uint256) {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
208     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   /**
214    * @dev Decrease the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To decrement
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _subtractedValue The amount of tokens to decrease the allowance by.
222    */
223   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
224     uint oldValue = allowed[msg.sender][_spender];
225     if (_subtractedValue > oldValue) {
226       allowed[msg.sender][_spender] = 0;
227     } else {
228       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
229     }
230     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234 }
235 
236 
237 
238 /**
239    @title ERC827, an extension of ERC20 token standard
240    Implementation the ERC827, following the ERC20 standard with extra
241    methods to transfer value and data and execute calls in transfers and
242    approvals.
243    Uses OpenZeppelin StandardToken.
244  */
245 contract ERC827Token is ERC827, StandardToken {
246 
247   /**
248      @dev Addition to ERC20 token methods. It allows to
249      approve the transfer of value and execute a call with the sent data.
250      Beware that changing an allowance with this method brings the risk that
251      someone may use both the old and the new allowance by unfortunate
252      transaction ordering. One possible solution to mitigate this race condition
253      is to first reduce the spender's allowance to 0 and set the desired value
254      afterwards:
255      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256      @param _spender The address that will spend the funds.
257      @param _value The amount of tokens to be spent.
258      @param _data ABI-encoded contract call to call `_to` address.
259      @return true if the call function was executed successfully
260    */
261   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
262     require(_spender != address(this));
263 
264     super.approve(_spender, _value);
265 
266     require(_spender.call(_data));
267 
268     return true;
269   }
270 
271   /**
272      @dev Addition to ERC20 token methods. Transfer tokens to a specified
273      address and execute a call with the sent data on the same transaction
274      @param _to address The address which you want to transfer to
275      @param _value uint256 the amout of tokens to be transfered
276      @param _data ABI-encoded contract call to call `_to` address.
277      @return true if the call function was executed successfully
278    */
279   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
280     require(_to != address(this));
281 
282     super.transfer(_to, _value);
283 
284     require(_to.call(_data));
285     return true;
286   }
287 
288   /**
289      @dev Addition to ERC20 token methods. Transfer tokens from one address to
290      another and make a contract call on the same transaction
291      @param _from The address which you want to send tokens from
292      @param _to The address which you want to transfer to
293      @param _value The amout of tokens to be transferred
294      @param _data ABI-encoded contract call to call `_to` address.
295      @return true if the call function was executed successfully
296    */
297   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
298     require(_to != address(this));
299 
300     super.transferFrom(_from, _to, _value);
301 
302     require(_to.call(_data));
303     return true;
304   }
305 
306   /**
307    * @dev Addition to StandardToken methods. Increase the amount of tokens that
308    * an owner allowed to a spender and execute a call with the sent data.
309    *
310    * approve should be called when allowed[_spender] == 0. To increment
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _addedValue The amount of tokens to increase the allowance by.
316    * @param _data ABI-encoded contract call to call `_spender` address.
317    */
318   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
319     require(_spender != address(this));
320 
321     super.increaseApproval(_spender, _addedValue);
322 
323     require(_spender.call(_data));
324 
325     return true;
326   }
327 
328   /**
329    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
330    * an owner allowed to a spender and execute a call with the sent data.
331    *
332    * approve should be called when allowed[_spender] == 0. To decrement
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _subtractedValue The amount of tokens to decrease the allowance by.
338    * @param _data ABI-encoded contract call to call `_spender` address.
339    */
340   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
341     require(_spender != address(this));
342 
343     super.decreaseApproval(_spender, _subtractedValue);
344 
345     require(_spender.call(_data));
346 
347     return true;
348   }
349 
350 }
351 
352 
353 
354 /**
355  * @title Ownable
356  * @dev The Ownable contract has an owner address, and provides basic authorization control
357  * functions, this simplifies the implementation of "user permissions".
358  */
359 contract Ownable {
360   address public owner;
361 
362 
363   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365 
366   /**
367    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
368    * account.
369    */
370   function Ownable() public {
371     owner = msg.sender;
372   }
373 
374   /**
375    * @dev Throws if called by any account other than the owner.
376    */
377   modifier onlyOwner() {
378     require(msg.sender == owner);
379     _;
380   }
381 
382   /**
383    * @dev Allows the current owner to transfer control of the contract to a newOwner.
384    * @param newOwner The address to transfer ownership to.
385    */
386   function transferOwnership(address newOwner) public onlyOwner {
387     require(newOwner != address(0));
388     OwnershipTransferred(owner, newOwner);
389     owner = newOwner;
390   }
391 
392 }
393 
394 
395 contract TALLY is ERC827Token, Ownable
396 {
397     using SafeMath for uint256;
398     
399     string public constant name = "TALLY";
400     string public constant symbol = "TLY";
401     uint256 public constant decimals = 18;
402     
403     address public foundationAddress;
404     address public developmentFundAddress;
405     uint256 public constant DEVELOPMENT_FUND_LOCK_TIMESPAN = 2 years;
406     
407     uint256 public developmentFundUnlockTime;
408     
409     bool public tokenSaleEnabled;
410     
411     uint256 public preSaleStartTime;
412     uint256 public preSaleEndTime;
413     uint256 public preSaleTLYperETH;
414     
415     uint256 public preferredSaleStartTime;
416     uint256 public preferredSaleEndTime;
417     uint256 public preferredSaleTLYperETH;
418 
419     uint256 public mainSaleStartTime;
420     uint256 public mainSaleEndTime;
421     uint256 public mainSaleTLYperETH;
422     
423     uint256 public preSaleTokensLeftForSale = 70000000 * (uint256(10)**decimals);
424     uint256 public preferredSaleTokensLeftForSale = 70000000 * (uint256(10)**decimals);
425     
426     uint256 public minimumAmountToParticipate = 0.5 ether;
427     
428     mapping(address => uint256) public addressToSpentEther;
429     mapping(address => uint256) public addressToPurchasedTokens;
430     
431     function TALLY() public
432     {
433         owner = 0xd512fa9Ca3DF0a2145e77B445579D4210380A635;
434         developmentFundAddress = 0x4D18700A05D92ae5e49724f13457e1959329e80e;
435         foundationAddress = 0xf1A2e7a164EF56807105ba198ef8F2465B682B16;
436         
437         balances[developmentFundAddress] = 300000000 * (uint256(10)**decimals);
438         Transfer(0x0, developmentFundAddress, balances[developmentFundAddress]);
439         
440         balances[this] = 1000000000 * (uint256(10)**decimals);
441         Transfer(0x0, this, balances[this]);
442         
443         totalSupply_ = balances[this] + balances[developmentFundAddress];
444         
445         preSaleTLYperETH = 30000;
446         preferredSaleTLYperETH = 25375;
447         mainSaleTLYperETH = 20000;
448         
449         preSaleStartTime = 1518652800;
450         preSaleEndTime = 1519516800; // 15 february 2018 - 25 february 2018
451         
452         preferredSaleStartTime = 1519862400;
453         preferredSaleEndTime = 1521072000; // 01 march 2018 - 15 march 2018
454         
455         mainSaleStartTime = 1521504000;
456         mainSaleEndTime = 1526774400; // 20 march 2018 - 20 may 2018
457         
458         tokenSaleEnabled = true;
459         
460         developmentFundUnlockTime = now + DEVELOPMENT_FUND_LOCK_TIMESPAN;
461     }
462     
463     function () payable external
464     {
465         require(tokenSaleEnabled);
466         
467         require(msg.value >= minimumAmountToParticipate);
468         
469         uint256 tokensPurchased;
470         if (now >= preSaleStartTime && now < preSaleEndTime)
471         {
472             tokensPurchased = msg.value.mul(preSaleTLYperETH);
473             preSaleTokensLeftForSale = preSaleTokensLeftForSale.sub(tokensPurchased);
474         }
475         else if (now >= preferredSaleStartTime && now < preferredSaleEndTime)
476         {
477             tokensPurchased = msg.value.mul(preferredSaleTLYperETH);
478             preferredSaleTokensLeftForSale = preferredSaleTokensLeftForSale.sub(tokensPurchased);
479         }
480         else if (now >= mainSaleStartTime && now < mainSaleEndTime)
481         {
482             tokensPurchased = msg.value.mul(mainSaleTLYperETH);
483         }
484         else
485         {
486             revert();
487         }
488         
489         addressToSpentEther[msg.sender] = addressToSpentEther[msg.sender].add(msg.value);
490         addressToPurchasedTokens[msg.sender] = addressToPurchasedTokens[msg.sender].add(tokensPurchased);
491         
492         this.transfer(msg.sender, tokensPurchased);
493     }
494     
495     function refund() external
496     {
497         // Only allow refunds before the main sale has ended
498         require(now < mainSaleEndTime);
499         
500         uint256 tokensRefunded = addressToPurchasedTokens[msg.sender];
501         uint256 etherRefunded = addressToSpentEther[msg.sender];
502         addressToPurchasedTokens[msg.sender] = 0;
503         addressToSpentEther[msg.sender] = 0;
504         
505         // Send the tokens back to this contract
506         balances[msg.sender] = balances[msg.sender].sub(tokensRefunded);
507         balances[this] = balances[this].add(tokensRefunded);
508         Transfer(msg.sender, this, tokensRefunded);
509         
510         // Add the tokens back to the pre-sale or preferred sale
511         if (now < preSaleEndTime)
512         {
513             preSaleTokensLeftForSale = preSaleTokensLeftForSale.add(tokensRefunded);
514         }
515         else if (now < preferredSaleEndTime)
516         {
517             preferredSaleTokensLeftForSale = preferredSaleTokensLeftForSale.add(tokensRefunded);
518         }
519         
520         // Send the ether back to the user
521         msg.sender.transfer(etherRefunded);
522     }
523     
524     // Prevent the development fund from transferring its tokens while they are locked
525     function transfer(address _to, uint256 _value) public returns (bool)
526     {
527         if (msg.sender == developmentFundAddress && now < developmentFundUnlockTime) revert();
528         super.transfer(_to, _value);
529     }
530     function transfer(address _to, uint256 _value, bytes _data) public returns (bool)
531     {
532         if (msg.sender == developmentFundAddress && now < developmentFundUnlockTime) revert();
533         super.transfer(_to, _value, _data);
534     }
535     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
536     {
537         if (_from == developmentFundAddress && now < developmentFundUnlockTime) revert();
538         super.transferFrom(_from, _to, _value);
539     }
540     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool)
541     {
542         if (_from == developmentFundAddress && now < developmentFundUnlockTime) revert();
543         super.transferFrom(_from, _to, _value, _data);
544     }
545     
546     // Allow the owner to retrieve all the collected ETH
547     function drain() external onlyOwner
548     {
549         owner.transfer(this.balance);
550     }
551     
552     // Allow the owner to enable or disable the token sale at any time.
553     function enableTokenSale() external onlyOwner
554     {
555         tokenSaleEnabled = true;
556     }
557     function disableTokenSale() external onlyOwner
558     {
559         tokenSaleEnabled = false;
560     }
561     
562     function moveUnsoldTokensToFoundation() external onlyOwner
563     {
564         this.transfer(foundationAddress, balances[this]);
565     }
566     
567     // Pre-sale configuration
568     function setPreSaleTLYperETH(uint256 _newTLYperETH) public onlyOwner
569     {
570         preSaleTLYperETH = _newTLYperETH;
571     }
572     function setPreSaleStartAndEndTime(uint256 _newStartTime, uint256 _newEndTime) public onlyOwner
573     {
574         preSaleStartTime = _newStartTime;
575         preSaleEndTime = _newEndTime;
576     }
577     
578     // Preferred sale configuration
579     function setPreferredSaleTLYperETH(uint256 _newTLYperETH) public onlyOwner
580     {
581         preferredSaleTLYperETH = _newTLYperETH;
582     }
583     function setPreferredSaleStartAndEndTime(uint256 _newStartTime, uint256 _newEndTime) public onlyOwner
584     {
585         preferredSaleStartTime = _newStartTime;
586         preferredSaleEndTime = _newEndTime;
587     }
588     
589     // Main sale configuration
590     function setMainSaleTLYperETH(uint256 _newTLYperETH) public onlyOwner
591     {
592         mainSaleTLYperETH = _newTLYperETH;
593     }
594     function setMainSaleStartAndEndTime(uint256 _newStartTime, uint256 _newEndTime) public onlyOwner
595     {
596         mainSaleStartTime = _newStartTime;
597         mainSaleEndTime = _newEndTime;
598     }
599 }