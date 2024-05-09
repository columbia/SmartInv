1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5       if (a == 0) {
6           return 0;
7       }
8       uint256 c = a * b;
9       assert(c / a == b);
10       return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14       uint256 c = a / b;
15       return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19       assert(b <= a);
20       return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24       uint256 c = a + b;
25       assert(c >= a);
26       return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     function Ownable() public {
36       owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40       require(msg.sender == owner);
41       _;
42     }
43 
44     function transferOwnership(address newOwner) public onlyOwner {
45       require(newOwner != address(0));
46 
47       OwnershipTransferred(owner, newOwner);
48       owner = newOwner;
49     }
50 }
51 
52 contract Authorizable {
53     mapping(address => bool) authorizers;
54 
55     modifier onlyAuthorized {
56       require(isAuthorized(msg.sender));
57       _;
58     }
59 
60     function Authorizable() public {
61       authorizers[msg.sender] = true;
62     }
63 
64 
65     function isAuthorized(address _addr) public constant returns(bool) {
66       require(_addr != address(0));
67 
68       bool result = bool(authorizers[_addr]);
69       return result;
70     }
71 
72     function addAuthorized(address _addr) external onlyAuthorized {
73       require(_addr != address(0));
74 
75       authorizers[_addr] = true;
76     }
77 
78     function delAuthorized(address _addr) external onlyAuthorized {
79       require(_addr != address(0));
80       require(_addr != msg.sender);
81 
82       //authorizers[_addr] = false;
83       delete authorizers[_addr];
84     }
85 }
86 
87 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
88 
89 contract ERC20Basic {
90     function totalSupply() public view returns (uint256);
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 contract ERC20 is ERC20Basic {
97     function allowance(address owner, address spender) public view returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 contract BasicToken is ERC20Basic {
104     using SafeMath for uint256;
105 
106     mapping(address => uint256) balances;
107 
108     uint256 totalSupply_;
109 
110     //modifier onlyPayloadSize(uint size) {
111     //  require(msg.data.length < size + 4);
112     //  _;
113     //}
114 
115     function totalSupply() public view returns (uint256) {
116       return totalSupply_;
117     }
118 
119     function transfer(address _to, uint256 _value) public returns (bool) {
120       //requeres in FrozenToken
121       //require(_to != address(0));
122       //require(_value <= balances[msg.sender]);
123 
124       balances[msg.sender] = balances[msg.sender].sub(_value);
125       balances[_to] = balances[_to].add(_value);
126       Transfer(msg.sender, _to, _value);
127       return true;
128     }
129 
130     function balanceOf(address _owner) public view returns (uint256 balance) {
131       return balances[_owner];
132     }
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140       //requires in FrozenToken
141       //require(_to != address(0));
142       //require(_value <= balances[_from]);
143       //require(_value <= allowed[_from][msg.sender]);
144 
145       balances[_from] = balances[_from].sub(_value);
146       balances[_to] = balances[_to].add(_value);
147       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148       Transfer(_from, _to, _value);
149       return true;
150     }
151 
152     function approve(address _spender, uint256 _value) public returns (bool) {
153       require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154       allowed[msg.sender][_spender] = _value;
155       Approval(msg.sender, _spender, _value);
156       return true;
157     }
158 
159     function allowance(address _owner, address _spender) public view returns (uint256) {
160       return allowed[_owner][_spender];
161     }
162 
163     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166       return true;
167     }
168 
169     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170       uint oldValue = allowed[msg.sender][_spender];
171       if (_subtractedValue > oldValue) {
172         allowed[msg.sender][_spender] = 0;
173       } else {
174         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175       }
176       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177       return true;
178     }
179 
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
181         tokenRecipient spender = tokenRecipient(_spender);
182         if (approve(_spender, _value)) {
183             spender.receiveApproval(msg.sender, _value, this, _extraData);
184             return true;
185         }
186     }
187 }
188 
189 contract FrozenToken is StandardToken, Ownable {
190     mapping(address => bool) frozens;
191     mapping(address => uint256) frozenTokens;
192 
193     event FrozenAddress(address addr);
194     event UnFrozenAddress(address addr);
195     event FrozenTokenEvent(address addr, uint256 amount);
196     event UnFrozenTokenEvent(address addr, uint256 amount);
197 
198     modifier isNotFrozen() {
199       require(frozens[msg.sender] == false);
200       _;
201     }
202 
203     function frozenAddress(address _addr) onlyOwner public returns (bool) {
204       require(_addr != address(0));
205 
206       frozens[_addr] = true;
207       FrozenAddress(_addr);
208       return frozens[_addr];
209     }
210 
211     function unFrozenAddress(address _addr) onlyOwner public returns (bool) {
212       require(_addr != address(0));
213 
214       delete frozens[_addr];
215       //frozens[_addr] = false;
216       UnFrozenAddress(_addr);
217       return frozens[_addr];
218     }
219 
220     function isFrozenByAddress(address _addr) public constant returns(bool) {
221       require(_addr != address(0));
222 
223       bool result = bool(frozens[_addr]);
224       return result;
225     }
226 
227     function balanceFrozenTokens(address _addr) public constant returns(uint256) {
228       require(_addr != address(0));
229 
230       uint256 result = uint256(frozenTokens[_addr]);
231       return result;
232     }
233 
234     function balanceAvailableTokens(address _addr) public constant returns(uint256) {
235       require(_addr != address(0));
236 
237       uint256 frozen = uint256(frozenTokens[_addr]);
238       uint256 balance = uint256(balances[_addr]);
239       require(balance >= frozen);
240 
241       uint256 result = balance.sub(frozen);
242 
243       return result;
244     }
245 
246     function frozenToken(address _addr, uint256 _amount) onlyOwner public returns(bool) {
247       require(_addr != address(0));
248       require(_amount > 0);
249 
250       uint256 balance = uint256(balances[_addr]);
251       require(balance >= _amount);
252 
253       frozenTokens[_addr] = frozenTokens[_addr].add(_amount);
254       FrozenTokenEvent(_addr, _amount);
255       return true;
256     }
257     
258 
259     function unFrozenToken(address _addr, uint256 _amount) onlyOwner public returns(bool) {
260       require(_addr != address(0));
261       require(_amount > 0);
262       require(frozenTokens[_addr] >= _amount);
263 
264       frozenTokens[_addr] = frozenTokens[_addr].sub(_amount);
265       UnFrozenTokenEvent(_addr, _amount);
266       return true;
267     }
268 
269     function transfer(address _to, uint256 _value) isNotFrozen() public returns (bool) {
270       require(_to != address(0));
271       require(_value <= balances[msg.sender]);
272 
273       uint256 balance = balances[msg.sender];
274       uint256 frozen = frozenTokens[msg.sender];
275       uint256 availableBalance = balance.sub(frozen);
276       require(availableBalance >= _value);
277 
278       return super.transfer(_to, _value);
279     }
280 
281     function transferFrom(address _from, address _to, uint256 _value) isNotFrozen() public returns (bool) {
282       require(_to != address(0));
283       require(_value <= balances[_from]);
284       require(_value <= allowed[_from][msg.sender]);
285 
286       uint256 balance = balances[_from];
287       uint256 frozen = frozenTokens[_from];
288       uint256 availableBalance = balance.sub(frozen);
289       require(availableBalance >= _value);
290 
291       return super.transferFrom(_from ,_to, _value);
292     }
293 }
294 
295 contract MallcoinToken is FrozenToken, Authorizable {
296       string public constant name = "Mallcoin Token";
297       string public constant symbol = "MLC";
298       uint8 public constant decimals = 18;
299       uint256 public MAX_TOKEN_SUPPLY = 250000000 * 1 ether;
300 
301       event CreateToken(address indexed to, uint256 amount);
302       event CreateTokenByAtes(address indexed to, uint256 amount, string data);
303 
304       modifier onlyOwnerOrAuthorized {
305         require(msg.sender == owner || isAuthorized(msg.sender));
306         _;
307       }
308 
309       function createToken(address _to, uint256 _amount) onlyOwnerOrAuthorized public returns (bool) {
310         require(_to != address(0));
311         require(_amount > 0);
312         require(MAX_TOKEN_SUPPLY >= totalSupply_ + _amount);
313 
314         totalSupply_ = totalSupply_.add(_amount);
315         balances[_to] = balances[_to].add(_amount);
316 
317         // KYC
318         frozens[_to] = true;
319         FrozenAddress(_to);
320 
321         CreateToken(_to, _amount);
322         Transfer(address(0), _to, _amount);
323         return true;
324       }
325 
326       function createTokenByAtes(address _to, uint256 _amount, string _data) onlyOwnerOrAuthorized public returns (bool) {
327         require(_to != address(0));
328         require(_amount > 0);
329         require(bytes(_data).length > 0);
330         require(MAX_TOKEN_SUPPLY >= totalSupply_ + _amount);
331 
332         totalSupply_ = totalSupply_.add(_amount);
333         balances[_to] = balances[_to].add(_amount);
334 
335         // KYC
336         frozens[_to] = true;
337         FrozenAddress(_to);
338 
339         CreateTokenByAtes(_to, _amount, _data);
340         Transfer(address(0), _to, _amount);
341         return true;
342       }
343 } 
344 
345 contract MallcoinCrowdSale is Ownable, Authorizable {
346       using SafeMath for uint256;
347 
348       MallcoinToken public token;
349       address public wallet; 
350 
351       uint256 public PRE_ICO_START_TIME = 1519297200; // Thursday, 22 February 2018, 11:00:00 GMT
352       uint256 public PRE_ICO_END_TIME = 1520550000; // Thursday, 8 March 2018, 23:00:00 GMT
353       uint256 public PRE_ICO_BONUS_TIME_1 =  1519556400; // Sunday, 25 February 2018, 11:00:00 GMT
354       uint256 public PRE_ICO_BONUS_TIME_2 =  1519988400; // Friday, 2 March 2018, 11:00:00 GMT
355       uint256 public PRE_ICO_BONUS_TIME_3 =  1520334000; // Tuesday, 6 March 2018, 11:00:00 GMT
356       uint256 public PRE_ICO_RATE = 3000 * 1 ether; // 1 Ether = 3000 MLC
357       uint256 public PRE_ICO_BONUS_RATE = 75 * 1 ether; // 75 MLC = 2.5%
358       uint256 public preIcoTokenSales;
359 
360       uint256 public ICO_START_TIME = 1521716400; // Thursday, 22 March 2018, 11:00:00 GMT
361       uint256 public ICO_END_TIME = 1523574000; // Thursday, 12 April 2018, 23:00:00 GMT
362       uint256 public ICO_BONUS_TIME_1 = 1521975600; // Sunday, 25 March 2018, 11:00:00 GMT
363       uint256 public ICO_BONUS_TIME_2 = 1522839600; // Wednesday, 4 April 2018, 11:00:00 GMT
364       uint256 public ICO_BONUS_TIME_3 = 1523358000; // Tuesday, 10 April 2018, 11:00:00 GMT
365       uint256 public ICO_RATE = 2000 * 1 ether; // 1 Ether = 2000 MLC
366       uint256 public ICO_BONUS_RATE = 50 * 1 ether; // 50 MLC = 2.5%
367       uint256 public icoTokenSales;
368 
369       uint256 public SECRET_BONUS_FACTOR = 0;
370 
371       bool public crowdSaleStop = false;
372 
373       uint256 public MAX_TOKEN_SUPPLY = 250000000 * 1 ether;
374       uint256 public MAX_CROWD_SALE_TOKENS = 185000000 * 1 ether;
375       uint256 public weiRaised;
376       uint256 public tokenSales;
377       uint256 public bountyTokenFund;
378       uint256 public reserveTokenFund;
379       uint256 public teamTokenFund;
380 
381 
382       event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
383       event ChangeCrowdSaleDate(uint8 period, uint256 unixtime);
384 
385       modifier onlyOwnerOrAuthorized {
386         require(msg.sender == owner || isAuthorized(msg.sender));
387         _;
388       }
389 
390       function MallcoinCrowdSale() public {
391         wallet = owner;
392         preIcoTokenSales = 0;
393         icoTokenSales = 0;
394         weiRaised = 0;
395         tokenSales = 0;
396 
397         bountyTokenFund = 0;
398         reserveTokenFund = 0;
399         teamTokenFund = 0;
400       
401       }
402 
403    function () external payable {
404      buyTokens(msg.sender);
405    }
406 
407     function buyTokens(address beneficiary) public payable {
408       require(beneficiary != address(0));
409       require(validPurchase());
410 
411       uint256 weiAmount = msg.value;
412       uint256 _buyTokens = 0;
413       uint256 rate = 0;
414       if (now >= PRE_ICO_START_TIME && now <= PRE_ICO_END_TIME) {
415         rate = PRE_ICO_RATE.add(getPreIcoBonusRate());
416         _buyTokens = rate.mul(weiAmount).div(1 ether);
417         preIcoTokenSales = preIcoTokenSales.add(_buyTokens);
418       } else if (now >= ICO_START_TIME && now <= ICO_END_TIME) {
419         rate = ICO_RATE.add(getIcoBonusRate());
420         _buyTokens = rate.mul(weiAmount).div(1 ether);
421         icoTokenSales = icoTokenSales.add(_buyTokens);
422       }
423 
424       require(MAX_CROWD_SALE_TOKENS >= tokenSales.add(_buyTokens));
425 
426       tokenSales = tokenSales.add(_buyTokens);
427       weiRaised = weiRaised.add(weiAmount);
428       wallet.transfer(msg.value);
429       token.createToken(beneficiary, _buyTokens);
430       TokenPurchase(msg.sender, beneficiary, weiAmount, _buyTokens);
431     }
432 
433     function buyTokensByAtes(address addr_, uint256 amount_, string data_) onlyOwnerOrAuthorized  public returns (bool) {
434       require(addr_ != address(0));
435       require(amount_ > 0);
436       require(bytes(data_).length > 0);
437       require(validPurchase());
438 
439       uint256 _buyTokens = 0;
440       uint256 rate = 0;
441       if (now >= PRE_ICO_START_TIME && now <= PRE_ICO_END_TIME) {
442         rate = PRE_ICO_RATE.add(getPreIcoBonusRate());
443         _buyTokens = rate.mul(amount_).div(1
444 
445 ether);
446         preIcoTokenSales = preIcoTokenSales.add(_buyTokens);
447       } else if (now >= ICO_START_TIME && now <= ICO_END_TIME) {
448         rate = ICO_RATE.add(getIcoBonusRate());
449         _buyTokens = rate.mul(amount_).div(1 ether);
450         icoTokenSales = icoTokenSales.add(_buyTokens);
451       }
452 
453       require(MAX_CROWD_SALE_TOKENS >= tokenSales.add(_buyTokens));
454 
455       tokenSales = tokenSales.add(_buyTokens);
456       weiRaised = weiRaised.add(amount_);
457       token.createTokenByAtes(addr_, _buyTokens, data_);
458       TokenPurchase(msg.sender, addr_, amount_, _buyTokens);
459 
460       return true;
461     }
462 
463     function getPreIcoBonusRate() private view returns (uint256 bonus) {
464       bonus = 0;
465       uint256 factorBonus = getFactorBonus();
466 
467       if (factorBonus > 0) {
468         if (now >= PRE_ICO_START_TIME && now < PRE_ICO_BONUS_TIME_1) { // Sunday, 25 February 2018, 11:00:00 GMT
469           factorBonus = factorBonus.add(7);
470           bonus = PRE_ICO_BONUS_RATE.mul(factorBonus); // add 600-750 MLC
471         } else if (now >= PRE_ICO_BONUS_TIME_1 && now < PRE_ICO_BONUS_TIME_2) { // Friday, 2 March 2018, 11:00:00 GMT
472           factorBonus = factorBonus.add(5);
473           bonus = PRE_ICO_BONUS_RATE.mul(factorBonus); // add 450-600 MLC
474         } else if (now >= PRE_ICO_BONUS_TIME_2 && now < PRE_ICO_BONUS_TIME_3) { // Tuesday, 6 March 2018, 11:00:00 GMT
475           factorBonus = factorBonus.add(1);
476           bonus = PRE_ICO_BONUS_RATE.mul(factorBonus); // add 150-300 MLC
477         } 
478       }
479 
480       return bonus;
481     }
482 
483     function getIcoBonusRate() private view returns (uint256 bonus) {
484       bonus = 0;
485       uint256 factorBonus = getFactorBonus();
486 
487       if (factorBonus > 0) {
488         if (now >= ICO_START_TIME && now < ICO_BONUS_TIME_1) { // Sunday, 25 March 2018, 11:00:00 GMT
489           factorBonus = factorBonus.add(7);
490           bonus = ICO_BONUS_RATE.mul(factorBonus); // add 400-500 MLC
491         } else if (now >= ICO_BONUS_TIME_1 && now < ICO_BONUS_TIME_2) { // Wednesday, 4 April 2018, 11:00:00 GMT
492           factorBonus = factorBonus.add(5);
493           bonus = ICO_BONUS_RATE.mul(factorBonus); // add 300-400 MLC
494         } else if (now >= ICO_BONUS_TIME_2 && now < ICO_BONUS_TIME_3) { // Tuesday, 10 April 2018, 11:00:00 GMT
495           factorBonus = factorBonus.add(1);
496           bonus = ICO_BONUS_RATE.mul(factorBonus); // add 100-200 MLC
497         } else if (now >= ICO_BONUS_TIME_3 && now < ICO_END_TIME) { // Secret bonus dates
498           factorBonus = factorBonus.add(SECRET_BONUS_FACTOR);
499           bonus = ICO_BONUS_RATE.mul(factorBonus); // add 150-300 MLC
500         } 
501       }
502 
503       return bonus;
504     }
505 
506     function getFactorBonus() private view returns (uint256 factor) {
507       factor = 0;
508       if (msg.value >= 5 ether && msg.value < 10 ether) {
509         factor = 1;
510       } else if (msg.value >= 10 ether && msg.value < 100 ether) {
511         factor = 2;
512       } else if (msg.value >= 100 ether) {
513         factor = 3;
514       }
515       return factor;
516     }
517 
518    function validPurchase() internal view returns (bool) {
519       bool withinPeriod = false;
520      if (now >= PRE_ICO_START_TIME && now <= PRE_ICO_END_TIME && !crowdSaleStop) {
521         withinPeriod = true;
522       } else if (now >= ICO_START_TIME && now <= ICO_END_TIME && !crowdSaleStop) {
523         withinPeriod = true;
524       }
525      bool nonZeroPurchase = msg.value > 0;
526       
527      return withinPeriod && nonZeroPurchase;
528    }
529 
530     function stopCrowdSale() onlyOwner public {
531       crowdSaleStop = true;
532     }
533 
534     function startCrowdSale() onlyOwner public {
535       crowdSaleStop = false;
536     }
537 
538     function changeCrowdSaleDates(uint8 _period, uint256 _unixTime) onlyOwner public {
539       require(_period > 0 && _unixTime > 0);
540 
541       if (_period == 1) {
542         PRE_ICO_START_TIME = _unixTime;
543         ChangeCrowdSaleDate(_period, _unixTime);
544       } else if (_period == 2) {
545         PRE_ICO_END_TIME = _unixTime;
546         ChangeCrowdSaleDate(_period, _unixTime);
547       } else if (_period == 3) {
548         PRE_ICO_BONUS_TIME_1 = _unixTime;
549         ChangeCrowdSaleDate(_period, _unixTime);
550       } else if (_period == 4) {
551 
552 PRE_ICO_BONUS_TIME_2 = _unixTime;
553         ChangeCrowdSaleDate(_period, _unixTime);
554       } else if (_period == 5) {
555         PRE_ICO_BONUS_TIME_3 = _unixTime;
556         ChangeCrowdSaleDate(_period, _unixTime);
557       } else if (_period == 6) {
558         ICO_START_TIME = _unixTime;
559         ChangeCrowdSaleDate(_period, _unixTime);
560       } else if (_period == 7) {
561         ICO_END_TIME = _unixTime;
562         ChangeCrowdSaleDate(_period, _unixTime);
563       } else if (_period == 8) {
564         ICO_BONUS_TIME_1 = _unixTime;
565         ChangeCrowdSaleDate(_period, _unixTime);
566       } else if (_period == 9) {
567         ICO_BONUS_TIME_2 = _unixTime;
568         ChangeCrowdSaleDate(_period, _unixTime);
569       } else if (_period == 10) {
570         ICO_BONUS_TIME_3 = _unixTime;
571         ChangeCrowdSaleDate(_period, _unixTime);
572       } 
573     }
574 
575     function setSecretBonusFactor(uint256 _factor) onlyOwner public {
576       require(_factor >= 0);
577 
578       SECRET_BONUS_FACTOR = _factor;
579     }
580     
581     function changeMallcoinTokenAddress(address _token) onlyOwner public {
582       require(_token != address(0));
583 
584       token = MallcoinToken(_token);
585     }
586 
587     function finishCrowdSale() onlyOwner public returns (bool) {
588       crowdSaleStop = true;
589       teamTokenFund = tokenSales.div(100).mul(10); // Team fund 10%
590       bountyTokenFund = tokenSales.div(100).mul(7); // Bounty fund 7%;
591       reserveTokenFund = tokenSales.div(100).mul(9); // Reserve fund 9%;
592 
593       uint256 tokensFund = teamTokenFund.add(bountyTokenFund).add(reserveTokenFund);
594       wallet.transfer(this.balance);
595       token.createToken(wallet, tokensFund);
596 
597       return true;
598     }
599 }