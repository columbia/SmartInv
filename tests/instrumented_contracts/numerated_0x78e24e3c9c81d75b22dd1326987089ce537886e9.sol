1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue)
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will receive the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 contract MultiOwners {
228 
229     event AccessGrant(address indexed owner);
230     event AccessRevoke(address indexed owner);
231     
232     mapping(address => bool) owners;
233     address public publisher;
234 
235 
236     function MultiOwners() {
237         owners[msg.sender] = true;
238         publisher = msg.sender;
239     }
240 
241     modifier onlyOwner() { 
242         require(owners[msg.sender] == true);
243         _; 
244     }
245 
246     function isOwner() constant returns (bool) {
247         return owners[msg.sender] ? true : false;
248     }
249 
250     function checkOwner(address maybe_owner) constant returns (bool) {
251         return owners[maybe_owner] ? true : false;
252     }
253 
254 
255     function grant(address _owner) onlyOwner {
256         owners[_owner] = true;
257         AccessGrant(_owner);
258     }
259 
260     function revoke(address _owner) onlyOwner {
261         require(_owner != publisher);
262         require(msg.sender != _owner);
263 
264         owners[_owner] = false;
265         AccessRevoke(_owner);
266     }
267 }
268 
269 contract Haltable is MultiOwners {
270     bool public halted;
271 
272     modifier stopInEmergency {
273         require(!halted);
274         _;
275     }
276 
277     modifier onlyInEmergency {
278         require(halted);
279         _;
280     }
281 
282     // called by the owner on emergency, triggers stopped state
283     function halt() external onlyOwner {
284         halted = true;
285     }
286 
287     // called by the owner on end of emergency, returns to normal state
288     function unhalt() external onlyOwner onlyInEmergency {
289         halted = false;
290     }
291 
292 }
293 
294 contract TripleAlphaCrowdsale is MultiOwners, Haltable {
295     using SafeMath for uint256;
296 
297     // Global
298     // ETHUSD change rate
299     uint256 public rateETHUSD = 300e2;
300 
301     // minimal token selled per time
302     uint256 public minimalTokens = 1e18;
303 
304     // Sale token
305     TripleAlphaToken public token;
306 
307     // Withdraw wallet
308     address public wallet;
309 
310 
311     // Pre-ICO
312     // Maximum possible cap in USD on periodPreITO
313     uint256 public periodPreITO_mainCapInUSD = 1000000e2;
314 
315     // Maximum possible cap in USD on periodPreITO
316     uint256 public periodPreITO_hardCapInUSD = periodPreITO_mainCapInUSD;
317 
318     // PreITO period in days
319     uint256 public periodPreITO_period = 30 days;
320 
321     // Token Price in USD
322     uint256 public periodPreITO_tokenPriceUSD = 50;
323 
324     // WEI per token
325     uint256 public periodPreITO_weiPerToken = periodPreITO_tokenPriceUSD.mul(1 ether).div(rateETHUSD);
326     
327     // start and end timestamp where investments are allowed (both inclusive)
328     uint256 public periodPreITO_startTime;
329     uint256 public periodPreITO_endTime;
330 
331     // total wei received during phase one
332     uint256 public periodPreITO_wei;
333 
334     // Maximum possible cap in wei for phase one
335     uint256 public periodPreITO_mainCapInWei = periodPreITO_mainCapInUSD.mul(1 ether).div(rateETHUSD);
336     // Maximum possible cap in wei
337     uint256 public periodPreITO_hardCapInWei = periodPreITO_mainCapInWei;
338 
339 
340     // ICO
341     // Minimal possible cap in USD on periodITO
342     uint256 public periodITO_softCapInUSD = 1000000e2;
343 
344     // Maximum possible cap in USD on periodITO
345     uint256 public periodITO_mainCapInUSD = 8000000e2;
346 
347     uint256 public periodITO_period = 60 days;
348 
349     // Maximum possible cap in USD on periodITO
350     uint256 public periodITO_hardCapInUSD = periodITO_softCapInUSD + periodITO_mainCapInUSD;
351 
352     // Token Price in USD
353     uint256 public periodITO_tokenPriceUSD = 100;
354 
355     // WEI per token
356     uint256 public periodITO_weiPerToken = periodITO_tokenPriceUSD.mul(1 ether).div(rateETHUSD);
357 
358     // start and end timestamp where investments are allowed (both inclusive)
359     uint256 public periodITO_startTime;
360     uint256 public periodITO_endTime;
361 
362     // total wei received during phase two
363     uint256 public periodITO_wei;
364     
365     // refund if softCap is not reached
366     bool public refundAllowed = false;
367 
368     // need for refund
369     mapping(address => uint256) public received_ethers;
370 
371 
372     // Hard possible cap - soft cap in wei for phase two
373     uint256 public periodITO_mainCapInWei = periodITO_mainCapInUSD.mul(1 ether).div(rateETHUSD);
374 
375     // Soft cap in wei
376     uint256 public periodITO_softCapInWei = periodITO_softCapInUSD.mul(1 ether).div(rateETHUSD);
377 
378     // Hard possible cap - soft cap in wei for phase two
379     uint256 public periodITO_hardCapInWei = periodITO_softCapInWei + periodITO_mainCapInWei;
380 
381 
382     // Events
383     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
384     event OddMoney(address indexed beneficiary, uint256 value);
385     event SetPeriodPreITO_startTime(uint256 new_startTimePeriodPreITO);
386     event SetPeriodITO_startTime(uint256 new_startTimePeriodITO);
387 
388     modifier validPurchase() {
389         bool nonZeroPurchase = msg.value != 0;
390 
391         require(withinPeriod() && nonZeroPurchase);
392 
393         _;        
394     }
395 
396     modifier isExpired() {
397         require(now > periodITO_endTime);
398 
399         _;        
400     }
401 
402     /**
403      * @return true if in period or false if not
404      */
405     function withinPeriod() constant returns(bool res) {
406         bool withinPeriodPreITO = (now >= periodPreITO_startTime && now <= periodPreITO_endTime);
407         bool withinPeriodITO = (now >= periodITO_startTime && now <= periodITO_endTime);
408         return (withinPeriodPreITO || withinPeriodITO);
409     }
410     
411 
412     /**
413      * @param _periodPreITO_startTime Pre-ITO start time
414      * @param _periodITO_startTime ITO start time
415      * @param _wallet destination fund address (i hope it will be multi-sig)
416      */
417     function TripleAlphaCrowdsale(uint256 _periodPreITO_startTime, uint256 _periodITO_startTime, address _wallet) {
418         require(_periodPreITO_startTime >= now);
419         require(_periodITO_startTime > _periodPreITO_startTime);
420         require(_wallet != 0x0);
421 
422         token = new TripleAlphaToken();
423         wallet = _wallet;
424 
425         setPeriodPreITO_startTime(_periodPreITO_startTime);
426         setPeriodITO_startTime(_periodITO_startTime);
427     }
428 
429     /**
430      * @dev Human readable period Name 
431      * @return current stage name
432      */
433     function stageName() constant public returns (string) {
434         bool beforePreITO = (now < periodPreITO_startTime);
435         bool withinPreITO = (now >= periodPreITO_startTime && now <= periodPreITO_endTime);
436         bool betweenPreITOAndITO = (now >= periodPreITO_endTime && now <= periodITO_startTime);
437         bool withinITO = (now >= periodITO_startTime && now <= periodITO_endTime);
438 
439         if(beforePreITO) {
440             return 'Not started';
441         }
442 
443         if(withinPreITO) {
444             return 'Pre-ITO';
445         } 
446 
447         if(betweenPreITOAndITO) {
448             return 'Between Pre-ITO and ITO';
449         }
450 
451         if(withinITO) {
452             return 'ITO';
453         }
454 
455         return 'Finished';
456     }
457 
458     /**
459      * @dev Human readable period Name 
460      * @return current stage name
461      */
462     function totalWei() public constant returns(uint256) {
463         return periodPreITO_wei + periodITO_wei;
464     }
465     
466     function totalEther() public constant returns(uint256) {
467         return totalWei().div(1e18);
468     }
469 
470     /*
471      * @dev update PreITO start time
472      * @param _at new start date
473      */
474     function setPeriodPreITO_startTime(uint256 _at) onlyOwner {
475         require(periodPreITO_startTime == 0 || block.timestamp < periodPreITO_startTime); // forbid change time when first phase is active
476         require(block.timestamp < _at); // should be great than current block timestamp
477         require(periodITO_startTime == 0 || _at < periodITO_startTime); // should be lower than start of second phase
478 
479         periodPreITO_startTime = _at;
480         periodPreITO_endTime = periodPreITO_startTime.add(periodPreITO_period);
481         SetPeriodPreITO_startTime(_at);
482     }
483 
484     /*
485      * @dev update ITO start date
486      * @param _at new start date
487      */
488     function setPeriodITO_startTime(uint256 _at) onlyOwner {
489         require(periodITO_startTime == 0 || block.timestamp < periodITO_startTime); // forbid change time when second phase is active
490         require(block.timestamp < _at); // should be great than current block timestamp
491         require(periodPreITO_endTime < _at); // should be great than end first phase
492 
493         periodITO_startTime = _at;
494         periodITO_endTime = periodITO_startTime.add(periodITO_period);
495         SetPeriodITO_startTime(_at);
496     }
497 
498     function periodITO_softCapReached() internal returns (bool) {
499         return periodITO_wei >= periodITO_softCapInWei;
500     }
501 
502     /*
503      * @dev fallback for processing ether
504      */
505     function() payable {
506         return buyTokens(msg.sender);
507     }
508 
509     /*
510      * @dev amount calculation, depends of current period
511      * @param _value ETH in wei
512      * @param _at time
513      */
514     function calcAmountAt(uint256 _value, uint256 _at) constant public returns (uint256, uint256) {
515         uint256 estimate;
516         uint256 odd;
517 
518         if(_at < periodPreITO_endTime) {
519             if(_value.add(periodPreITO_wei) > periodPreITO_hardCapInWei) {
520                 odd = _value.add(periodPreITO_wei).sub(periodPreITO_hardCapInWei);
521                 _value = periodPreITO_hardCapInWei.sub(periodPreITO_wei);
522             } 
523             estimate = _value.mul(1 ether).div(periodPreITO_weiPerToken);
524             require(_value + periodPreITO_wei <= periodPreITO_hardCapInWei);
525         } else {
526             if(_value.add(periodITO_wei) > periodITO_hardCapInWei) {
527                 odd = _value.add(periodITO_wei).sub(periodITO_hardCapInWei);
528                 _value = periodITO_hardCapInWei.sub(periodITO_wei);
529             }             
530             estimate = _value.mul(1 ether).div(periodITO_weiPerToken);
531             require(_value + periodITO_wei <= periodITO_hardCapInWei);
532         }
533 
534         return (estimate, odd);
535     }
536 
537     /*
538      * @dev sell token and send to contributor address
539      * @param contributor address
540      */
541     function buyTokens(address contributor) payable stopInEmergency validPurchase public {
542         uint256 amount;
543         uint256 odd_ethers;
544         bool transfer_allowed = true;
545         
546         (amount, odd_ethers) = calcAmountAt(msg.value, now);
547   
548         require(contributor != 0x0) ;
549         require(minimalTokens <= amount);
550 
551         token.mint(contributor, amount);
552         TokenPurchase(contributor, msg.value, amount);
553 
554         if(now < periodPreITO_endTime) {
555             // Pre-ITO
556             periodPreITO_wei = periodPreITO_wei.add(msg.value);
557 
558         } else {
559             // ITO
560             if(periodITO_softCapReached()) {
561                 periodITO_wei = periodITO_wei.add(msg.value).sub(odd_ethers);
562             } else if(this.balance >= periodITO_softCapInWei) {
563                 periodITO_wei = this.balance.sub(odd_ethers);
564             } else {
565                 received_ethers[contributor] = received_ethers[contributor].add(msg.value);
566                 transfer_allowed = false;
567             }
568         }
569 
570         if(odd_ethers > 0) {
571             require(odd_ethers < msg.value);
572             OddMoney(contributor, odd_ethers);
573             contributor.transfer(odd_ethers);
574         }
575 
576         if(transfer_allowed) {
577             wallet.transfer(this.balance);
578         }
579     }
580 
581     /*
582      * @dev sell token and send to contributor address
583      * @param contributor address
584      */
585     function refund() isExpired public {
586         require(refundAllowed);
587         require(!periodITO_softCapReached());
588         require(received_ethers[msg.sender] > 0);
589         require(token.balanceOf(msg.sender) > 0);
590 
591         uint256 current_balance = received_ethers[msg.sender];
592         received_ethers[msg.sender] = 0;
593         token.burn(msg.sender);
594         msg.sender.transfer(current_balance);
595     }
596 
597     /*
598      * @dev finish crowdsale
599      */
600     function finishCrowdsale() onlyOwner public {
601         require(now > periodITO_endTime || periodITO_wei == periodITO_hardCapInWei);
602         require(!token.mintingFinished());
603 
604         if(periodITO_softCapReached()) {
605             token.finishMinting(true);
606         } else {
607             refundAllowed = true;
608             token.finishMinting(false);
609         }
610    }
611 
612     // @return true if crowdsale event has ended
613     function running() constant public returns (bool) {
614         return withinPeriod() && !token.mintingFinished();
615     }
616 }
617 
618 contract TripleAlphaToken is MintableToken {
619 
620     string public constant name = 'Triple Alpha Token';
621     string public constant symbol = 'TRIA';
622     uint8 public constant decimals = 18;
623     bool public transferAllowed;
624 
625     event Burn(address indexed from, uint256 value);
626     event TransferAllowed(bool);
627 
628     modifier canTransfer() {
629         require(mintingFinished && transferAllowed);
630         _;        
631     }
632 
633     function transferFrom(address from, address to, uint256 value) canTransfer returns (bool) {
634         return super.transferFrom(from, to, value);
635     }
636 
637     function transfer(address to, uint256 value) canTransfer returns (bool) {
638         return super.transfer(to, value);
639     }
640 
641     function finishMinting(bool _transferAllowed) onlyOwner returns (bool) {
642         transferAllowed = _transferAllowed;
643         TransferAllowed(_transferAllowed);
644         return super.finishMinting();
645     }
646 
647     function burn(address from) onlyOwner returns (bool) {
648         Transfer(from, 0x0, balances[from]);
649         Burn(from, balances[from]);
650 
651         balances[0x0] += balances[from];
652         balances[from] = 0;
653     }
654 }