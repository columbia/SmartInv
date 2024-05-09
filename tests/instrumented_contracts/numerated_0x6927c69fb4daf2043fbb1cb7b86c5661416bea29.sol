1 pragma solidity ^0.4.21;
2 
3 /// @title SafeMath contract - Math operations with safety checks.
4 /// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5 contract SafeMath {
6     function mulsm(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function divsm(uint256 a, uint256 b) internal pure returns (uint256) {
13         assert(b > 0);
14         uint c = a / b;
15         assert(a == b * c + a % b);
16         return c;
17     }
18 
19     function subsm(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function addsm(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 
30     function powsm(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint c = a ** b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract Owned {
38 
39     event NewOwner(address old, address current);
40     event NewPotentialOwner(address old, address potential);
41 
42     address public owner = msg.sender;
43     address public potentialOwner;
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     modifier onlyPotentialOwner {
51         require(msg.sender == potentialOwner);
52         _;
53     }
54 
55     function setOwner(address _new) public onlyOwner {
56         emit NewPotentialOwner(owner, _new);
57         potentialOwner = _new;
58     }
59 
60     function confirmOwnership() public onlyPotentialOwner {
61         emit NewOwner(owner, potentialOwner);
62         owner = potentialOwner;
63         potentialOwner = 0;
64     }
65 }
66 
67 contract Managed is Owned {
68 
69     event NewManager(address owner, address manager);
70 
71     mapping (address => bool) public manager;
72 
73     modifier onlyManager() {
74         require(manager[msg.sender] == true || msg.sender == owner);
75         _;
76     }
77 
78     function setManager(address _manager) public onlyOwner {
79         emit NewManager(owner, _manager);
80         manager[_manager] = true;
81     }
82 
83     function superManager(address _manager) internal {
84         emit NewManager(owner, _manager);
85         manager[_manager] = true;
86     }
87 
88     function delManager(address _manager) public onlyOwner {
89         emit NewManager(owner, _manager);
90         manager[_manager] = false;
91     }
92 }
93 
94 /// @title Abstract Token, ERC20 token interface
95 contract ERC20 {
96 
97     function name() constant public returns (string);
98     function symbol() constant public returns (string);
99     function decimals() constant public returns (uint8);
100     function totalSupply() constant public returns (uint256);
101     function balanceOf(address owner) public view returns (uint256);
102     function transfer(address to, uint256 value) public returns (bool);
103     function transferFrom(address from, address to, uint256 value) public returns (bool);
104     function approve(address spender, uint256 value) public returns (bool);
105     function allowance(address owner, address spender) public view returns (uint256);
106 
107     event Transfer(address indexed from, address indexed to, uint256 value);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /// Full complete implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
112 contract StandardToken is SafeMath, ERC20  {
113 
114     string  public name;
115     string  public symbol;
116     uint8   public decimals;
117     uint256 public totalSupply;
118 
119     mapping (address => uint256) internal balances;
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122     /// @dev Returns number of tokens owned by given address.
123     function name() public view returns (string) {
124         return name;
125     }
126 
127     /// @dev Returns number of tokens owned by given address.
128     function symbol() public view returns (string) {
129         return symbol;
130     }
131 
132     /// @dev Returns number of tokens owned by given address.
133     function decimals() public view returns (uint8) {
134         return decimals;
135     }
136 
137     /// @dev Returns number of tokens owned by given address.
138     function totalSupply() public view returns (uint256) {
139         return totalSupply;
140     }
141 
142 
143     /// @dev Returns number of tokens owned by given address.
144     /// @param _owner Address of token owner.
145     function balanceOf(address _owner) public view returns (uint256) {
146         return balances[_owner];
147     }
148 
149     /// @dev Transfers sender's tokens to a given address. Returns success.
150     /// @param _to Address of token receiver.
151     /// @param _value Number of tokens to transfer.
152     function transfer(address _to, uint256 _value) public returns (bool) {
153         require(_to != address(this)); //prevent direct send to contract
154         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
155             balances[msg.sender] -= _value;
156             balances[_to] += _value;
157             emit Transfer(msg.sender, _to, _value);
158             return true;
159         }
160         else {
161             return false;
162         }
163     }
164 
165     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
167             balances[_to] += _value;
168             balances[_from] -= _value;
169             allowed[_from][msg.sender] -= _value;
170             emit Transfer(_from, _to, _value);
171             return true;
172         }
173         else {
174             return false;
175         }
176     }
177 
178     function approve(address _spender, uint256 _value) public returns (bool) {
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     function allowance(address _owner, address _spender) public view returns (uint256) {
185       return allowed[_owner][_spender];
186     }
187 }
188 
189 /**
190    @title ERC827 interface, an extension of ERC20 token standard
191 
192    Interface of a ERC827 token, following the ERC20 standard with extra
193    methods to transfer value and data and execute calls in transfers and
194    approvals.
195  */
196 contract ERC827 {
197 
198   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
199   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
200   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
201 
202 }
203 
204 /**
205    @title ERC827, an extension of ERC20 token standard
206 
207    Implementation the ERC827, following the ERC20 standard with extra
208    methods to transfer value and data and execute calls in transfers and
209    approvals.
210    Uses OpenZeppelin StandardToken.
211  */
212 contract ERC827Token is ERC827, StandardToken {
213 
214   /**
215      @dev Addition to ERC20 token methods. It allows to
216      approve the transfer of value and execute a call with the sent data.
217 
218      Beware that changing an allowance with this method brings the risk that
219      someone may use both the old and the new allowance by unfortunate
220      transaction ordering. One possible solution to mitigate this race condition
221      is to first reduce the spender's allowance to 0 and set the desired value
222      afterwards:
223      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224 
225      @param _spender The address that will spend the funds.
226      @param _value The amount of tokens to be spent.
227      @param _data ABI-encoded contract call to call `_to` address.
228 
229      @return true if the call function was executed successfully
230    */
231   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
232     require(_spender != address(this));
233 
234     super.approve(_spender, _value);
235 
236     require(_spender.call(_data));
237 
238     return true;
239   }
240 
241   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
242     require(_to != address(this));
243 
244     super.transfer(_to, _value);
245 
246     require(_to.call(_data));
247     return true;
248   }
249 
250   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
251     require(_to != address(this));
252 
253     super.transferFrom(_from, _to, _value);
254 
255     require(_to.call(_data));
256     return true;
257   }
258 }
259 
260 contract MintableToken is ERC827Token {
261 
262         uint256 constant maxSupply = 1e30; // max amount of tokens 1 trillion
263         bool internal mintable = true;
264 
265         modifier isMintable() {
266             require(mintable);
267             _;
268         }
269 
270         function stopMint() internal {
271             mintable = false;
272         }
273 
274         // triggered when the total supply is increased
275         event Issuance(uint256 _amount);
276         // triggered when the total supply is decreased
277         event Destruction(uint256 _amount);
278 
279         /**
280             @dev increases the token supply and sends the new tokens to an account
281             can only be called by the contract owner
282             @param _to         account to receive the new amount
283             @param _amount     amount to increase the supply by
284         */
285         function issue(address _to, uint256 _amount) internal {
286             assert(totalSupply + _amount <= maxSupply); // prevent overflows
287             totalSupply +=  _amount;
288             balances[_to] += _amount;
289             emit Issuance(_amount);
290             emit Transfer(this, _to, _amount);
291         }
292 
293         /**
294             @dev removes tokens from an account and decreases the token supply
295             can only be called by the contract owner
296             (if robbers detected, if will be consensus about token amount)
297 
298             @param _from       account to remove the amount from
299             @param _amount     amount to decrease the supply by
300         */
301         /* function destroy(address _from, uint256 _amount) public onlyOwner {
302             balances[_from] -= _amount;
303             _totalSupply -= _amount;
304             Transfer(_from, this, _amount);
305             Destruction(_amount);
306         } */
307 }
308 
309 contract PaymentManager is MintableToken, Owned {
310 
311     uint256 public receivedWais;
312     uint256 internal _price;
313     bool internal paused = false;
314 
315     modifier isSuspended() {
316         require(!paused);
317         _;
318     }
319 
320    function setPrice(uint256 _value) public onlyOwner returns (bool) {
321         _price = _value;
322         return true;
323     }
324 
325     function watchPrice() public view returns (uint256 price) {
326         return _price;
327     }
328 
329     function rateSystem(address _to, uint256 _value) internal returns (bool) {
330         uint256 _amount;
331         if(_value >= (1 ether / 1000) && _value <= 1 ether) {
332             _amount = _value * _price;
333         } else
334         if(_value >= 1 ether) {
335              _amount = divsm(powsm(_value, 2), 1 ether) * _price;
336         }
337         issue(_to, _amount);
338         if(paused == false) {
339             if(totalSupply > 1 * 10e9 * 1 * 1 ether) paused = true; // if more then 10 billions stop sell
340         }
341         return true;
342     }
343 
344     /** @dev transfer ethereum from contract */
345     function transferEther(address _to, uint256 _value) public onlyOwner {
346         _to.transfer(_value);
347     }
348 }
349 
350 contract InvestBox is PaymentManager, Managed {
351 
352     // triggered when the amount of reaward are changed
353     event BonusChanged(uint256 _amount);
354     // triggered when making invest
355     event Invested(address _from, uint256 _value);
356     // triggered when invest closed or updated
357     event InvestClosed(address _who, uint256 _value);
358     // triggered when counted
359     event Counted(address _sender, uint256 _intervals);
360 
361     uint256 constant _day = 24 * 60 * 60 * 1 seconds;
362 
363     bytes5 internal _td = bytes5("day");
364     bytes5 internal _tw = bytes5("week");
365     bytes5 internal _tm = bytes5("month");
366     bytes5 internal _ty = bytes5("year");
367 
368     uint256 internal _creation;
369     uint256 internal _1sty;
370     uint256 internal _2ndy;
371 
372     uint256 internal min_invest;
373     uint256 internal max_invest;
374 
375     struct invest {
376         bool exists;
377         uint256 balance;
378         uint256 created; // creation time
379         uint256 closed;  // closing time
380     }
381 
382     mapping (address => mapping (bytes5 => invest)) public investInfo;
383 
384     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
385         bytes memory tempEmptyStringTest = bytes(source);
386         if (tempEmptyStringTest.length == 0) {
387             return 0x0;
388         }
389         assembly {
390             result := mload(add(source, 32))
391         }
392     }
393 
394     /** @dev return in interface string encoded to bytes (max len 5 bytes) */
395     function stringToBytes5(string _data) public pure returns (bytes5) {
396         return bytes5(stringToBytes32(_data));
397     }
398 
399     struct intervalBytecodes {
400         string day;
401         string week;
402         string month;
403         string year;
404     }
405 
406     intervalBytecodes public IntervalBytecodes;
407 
408     /** @dev setter min max params for investition */
409     function setMinMaxInvestValue(uint256 _min, uint256 _max) public onlyOwner {
410         min_invest = _min * 10 ** uint256(decimals);
411         max_invest = _max * 10 ** uint256(decimals);
412     }
413 
414     /** @dev number of complete cycles d/m/w/y */
415     function countPeriod(address _investor, bytes5 _t) internal view returns (uint256) {
416         uint256 _period;
417         uint256 _now = now; // blocking timestamp
418         if (_t == _td) _period = 1 * _day;
419         if (_t == _tw) _period = 7 * _day;
420         if (_t == _tm) _period = 31 * _day;
421         if (_t == _ty) _period = 365 * _day;
422         invest storage inv = investInfo[_investor][_t];
423         if (_now - inv.created < _period) return 0;
424         return (_now - inv.created)/_period; // get full days
425     }
426 
427     /** @dev loop 'for' wrapper, where 100,000%, 10^3 decimal */
428     function loopFor(uint256 _condition, uint256 _data, uint256 _bonus) internal pure returns (uint256 r) {
429         assembly {
430             for { let i := 0 } lt(i, _condition) { i := add(i, 1) } {
431               let m := mul(_data, _bonus)
432               let d := div(m, 100000)
433               _data := add(_data, d)
434             }
435             r := _data
436         }
437     }
438 
439     /** @dev invest box controller */
440     function rewardController(address _investor, bytes5 _type) internal view returns (uint256) {
441 
442         uint256 _period;
443         uint256 _balance;
444         uint256 _created;
445 
446         invest storage inv = investInfo[msg.sender][_type];
447 
448         _period = countPeriod(_investor, _type);
449         _balance = inv.balance;
450         _created = inv.created;
451 
452         uint256 full_steps;
453         uint256 last_step;
454         uint256 _d;
455 
456         if(_type == _td) _d = 365;
457         if(_type == _tw) _d = 54;
458         if(_type == _tm) _d = 12;
459         if(_type == _ty) _d = 1;
460 
461         full_steps = _period/_d;
462         last_step = _period - (full_steps * _d);
463 
464         for(uint256 i=0; i<full_steps; i++) { // not executed if zero
465             _balance = compaundIntrest(_d, _type, _balance, _created);
466             _created += 1 years;
467         }
468 
469         if(last_step > 0) _balance = compaundIntrest(last_step, _type, _balance, _created);
470 
471         return _balance;
472     }
473 
474     /**
475         @dev Compaund Intrest realization, return balance + Intrest
476         @param _period - time interval dependent from invest time
477     */
478     function compaundIntrest(uint256 _period, bytes5 _type, uint256 _balance, uint256 _created) internal view returns (uint256) {
479         uint256 full_steps;
480         uint256 last_step;
481         uint256 _d = 100; // safe divider
482         uint256 _bonus = bonusSystem(_type, _created);
483 
484         if (_period>_d) {
485             full_steps = _period/_d;
486             last_step = _period - (full_steps * _d);
487             for(uint256 i=0; i<full_steps; i++) {
488                 _balance = loopFor(_d, _balance, _bonus);
489             }
490             if(last_step > 0) _balance = loopFor(last_step, _balance, _bonus);
491         } else
492         if (_period<=_d) {
493             _balance = loopFor(_period, _balance, _bonus);
494         }
495         return _balance;
496     }
497 
498     /** @dev Bonus program */
499     function bonusSystem(bytes5 _t, uint256 _now) internal view returns (uint256) {
500         uint256 _b;
501         if (_t == _td) {
502             if (_now < _1sty) {
503                 _b = 600; // 0.6 %/day  // 100.6 % by day => 887.69 % by year
504             } else
505             if (_now >= _1sty && _now < _2ndy) {
506                 _b = 300; // 0.3 %/day
507             } else
508             if (_now >= _2ndy) {
509                 _b = 30; // 0.03 %/day
510             }
511         }
512         if (_t == _tw) {
513             if (_now < _1sty) {
514                 _b = 5370; // 0.75 %/day => 5.37 % by week => 1529.13 % by year
515             } else
516             if (_now >= _1sty && _now < _2ndy) {
517                 _b = 2650; // 0.375 %/day
518             } else
519             if (_now >= _2ndy) {
520                 _b = 270; // 0.038 %/day
521             }
522         }
523         if (_t == _tm) {
524             if (_now < _1sty) {
525                 _b = 30000; // 0.85 %/day // 130 % by month => 2196.36 % by year
526             } else
527             if (_now >= _1sty && _now < _2ndy) {
528 
529                 _b = 14050; // 0.425 %/day
530             } else
531             if (_now >= _2ndy) {
532                 _b = 1340; // 0.043 %/day
533             }
534         }
535         if (_t == _ty) {
536             if (_now < _1sty) {
537                 _b = 3678000; // 1 %/day // 3678.34 * 1000 = 3678340 = 3678% by year
538             } else
539             if (_now >= _1sty && _now < _2ndy) {
540                 _b = 517470; // 0.5 %/day
541             } else
542             if (_now >= _2ndy) {
543                 _b = 20020; // 0.05 %/day
544             }
545         }
546         return _b;
547     }
548 
549     /** @dev make invest */
550     function makeInvest(uint256 _value, bytes5 _interval) internal isMintable {
551         require(min_invest <= _value && _value <= max_invest); // min max condition
552         assert(balances[msg.sender] >= _value && balances[this] + _value > balances[this]);
553         balances[msg.sender] -= _value;
554         balances[this] += _value;
555         invest storage inv = investInfo[msg.sender][_interval];
556         if (inv.exists == false) { // if invest no exists
557             inv.balance = _value;
558             inv.created = now;
559             inv.closed = 0;
560             emit Transfer(msg.sender, this, _value);
561         } else
562         if (inv.exists == true) {
563             uint256 rew = rewardController(msg.sender, _interval);
564             inv.balance = _value + rew;
565             inv.closed = 0;
566             emit Transfer(0x0, this, rew); // fix rise total supply
567         }
568         inv.exists = true;
569         emit Invested(msg.sender, _value);
570         if(totalSupply > maxSupply) stopMint(); // stop invest
571     }
572 
573     function makeDailyInvest(uint256 _value) public {
574         makeInvest(_value * 10 ** uint256(decimals), _td);
575     }
576 
577     function makeWeeklyInvest(uint256 _value) public {
578         makeInvest(_value * 10 ** uint256(decimals), _tw);
579     }
580 
581     function makeMonthlyInvest(uint256 _value) public {
582         makeInvest(_value * 10 ** uint256(decimals), _tm);
583     }
584 
585     function makeAnnualInvest(uint256 _value) public {
586         makeInvest(_value * 10 ** uint256(decimals), _ty);
587     }
588 
589     /** @dev close invest */
590     function closeInvest(bytes5 _interval) internal {
591         uint256 _intrest;
592         address _to = msg.sender;
593         uint256 _period = countPeriod(_to, _interval);
594         invest storage inv = investInfo[_to][_interval];
595         uint256 _value = inv.balance;
596         if (_period == 0) {
597             balances[this] -= _value;
598             balances[_to] += _value;
599             emit Transfer(this, _to, _value); // tx of begining balance
600             emit InvestClosed(_to, _value);
601         } else
602         if (_period > 0) {
603             // Destruction init
604             balances[this] -= _value;
605             totalSupply -= _value;
606             emit Transfer(this, 0x0, _value);
607             emit Destruction(_value);
608             // Issue init
609             _intrest = rewardController(_to, _interval);
610             if(manager[msg.sender]) {
611                 _intrest = mulsm(divsm(_intrest, 100), 105); // addition 5% bonus for manager
612             }
613             issue(_to, _intrest); // tx of %
614             emit InvestClosed(_to, _intrest);
615         }
616         inv.exists = false; // invest inv clear
617         inv.balance = 0;
618         inv.closed = now;
619     }
620 
621     function closeDailyInvest() public {
622         closeInvest(_td);
623     }
624 
625     function closeWeeklyInvest() public {
626         closeInvest(_tw);
627     }
628 
629     function closeMonthlyInvest() public {
630         closeInvest(_tm);
631     }
632 
633     function closeAnnualInvest() public {
634         closeInvest(_ty);
635     }
636 
637     /** @dev safe closing invest, checking for complete by date. */
638     function isFullInvest(address _ms, bytes5 _t) internal returns (uint256) {
639         uint256 res = countPeriod(_ms, _t);
640         emit Counted(msg.sender, res);
641         return res;
642     }
643 
644     function countDays() public returns (uint256) {
645         return isFullInvest(msg.sender, _td);
646     }
647 
648     function countWeeks() public returns (uint256) {
649         return isFullInvest(msg.sender, _tw);
650     }
651 
652     function countMonths() public returns (uint256) {
653         return isFullInvest(msg.sender, _tm);
654     }
655 
656     function countYears() public returns (uint256) {
657         return isFullInvest(msg.sender, _ty);
658     }
659 }
660 
661 contract EthereumRisen is InvestBox {
662 
663     // devs addresess, pay for code
664     address public devWallet = address(0x00FBB38c017843DFa86a97c31fECaCFF0a092F6F);
665     uint256 constant public devReward = 100000 * 1e18; // 100K
666 
667     // fondation for pay by promotion this project
668     address public bountyWallet = address(0x00Ed07D0170B1c5F3EeDe1fC7261719e04b15ecD);
669     uint256 constant public bountyReward = 50000 * 1e18; // 50K
670 
671     // will be send for first 10k rischest wallets, if it is enough to pay the commission
672     address public airdropWallet = address(0x000DdB5A903d15b2F7f7300f672d2EB9bF882143);
673     uint256 constant public airdropReward = 99900 * 1e18; // 99.9K
674 
675     bool internal _airdrop_status = false;
676     uint256 internal _paySize;
677 
678     /** init airdrop program if cap will reach сost price */
679     function startAirdrop() public onlyOwner {
680         if(address(this).balance < 5 ether && _airdrop_status == true) revert();
681         issue(airdropWallet, airdropReward);
682         _paySize = 999 * 1e16; // 9.99 tokens
683         _airdrop_status = true;
684     }
685 
686     /**
687         @dev notify owners about their balances was in promo action.
688         @param _holders addresses of the owners to be notified ["address_1", "address_2", ..]
689      */
690     function airdropper(address [] _holders, uint256 _pay_size) public onlyManager {
691         if(_pay_size == 0) _pay_size = _paySize; // if empty set default
692         if(_pay_size < 1 * 1e18) revert(); // limit no less then 1 token
693         uint256 count = _holders.length;
694         require(count <= 200);
695         assert(_pay_size * count <= balanceOf(msg.sender));
696         for (uint256 i = 0; i < count; i++) {
697             transfer(_holders [i], _pay_size);
698         }
699     }
700 
701     function EthereumRisen() public {
702 
703         name = "Ethereum Risen";
704         symbol = "ETR";
705         decimals = 18;
706         totalSupply = 0;
707         _creation = now;
708         _1sty = now + 365 * 1 days;
709         _2ndy = now + 2 * 365 * 1 days;
710 
711         PaymentManager.setPrice(10000);
712         Managed.setManager(bountyWallet);
713         InvestBox.IntervalBytecodes = intervalBytecodes(
714             "0x6461790000",
715             "0x7765656b00",
716             "0x6d6f6e7468",
717             "0x7965617200"
718         );
719         InvestBox.setMinMaxInvestValue(1000,100000000);
720         issue(bountyWallet, bountyReward);
721         issue(devWallet, devReward);
722     }
723 
724     function() public payable isSuspended {
725         require(msg.value >= (1 ether / 100));
726         if(msg.value >= 5 ether) superManager(msg.sender); // you can make airdrop from this contract
727         rateSystem(msg.sender, msg.value);
728         receivedWais = addsm(receivedWais, msg.value); // count ether which was spent to contract
729     }
730 }