1 pragma solidity ^0.4.18;
2 
3 
4 //>> Reference to https://github.com/Arachnid/solidity-stringutils
5 
6 library strings {
7     struct slice {
8         uint _len;
9         uint _ptr;
10     }
11     
12     /*
13      * @dev Returns a slice containing the entire string.
14      * @param self The string to make a slice from.
15      * @return A newly allocated slice containing the entire string.
16      */
17     function toSlice(string self) internal pure returns (slice) {
18         uint ptr;
19         assembly {
20             ptr := add(self, 0x20)
21         }
22         return slice(bytes(self).length, ptr);
23     }
24     
25     /*
26      * @dev Returns true if the slice is empty (has a length of 0).
27      * @param self The slice to operate on.
28      * @return True if the slice is empty, False otherwise.
29      */
30     function empty(slice self) internal pure returns (bool) {
31         return self._len == 0;
32     }
33 }
34 
35 //<< Reference to https://github.com/Arachnid/solidity-stringutils
36 
37 
38 
39 
40 //>> Reference to https://github.com/OpenZeppelin/zeppelin-solidity
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, throws on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     if (a == 0) {
53       return 0;
54     }
55     uint256 c = a * b;
56     assert(c / a == b);
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers, truncating the quotient.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   /**
71   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   /**
79   * @dev Adds two numbers, throws on overflow.
80   */
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 /**
115  * @title SafeERC20
116  * @dev Wrappers around ERC20 operations that throw on failure.
117  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
118  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
119  */
120 library SafeERC20 {
121   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
122     assert(token.transfer(to, value));
123   }
124 
125   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
126     assert(token.transferFrom(from, to, value));
127   }
128 
129   function safeApprove(ERC20 token, address spender, uint256 value) internal {
130     assert(token.approve(spender, value));
131   }
132 }
133 
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) balances;
143 
144   uint256 totalSupply_;
145 
146   /**
147   * @dev total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is ERC20, BasicToken {
189 
190   mapping (address => mapping (address => uint256)) internal allowed;
191 
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(_value <= balances[_from]);
202     require(_value <= allowed[_from][msg.sender]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public view returns (uint256) {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _addedValue The amount of tokens to increase the allowance by.
246    */
247   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   /**
254    * @dev Decrease the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To decrement
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _subtractedValue The amount of tokens to decrease the allowance by.
262    */
263   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264     uint oldValue = allowed[msg.sender][_spender];
265     if (_subtractedValue > oldValue) {
266       allowed[msg.sender][_spender] = 0;
267     } else {
268       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269     }
270     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274 }
275 
276 
277 /**
278    @title ERC827 interface, an extension of ERC20 token standard
279    Interface of a ERC827 token, following the ERC20 standard with extra
280    methods to transfer value and data and execute calls in transfers and
281    approvals.
282  */
283 contract ERC827 is ERC20 {
284 
285   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
286   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
287   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
288 
289 }
290 
291 
292 /**
293    @title ERC827, an extension of ERC20 token standard
294    Implementation the ERC827, following the ERC20 standard with extra
295    methods to transfer value and data and execute calls in transfers and
296    approvals.
297    Uses OpenZeppelin StandardToken.
298  */
299 contract ERC827Token is ERC827, StandardToken {
300 
301   /**
302      @dev Addition to ERC20 token methods. It allows to
303      approve the transfer of value and execute a call with the sent data.
304      Beware that changing an allowance with this method brings the risk that
305      someone may use both the old and the new allowance by unfortunate
306      transaction ordering. One possible solution to mitigate this race condition
307      is to first reduce the spender's allowance to 0 and set the desired value
308      afterwards:
309      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310      @param _spender The address that will spend the funds.
311      @param _value The amount of tokens to be spent.
312      @param _data ABI-encoded contract call to call `_to` address.
313      @return true if the call function was executed successfully
314    */
315   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
316     require(_spender != address(this));
317 
318     super.approve(_spender, _value);
319 
320     require(_spender.call(_data));
321 
322     return true;
323   }
324 
325   /**
326      @dev Addition to ERC20 token methods. Transfer tokens to a specified
327      address and execute a call with the sent data on the same transaction
328      @param _to address The address which you want to transfer to
329      @param _value uint256 the amout of tokens to be transfered
330      @param _data ABI-encoded contract call to call `_to` address.
331      @return true if the call function was executed successfully
332    */
333   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
334     require(_to != address(this));
335 
336     super.transfer(_to, _value);
337 
338     require(_to.call(_data));
339     return true;
340   }
341 
342   /**
343      @dev Addition to ERC20 token methods. Transfer tokens from one address to
344      another and make a contract call on the same transaction
345      @param _from The address which you want to send tokens from
346      @param _to The address which you want to transfer to
347      @param _value The amout of tokens to be transferred
348      @param _data ABI-encoded contract call to call `_to` address.
349      @return true if the call function was executed successfully
350    */
351   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
352     require(_to != address(this));
353 
354     super.transferFrom(_from, _to, _value);
355 
356     require(_to.call(_data));
357     return true;
358   }
359 
360   /**
361    * @dev Addition to StandardToken methods. Increase the amount of tokens that
362    * an owner allowed to a spender and execute a call with the sent data.
363    *
364    * approve should be called when allowed[_spender] == 0. To increment
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _addedValue The amount of tokens to increase the allowance by.
370    * @param _data ABI-encoded contract call to call `_spender` address.
371    */
372   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
373     require(_spender != address(this));
374 
375     super.increaseApproval(_spender, _addedValue);
376 
377     require(_spender.call(_data));
378 
379     return true;
380   }
381 
382   /**
383    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
384    * an owner allowed to a spender and execute a call with the sent data.
385    *
386    * approve should be called when allowed[_spender] == 0. To decrement
387    * allowed value is better to use this function to avoid 2 calls (and wait until
388    * the first transaction is mined)
389    * From MonolithDAO Token.sol
390    * @param _spender The address which will spend the funds.
391    * @param _subtractedValue The amount of tokens to decrease the allowance by.
392    * @param _data ABI-encoded contract call to call `_spender` address.
393    */
394   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
395     require(_spender != address(this));
396 
397     super.decreaseApproval(_spender, _subtractedValue);
398 
399     require(_spender.call(_data));
400 
401     return true;
402   }
403 
404 }
405 
406 //<< Reference to https://github.com/OpenZeppelin/zeppelin-solidity
407 
408 
409 
410 
411 /**
412  * @title MultiOwnable
413  */
414 contract MultiOwnable {
415     address public root;
416     mapping (address => address) public owners; // owner => parent of owner
417     
418     /**
419     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
420     * account.
421     */
422     function MultiOwnable() public {
423         root= msg.sender;
424         owners[root]= root;
425     }
426     
427     /**
428     * @dev Throws if called by any account other than the owner.
429     */
430     modifier onlyOwner() {
431         require(owners[msg.sender] != 0);
432         _;
433     }
434     
435     /**
436     * @dev Adding new owners
437     */
438     function newOwner(address _owner) onlyOwner public returns (bool) {
439         require(_owner != 0);
440         owners[_owner]= msg.sender;
441         return true;
442     }
443     
444     /**
445      * @dev Deleting owners
446      */
447     function deleteOwner(address _owner) onlyOwner public returns (bool) {
448         require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
449         owners[_owner]= 0;
450         return true;
451     }
452 }
453 
454 
455 /**
456  * @title KStarCoinBasic
457  */
458 contract KStarCoinBasic is ERC827Token, MultiOwnable {
459     using SafeMath for uint256;
460     using SafeERC20 for ERC20Basic;
461     using strings for *;
462 
463     // KStarCoin Distribution
464     // - Crowdsale : 9%(softcap) ~ 45%(hardcap)
465     // - Reserve: 15%
466     // - Team: 10%
467     // - Advisors & Partners: 5%
468     // - Bounty Program + Ecosystem : 25% ~ 61%
469     uint256 public capOfTotalSupply;
470     uint256 public constant INITIAL_SUPPLY= 30e6 * 1 ether; // Reserve(15) + Team(10) + Advisors&Patners(5)
471 
472     uint256 public crowdsaleRaised;
473     uint256 public constant CROWDSALE_HARDCAP= 45e6 * 1 ether; // Crowdsale(Max 45)
474 
475     /**
476      * @dev Function to increase capOfTotalSupply in the next phase of KStarCoin's ecosystem
477      */
478     function increaseCap(uint256 _addedValue) onlyOwner public returns (bool) {
479         require(_addedValue >= 100e6 * 1 ether);
480         capOfTotalSupply = capOfTotalSupply.add(_addedValue);
481         return true;
482     }
483     
484     /**
485      * @dev Function to check whether the current supply exceeds capOfTotalSupply
486      */
487     function checkCap(uint256 _amount) public view returns (bool) {
488         return (totalSupply_.add(_amount) <= capOfTotalSupply);
489     }
490     
491     //> for ERC20
492     function transfer(address _to, uint256 _value) public returns (bool) {
493         require(super.transfer(_to, _value));
494         KSC_Send(msg.sender, _to, _value, "");
495         KSC_Receive(_to, msg.sender, _value, "");
496         return true;
497     }
498     
499     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
500         require(super.transferFrom(_from, _to, _value));
501         KSC_SendTo(_from, _to, _value, "");
502         KSC_ReceiveFrom(_to, _from, _value, "");
503         return true;
504     }
505     
506     function approve(address _to, uint256 _value) public returns (bool) {
507         require(super.approve(_to, _value));
508         KSC_Approve(msg.sender, _to, _value, "");
509         return true;
510     }
511     
512     // additional StandardToken method of zeppelin-solidity
513     function increaseApproval(address _to, uint _addedValue) public returns (bool) {
514         require(super.increaseApproval(_to, _addedValue));
515         KSC_ApprovalInc(msg.sender, _to, _addedValue, "");
516         return true;
517     }
518     
519     // additional StandardToken method of zeppelin-solidity
520     function decreaseApproval(address _to, uint _subtractedValue) public returns (bool) {
521         require(super.decreaseApproval(_to, _subtractedValue));
522         KSC_ApprovalDec(msg.sender, _to, _subtractedValue, "");
523         return true;
524     }
525 	//<
526     
527     //> for ERC827
528     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
529         return transfer(_to, _value, _data, "");
530     }
531     
532     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
533         return transferFrom(_from, _to, _value, _data, "");
534     }
535     
536     function approve(address _to, uint256 _value, bytes _data) public returns (bool) {
537         return approve(_to, _value, _data, "");
538     }
539     
540     // additional StandardToken method of zeppelin-solidity
541     function increaseApproval(address _to, uint _addedValue, bytes _data) public returns (bool) {
542         return increaseApproval(_to, _addedValue, _data, "");
543     }
544     
545     // additional StandardToken method of zeppelin-solidity
546     function decreaseApproval(address _to, uint _subtractedValue, bytes _data) public returns (bool) {
547         return decreaseApproval(_to, _subtractedValue, _data, "");
548     }
549 	//<
550     
551     //> notation for ERC827
552     function transfer(address _to, uint256 _value, bytes _data, string _note) public returns (bool) {
553         require(super.transfer(_to, _value, _data));
554         KSC_Send(msg.sender, _to, _value, _note);
555         KSC_Receive(_to, msg.sender, _value, _note);
556         return true;
557     }
558     
559     function transferFrom(address _from, address _to, uint256 _value, bytes _data, string _note) public returns (bool) {
560         require(super.transferFrom(_from, _to, _value, _data));
561         KSC_SendTo(_from, _to, _value, _note);
562         KSC_ReceiveFrom(_to, _from, _value, _note);
563         return true;
564     }
565     
566     function approve(address _to, uint256 _value, bytes _data, string _note) public returns (bool) {
567         require(super.approve(_to, _value, _data));
568         KSC_Approve(msg.sender, _to, _value, _note);
569         return true;
570     }
571     
572     function increaseApproval(address _to, uint _addedValue, bytes _data, string _note) public returns (bool) {
573         require(super.increaseApproval(_to, _addedValue, _data));
574         KSC_ApprovalInc(msg.sender, _to, _addedValue, _note);
575         return true;
576     }
577     
578     function decreaseApproval(address _to, uint _subtractedValue, bytes _data, string _note) public returns (bool) {
579         require(super.decreaseApproval(_to, _subtractedValue, _data));
580         KSC_ApprovalDec(msg.sender, _to, _subtractedValue, _note);
581         return true;
582     }
583 	//<
584       
585     /**
586      * @dev Function to mint coins
587      * @param _to The address that will receive the minted coins.
588      * @param _amount The amount of coins to mint.
589      * @return A boolean that indicates if the operation was successful.
590      * @dev reference : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/MintableToken.sol
591      */
592     function mint(address _to, uint256 _amount) onlyOwner internal returns (bool) {
593         require(_to != address(0));
594         require(checkCap(_amount));
595 
596         totalSupply_= totalSupply_.add(_amount);
597         balances[_to]= balances[_to].add(_amount);
598 
599         Transfer(address(0), _to, _amount);
600         return true;
601     }
602     
603     /**
604      * @dev Function to mint coins
605      * @param _to The address that will receive the minted coins.
606      * @param _amount The amount of coins to mint.
607      * @param _note The notation for ethereum blockchain event log system
608      * @return A boolean that indicates if the operation was successful.
609      * @dev reference : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/MintableToken.sol
610      */
611     function mint(address _to, uint256 _amount, string _note) onlyOwner public returns (bool) {
612         require(mint(_to, _amount));
613         KSC_Mint(_to, msg.sender, _amount, _note);
614         return true;
615     }
616 
617     /**
618      * @dev Burns a specific amount of coins.
619      * @param _to The address that will be burned the coins.
620      * @param _amount The amount of coins to be burned.
621      * @return A boolean that indicates if the operation was successful.
622      * @dev reference : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
623      */
624     function burn(address _to, uint256 _amount) onlyOwner internal returns (bool) {
625         require(_to != address(0));
626         require(_amount <= balances[msg.sender]);
627 
628         balances[_to]= balances[_to].sub(_amount);
629         totalSupply_= totalSupply_.sub(_amount);
630         
631         return true;
632     }
633     
634     /**
635      * @dev Burns a specific amount of coins.
636      * @param _to The address that will be burned the coins.
637      * @param _amount The amount of coins to be burned.
638      * @param _note The notation for ethereum blockchain event log system
639      * @return A boolean that indicates if the operation was successful.
640      * @dev reference : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
641      */
642     function burn(address _to, uint256 _amount, string _note) onlyOwner public returns (bool) {
643         require(burn(_to, _amount));
644         KSC_Burn(_to, msg.sender, _amount, _note);
645         return true;
646     }
647     
648     // for crowdsale
649     /**
650      * @dev Function which allows users to buy KStarCoin during the crowdsale period
651      * @param _to The address that will receive the coins.
652      * @param _value The amount of coins to sell.
653      * @param _note The notation for ethereum blockchain event log system
654      * @return A boolean that indicates if the operation was successful.
655      */
656     function sell(address _to, uint256 _value, string _note) onlyOwner public returns (bool) {
657         require(crowdsaleRaised.add(_value) <= CROWDSALE_HARDCAP);
658         require(mint(_to, _value));
659         
660         crowdsaleRaised= crowdsaleRaised.add(_value);
661         KSC_Buy(_to, msg.sender, _value, _note);
662         return true;
663     }
664     
665     // for buyer with cryptocurrency other than ETH
666     /**
667      * @dev This function is occured when owner mint coins to users as they buy with cryptocurrency other than ETH.
668      * @param _to The address that will receive the coins.
669      * @param _value The amount of coins to mint.
670      * @param _note The notation for ethereum blockchain event log system
671      * @return A boolean that indicates if the operation was successful.
672      */
673     function mintToOtherCoinBuyer(address _to, uint256 _value, string _note) onlyOwner public returns (bool) {
674         require(mint(_to, _value));
675         KSC_BuyOtherCoin(_to, msg.sender, _value, _note);
676         return true;
677     }
678   
679     // for bounty program
680     /**
681      * @dev Function to reward influencers with KStarCoin
682      * @param _to The address that will receive the coins.
683      * @param _value The amount of coins to mint.
684      * @param _note The notation for ethereum blockchain event log system
685      * @return A boolean that indicates if the operation was successful.
686      */
687     function mintToInfluencer(address _to, uint256 _value, string _note) onlyOwner public returns (bool) {
688         require(mint(_to, _value));
689         KSC_GetAsInfluencer(_to, msg.sender, _value, _note);
690         return true;
691     }
692     
693     // for KSCPoint (KStarLive ecosystem point)
694     /**
695      * @dev Function to exchange KSCPoint to KStarCoin
696      * @param _to The address that will receive the coins.
697      * @param _value The amount of coins to mint.
698      * @param _note The notation for ethereum blockchain event log system
699      * @return A boolean that indicates if the operation was successful.
700      */
701     function exchangePointToCoin(address _to, uint256 _value, string _note) onlyOwner public returns (bool) {
702         require(mint(_to, _value));
703         KSC_ExchangePointToCoin(_to, msg.sender, _value, _note);
704         return true;
705     }
706     
707     // Event functions to log the notation for ethereum blockchain 
708     // for initializing
709     event KSC_Initialize(address indexed _src, address indexed _desc, uint256 _value, string _note);
710     
711     // for transfer()
712     event KSC_Send(address indexed _src, address indexed _desc, uint256 _value, string _note);
713     event KSC_Receive(address indexed _src, address indexed _desc, uint256 _value, string _note);
714     
715     // for approve(), increaseApproval(), decreaseApproval()
716     event KSC_Approve(address indexed _src, address indexed _desc, uint256 _value, string _note);
717     event KSC_ApprovalInc(address indexed _src, address indexed _desc, uint256 _value, string _note);
718     event KSC_ApprovalDec(address indexed _src, address indexed _desc, uint256 _value, string _note);
719     
720     // for transferFrom()
721     event KSC_SendTo(address indexed _src, address indexed _desc, uint256 _value, string _note);
722     event KSC_ReceiveFrom(address indexed _src, address indexed _desc, uint256 _value, string _note);
723     
724     // for mint(), burn()
725     event KSC_Mint(address indexed _src, address indexed _desc, uint256 _value, string _note);
726     event KSC_Burn(address indexed _src, address indexed _desc, uint256 _value, string _note);
727     
728     // for crowdsale
729     event KSC_Buy(address indexed _src, address indexed _desc, uint256 _value, string _note);
730     
731     // for buyer with cryptocurrency other than ETH
732     event KSC_BuyOtherCoin(address indexed _src, address indexed _desc, uint256 _value, string _note);
733     
734     // for bounty program
735     event KSC_GetAsInfluencer(address indexed _src, address indexed _desc, uint256 _value, string _note);
736 
737     // for KSCPoint (KStarLive ecosystem point)
738     event KSC_ExchangePointToCoin(address indexed _src, address indexed _desc, uint256 _value, string _note);
739 }
740 
741 
742 /**
743  * @title KStarCoin v1.0
744  * @author Tae Kim
745  * @notice KStarCoin is an ERC20 (with an alternative of ERC827) Ethereum based token, which will be integrated in KStarLive platform.
746  */
747 contract KStarCoin is KStarCoinBasic {
748     string public constant name= "KStarCoin";
749     string public constant symbol= "KSC";
750     uint8 public constant decimals= 18;
751     
752     // Constructure
753     function KStarCoin() public {
754         totalSupply_= INITIAL_SUPPLY;
755         balances[msg.sender]= INITIAL_SUPPLY;
756 	    capOfTotalSupply = 100e6 * 1 ether;
757         crowdsaleRaised= 0;
758         
759         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
760         KSC_Initialize(msg.sender, 0x0, INITIAL_SUPPLY, "");
761     }
762 }