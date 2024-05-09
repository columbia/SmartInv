1 pragma solidity ^0.4.23;
2 
3 
4 contract Random {
5 
6     uint public ticketsNum = 0;
7     
8     mapping(uint => address) internal tickets;
9     mapping(uint => bool) internal payed_back;
10     
11     uint32 public random_num = 0;
12  
13     uint public liveBlocksNumber = 5760;
14     uint public startBlockNumber = 0;
15     uint public endBlockNumber = 0;
16     
17     string public constant name = "Random Daily Lottery";
18     string public constant symbol = "RND";
19     uint   public constant decimals = 0;
20 
21     uint public constant onePotWei = 10000000000000000; // 1 ticket cost is 0.01 ETH
22 
23     address public inv_contract = 0x1d9Ed8e4c1591384A4b2fbd005ccCBDc58501cc0; // investing contract
24     address public rtm_contract = 0x67e5e779bfc7a93374f273dcaefce0db8b3559c2; // team contract
25     
26     address manager; 
27     
28     uint public winners_count = 0; 
29     uint public last_winner = 0; 
30     uint public others_prize = 0;
31     
32     uint public fee_balance = 0; 
33     bool public autopayfee = true;
34 
35     // Events
36     // This generates a publics event on the blockchain that will notify clients
37     
38     event Buy(address indexed sender, uint eth); 
39     event Withdraw(address indexed sender, address to, uint eth); 
40     event Transfer(address indexed from, address indexed to, uint value); 
41     event TransferError(address indexed to, uint value); // event (error): sending ETH from the contract was failed
42     event PayFee(address _to, uint value);
43     
44     
45     
46 
47     // methods with following modifier can only be called by the manager
48     modifier onlyManager() {
49         require(msg.sender == manager);
50         _;
51     }
52     
53 
54     // constructor
55     constructor() public {
56         manager = msg.sender;
57         startBlockNumber = block.number - 1;
58         endBlockNumber = startBlockNumber + liveBlocksNumber;
59     }
60 
61 
62     /// function for straight tickets purchase (sending ETH to the contract address)
63 
64     function() public payable {
65         emit Transfer(msg.sender, 0, 0);
66         require(block.number < endBlockNumber || msg.value < 1000000000000000000);  
67         if (msg.value > 0 && last_winner == 0) { 
68             uint val =  msg.value / onePotWei;  
69             uint i = 0;
70             for(i; i < val; i++) { tickets[ticketsNum+i] = msg.sender; }  
71             ticketsNum += val;                                    
72             emit Buy(msg.sender, msg.value);                      
73         }
74         if (block.number >= endBlockNumber) { 
75             EndLottery(); 
76         }
77     }
78     
79     /// function for ticket sending from owner's address to designated address
80     function transfer(address _to, uint _ticketNum) public {    
81         require(msg.sender == tickets[_ticketNum] && _to != address(0));
82         tickets[_ticketNum] = _to;
83         emit Transfer(msg.sender, _to, _ticketNum);
84     }
85 
86 
87     /// manager's opportunity to write off ETH from the contract, in a case of unforseen contract blocking (possible in only case of more than 24 hours from the moment of lottery ending had passed and a new one has not started)
88     function manager_withdraw() onlyManager public {
89         require(block.number >= endBlockNumber + liveBlocksNumber);
90         msg.sender.transfer(address(this).balance);
91     }
92     
93     /// lottery ending  
94     function EndLottery() public payable returns (bool success) {
95         require(block.number >= endBlockNumber); 
96         uint tn = ticketsNum;
97         if(tn < 3) { 
98             tn = 0;
99             if(msg.value > 0) { msg.sender.transfer(msg.value); }  
100             startNewDraw(0);
101             return false;
102         }
103         uint pf = prizeFund(); 
104         uint jp1 = percent(pf, 10);
105         uint jp2 = percent(pf, 4);
106         uint jp3 = percent(pf, 1);
107         uint lastbet_prize = onePotWei*10;  
108 
109         if(tn < 100) { lastbet_prize = onePotWei; }
110         
111         if(last_winner == 0) { 
112             
113             winners_count = percent(tn, 4) + 3; 
114 
115             uint prizes = jp1 + jp2 + jp3 + lastbet_prize*2; 
116             
117             uint full_prizes = jp1 + jp2 + jp3 + ( lastbet_prize * (winners_count+1)/10 );
118             
119             if(winners_count < 10) {
120                 if(prizes > pf) {
121                     others_prize = 0;
122                 } else {
123                     others_prize = pf - prizes;    
124                 }
125             } else {
126                 if(full_prizes > pf) {
127                     others_prize = 0;
128                 } else {
129                     others_prize = pf - full_prizes;    
130                 }
131             }
132             sendEth(tickets[getWinningNumber(1)], jp1);
133             sendEth(tickets[getWinningNumber(2)], jp2);
134             sendEth(tickets[getWinningNumber(3)], jp3);
135             last_winner += 3;
136             
137             sendEth(msg.sender, lastbet_prize + msg.value);
138             return true;
139         } 
140         
141         if(last_winner < winners_count && others_prize > 0) {
142             
143             uint val = others_prize / winners_count;
144             uint i;
145             uint8 cnt = 0;
146             for(i = last_winner; i < winners_count; i++) {
147                 sendEth(tickets[getWinningNumber(i+3)], val);
148                 cnt++;
149                 if(cnt >= 9) {
150                     last_winner = i;
151                     return true;
152                 }
153             }
154             last_winner = i;
155             if(cnt < 9) { 
156                 startNewDraw(lastbet_prize + msg.value); 
157             } else {
158                 sendEth(msg.sender, lastbet_prize + msg.value);
159             }
160             return true;
161             
162         } else {
163 
164             startNewDraw(lastbet_prize + msg.value);
165         }
166         
167         return true;
168     }
169     
170     /// new draw start
171     function startNewDraw(uint _msg_value) internal { 
172         ticketsNum = 0;
173         startBlockNumber = block.number - 1;
174         endBlockNumber = startBlockNumber + liveBlocksNumber;
175         random_num += 1;
176         winners_count = 0;
177         last_winner = 0;
178         
179         fee_balance = subZero(address(this).balance, _msg_value); 
180         if(msg.value > 0) { sendEth(msg.sender, _msg_value); }
181         // fee_balance = address(this).balance;
182         
183         if(autopayfee) { _payfee(); }
184     }
185     
186     /// sending rewards to the investing, team and marketing contracts 
187     function payfee() public {   
188         require(fee_balance > 0);
189         uint val = fee_balance;
190         
191         RNDInvestor rinv = RNDInvestor(inv_contract);
192         rinv.takeEther.value( percent(val, 25) )();
193         rtm_contract.transfer( percent(val, 74) );
194         fee_balance = 0;
195         
196         emit PayFee(inv_contract, percent(val, 25) );
197         emit PayFee(rtm_contract, percent(val, 74) );
198     }
199     
200     function _payfee() internal {
201         if(fee_balance <= 0) { return; }
202         uint val = fee_balance;
203         
204         RNDInvestor rinv = RNDInvestor(inv_contract);
205         rinv.takeEther.value( percent(val, 25) )();
206         rtm_contract.transfer( percent(val, 74) );
207         fee_balance = 0;
208         
209         emit PayFee(inv_contract, percent(val, 25) );
210         emit PayFee(rtm_contract, percent(val, 74) );
211     }
212     
213     /// function for sending ETH with balance check (does not interrupt the program if balance is not sufficient)
214     function sendEth(address _to, uint _val) internal returns(bool) {
215         if(address(this).balance < _val) {
216             emit TransferError(_to, _val);
217             return false;
218         }
219         _to.transfer(_val);
220         emit Withdraw(address(this), _to, _val);
221         return true;
222     }
223     
224     
225     /// get winning ticket number basing on block hasg (block number is being calculated basing on specified displacement)
226     function getWinningNumber(uint _blockshift) internal constant returns (uint) {
227         return uint(blockhash(endBlockNumber - _blockshift)) % ticketsNum + 1;  
228     }
229     
230 
231     /// current amount of jack pot 1
232     function jackPotA() public view returns (uint) {  
233         return percent(prizeFund(), 10);
234     }
235     
236     /// current amount of jack pot 2
237     function jackPotB() public view returns (uint) {
238         return percent(prizeFund(), 4);
239     }
240     
241 
242     /// current amount of jack pot 3
243     function jackPotC() public view returns (uint) {
244         return percent(prizeFund(), 1);
245     }
246 
247     /// current amount of prize fund
248     function prizeFund() public view returns (uint) {
249         return ( (ticketsNum * onePotWei) / 100 ) * 90;
250     }
251 
252     /// function for calculating definite percent of a number
253     function percent(uint _val, uint _percent) public pure returns (uint) {
254         return ( _val * _percent ) / 100;
255     }
256 
257 
258     /// returns owner address using ticket number
259     function getTicketOwner(uint _num) public view returns (address) { 
260         if(ticketsNum == 0) {
261             return 0;
262         }
263         return tickets[_num];
264     }
265 
266     /// returns amount of tickets for the current draw in the possession of specified address
267     function getTicketsCount(address _addr) public view returns (uint) {
268         if(ticketsNum == 0) {
269             return 0;
270         }
271         uint num = 0;
272         for(uint i = 0; i < ticketsNum; i++) {
273             if(tickets[i] == _addr) {
274                 num++;
275             }
276         }
277         return num;
278     }
279     
280     /// returns amount of tickets for the current draw in the possession of specified address
281     function balanceOf(address _addr) public view returns (uint) {
282         if(ticketsNum == 0) {
283             return 0;
284         }
285         uint num = 0;
286         for(uint i = 0; i < ticketsNum; i++) {
287             if(tickets[i] == _addr) {
288                 num++;
289             }
290         }
291         return num;
292     }
293     
294     /// returns tickets numbers for the current draw in the possession of specified address
295     function getTicketsAtAdress(address _address) public view returns(uint[]) {
296         uint[] memory result = new uint[](getTicketsCount(_address)); 
297         uint num = 0;
298         for(uint i = 0; i < ticketsNum; i++) {
299             if(tickets[i] == _address) {
300                 result[num] = i;
301                 num++;
302             }
303         }
304         return result;
305     }
306 
307 
308     /// returns amount of paid rewards for the current draw
309     function getLastWinner() public view returns(uint) {
310         return last_winner+1;
311     }
312 
313 
314     // /// investing contract address change
315     // function setInvContract(address _addr) onlyManager public {
316     //     inv_contract = _addr;
317     // }
318 
319     /// team contract address change
320     function setRtmContract(address _addr) onlyManager public {
321         rtm_contract = _addr;
322     }
323     
324     function setAutoPayFee(bool _auto) onlyManager public {
325         autopayfee = _auto;
326     }
327 
328    
329     function contractBalance() public view returns (uint256) {
330         return address(this).balance;
331     }
332     
333     function blockLeft() public view returns (uint256) {
334         if(endBlockNumber > block.number) {
335             return endBlockNumber - block.number;    
336         }
337         return 0;
338     }
339 
340     /// method for direct contract replenishment with ETH
341     function deposit() public payable {
342         require(msg.value > 0);
343     }
344 
345 
346 
347     ///Math functions
348 
349     function safeMul(uint a, uint b) internal pure returns (uint) {
350         uint c = a * b;
351         require(a == 0 || c / a == b);
352         return c;
353     }
354 
355     function safeSub(uint a, uint b) internal pure returns (uint) {
356         require(b <= a);
357         return a - b;
358     }
359     
360     function subZero(uint a, uint b) internal pure returns (uint) {
361         if(a < b) {
362             return 0;
363         }
364         return a - b;
365     }
366 
367     function safeAdd(uint a, uint b) internal pure returns (uint) {
368         uint c = a + b;
369         require(c>=a && c>=b);
370         return c;
371     }
372     
373     
374     function destroy() public onlyManager {
375         selfdestruct(manager);
376     }
377     
378 
379 }
380 
381 
382 /**
383 * @title Random Investor Contract
384 * @dev The Investor token contract
385 */
386 
387 contract RNDInvestor {
388    
389     address public owner; // Token owner address
390     mapping (address => uint256) public balances; // balanceOf
391     address[] public addresses;
392 
393     mapping (address => uint256) public debited;
394 
395     mapping (address => mapping (address => uint256)) allowed;
396 
397     string public standard = 'Random 1.1';
398     string public constant name = "Random Investor Token";
399     string public constant symbol = "RINVEST";
400     uint   public constant decimals = 0;
401     uint   public constant totalSupply = 2500;
402     uint   public raised = 0;
403 
404     uint public ownerPrice = 1 ether;
405     uint public soldAmount = 0; // current sold amount (for current state)
406     bool public buyAllowed = true;
407     bool public transferAllowed = false;
408     
409     State public current_state; // current token state
410     
411     // States
412     enum State {
413         Presale,
414         ICO,
415         Public
416     }
417 
418     //
419     // Events
420     // This generates a publics event on the blockchain that will notify clients
421     
422     event Sent(address from, address to, uint amount);
423     event Buy(address indexed sender, uint eth, uint fbt);
424     event Withdraw(address indexed sender, address to, uint eth);
425     event Transfer(address indexed from, address indexed to, uint256 value);
426     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
427     event Raised(uint _value);
428     event StateSwitch(State newState);
429     
430     //
431     // Modifiers
432 
433     modifier onlyOwner() {
434         require(msg.sender == owner);
435         _;
436     }
437     
438     modifier onlyIfAllowed() {
439         if(!transferAllowed) { require(msg.sender == owner); }
440         _;
441     }
442 
443     //
444     // Functions
445     // 
446 
447     // Constructor
448     function RNDInvestor() public {
449         owner = msg.sender;
450         balances[owner] = totalSupply;
451     }
452 
453     // fallback function
454     function() payable public {
455         if(current_state == State.Public) {
456             takeEther();
457             return;
458         }
459         
460         require(buyAllowed);
461         require(msg.value >= ownerPrice);
462         require(msg.sender != owner);
463         
464         uint wei_value = msg.value;
465 
466         // uint tokens = safeMul(wei_value, ownerPrice);
467         uint tokens = wei_value / ownerPrice;
468         uint cost = tokens * ownerPrice;
469         
470         if(current_state == State.Presale) {
471             tokens = tokens * 2;
472         }
473         
474         uint currentSoldAmount = safeAdd(tokens, soldAmount);
475 
476         if (current_state == State.Presale) {
477             require(currentSoldAmount <= 1000);
478         }
479         
480         require(balances[owner] >= tokens);
481         
482         balances[owner] = safeSub(balances[owner], tokens);
483         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
484         soldAmount = safeAdd(soldAmount, tokens);
485         
486         uint extra_ether = safeSub(msg.value, cost); 
487         if(extra_ether > 0) {
488             msg.sender.transfer(extra_ether);
489         }
490     }
491     
492     
493     function takeEther() payable public {
494         if(msg.value > 0) {
495             raised += msg.value;
496             emit Raised(msg.value);
497         } else {
498             withdraw();
499         }
500     }
501     
502     function setOwnerPrice(uint _newPrice) public
503         onlyOwner
504         returns (bool success)
505     {
506         ownerPrice = _newPrice;
507         return true;
508     }
509     
510     function setTokenState(State _nextState) public
511         onlyOwner
512         returns (bool success)
513     {
514         bool canSwitchState
515             =  (current_state == State.Presale && _nextState == State.ICO)
516             || (current_state == State.Presale && _nextState == State.Public)
517             || (current_state == State.ICO && _nextState == State.Public) ;
518 
519         require(canSwitchState);
520         
521         current_state = _nextState;
522 
523         emit StateSwitch(_nextState);
524 
525         return true;
526     }
527     
528     function setBuyAllowed(bool _allowed) public
529         onlyOwner
530         returns (bool success)
531     {
532         buyAllowed = _allowed;
533         return true;
534     }
535     
536     function allowTransfer() public
537         onlyOwner
538         returns (bool success)
539     {
540         transferAllowed = true;
541         return true;
542     }
543 
544     /**
545     * @dev Allows the current owner to transfer control of the contract to a newOwner.
546     * @param newOwner The address to transfer ownership to.
547     */
548     function transferOwnership(address newOwner) public onlyOwner {
549       if (newOwner != address(0)) {
550         owner = newOwner;
551       }
552     }
553 
554     function safeMul(uint a, uint b) internal pure returns (uint) {
555         uint c = a * b;
556         require(a == 0 || c / a == b);
557         return c;
558     }
559     
560     function safeSub(uint a, uint b) internal pure returns (uint) {
561         require(b <= a);
562         return a - b;
563     }
564 
565     function safeAdd(uint a, uint b) internal pure returns (uint) {
566         uint c = a + b;
567         require(c>=a && c>=b);
568         return c;
569     }
570 
571     function withdraw() public returns (bool success) {
572         uint val = ethBalanceOf(msg.sender);
573         if(val > 0) {
574             msg.sender.transfer(val);
575             debited[msg.sender] += val;
576             return true;
577         }
578         return false;
579     }
580 
581 
582 
583     function ethBalanceOf(address _investor) public view returns (uint256 balance) {
584         uint val = (raised / totalSupply) * balances[_investor];
585         if(val >= debited[_investor]) {
586             return val - debited[_investor];
587         }
588         return 0;
589     }
590 
591 
592     function manager_withdraw() onlyOwner public {
593         uint summ = 0;
594         for(uint i = 0; i < addresses.length; i++) {
595             summ += ethBalanceOf(addresses[i]);
596         }
597         require(summ < address(this).balance);
598         msg.sender.transfer(address(this).balance - summ);
599     }
600 
601     
602     function manual_withdraw() public {
603         for(uint i = 0; i < addresses.length; i++) {
604             addresses[i].transfer( ethBalanceOf(addresses[i]) );
605         }
606     }
607 
608 
609     function checkAddress(address _addr) public
610         returns (bool have_addr)
611     {
612         for(uint i=0; i<addresses.length; i++) {
613             if(addresses[i] == _addr) {
614                 return true;
615             }
616         }
617         addresses.push(_addr);
618         return true;
619     }
620     
621 
622     function destroy() public onlyOwner {
623         selfdestruct(owner);
624     }
625 
626 
627     /**
628      * ERC 20 token functions
629      *
630      * https://github.com/ethereum/EIPs/issues/20
631      */
632     
633     function transfer(address _to, uint256 _value) public
634         onlyIfAllowed
635         returns (bool success) 
636     {
637         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
638             balances[msg.sender] -= _value;
639             balances[_to] += _value;
640             emit Transfer(msg.sender, _to, _value);
641             checkAddress(_to);
642             return true;
643         } else { return false; }
644     }
645 
646     function transferFrom(address _from, address _to, uint256 _value) public
647         onlyIfAllowed
648         returns (bool success)
649     {
650         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
651             balances[_to] += _value;
652             balances[_from] -= _value;
653             allowed[_from][msg.sender] -= _value;
654             emit Transfer(_from, _to, _value);
655             checkAddress(_to);
656             return true;
657         } else { return false; }
658     }
659 
660     function balanceOf(address _owner) public constant returns (uint256 balance) {
661         return balances[_owner];
662     }
663 
664 
665     function approve(address _spender, uint256 _value) public
666         returns (bool success)
667     {
668         allowed[msg.sender][_spender] = _value;
669         emit Approval(msg.sender, _spender, _value);
670         return true;
671     }
672 
673     function allowance(address _owner, address _spender) public
674         constant returns (uint256 remaining)
675     {
676       return allowed[_owner][_spender];
677     }
678     
679     
680     
681 }