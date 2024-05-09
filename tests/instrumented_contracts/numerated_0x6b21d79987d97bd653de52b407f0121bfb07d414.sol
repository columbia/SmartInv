1 pragma solidity ^0.4.15;
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
227 contract McFlyToken is MintableToken {
228 
229     string public constant name = 'McFly';
230     string public constant symbol = 'MFL';
231     uint8 public constant decimals = 18;
232 
233     mapping(address=>bool) whitelist;
234 
235     event Burn(address indexed from, uint256 value);
236     event AllowTransfer(address from);
237 
238     modifier canTransfer() {
239         require(mintingFinished || whitelist[msg.sender]);
240         _;        
241     }
242 
243     function allowTransfer(address from) onlyOwner {
244         AllowTransfer(from);
245         whitelist[from] = true;
246     }
247 
248     function transferFrom(address from, address to, uint256 value) canTransfer returns (bool) {
249         return super.transferFrom(from, to, value);
250     }
251 
252     function transfer(address to, uint256 value) canTransfer returns (bool) {
253         return super.transfer(to, value);
254     }
255 
256     function burn(address from) onlyOwner returns (bool) {
257         Transfer(from, 0x0, balances[from]);
258         Burn(from, balances[from]);
259 
260         balances[0x0] += balances[from];
261         balances[from] = 0;
262     }
263 }
264 
265 contract MultiOwners {
266 
267     event AccessGrant(address indexed owner);
268     event AccessRevoke(address indexed owner);
269     
270     mapping(address => bool) owners;
271     address public publisher;
272 
273 
274     function MultiOwners() {
275         owners[msg.sender] = true;
276         publisher = msg.sender;
277     }
278 
279     modifier onlyOwner() { 
280         require(owners[msg.sender] == true);
281         _; 
282     }
283 
284     function isOwner() constant returns (bool) {
285         return owners[msg.sender] ? true : false;
286     }
287 
288     function checkOwner(address maybe_owner) constant returns (bool) {
289         return owners[maybe_owner] ? true : false;
290     }
291 
292 
293     function grant(address _owner) onlyOwner {
294         owners[_owner] = true;
295         AccessGrant(_owner);
296     }
297 
298     function revoke(address _owner) onlyOwner {
299         require(_owner != publisher);
300         require(msg.sender != _owner);
301 
302         owners[_owner] = false;
303         AccessRevoke(_owner);
304     }
305 }
306 
307 contract Haltable is MultiOwners {
308     bool public halted;
309 
310     modifier stopInEmergency {
311         require(!halted);
312         _;
313     }
314 
315     modifier onlyInEmergency {
316         require(halted);
317         _;
318     }
319 
320     // called by the owner on emergency, triggers stopped state
321     function halt() external onlyOwner {
322         halted = true;
323     }
324 
325     // called by the owner on end of emergency, returns to normal state
326     function unhalt() external onlyOwner onlyInEmergency {
327         halted = false;
328     }
329 
330 }
331 
332 contract McFlyCrowdsale is MultiOwners, Haltable {
333     using SafeMath for uint256;
334 
335     // min wei per tx for TLP 1.1
336     uint256 public minimalWeiTLP1 = 1e17; // 0.1 ETH
337     uint256 public priceTLP1 = 1e14; // 0.0001 ETH
338 
339     // min wei per tx for TLP 1.2
340     uint256 public minimalWeiTLP2 = 2e17; // 0.2 ETH
341     uint256 public priceTLP2 = 2e14; // 0.0002 ETH
342 
343     // Total ETH received during WAVES, TLP1.1 and TLP1.2
344     uint256 public totalETH;
345 
346     // Token
347     McFlyToken public token;
348 
349     // Withdraw wallet
350     address public wallet;
351 
352     // start and end timestamp for TLP 1.1, endTimeTLP1 calculate from startTimeTLP1
353     uint256 public startTimeTLP1;
354     uint256 public endTimeTLP1;
355     uint256 daysTLP1 = 12 days;
356 
357     // start and end timestamp for TLP 1.2, endTimeTLP2 calculate from startTimeTLP2
358     uint256 public startTimeTLP2;
359     uint256 public endTimeTLP2;
360     uint256 daysTLP2 = 24 days;
361 
362     // Percents
363     uint256 fundPercents = 15;
364     uint256 teamPercents = 10;
365     uint256 reservedPercents = 10;
366     uint256 bountyOnlinePercents = 2;
367     uint256 bountyOfflinePercents = 3;
368     uint256 advisoryPercents = 5;
369     
370     // Cap
371     // maximum possible tokens for minting
372     uint256 public hardCapInTokens = 1800e24; // 1,800,000,000 MFL
373 
374     // maximum possible tokens for sell 
375     uint256 public mintCapInTokens = hardCapInTokens.mul(70).div(100); // 1,260,000,000 MFL
376 
377     // maximum possible tokens for fund minting
378     uint256 public fundTokens = hardCapInTokens.mul(fundPercents).div(100); // 270,000,000 MFL
379     uint256 public fundTotalSupply;
380     address public fundMintingAgent;
381 
382     // Rewards
383     // WAVES
384     // maximum possible tokens to convert from WAVES
385     uint256 public wavesTokens = 100e24; // 100,000,000 MFL
386     address public wavesAgent;
387 
388     // Team 10%
389     uint256 teamVestingPeriodInSeconds = 31 days;
390     uint256 teamVestingPeriodsCount = 12;
391     uint256 _teamTokens;
392     uint256 public teamTotalSupply;
393     address public teamWallet;
394 
395     // Bounty 5% (2% + 3%)
396     // Bounty online 2%
397     uint256 _bountyOnlineTokens;
398     address public bountyOnlineWallet;
399 
400     // Bounty offline 3%
401     uint256 _bountyOfflineTokens;
402     address public bountyOfflineWallet;
403 
404     // Advisory 5%
405     uint256 _advisoryTokens;
406     address public advisoryWallet;
407 
408     // Reserved for future 10%
409     uint256 _reservedTokens;
410     address public reservedWallet;
411 
412 
413     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
414     event TransferOddEther(address indexed beneficiary, uint256 value);
415     event FundMinting(address indexed beneficiary, uint256 value);
416     event TeamVesting(address indexed beneficiary, uint256 period, uint256 value);
417     event SetFundMintingAgent(address new_agent);
418     event SetStartTimeTLP1(uint256 new_startTimeTLP1);
419     event SetStartTimeTLP2(uint256 new_startTimeTLP2);
420 
421 
422     modifier validPurchase() {
423         bool nonZeroPurchase = msg.value != 0;
424         
425         require(withinPeriod() && nonZeroPurchase);
426 
427         _;        
428     }
429 
430     function McFlyCrowdsale(
431         uint256 _startTimeTLP1,
432         uint256 _startTimeTLP2,
433         address _wallet,
434         address _wavesAgent,
435         address _fundMintingAgent,
436         address _teamWallet,
437         address _bountyOnlineWallet,
438         address _bountyOfflineWallet,
439         address _advisoryWallet,
440         address _reservedWallet
441     ) {
442         require(_startTimeTLP1 >= block.timestamp);
443         require(_startTimeTLP2 > _startTimeTLP1);
444         require(_wallet != 0x0);
445         require(_wavesAgent != 0x0);
446         require(_fundMintingAgent != 0x0);
447         require(_teamWallet != 0x0);
448         require(_bountyOnlineWallet != 0x0);
449         require(_bountyOfflineWallet != 0x0);
450         require(_advisoryWallet != 0x0);
451         require(_reservedWallet != 0x0);
452 
453         token = new McFlyToken();
454 
455         startTimeTLP1 = _startTimeTLP1; 
456         endTimeTLP1 = startTimeTLP1.add(daysTLP1);
457 
458         require(endTimeTLP1 < _startTimeTLP2);
459 
460         startTimeTLP2 = _startTimeTLP2; 
461         endTimeTLP2 = startTimeTLP2.add(daysTLP2);
462 
463         wavesAgent = _wavesAgent;
464         fundMintingAgent = _fundMintingAgent;
465 
466         wallet = _wallet;
467         teamWallet = _teamWallet;
468         bountyOnlineWallet = _bountyOnlineWallet;
469         bountyOfflineWallet = _bountyOfflineWallet;
470         advisoryWallet = _advisoryWallet;
471         reservedWallet = _reservedWallet;
472 
473         totalETH = wavesTokens.mul(priceTLP1.mul(65).div(100)).div(1e18); // 6500 for 100,000,000 MFL from WAVES
474         token.mint(wavesAgent, wavesTokens);
475         token.allowTransfer(wavesAgent);
476     }
477 
478     function withinPeriod() constant public returns (bool) {
479         bool withinPeriodTLP1 = (now >= startTimeTLP1 && now <= endTimeTLP1);
480         bool withinPeriodTLP2 = (now >= startTimeTLP2 && now <= endTimeTLP2);
481         return withinPeriodTLP1 || withinPeriodTLP2;
482     }
483 
484     // @return false if crowdsale event was ended
485     function running() constant public returns (bool) {
486         return withinPeriod() && !token.mintingFinished();
487     }
488 
489     function teamTokens() constant public returns (uint256) {
490         if(_teamTokens > 0) {
491             return _teamTokens;
492         }
493         return token.totalSupply().mul(teamPercents).div(70);
494     }
495 
496     function bountyOnlineTokens() constant public returns (uint256) {
497         if(_bountyOnlineTokens > 0) {
498             return _bountyOnlineTokens;
499         }
500         return token.totalSupply().mul(bountyOnlinePercents).div(70);
501     }
502 
503     function bountyOfflineTokens() constant public returns (uint256) {
504         if(_bountyOfflineTokens > 0) {
505             return _bountyOfflineTokens;
506         }
507         return token.totalSupply().mul(bountyOfflinePercents).div(70);
508     }
509 
510     function advisoryTokens() constant public returns (uint256) {
511         if(_advisoryTokens > 0) {
512             return _advisoryTokens;
513         }
514         return token.totalSupply().mul(advisoryPercents).div(70);
515     }
516 
517     function reservedTokens() constant public returns (uint256) {
518         if(_reservedTokens > 0) {
519             return _reservedTokens;
520         }
521         return token.totalSupply().mul(reservedPercents).div(70);
522     }
523 
524     // @return current stage name
525     function stageName() constant public returns (string) {
526         bool beforePeriodTLP1 = (now < startTimeTLP1);
527         bool withinPeriodTLP1 = (now >= startTimeTLP1 && now <= endTimeTLP1);
528         bool betweenPeriodTLP1andTLP2 = (now >= endTimeTLP1 && now <= startTimeTLP2);
529         bool withinPeriodTLP2 = (now >= startTimeTLP2 && now <= endTimeTLP2);
530 
531         if(beforePeriodTLP1) {
532             return 'Not started';
533         }
534 
535         if(withinPeriodTLP1) {
536             return 'TLP1.1';
537         } 
538 
539         if(betweenPeriodTLP1andTLP2) {
540             return 'Between TLP1.1 and TLP1.2';
541         }
542 
543         if(withinPeriodTLP2) {
544             return 'TLP1.2';
545         }
546 
547         return 'Finished';
548     }
549 
550     /*
551      * @dev fallback for processing ether
552      */
553     function() payable {
554         return buyTokens(msg.sender);
555     }
556 
557     /*
558      * @dev change agent for waves minting
559      * @praram agent - new agent address
560      */
561     function setFundMintingAgent(address agent) onlyOwner {
562         fundMintingAgent = agent;
563         SetFundMintingAgent(agent);
564     }
565 
566     /*
567      * @dev set TLP1.2 start date
568      * @param _at â new start date
569      */
570     function setStartTimeTLP2(uint256 _at) onlyOwner {
571         require(block.timestamp < startTimeTLP2); // forbid change time when TLP1.2 is active
572         require(block.timestamp < _at); // should be great than current block timestamp
573         require(endTimeTLP1 < _at); // should be great than end TLP1.1
574 
575         startTimeTLP2 = _at;
576         endTimeTLP2 = startTimeTLP2.add(daysTLP2);
577         SetStartTimeTLP2(_at);
578     }
579 
580     /*
581      * @dev set TLP1.1 start date
582      * @param _at - new start date
583      */
584     function setStartTimeTLP1(uint256 _at) onlyOwner {
585         require(block.timestamp < startTimeTLP1); // forbid change time when TLP1.1 is active
586         require(block.timestamp < _at); // should be great than current block timestamp
587 
588         startTimeTLP1 = _at;
589         endTimeTLP1 = startTimeTLP1.add(daysTLP1);
590         SetStartTimeTLP1(_at);
591     }
592 
593     /*
594      * @dev Large Token Holder minting 
595      * @param to - mint to address
596      * @param amount - how much mint
597      */
598     function fundMinting(address to, uint256 amount) stopInEmergency {
599         require(msg.sender == fundMintingAgent || isOwner());
600         require(block.timestamp <= startTimeTLP2);
601         require(fundTotalSupply + amount <= fundTokens);
602         require(token.totalSupply() + amount <= mintCapInTokens);
603 
604         fundTotalSupply = fundTotalSupply.add(amount);
605         FundMinting(to, amount);
606         token.mint(to, amount);
607     }
608 
609     /*
610      * @dev calculate amount
611      * @param  _value - ether to be converted to tokens
612      * @param  at - current time
613      * @param  _totalSupply - total supplied tokens
614      * @return tokens amount that we should send to our dear investor
615      * @return odd ethers amount, which contract should send back
616      */
617     function calcAmountAt(
618         uint256 amount,
619         uint256 at,
620         uint256 _totalSupply
621     ) public constant returns (uint256, uint256) {
622         uint256 estimate;
623         uint256 discount;
624         uint256 price;
625 
626         if(at >= startTimeTLP1 && at <= endTimeTLP1) {
627             /*
628                 35% 0.0650 | 1 ETH -> 1 / (100-35) * 100 / 0.1 * 1000 = 15384.61538461538 MFL
629                 30% 0.0700 | 1 ETH -> 1 / (100-30) * 100 / 0.1 * 1000 = 14285.714287 MFL
630                 15% 0.0850 | 1 ETH -> 1 / (100-15) * 100 / 0.1 * 1000 = 11764.705882352941 MFL
631                  0% 0.1000 | 1 ETH -> 1 / (100-0) * 100  / 0.1 * 1000 = 10000 MFL
632             */
633             require(amount >= minimalWeiTLP1);
634 
635             price = priceTLP1;
636 
637             if(at < startTimeTLP1 + 3 days) {
638                 discount = 65; //  100-35 = 0.065 ETH per 1000 MFL
639 
640             } else if(at < startTimeTLP1 + 6 days) {
641                 discount = 70; //  100-30 = 0.07 ETH per 1000 MFL
642 
643             } else if(at < startTimeTLP1 + 9 days) {
644                 discount = 85; //  100-15 = 0.085 ETH per 1000 MFL
645 
646             } else if(at < startTimeTLP1 + 12 days) {
647                 discount = 100; // 100 = 0.1 ETH per 1000 MFL
648 
649             } else {
650                 revert();
651             }
652 
653         } else if(at >= startTimeTLP2 && at <= endTimeTLP2) {
654             /*
655                  -40% 0.12 | 1 ETH -> 1 / (100-40) * 100 / 0.2 * 1000 = 8333.3333333333 MFL
656                  -30% 0.14 | 1 ETH -> 1 / (100-30) * 100 / 0.2 * 1000 = 7142.8571428571 MFL
657                  -20% 0.16 | 1 ETH -> 1 / (100-20) * 100 / 0.2 * 1000 = 6250 MFL
658                  -10% 0.18 | 1 ETH -> 1 / (100-10) * 100 / 0.2 * 1000 = 5555.5555555556 MFL
659                    0% 0.20 | 1 ETH -> 1 / (100-0) * 100 / 0.2 * 1000  = 5000 MFL
660                   10% 0.22 | 1 ETH -> 1 / (100+10) * 100 / 0.2 * 1000 = 4545.4545454545 MFL
661                   20% 0.24 | 1 ETH -> 1 / (100+20) * 100 / 0.2 * 1000 = 4166.6666666667 MFL
662                   30% 0.26 | 1 ETH -> 1 / (100+30) * 100 / 0.2 * 1000 = 3846.1538461538 MFL
663             */
664             require(amount >= minimalWeiTLP2);
665 
666             price = priceTLP2;
667 
668             if(at < startTimeTLP2 + 3 days) {
669                 discount = 60; // 100-40 = 0.12 ETH per 1000 MFL
670 
671             } else if(at < startTimeTLP2 + 6 days) {
672                 discount = 70; // 100-30 = 0.14 ETH per 1000 MFL
673 
674             } else if(at < startTimeTLP2 + 9 days) {
675                 discount = 80; // 100-20 = 0.16 ETH per 1000 MFL
676 
677             } else if(at < startTimeTLP2 + 12 days) {
678                 discount = 90; // 100-10 = 0.18 ETH per 1000 MFL
679 
680             } else if(at < startTimeTLP2 + 15 days) {
681                 discount = 100; // 100 = 0.2 ETH per 1000 MFL
682 
683             } else if(at < startTimeTLP2 + 18 days) {
684                 discount = 110; // 100+10 = 0.22 ETH per 1000 MFL
685 
686             } else if(at < startTimeTLP2 + 21 days) {
687                 discount = 120; // 100+20 = 0.24 ETH per 1000 MFL
688 
689             } else if(at < startTimeTLP2 + 24 days) {
690                 discount = 130; // 100+30 = 0.26 ETH per 1000 MFL
691 
692             } else {
693                 revert();
694             }
695         } else {
696             revert();
697         }
698 
699         price = price.mul(discount).div(100);
700         estimate = _totalSupply.add(amount.mul(1e18).div(price));
701 
702         if(estimate > mintCapInTokens) {
703             return (
704                 mintCapInTokens.sub(_totalSupply),
705                 estimate.sub(mintCapInTokens).mul(price).div(1e18)
706             );
707         }
708         return (estimate.sub(_totalSupply), 0);
709     }
710 
711     /*
712      * @dev sell token and send to contributor address
713      * @param contributor address
714      */
715     function buyTokens(address contributor) payable stopInEmergency validPurchase public {
716         uint256 amount;
717         uint256 odd_ethers;
718         uint256 ethers;
719         
720         (amount, odd_ethers) = calcAmountAt(msg.value, block.timestamp, token.totalSupply());
721   
722         require(contributor != 0x0) ;
723         require(amount + token.totalSupply() <= mintCapInTokens);
724 
725         ethers = (msg.value - odd_ethers);
726 
727         token.mint(contributor, amount); // fail if minting is finished
728         TokenPurchase(contributor, ethers, amount);
729         totalETH += ethers;
730 
731         if(odd_ethers > 0) {
732             require(odd_ethers < msg.value);
733             TransferOddEther(contributor, odd_ethers);
734             contributor.transfer(odd_ethers);
735         }
736 
737         wallet.transfer(ethers);
738     }
739 
740     function teamWithdraw() public {
741         require(token.mintingFinished());
742         require(msg.sender == teamWallet || isOwner());
743 
744         uint256 currentPeriod = (block.timestamp).sub(endTimeTLP2).div(teamVestingPeriodInSeconds);
745         if(currentPeriod > teamVestingPeriodsCount) {
746             currentPeriod = teamVestingPeriodsCount;
747         }
748         uint256 tokenAvailable = _teamTokens.mul(currentPeriod).div(teamVestingPeriodsCount).sub(teamTotalSupply);
749 
750         require(teamTotalSupply + tokenAvailable <= _teamTokens);
751 
752         teamTotalSupply = teamTotalSupply.add(tokenAvailable);
753 
754         TeamVesting(teamWallet, currentPeriod, tokenAvailable);
755         token.transfer(teamWallet, tokenAvailable);
756 
757     }
758 
759     function finishCrowdsale() onlyOwner public {
760         require(now > endTimeTLP2 || mintCapInTokens == token.totalSupply());
761         require(!token.mintingFinished());
762 
763         uint256 _totalSupply = token.totalSupply();
764 
765         // rewards
766         _teamTokens = _totalSupply.mul(teamPercents).div(70); // 180,000,000 MFL
767         token.mint(this, _teamTokens); // mint to contract address
768 
769         _reservedTokens = _totalSupply.mul(reservedPercents).div(70); // 180,000,000 MFL
770         token.mint(reservedWallet, _reservedTokens);
771 
772         _advisoryTokens = _totalSupply.mul(advisoryPercents).div(70); // 90,000,000 MFL
773         token.mint(advisoryWallet, _advisoryTokens);
774 
775         _bountyOfflineTokens = _totalSupply.mul(bountyOfflinePercents).div(70); // 54,000,000 MFL
776         token.mint(bountyOfflineWallet, _bountyOfflineTokens);
777 
778         _bountyOnlineTokens = _totalSupply.mul(bountyOnlinePercents).div(70); // 36,000,000 MFL
779         token.mint(bountyOnlineWallet, _bountyOnlineTokens);
780 
781         token.finishMinting();
782    }
783 
784 }