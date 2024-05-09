1 pragma solidity ^0.4.18;
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
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31 
32     // SafeMath.sub will throw if there is not enough balance.
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public constant returns (uint256 balance) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 
51 
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 /**
65  * @title Standard ERC20 token
66  *
67  * @dev Implementation of the basic standard token.
68  * @dev https://github.com/ethereum/EIPs/issues/20
69  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
70  */
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amount of tokens to be transferred
81    */
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84 
85     uint256 _allowance = allowed[_from][msg.sender];
86 
87     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
88     // require (_value <= _allowance);
89 
90     balances[_from] = balances[_from].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     allowed[_from][msg.sender] = _allowance.sub(_value);
93     Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    *
100    * Beware that changing an allowance with this method brings the risk that someone may use both the old
101    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
102    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
103    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104    * @param _spender The address which will spend the funds.
105    * @param _value The amount of tokens to be spent.
106    */
107   function approve(address _spender, uint256 _value) public returns (bool) {
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifying the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123   /**
124    * approve should be called when allowed[_spender] == 0. To increment
125    * allowed value is better to use this function to avoid 2 calls (and wait until
126    * the first transaction is mined)
127    * From MonolithDAO Token.sol
128    */
129   function increaseApproval (address _spender, uint _addedValue)
130     returns (bool success) {
131     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   function decreaseApproval (address _spender, uint _subtractedValue)
137     returns (bool success) {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148 }
149 
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157   address public owner;
158 
159 
160   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() {
168     owner = msg.sender;
169   }
170 
171 
172   /**
173    * @dev Throws if called by any account other than the owner.
174    */
175   modifier onlyOwner() {
176     require(msg.sender == owner);
177     _;
178   }
179 
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner public {
186     require(newOwner != address(0));
187     OwnershipTransferred(owner, newOwner);
188     owner = newOwner;
189   }
190 
191 }
192 
193 
194 /**
195  * @title Contactable token
196  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
197  * contact information.
198  */
199 contract Contactable is Ownable{
200 
201     string public contactInformation;
202 
203     /**
204      * @dev Allows the owner to set a string with their contact information.
205      * @param info The contact information to attach to the contract.
206      */
207     function setContactInformation(string info) onlyOwner public {
208          contactInformation = info;
209      }
210 }
211 
212 
213 /**
214  * @title Pausable
215  * @dev Base contract which allows children to implement an emergency stop mechanism.
216  */
217 contract Pausable is Ownable {
218   event Pause();
219   event Unpause();
220 
221   bool public paused = false;
222 
223 
224   /**
225    * @dev Modifier to make a function callable only when the contract is not paused.
226    */
227   modifier whenNotPaused() {
228     require(!paused);
229     _;
230   }
231 
232   /**
233    * @dev Modifier to make a function callable only when the contract is paused.
234    */
235   modifier whenPaused() {
236     require(paused);
237     _;
238   }
239 
240   /**
241    * @dev called by the owner to pause, triggers stopped state
242    */
243   function pause() onlyOwner whenNotPaused public {
244     paused = true;
245     Pause();
246   }
247 
248   /**
249    * @dev called by the owner to unpause, returns to normal state
250    */
251   function unpause() onlyOwner whenPaused public {
252     paused = false;
253     Unpause();
254   }
255 }
256 
257 
258 /**
259  * @title SafeMath
260  * @dev Math operations with safety checks that throw on error
261  */
262 library SafeMath {
263   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
264     uint256 c = a * b;
265     assert(a == 0 || c / a == b);
266     return c;
267   }
268 
269   function div(uint256 a, uint256 b) internal constant returns (uint256) {
270     // assert(b > 0); // Solidity automatically throws when dividing by 0
271     uint256 c = a / b;
272     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273     return c;
274   }
275 
276   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
277     assert(b <= a);
278     return a - b;
279   }
280 
281   function add(uint256 a, uint256 b) internal constant returns (uint256) {
282     uint256 c = a + b;
283     assert(c >= a);
284     return c;
285   }
286 }
287 
288 contract IRefundHandler {
289     function handleRefundRequest(address _contributor) external;
290 }
291 
292 
293 contract LOCIcoin is StandardToken, Ownable, Contactable {
294     string public name = "";
295     string public symbol = "";
296     uint256 public constant decimals = 18;
297 
298     mapping (address => bool) internal allowedOverrideAddresses;
299 
300     bool public tokenActive = false;
301 
302     modifier onlyIfTokenActiveOrOverride() {
303         // owner or any addresses listed in the overrides
304         // can perform token transfers while inactive
305         require(tokenActive || msg.sender == owner || allowedOverrideAddresses[msg.sender]);
306         _;
307     }
308 
309     modifier onlyIfTokenInactive() {
310         require(!tokenActive);
311         _;
312     }
313 
314     modifier onlyIfValidAddress(address _to) {
315         // prevent 'invalid' addresses for transfer destinations
316         require(_to != 0x0);
317         // don't allow transferring to this contract's address
318         require(_to != address(this));
319         _;
320     }
321 
322     event TokenActivated();
323 
324     function LOCIcoin(uint256 _totalSupply, string _contactInformation ) public {
325         totalSupply = _totalSupply;
326         contactInformation = _contactInformation;
327 
328         // msg.sender == owner of the contract
329         balances[msg.sender] = _totalSupply;
330     }
331 
332     /// @dev Same ERC20 behavior, but reverts if not yet active.
333     /// @param _spender address The address which will spend the funds.
334     /// @param _value uint256 The amount of tokens to be spent.
335     function approve(address _spender, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_spender) returns (bool) {
336         return super.approve(_spender, _value);
337     }
338 
339     /// @dev Same ERC20 behavior, but reverts if not yet active.
340     /// @param _to address The address to transfer to.
341     /// @param _value uint256 The amount to be transferred.
342     function transfer(address _to, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_to) returns (bool) {
343         return super.transfer(_to, _value);
344     }
345 
346     function ownerSetOverride(address _address, bool enable) external onlyOwner {
347         allowedOverrideAddresses[_address] = enable;
348     }
349 
350     function ownerSetVisible(string _name, string _symbol) external onlyOwner onlyIfTokenInactive {        
351 
352         // By holding back on setting these, it prevents the token
353         // from being a duplicate in ERC token searches if the need to
354         // redeploy arises prior to the crowdsale starts.
355         // Mainly useful during testnet deployment/testing.
356         name = _name;
357         symbol = _symbol;
358     }
359 
360     function ownerActivateToken() external onlyOwner onlyIfTokenInactive {
361         require(bytes(symbol).length > 0);
362 
363         tokenActive = true;
364         TokenActivated();
365     }
366 
367     function claimRefund(IRefundHandler _refundHandler) external {
368         uint256 _balance = balances[msg.sender];
369 
370         // Positive token balance required to perform a refund
371         require(_balance > 0);
372 
373         // this mitigates re-entrancy concerns
374         balances[msg.sender] = 0;
375 
376         // Attempt to transfer wei back to msg.sender from the
377         // crowdsale contract
378         // Note: re-entrancy concerns are also addressed within
379         // `handleRefundRequest`
380         // this will throw an exception if any
381         // problems or if refunding isn't enabled
382         _refundHandler.handleRefundRequest(msg.sender);
383 
384         // If we've gotten here, then the wei transfer above
385         // worked (didn't throw an exception) and it confirmed
386         // that `msg.sender` had an ether balance on the contract.
387         // Now do token transfer from `msg.sender` back to
388         // `owner` completes the refund.
389         balances[owner] = balances[owner].add(_balance);
390         Transfer(msg.sender, owner, _balance);
391     }
392 }
393 
394 
395 contract LOCIsale is Ownable, Pausable, IRefundHandler {
396     using SafeMath for uint256;
397 
398     // this sale contract is creating the LOCIcoin
399     // contract, and so will own it
400     LOCIcoin internal token;
401 
402     // UNIX timestamp (UTC) based start and end, inclusive
403     uint256 public start;               /* UTC of timestamp that the sale will start based on the value passed in at the time of construction */
404     uint256 public end;                 /* UTC of computed time that the sale will end based on the hours passed in at time of construction */
405 
406     bool public isPresale;              /* For LOCI this will be false. We raised pre-ICO offline. */
407     bool public isRefunding = false;    /* No plans to refund. */
408 
409     uint256 public minFundingGoalWei;   /* we can set this to zero, but we might want to raise at least 20000 Ether */
410     uint256 public minContributionWei;  /* individual contribution min. we require at least a 0.1 Ether investment, for example. */
411     uint256 public maxContributionWei;  /* individual contribution max. probably don't want someone to buy more than 60000 Ether */
412 
413     uint256 public weiRaised;       /* total of all weiContributions */
414     uint256 public weiRaisedAfterDiscounts; /* wei raised after the discount periods end */
415     uint256 internal weiForRefund;  /* only applicable if we enable refunding, if we don't meet our expected raise */
416 
417     uint256 public peggedETHUSD;    /* In whole dollars. $300 means use 300 */
418     uint256 public hardCap;         /* In wei. Example: 64,000 cap = 64,000,000,000,000,000,000,000 */
419     uint256 public reservedTokens;  /* In wei. Example: 54 million tokens, use 54000000 with 18 more zeros. then it would be 54000000 * Math.pow(10,18) */
420     uint256 public baseRateInCents; /* $2.50 means use 250 */
421     uint256 internal startingTokensAmount; // this will be set once, internally
422 
423     mapping (address => uint256) public contributions;
424 
425     struct DiscountTranche {
426         // this will be a timestamp that is calculated based on
427         // the # of hours a tranche rate is to be active for
428         uint256 end;
429         // should be a % number between 0 and 100
430         uint8 discount;
431         // should be 1, 2, 3, 4, etc...
432         uint8 round;
433         // amount raised during tranche in wei
434         uint256 roundWeiRaised;
435         // amount sold during tranche in wei
436         uint256 roundTokensSold;
437     }
438     DiscountTranche[] internal discountTranches;
439     uint8 internal currentDiscountTrancheIndex = 0;
440     uint8 internal discountTrancheLength = 0;
441 
442     event ContributionReceived(address indexed buyer, bool presale, uint8 rate, uint256 value, uint256 tokens);
443     event RefundsEnabled();
444     event Refunded(address indexed buyer, uint256 weiAmount);
445     event ToppedUp();
446     event PegETHUSD(uint256 pegETHUSD);
447 
448     function LOCIsale(
449         address _token,                /* LOCIcoin contract address */
450         uint256 _peggedETHUSD,          /* 300 = 300 USD */
451         uint256 _hardCapETHinWei,       /* In wei. Example: 64,000 cap = 64,000,000,000,000,000,000,000 */
452         uint256 _reservedTokens,        /* In wei. Example: 54 million tokens, use 54000000 with 18 more zeros. then it would be 54000000 * Math.pow(10,18) */
453         bool _isPresale,                /* For LOCI this will be false. Presale offline, and accounted for in reservedTokens */
454         uint256 _minFundingGoalWei,     /* If we are looking to raise a minimum amount of wei, put it here */
455         uint256 _minContributionWei,    /* For LOCI this will be 0.1 ETH */
456         uint256 _maxContributionWei,    /* Advisable to not let a single contributor go over the max alloted, say 63333 * Math.pow(10,18) wei. */
457         uint256 _start,                 /* For LOCI this will be Dec 6th 0:00 UTC in seconds */
458         uint256 _durationHours,         /* Total length of the sale, in hours */
459         uint256 _baseRateInCents,       /* Base rate in cents. $2.50 would be 250 */
460         uint256[] _hourBasedDiscounts   /* Single dimensional array of pairs [hours, rateInCents, hours, rateInCents, hours, rateInCents, ... ] */
461     ) public {
462         require(_token != 0x0);
463         // either have NO max contribution or the max must be more than the min
464         require(_maxContributionWei == 0 || _maxContributionWei > _minContributionWei);
465         // sale must have a duration!
466         require(_durationHours > 0);
467 
468         token = LOCIcoin(_token);
469 
470         peggedETHUSD = _peggedETHUSD;
471         hardCap = _hardCapETHinWei;
472         reservedTokens = _reservedTokens;
473 
474         isPresale = _isPresale;
475 
476         start = _start;
477         end = start.add(_durationHours.mul(1 hours));
478 
479         minFundingGoalWei = _minFundingGoalWei;
480         minContributionWei = _minContributionWei;
481         maxContributionWei = _maxContributionWei;
482 
483         baseRateInCents = _baseRateInCents;
484 
485         // this will throw if the # of hours and
486         // discount % don't come in pairs
487         uint256 _end = start;
488 
489         uint _tranche_round = 0;
490 
491         for (uint i = 0; i < _hourBasedDiscounts.length; i += 2) {
492             // calculate the timestamp where the discount rate will end
493             _end = _end.add(_hourBasedDiscounts[i].mul(1 hours));
494 
495             // the calculated tranche end cannot go past the crowdsale end
496             require(_end <= end);
497 
498             _tranche_round += 1;
499 
500             discountTranches.push(DiscountTranche({ end:_end,
501                                                     discount:uint8(_hourBasedDiscounts[i + 1]),
502                                                     round:uint8(_tranche_round),
503                                                     roundWeiRaised:0,
504                                                     roundTokensSold:0}));
505 
506             discountTrancheLength = uint8(i+1);
507         }
508     }
509 
510     function determineDiscountTranche() internal returns (uint256, uint8, uint8) {
511         if (currentDiscountTrancheIndex >= discountTranches.length) {
512             return(0, 0, 0);
513         }
514 
515         DiscountTranche storage _dt = discountTranches[currentDiscountTrancheIndex];
516         if (_dt.end < now) {
517             // find the next applicable tranche
518             while (++currentDiscountTrancheIndex < discountTranches.length) {
519                 _dt = discountTranches[currentDiscountTrancheIndex];
520                 if (_dt.end > now) {
521                     break;
522                 }
523             }
524         }
525 
526         // Example: there are 4 rounds, and we want to divide rounds 2-4 equally based on (starting-round1)/(discountTranches.length-1), move to next tranche
527         // But don't move past the last round. Note, the last round should not be capped. That's why we check for round < # tranches
528         if (_dt.round > 1 && _dt.roundTokensSold > 0 && _dt.round < discountTranches.length) {
529             uint256 _trancheCountExceptForOne = discountTranches.length-1;
530             uint256 _tokensSoldFirstRound = discountTranches[0].roundTokensSold;
531             uint256 _allowedTokensThisRound = (startingTokensAmount.sub(_tokensSoldFirstRound)).div(_trancheCountExceptForOne);
532 
533             if (_dt.roundTokensSold > _allowedTokensThisRound) {
534                 currentDiscountTrancheIndex = currentDiscountTrancheIndex + 1;
535                 _dt = discountTranches[currentDiscountTrancheIndex];
536             }
537         }
538 
539         uint256 _end = 0;
540         uint8 _rate = 0;
541         uint8 _round = 0;
542 
543         // if the index is still valid, then we must have
544         // a valid tranche, so return discount rate
545         if (currentDiscountTrancheIndex < discountTranches.length) {
546             _end = _dt.end;
547             _rate = _dt.discount;
548             _round = _dt.round;
549         } else {
550             _end = end;
551             _rate = 0;
552             _round = discountTrancheLength + 1;
553         }
554 
555         return (_end, _rate, _round);
556     }
557 
558     function() public payable whenNotPaused {
559         require(!isRefunding);
560         require(msg.sender != 0x0);
561         require(msg.value >= minContributionWei);
562         require(start <= now && end >= now);
563 
564         // prevent anything more than maxContributionWei per contributor address
565         uint256 _weiContributionAllowed = maxContributionWei > 0 ? maxContributionWei.sub(contributions[msg.sender]) : msg.value;
566         if (maxContributionWei > 0) {
567             require(_weiContributionAllowed > 0);
568         }
569 
570         // are limited by the number of tokens remaining
571         uint256 _tokensRemaining = token.balanceOf(address(this)).sub( reservedTokens );
572         require(_tokensRemaining > 0);
573 
574         if (startingTokensAmount == 0) {
575             startingTokensAmount = _tokensRemaining; // set this once.
576         }
577 
578         // limit contribution's value based on max/previous contributions
579         uint256 _weiContribution = msg.value;
580         if (_weiContribution > _weiContributionAllowed) {
581             _weiContribution = _weiContributionAllowed;
582         }
583 
584         // limit contribution's value based on hard cap of hardCap
585         if (hardCap > 0 && weiRaised.add(_weiContribution) > hardCap) {
586             _weiContribution = hardCap.sub( weiRaised );
587         }
588 
589         // calculate token amount to be created
590         uint256 _tokens = _weiContribution.mul(peggedETHUSD).mul(100).div(baseRateInCents);
591         var (, _rate, _round) = determineDiscountTranche();
592         if (_rate > 0) {
593             _tokens = _weiContribution.mul(peggedETHUSD).mul(100).div(_rate);
594         }
595 
596         if (_tokens > _tokensRemaining) {
597             // there aren't enough tokens to fill the contribution amount, so recalculate the contribution amount
598             _tokens = _tokensRemaining;
599             if (_rate > 0) {
600                 _weiContribution = _tokens.mul(_rate).div(100).div(peggedETHUSD);
601             } else {
602                 _weiContribution = _tokens.mul(baseRateInCents).div(100).div(peggedETHUSD);
603             }
604         }
605 
606         // add the contributed wei to any existing value for the sender
607         contributions[msg.sender] = contributions[msg.sender].add(_weiContribution);
608         ContributionReceived(msg.sender, isPresale, _rate, _weiContribution, _tokens);
609 
610         require(token.transfer(msg.sender, _tokens));
611 
612         weiRaised = weiRaised.add(_weiContribution); //total of all weiContributions
613 
614         if (discountTrancheLength > 0 && _round > 0 && _round <= discountTrancheLength) {
615             discountTranches[_round-1].roundWeiRaised = discountTranches[_round-1].roundWeiRaised.add(_weiContribution);
616             discountTranches[_round-1].roundTokensSold = discountTranches[_round-1].roundTokensSold.add(_tokens);
617         }
618         if (discountTrancheLength > 0 && _round > discountTrancheLength) {
619             weiRaisedAfterDiscounts = weiRaisedAfterDiscounts.add(_weiContribution);
620         }
621 
622         uint256 _weiRefund = msg.value.sub(_weiContribution);
623         if (_weiRefund > 0) {
624             msg.sender.transfer(_weiRefund);
625         }
626     }
627 
628     // in case we need to return funds to this contract
629     function ownerTopUp() external payable {}
630 
631     function setReservedTokens( uint256 _reservedTokens ) onlyOwner public {
632         reservedTokens = _reservedTokens;        
633     }
634 
635     function pegETHUSD(uint256 _peggedETHUSD) onlyOwner public {
636         peggedETHUSD = _peggedETHUSD;
637         PegETHUSD(peggedETHUSD);
638     }
639 
640     function setHardCap( uint256 _hardCap ) onlyOwner public {
641         hardCap = _hardCap;
642     }
643 
644     function peggedETHUSD() constant onlyOwner public returns(uint256) {
645         return peggedETHUSD;
646     }
647 
648     function hardCapETHInWeiValue() constant onlyOwner public returns(uint256) {
649         return hardCap;
650     }
651 
652     function weiRaisedDuringRound(uint8 round) constant onlyOwner public returns(uint256) {
653         require( round > 0 && round <= discountTrancheLength );
654         return discountTranches[round-1].roundWeiRaised;
655     }
656 
657     function tokensRaisedDuringRound(uint8 round) constant onlyOwner public returns(uint256) {
658         require( round > 0 && round <= discountTrancheLength );
659         return discountTranches[round-1].roundTokensSold;
660     }
661 
662     function weiRaisedAfterDiscountRounds() constant onlyOwner public returns(uint256) {
663         return weiRaisedAfterDiscounts;
664     }
665 
666     function totalWeiRaised() constant onlyOwner public returns(uint256) {
667         return weiRaised;
668     }
669 
670     function setStartingTokensAmount(uint256 _startingTokensAmount) onlyOwner public {
671         startingTokensAmount = _startingTokensAmount;
672     }
673 
674     function ownerEnableRefunds() external onlyOwner {
675         // a little protection against human error;
676         // sale must be ended OR it must be paused
677         require(paused || now > end);
678         require(!isRefunding);
679 
680         weiForRefund = this.balance;
681         isRefunding = true;
682         RefundsEnabled();
683     }
684 
685     function ownerTransferWei(address _beneficiary, uint256 _value) external onlyOwner {
686         require(_beneficiary != 0x0);
687         require(_beneficiary != address(token));
688         // we cannot withdraw if we didn't reach the minimum funding goal
689         require(minFundingGoalWei == 0 || weiRaised >= minFundingGoalWei);
690 
691         // if zero requested, send the entire amount, otherwise the amount requested
692         uint256 _amount = _value > 0 ? _value : this.balance;
693 
694         _beneficiary.transfer(_amount);
695     }
696 
697     function ownerRecoverTokens(address _beneficiary) external onlyOwner {
698         require(_beneficiary != 0x0);
699         require(_beneficiary != address(token));
700         require(paused || now > end);
701 
702         uint256 _tokensRemaining = token.balanceOf(address(this));
703         if (_tokensRemaining > 0) {
704             token.transfer(_beneficiary, _tokensRemaining);
705         }
706     }
707 
708     function handleRefundRequest(address _contributor) external {
709         // Note that this method can only ever called by
710         // the token contract's `claimRefund()` method;
711         // everything that happens in here will only
712         // succeed if `claimRefund()` works as well.
713 
714         require(isRefunding);
715         // this can only be called by the token contract;
716         // it is the entry point for the refund flow
717         require(msg.sender == address(token));
718 
719         uint256 _wei = contributions[_contributor];
720 
721         // if this is zero, then `_contributor` didn't
722         // contribute or they've already been refunded
723         require(_wei > 0);
724 
725         // prorata the amount if necessary
726         if (weiRaised > weiForRefund) {
727             uint256 _n  = weiForRefund.mul(_wei).div(weiRaised);
728             require(_n < _wei);
729             _wei = _n;
730         }
731 
732         // zero out their contribution, so they cannot
733         // claim another refund; it's important (for
734         // avoiding re-entrancy attacks) that this zeroing
735         // happens before the transfer below
736         contributions[_contributor] = 0;
737 
738         // give them their ether back; throws on failure
739         _contributor.transfer(_wei);
740 
741         Refunded(_contributor, _wei);
742     }
743 }