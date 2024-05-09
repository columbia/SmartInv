1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * approve should be called when allowed[_spender] == 0. To increment
151    * allowed value is better to use this function to avoid 2 calls (and wait until
152    * the first transaction is mined)
153    * From MonolithDAO Token.sol
154    */
155   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 
174 /**
175  * @title Burnable Token
176  * @dev Token that can be irreversibly burned (destroyed).
177  */
178 contract BurnableToken is StandardToken {
179 
180     event Burn(address indexed burner, uint256 value);
181 
182     /**
183      * @dev Burns a specific amount of tokens.
184      * @param _value The amount of token to be burned.
185      */
186     function burn(uint256 _value) public {
187         require(_value > 0);
188         require(_value <= balances[msg.sender]);
189         // no need to require value <= totalSupply, since that would imply the
190         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
191 
192         address burner = msg.sender;
193         balances[burner] = balances[burner].sub(_value);
194         totalSupply = totalSupply.sub(_value);
195         Burn(burner, _value);
196     }
197 }
198 
199 /**
200  * @title Ownable
201  * @dev The Ownable contract has an owner address, and provides basic authorization control
202  * functions, this simplifies the implementation of "user permissions".
203  */
204 contract Ownable {
205   address public owner;
206 
207 
208   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210 
211   /**
212    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
213    * account.
214    */
215   function Ownable() public {
216     owner = msg.sender;
217   }
218 
219 
220   /**
221    * @dev Throws if called by any account other than the owner.
222    */
223   modifier onlyOwner() {
224     require(msg.sender == owner);
225     _;
226   }
227 
228 
229   /**
230    * @dev Allows the current owner to transfer control of the contract to a newOwner.
231    * @param newOwner The address to transfer ownership to.
232    */
233   function transferOwnership(address newOwner) public onlyOwner {
234     require(newOwner != address(0));
235     OwnershipTransferred(owner, newOwner);
236     owner = newOwner;
237   }
238 
239 }
240 
241 contract CHXToken is BurnableToken, Ownable {
242     string public constant name = "Chainium";
243     string public constant symbol = "CHX";
244     uint8 public constant decimals = 18;
245 
246     bool public isRestricted = true;
247     address public tokenSaleContractAddress;
248 
249     function CHXToken()
250         public
251     {
252         totalSupply = 200000000e18;
253         balances[owner] = totalSupply;
254         Transfer(address(0), owner, totalSupply);
255     }
256 
257     function setTokenSaleContractAddress(address _tokenSaleContractAddress)
258         external
259         onlyOwner
260     {
261         require(_tokenSaleContractAddress != address(0));
262         tokenSaleContractAddress = _tokenSaleContractAddress;
263     }
264 
265 
266     ////////////////////////////////////////////////////////////////////////////////////////////////////
267     // Transfer Restriction
268     ////////////////////////////////////////////////////////////////////////////////////////////////////
269 
270     function setRestrictedState(bool _isRestricted)
271         external
272         onlyOwner
273     {
274         isRestricted = _isRestricted;
275     }
276 
277     modifier restricted() {
278         if (isRestricted) {
279             require(
280                 msg.sender == owner ||
281                 (msg.sender == tokenSaleContractAddress && tokenSaleContractAddress != address(0))
282             );
283         }
284         _;
285     }
286 
287 
288     ////////////////////////////////////////////////////////////////////////////////////////////////////
289     // Transfers
290     ////////////////////////////////////////////////////////////////////////////////////////////////////
291 
292     function transfer(address _to, uint _value)
293         public
294         restricted
295         returns (bool)
296     {
297         require(_to != address(this));
298         return super.transfer(_to, _value);
299     }
300 
301     function transferFrom(address _from, address _to, uint _value)
302         public
303         restricted
304         returns (bool)
305     {
306         require(_to != address(this));
307         return super.transferFrom(_from, _to, _value);
308     }
309 
310     function approve(address _spender, uint _value)
311         public
312         restricted
313         returns (bool)
314     {
315         return super.approve(_spender, _value);
316     }
317 
318     function increaseApproval(address _spender, uint _addedValue)
319         public
320         restricted
321         returns (bool success)
322     {
323         return super.increaseApproval(_spender, _addedValue);
324     }
325 
326     function decreaseApproval(address _spender, uint _subtractedValue)
327         public
328         restricted
329         returns (bool success)
330     {
331         return super.decreaseApproval(_spender, _subtractedValue);
332     }
333 
334 
335     ////////////////////////////////////////////////////////////////////////////////////////////////////
336     // Batch transfers
337     ////////////////////////////////////////////////////////////////////////////////////////////////////
338 
339     function batchTransfer(address[] _recipients, uint[] _values)
340         external
341         returns (bool)
342     {
343         require(_recipients.length == _values.length);
344 
345         for (uint i = 0; i < _values.length; i++) {
346             require(transfer(_recipients[i], _values[i]));
347         }
348 
349         return true;
350     }
351 
352     function batchTransferFrom(address _from, address[] _recipients, uint[] _values)
353         external
354         returns (bool)
355     {
356         require(_recipients.length == _values.length);
357 
358         for (uint i = 0; i < _values.length; i++) {
359             require(transferFrom(_from, _recipients[i], _values[i]));
360         }
361 
362         return true;
363     }
364 
365     function batchTransferFromMany(address[] _senders, address _to, uint[] _values)
366         external
367         returns (bool)
368     {
369         require(_senders.length == _values.length);
370 
371         for (uint i = 0; i < _values.length; i++) {
372             require(transferFrom(_senders[i], _to, _values[i]));
373         }
374 
375         return true;
376     }
377 
378     function batchTransferFromManyToMany(address[] _senders, address[] _recipients, uint[] _values)
379         external
380         returns (bool)
381     {
382         require(_senders.length == _recipients.length);
383         require(_senders.length == _values.length);
384 
385         for (uint i = 0; i < _values.length; i++) {
386             require(transferFrom(_senders[i], _recipients[i], _values[i]));
387         }
388 
389         return true;
390     }
391 
392     function batchApprove(address[] _spenders, uint[] _values)
393         external
394         returns (bool)
395     {
396         require(_spenders.length == _values.length);
397 
398         for (uint i = 0; i < _values.length; i++) {
399             require(approve(_spenders[i], _values[i]));
400         }
401 
402         return true;
403     }
404 
405     function batchIncreaseApproval(address[] _spenders, uint[] _addedValues)
406         external
407         returns (bool)
408     {
409         require(_spenders.length == _addedValues.length);
410 
411         for (uint i = 0; i < _addedValues.length; i++) {
412             require(increaseApproval(_spenders[i], _addedValues[i]));
413         }
414 
415         return true;
416     }
417 
418     function batchDecreaseApproval(address[] _spenders, uint[] _subtractedValues)
419         external
420         returns (bool)
421     {
422         require(_spenders.length == _subtractedValues.length);
423 
424         for (uint i = 0; i < _subtractedValues.length; i++) {
425             require(decreaseApproval(_spenders[i], _subtractedValues[i]));
426         }
427 
428         return true;
429     }
430 
431 
432     ////////////////////////////////////////////////////////////////////////////////////////////////////
433     // Miscellaneous
434     ////////////////////////////////////////////////////////////////////////////////////////////////////
435 
436     function burn(uint _value)
437         public
438         onlyOwner
439     {
440         super.burn(_value);
441     }
442 
443     // Enable recovery of ether sent by mistake to this contract's address.
444     function drainStrayEther(uint _amount)
445         external
446         onlyOwner
447         returns (bool)
448     {
449         owner.transfer(_amount);
450         return true;
451     }
452 
453     // Enable recovery of any ERC20 compatible token, sent by mistake to this contract's address.
454     function drainStrayTokens(ERC20Basic _token, uint _amount)
455         external
456         onlyOwner
457         returns (bool)
458     {
459         return _token.transfer(owner, _amount);
460     }
461 }
462 
463 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
464 
465 contract Whitelistable is Ownable {
466 
467     mapping (address => bool) whitelist;
468     address public whitelistAdmin;
469 
470     function Whitelistable()
471         public
472     {
473         whitelistAdmin = owner; // Owner fulfils the role of the admin initially, until new admin is set.
474     }
475 
476     modifier onlyOwnerOrWhitelistAdmin() {
477         require(msg.sender == owner || msg.sender == whitelistAdmin);
478         _;
479     }
480 
481     modifier onlyWhitelisted() {
482         require(whitelist[msg.sender]);
483         _;
484     }
485 
486     function isWhitelisted(address _address)
487         external
488         view
489         returns (bool)
490     {
491         return whitelist[_address];
492     }
493 
494     function addToWhitelist(address[] _addresses)
495         external
496         onlyOwnerOrWhitelistAdmin
497     {
498         for (uint i = 0; i < _addresses.length; i++) {
499             whitelist[_addresses[i]] = true;
500         }
501     }
502 
503     function removeFromWhitelist(address[] _addresses)
504         external
505         onlyOwnerOrWhitelistAdmin
506     {
507         for (uint i = 0; i < _addresses.length; i++) {
508             whitelist[_addresses[i]] = false;
509         }
510     }
511 
512     function setWhitelistAdmin(address _newAdmin)
513         public
514         onlyOwnerOrWhitelistAdmin
515     {
516         require(_newAdmin != address(0));
517         whitelistAdmin = _newAdmin;
518     }
519 }
520 
521 contract CHXTokenSale is Whitelistable {
522     using SafeMath for uint;
523 
524     event TokenPurchased(address indexed investor, uint contribution, uint tokens);
525 
526     uint public constant TOKEN_PRICE = 170 szabo; // Assumes token has 18 decimals
527 
528     uint public saleStartTime;
529     uint public saleEndTime;
530     uint public maxGasPrice = 20e9 wei; // 20 GWEI - to prevent "gas race"
531     uint public minContribution = 100 finney; // 0.1 ETH
532     uint public maxContributionPhase1 = 500 finney; // 0.5 ETH
533     uint public maxContributionPhase2 = 10 ether;
534     uint public phase1DurationInHours = 24;
535 
536     CHXToken public tokenContract;
537 
538     mapping (address => uint) public etherContributions;
539     mapping (address => uint) public tokenAllocations;
540     uint public etherCollected;
541     uint public tokensSold;
542 
543     function CHXTokenSale()
544         public
545     {
546     }
547 
548     function setTokenContract(address _tokenContractAddress)
549         external
550         onlyOwner
551     {
552         require(_tokenContractAddress != address(0));
553         tokenContract = CHXToken(_tokenContractAddress);
554         require(tokenContract.decimals() == 18); // Calculations assume 18 decimals (1 ETH = 10^18 WEI)
555     }
556 
557     function transferOwnership(address newOwner)
558         public
559         onlyOwner
560     {
561         require(newOwner != owner);
562 
563         if (whitelistAdmin == owner) {
564             setWhitelistAdmin(newOwner);
565         }
566 
567         super.transferOwnership(newOwner);
568     }
569 
570 
571     ////////////////////////////////////////////////////////////////////////////////////////////////////
572     // Sale
573     ////////////////////////////////////////////////////////////////////////////////////////////////////
574 
575     function()
576         public
577         payable
578     {
579         address investor = msg.sender;
580         uint contribution = msg.value;
581 
582         require(saleStartTime <= now && now <= saleEndTime);
583         require(tx.gasprice <= maxGasPrice);
584         require(whitelist[investor]);
585         require(contribution >= minContribution);
586         if (phase1DurationInHours.mul(1 hours).add(saleStartTime) >= now) {
587             require(etherContributions[investor].add(contribution) <= maxContributionPhase1);
588         } else {
589             require(etherContributions[investor].add(contribution) <= maxContributionPhase2);
590         }
591 
592         etherContributions[investor] = etherContributions[investor].add(contribution);
593         etherCollected = etherCollected.add(contribution);
594 
595         uint multiplier = 1e18; // 18 decimal places
596         uint tokens = contribution.mul(multiplier).div(TOKEN_PRICE);
597         tokenAllocations[investor] = tokenAllocations[investor].add(tokens);
598         tokensSold = tokensSold.add(tokens);
599 
600         require(tokenContract.transfer(investor, tokens));
601         TokenPurchased(investor, contribution, tokens);
602     }
603 
604     function sendCollectedEther(address _recipient)
605         external
606         onlyOwner
607     {
608         if (this.balance > 0) {
609             _recipient.transfer(this.balance);
610         }
611     }
612 
613     function sendRemainingTokens(address _recipient)
614         external
615         onlyOwner
616     {
617         uint unsoldTokens = tokenContract.balanceOf(this);
618         if (unsoldTokens > 0) {
619             require(tokenContract.transfer(_recipient, unsoldTokens));
620         }
621     }
622 
623 
624     ////////////////////////////////////////////////////////////////////////////////////////////////////
625     // Configuration
626     ////////////////////////////////////////////////////////////////////////////////////////////////////
627 
628     function setSaleTime(uint _newStartTime, uint _newEndTime)
629         external
630         onlyOwner
631     {
632         require(_newStartTime <= _newEndTime);
633         saleStartTime = _newStartTime;
634         saleEndTime = _newEndTime;
635     }
636 
637     function setMaxGasPrice(uint _newMaxGasPrice)
638         external
639         onlyOwner
640     {
641         require(_newMaxGasPrice > 0);
642         maxGasPrice = _newMaxGasPrice;
643     }
644 
645     function setMinContribution(uint _newMinContribution)
646         external
647         onlyOwner
648     {
649         require(_newMinContribution > 0);
650         minContribution = _newMinContribution;
651     }
652 
653     function setMaxContributionPhase1(uint _newMaxContributionPhase1)
654         external
655         onlyOwner
656     {
657         require(_newMaxContributionPhase1 > minContribution);
658         maxContributionPhase1 = _newMaxContributionPhase1;
659     }
660 
661     function setMaxContributionPhase2(uint _newMaxContributionPhase2)
662         external
663         onlyOwner
664     {
665         require(_newMaxContributionPhase2 > minContribution);
666         maxContributionPhase2 = _newMaxContributionPhase2;
667     }
668 
669     function setPhase1DurationInHours(uint _newPhase1DurationInHours)
670         external
671         onlyOwner
672     {
673         require(_newPhase1DurationInHours > 0);
674         phase1DurationInHours = _newPhase1DurationInHours;
675     }
676 }