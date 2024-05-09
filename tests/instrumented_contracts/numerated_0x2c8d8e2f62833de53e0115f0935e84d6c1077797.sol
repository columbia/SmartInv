1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0 || b == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
63      */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner, "Invalid owner");
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0), "Zero address");
82         emit OwnershipTransferred(owner, newOwner);  
83         owner = newOwner;
84     }
85 }
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 {
93     function totalSupply() public view returns (uint256);
94 
95     function balanceOf(address _owner) public view returns (uint256);
96 
97     function transfer(address to, uint256 value) public returns (bool);
98 
99     function allowance(address owner, address spender) public view returns (uint256);
100 
101     function transferFrom(address from, address to, uint256 value) public returns (bool);
102 
103     function approve(address spender, uint256 value) public returns (bool);
104 
105     event Transfer(address indexed from, address indexed to, uint256 value);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 /**
111  * @title Basic token
112  * @dev Basic version of StandardToken, with no allowances.
113  */
114 contract EyeToken is ERC20, Ownable {
115     using SafeMath for uint256;
116 
117     struct Frozen {
118         bool frozen;
119         uint until;
120     }
121 
122     string public name = "EYE Token";
123     string public symbol = "EYE";
124     uint8 public decimals = 18;
125 
126     mapping(address => uint256) internal balances;
127     mapping(address => mapping(address => uint256)) internal allowed;
128     mapping(address => Frozen) public frozenAccounts;
129     uint256 internal totalSupplyTokens;
130     bool internal isICO;
131     address public wallet;
132 
133     function EyeToken() public Ownable() {
134         wallet = msg.sender;
135         isICO = true;
136         totalSupplyTokens = 10000000000 * 10 ** uint256(decimals);
137         balances[wallet] = totalSupplyTokens;
138     }
139 
140     /**
141      * @dev Finalize ICO
142      */
143     function finalizeICO() public onlyOwner {
144         isICO = false;
145     }
146 
147     /**
148     * @dev Total number of tokens in existence
149     */
150     function totalSupply() public view returns (uint256) {
151         return totalSupplyTokens;
152     }
153 
154     /**
155      * @dev Freeze account, make transfers from this account unavailable
156      * @param _account Given account
157      */
158     function freeze(address _account) public onlyOwner {
159         freeze(_account, 0);
160     }
161 
162     /**
163      * @dev  Temporary freeze account, make transfers from this account unavailable for a time
164      * @param _account Given account
165      * @param _until Time until
166      */
167     function freeze(address _account, uint _until) public onlyOwner {
168         if (_until == 0 || (_until != 0 && _until > now)) {
169             frozenAccounts[_account] = Frozen(true, _until);
170         }
171     }
172 
173     /**
174      * @dev Unfreeze account, make transfers from this account available
175      * @param _account Given account
176      */
177     function unfreeze(address _account) public onlyOwner {
178         if (frozenAccounts[_account].frozen) {
179             delete frozenAccounts[_account];
180         }
181     }
182 
183     /**
184      * @dev allow transfer tokens or not
185      * @param _from The address to transfer from.
186      */
187     modifier allowTransfer(address _from) {
188         require(!isICO, "ICO phase");
189         if (frozenAccounts[_from].frozen) {
190             require(frozenAccounts[_from].until != 0 && frozenAccounts[_from].until < now, "Frozen account");
191             delete frozenAccounts[_from];
192         }
193         _;
194     }
195 
196     /**
197     * @dev transfer tokens for a specified address
198     * @param _to The address to transfer to.
199     * @param _value The amount to be transferred.
200     */
201     function transfer(address _to, uint256 _value) public returns (bool) {
202         bool result = _transfer(msg.sender, _to, _value);
203         emit Transfer(msg.sender, _to, _value); 
204         return result;
205     }
206 
207     /**
208     * @dev transfer tokens for a specified address in ICO mode
209     * @param _to The address to transfer to.
210     * @param _value The amount to be transferred.
211     */
212     function transferICO(address _to, uint256 _value) public onlyOwner returns (bool) {
213         require(isICO, "Not ICO phase");
214         require(_to != address(0), "Zero address 'To'");
215         require(_value <= balances[wallet], "Not enought balance");
216         balances[wallet] = balances[wallet].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         emit Transfer(wallet, _to, _value);  
219         return true;
220     }
221 
222     /**
223     * @dev Gets the balance of the specified address.
224     * @param _owner The address to query the the balance of.
225     * @return An uint256 representing the amount owned by the passed address.
226     */
227     function balanceOf(address _owner) public view returns (uint256) {
228         return balances[_owner];
229     }
230 
231     /**
232      * @dev Transfer tokens from one address to another
233      * @param _from address The address which you want to send tokens from
234      * @param _to address The address which you want to transfer to
235      * @param _value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(address _from, address _to, uint256 _value) public allowTransfer(_from) returns (bool) {
238         require(_value <= allowed[_from][msg.sender], "Not enought allowance");
239         bool result = _transfer(_from, _to, _value);
240         if (result) {
241             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242             emit Transfer(_from, _to, _value);  
243         }
244         return result;
245     }
246 
247     /**
248      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249      *
250      * Beware that changing an allowance with this method brings the risk that someone may use both the old
251      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254      * @param _spender The address which will spend the funds.
255      * @param _value The amount of tokens to be spent.
256      */
257     function approve(address _spender, uint256 _value) public returns (bool) {
258         allowed[msg.sender][_spender] = _value;
259         emit Approval(msg.sender, _spender, _value);  
260         return true;
261     }
262 
263     /**
264      * @dev Function to check the amount of tokens that an owner allowed to a spender.
265      * @param _owner address The address which owns the funds.
266      * @param _spender address The address which will spend the funds.
267      * @return A uint256 specifying the amount of tokens still available for the spender.
268      */
269     function allowance(address _owner, address _spender) public view returns (uint256) {
270         return allowed[_owner][_spender];
271     }
272 
273     /**
274      * @dev Increase the amount of tokens that an owner allowed to a spender.
275      *
276      * approve should be called when allowed[_spender] == 0. To increment
277      * allowed value is better to use this function to avoid 2 calls (and wait until
278      * the first transaction is mined)
279      * From MonolithDAO Token.sol
280      * @param _spender The address which will spend the funds.
281      * @param _addedValue The amount of tokens to increase the allowance by.
282      */
283     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
284         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
285         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);  
286         return true;
287     }
288 
289     /**
290      * @dev Decrease the amount of tokens that an owner allowed to a spender.
291      *
292      * approve should be called when allowed[_spender] == 0. To decrement
293      * allowed value is better to use this function to avoid 2 calls (and wait until
294      * the first transaction is mined)
295      * From MonolithDAO Token.sol
296      * @param _spender The address which will spend the funds.
297      * @param _subtractedValue The amount of tokens to decrease the allowance by.
298      */
299     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
300         uint oldValue = allowed[msg.sender][_spender];
301         if (_subtractedValue > oldValue) {
302             allowed[msg.sender][_spender] = 0;
303         } else {
304             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305         }
306         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);  
307         return true;
308     }
309 
310     /**
311      * @dev transfer token for a specified address
312      * @param _from The address to transfer from.
313      * @param _to The address to transfer to.
314      * @param _value The amount to be transferred.
315      */
316     function _transfer(address _from, address _to, uint256 _value) internal allowTransfer(_from) returns (bool) {
317         require(_to != address(0), "Zero address 'To'");
318         require(_from != address(0), "Zero address 'From'");
319         require(_value <= balances[_from], "Not enought balance");
320         balances[_from] = balances[_from].sub(_value);
321         balances[_to] = balances[_to].add(_value);
322         return true;
323     }
324 }
325 
326 
327 /**
328  * @title Crowd-sale
329  *
330  * @dev Crowd-sale contract for tokens
331  */
332 contract CrowdSale is Ownable {
333     using SafeMath for uint256;
334 
335     event Payment(
336         address wallet,
337         uint date,
338         uint256 amountEth,
339         uint256 amountCoin,
340         uint8 bonusPercent
341     );
342 
343     uint constant internal MIN_TOKEN_AMOUNT = 5000;
344     uint constant internal SECONDS_IN_DAY = 86400; // 24 * 60 * 60
345     uint constant internal SECONDS_IN_YEAR = 31557600; // ( 365 * 24 + 6 ) * 60 * 60
346     int8 constant internal PHASE_NOT_STARTED = -5;
347     int8 constant internal PHASE_BEFORE_PRESALE = -4;
348     int8 constant internal PHASE_BETWEEN_PRESALE_ICO = -3;
349     int8 constant internal PHASE_ICO_FINISHED = -2;
350     int8 constant internal PHASE_FINISHED = -1;
351     int8 constant internal PHASE_PRESALE = 0;
352     int8 constant internal PHASE_ICO_1 = 1;
353     int8 constant internal PHASE_ICO_2 = 2;
354     int8 constant internal PHASE_ICO_3 = 3;
355     int8 constant internal PHASE_ICO_4 = 4;
356     int8 constant internal PHASE_ICO_5 = 5;
357 
358     address internal manager;
359 
360     EyeToken internal token;
361     address internal base_wallet;
362     uint256 internal dec_mul;
363     address internal vest_1;
364     address internal vest_2;
365     address internal vest_3;
366     address internal vest_4;
367 
368     int8 internal phase_i; // see PHASE_XXX
369 
370     uint internal presale_start = 1533020400; // 2018-07-31 07:00 UTC
371     uint internal presale_end = 1534316400; // 2018-08-15 07:00 UTC
372     uint internal ico_start = 1537254000; // 2018-09-18 07:00 UTC
373     uint internal ico_phase_1_days = 7;
374     uint internal ico_phase_2_days = 7;
375     uint internal ico_phase_3_days = 7;
376     uint internal ico_phase_4_days = 7;
377     uint internal ico_phase_5_days = 7;
378     uint internal ico_phase_1_end;
379     uint internal ico_phase_2_end;
380     uint internal ico_phase_3_end;
381     uint internal ico_phase_4_end;
382     uint internal ico_phase_5_end;
383     uint8[6] public bonus_percents = [50, 40, 30, 20, 10, 0];
384     uint internal finish_date;
385     uint public exchange_rate;  //  tokens in one ethereum * 1000
386     uint256 public lastPayerOverflow = 0;
387 
388     /**
389      * @dev Crowd-sale constructor
390      */
391     function CrowdSale() Ownable() public {
392         phase_i = PHASE_NOT_STARTED;
393         manager = address(0);
394     }
395 
396     /**
397      * @dev Allow only for owner or manager
398      */
399     modifier onlyOwnerOrManager(){
400         require(msg.sender == owner || (msg.sender == manager && manager != address(0)), "Invalid owner or manager");
401         _;
402     }
403 
404     /**
405      * @dev Returns current manager
406      */
407     function getManager() public view onlyOwnerOrManager returns (address) {
408         return manager;
409     }
410 
411     /**
412      * @dev Sets new manager
413      * @param _manager New manager
414      */
415     function setManager(address _manager) public onlyOwner {
416         manager = _manager;
417     }
418 
419     /**
420      * @dev Set exchange rate
421      * @param _rate New exchange rate
422      *
423      * executed by CRM
424      */
425     function setRate(uint _rate) public onlyOwnerOrManager {
426         require(_rate > 0, "Invalid exchange rate");
427         exchange_rate = _rate;
428     }
429 
430     function _addPayment(address wallet, uint256 amountEth, uint256 amountCoin, uint8 bonusPercent) internal {
431         emit Payment(wallet, now, amountEth, amountCoin, bonusPercent);
432     }
433 
434     /**
435      * @dev Start crowd-sale
436      * @param _token Coin's contract
437      * @param _rate current exchange rate
438      */
439     function start(address _token, uint256 _rate) public onlyOwnerOrManager {
440         require(_rate > 0, "Invalid exchange rate");
441         require(phase_i == PHASE_NOT_STARTED, "Bad phase");
442 
443         token = EyeToken(_token);
444         base_wallet = token.wallet();
445         dec_mul = 10 ** uint256(token.decimals());
446 
447         // Organizasional expenses
448         address org_exp = 0xeb967ECF00e86F58F6EB8019d003c48186679A96;
449         // Early birds
450         address ear_brd = 0x469A97b357C2056B927fF4CA097513BD927db99E;
451         // Community development
452         address com_dev = 0x877D6a4865478f50219a20870Bdd16E6f7aa954F;
453         // Special coins
454         address special = 0x5D2C58e6aCC5BcC1aaA9b54B007e0c9c3E091adE;
455         // Team lock
456         vest_1 = 0x47997109aE9bEd21efbBBA362957F1b20F435BF3;
457         vest_2 = 0xd031B38d0520aa10450046Dc0328447C3FF59147;
458         vest_3 = 0x32FcE00BfE1fEC48A45DC543224748f280a5c69E;
459         vest_4 = 0x07B489712235197736E207836f3B71ffaC6b1220;
460 
461         token.transferICO(org_exp, 600000000 * dec_mul);
462         token.transferICO(ear_brd, 1000000000 * dec_mul);
463         token.transferICO(com_dev, 1000000000 * dec_mul);
464         token.transferICO(special, 800000000 * dec_mul);
465         token.transferICO(vest_1, 500000000 * dec_mul);
466         token.transferICO(vest_2, 500000000 * dec_mul);
467         token.transferICO(vest_3, 500000000 * dec_mul);
468         token.transferICO(vest_4, 500000000 * dec_mul);
469 
470         exchange_rate = _rate;
471 
472         phase_i = PHASE_BEFORE_PRESALE;
473         _updatePhaseTimes();
474     }
475 
476     /**
477      * @dev Finalize ICO
478      */
479     function _finalizeICO() internal {
480         require(phase_i != PHASE_NOT_STARTED && phase_i != PHASE_FINISHED, "Bad phase");
481         phase_i = PHASE_ICO_FINISHED;
482         uint curr_date = now;
483         finish_date = (curr_date < ico_phase_5_end ? ico_phase_5_end : curr_date).add(SECONDS_IN_DAY * 10);
484     }
485 
486     /**
487      * @dev Finalize crowd-sale
488      */
489     function _finalize() internal {
490         require(phase_i != PHASE_NOT_STARTED && phase_i != PHASE_FINISHED, "Bad phase");
491 
492         uint date = now.add(SECONDS_IN_YEAR);
493         token.freeze(vest_1, date);
494         date = date.add(SECONDS_IN_YEAR);
495         token.freeze(vest_2, date);
496         date = date.add(SECONDS_IN_YEAR);
497         token.freeze(vest_3, date);
498         date = date.add(SECONDS_IN_YEAR);
499         token.freeze(vest_4, date);
500 
501         token.finalizeICO();
502         token.transferOwnership(base_wallet);
503 
504         phase_i = PHASE_FINISHED;
505     }
506 
507     /**
508      * @dev Finalize crowd-sale
509      */
510     function finalize() public onlyOwner {
511         _finalize();
512     }
513 
514     function _calcPhase() internal view returns (int8) {
515         if (phase_i == PHASE_FINISHED || phase_i == PHASE_NOT_STARTED)
516             return phase_i;
517         uint curr_date = now;
518         if (curr_date >= ico_phase_5_end || token.balanceOf(base_wallet) == 0)
519             return PHASE_ICO_FINISHED;
520         if (curr_date < presale_start)
521             return PHASE_BEFORE_PRESALE;
522         if (curr_date <= presale_end)
523             return PHASE_PRESALE;
524         if (curr_date < ico_start)
525             return PHASE_BETWEEN_PRESALE_ICO;
526         if (curr_date < ico_phase_1_end)
527             return PHASE_ICO_1;
528         if (curr_date < ico_phase_2_end)
529             return PHASE_ICO_2;
530         if (curr_date < ico_phase_3_end)
531             return PHASE_ICO_3;
532         if (curr_date < ico_phase_4_end)
533             return PHASE_ICO_4;
534         return PHASE_ICO_5;
535     }
536 
537     function phase() public view returns (int8) {
538         return _calcPhase();
539     }
540 
541     /**
542      * @dev Recalculate phase
543      */
544     function _updatePhase(bool check_can_sale) internal {
545         uint curr_date = now;
546         if (phase_i == PHASE_ICO_FINISHED) {
547             if (curr_date >= finish_date)
548                 _finalize();
549         }
550         else
551             if (phase_i != PHASE_NOT_STARTED && phase_i != PHASE_FINISHED) {
552                 int8 new_phase = _calcPhase();
553                 if (new_phase == PHASE_ICO_FINISHED && phase_i != PHASE_ICO_FINISHED)
554                     _finalizeICO();
555                 else
556                     phase_i = new_phase;
557             }
558         if (check_can_sale)
559             require(phase_i >= 0, "Bad phase");
560     }
561 
562     /**
563      * @dev Update phase end times
564      */
565     function _updatePhaseTimes() internal {
566         require(phase_i != PHASE_NOT_STARTED && phase_i != PHASE_FINISHED, "Bad phase");
567         if (phase_i < PHASE_ICO_1)
568             ico_phase_1_end = ico_start.add(SECONDS_IN_DAY.mul(ico_phase_1_days));
569         if (phase_i < PHASE_ICO_2)
570             ico_phase_2_end = ico_phase_1_end.add(SECONDS_IN_DAY.mul(ico_phase_2_days));
571         if (phase_i < PHASE_ICO_3)
572             ico_phase_3_end = ico_phase_2_end.add(SECONDS_IN_DAY.mul(ico_phase_3_days));
573         if (phase_i < PHASE_ICO_4)
574             ico_phase_4_end = ico_phase_3_end.add(SECONDS_IN_DAY.mul(ico_phase_4_days));
575         if (phase_i < PHASE_ICO_5)
576             ico_phase_5_end = ico_phase_4_end.add(SECONDS_IN_DAY.mul(ico_phase_5_days));
577         if (phase_i != PHASE_ICO_FINISHED)
578             finish_date = ico_phase_5_end.add(SECONDS_IN_DAY.mul(10));
579         _updatePhase(false);
580     }
581 
582     /**
583      * @dev Send tokens to the specified address
584      *
585      * @param _to Address sent to
586      * @param _amount_coin Amount of tockens
587      * @return excess coins
588      *
589      * executed by CRM
590      */
591     function transferICO(address _to, uint256 _amount_coin) public onlyOwnerOrManager {
592         _updatePhase(true);
593         uint256 remainedCoin = token.balanceOf(base_wallet);
594         require(remainedCoin >= _amount_coin, "Not enough coins");
595         token.transferICO(_to, _amount_coin);
596         if (remainedCoin == _amount_coin)
597             _finalizeICO();
598     }
599 
600     /**
601      * @dev Default contract function. Buy tokens by sending ethereums
602      */
603     function() public payable {
604         _updatePhase(true);
605         address sender = msg.sender;
606         uint256 amountEth = msg.value;
607         uint256 remainedCoin = token.balanceOf(base_wallet);
608         if (remainedCoin == 0) {
609             sender.transfer(amountEth);
610             _finalizeICO();
611         } else {
612             uint8 percent = bonus_percents[uint256(phase_i)];
613             uint256 amountCoin = calcTokensFromEth(amountEth);
614             assert(amountCoin >= MIN_TOKEN_AMOUNT);
615             if (amountCoin > remainedCoin) {
616                 lastPayerOverflow = amountCoin.sub(remainedCoin);
617                 amountCoin = remainedCoin;
618             }
619             base_wallet.transfer(amountEth);
620             token.transferICO(sender, amountCoin);
621             _addPayment(sender, amountEth, amountCoin, percent);
622             if (amountCoin == remainedCoin)
623                 _finalizeICO();
624         }
625     }
626 
627     function calcTokensFromEth(uint256 ethAmount) internal view returns (uint256) {
628         uint8 percent = bonus_percents[uint256(phase_i)];
629         uint256 bonusRate = uint256(percent).add(100);
630         uint256 totalCoins = ethAmount.mul(exchange_rate).div(1000);
631         uint256 totalFullCoins = (totalCoins.add(dec_mul.div(2))).div(dec_mul);
632         uint256 tokensWithBonusX100 = bonusRate.mul(totalFullCoins);
633         uint256 fullCoins = (tokensWithBonusX100.add(50)).div(100);
634         return fullCoins.mul(dec_mul);
635     }
636 
637     /**
638      * @dev Freeze the account
639      * @param _accounts Given accounts
640      *
641      * executed by CRM
642      */
643     function freeze(address[] _accounts) public onlyOwnerOrManager {
644         require(phase_i != PHASE_NOT_STARTED && phase_i != PHASE_FINISHED, "Bad phase");
645         uint i;
646         for (i = 0; i < _accounts.length; i++) {
647             require(_accounts[i] != address(0), "Zero address");
648             require(_accounts[i] != base_wallet, "Freeze self");
649         }
650         for (i = 0; i < _accounts.length; i++) {
651             token.freeze(_accounts[i]);
652         }
653     }
654 
655     /**
656      * @dev Unfreeze the account
657      * @param _accounts Given accounts
658      */
659     function unfreeze(address[] _accounts) public onlyOwnerOrManager {
660         require(phase_i != PHASE_NOT_STARTED && phase_i != PHASE_FINISHED, "Bad phase");
661         uint i;
662         for (i = 0; i < _accounts.length; i++) {
663             require(_accounts[i] != address(0), "Zero address");
664             require(_accounts[i] != base_wallet, "Freeze self");
665         }
666         for (i = 0; i < _accounts.length; i++) {
667             token.unfreeze(_accounts[i]);
668         }
669     }
670 
671     /**
672      * @dev get ICO times
673      * @return presale_start, presale_end, ico_start, ico_phase_1_end, ico_phase_2_end, ico_phase_3_end, ico_phase_4_end, ico_phase_5_end
674      */
675     function getTimes() public view returns (uint, uint, uint, uint, uint, uint, uint, uint) {
676         return (presale_start, presale_end, ico_start, ico_phase_1_end, ico_phase_2_end, ico_phase_3_end, ico_phase_4_end, ico_phase_5_end);
677     }
678 
679     /**
680      * @dev Sets start and end dates for pre-sale phase_i
681      * @param _presale_start Pre-sale sart date
682      * @param _presale_end Pre-sale end date
683      */
684     function setPresaleDates(uint _presale_start, uint _presale_end) public onlyOwnerOrManager {
685         _updatePhase(false);
686         require(phase_i == PHASE_BEFORE_PRESALE, "Bad phase");
687         // require(_presale_start >= now);
688         require(_presale_start < _presale_end, "Invalid presale dates");
689         require(_presale_end < ico_start, "Invalid dates");
690         presale_start = _presale_start;
691         presale_end = _presale_end;
692     }
693 
694     /**
695      * @dev Sets start date for ICO phases
696      * @param _ico_start ICO start date
697      * @param _ico_1_days Days of ICO phase 1
698      * @param _ico_2_days Days of ICO phase 2
699      * @param _ico_3_days Days of ICO phase 3
700      * @param _ico_4_days Days of ICO phase 4
701      * @param _ico_5_days Days of ICO phase 5
702      */
703     function setICODates(uint _ico_start, uint _ico_1_days, uint _ico_2_days, uint _ico_3_days, uint _ico_4_days, uint _ico_5_days) public onlyOwnerOrManager {
704         _updatePhase(false);
705         require(phase_i != PHASE_FINISHED && phase_i != PHASE_ICO_FINISHED && phase_i < PHASE_ICO_1, "Bad phase");
706         require(presale_end < _ico_start, "Invalid dates");
707         ico_start = _ico_start;
708         ico_phase_1_days = _ico_1_days;
709         ico_phase_2_days = _ico_2_days;
710         ico_phase_3_days = _ico_3_days;
711         ico_phase_4_days = _ico_4_days;
712         ico_phase_5_days = _ico_5_days;
713         _updatePhaseTimes();
714     }
715 }