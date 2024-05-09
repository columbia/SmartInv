1 pragma solidity 0.4.25;
2 /** 
3  _____                   __  __      ______      ____                 ____       ______      ______   
4 /\  __`\     /'\_/`\    /\ \/\ \    /\__  _\    /\  _`\              /\  _`\    /\__  _\    /\__  _\  
5 \ \ \/\ \   /\      \   \ \ `\\ \   \/_/\ \/    \ \,\L\_\            \ \ \L\ \  \/_/\ \/    \/_/\ \/  
6  \ \ \ \ \  \ \ \__\ \   \ \ , ` \     \ \ \     \/_\__ \    _______  \ \  _ <'    \ \ \       \ \ \  
7   \ \ \_\ \  \ \ \_/\ \   \ \ \`\ \     \_\ \__    /\ \L\ \ /\______\  \ \ \L\ \    \_\ \__     \ \ \ 
8    \ \_____\  \ \_\\ \_\   \ \_\ \_\    /\_____\   \ `\____\\/______/   \ \____/    /\_____\     \ \_\
9     \/_____/   \/_/ \/_/    \/_/\/_/    \/_____/    \/_____/             \/___/     \/_____/      \/_/
10 
11     WEBSITE: omnis-bit.com
12  */
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
20         uint256 c = a * b;
21         assert(a == 0 || c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns(uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns(uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50     address public owner;
51 
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69      * @dev Allows the current owner to transfer control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function transferOwnership(address newOwner) onlyOwner public {
73         require(newOwner != address(0));
74         owner = newOwner;
75     }
76 
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85     uint256 public totalSupply;
86 
87     function balanceOf(address who) public view returns(uint256);
88 
89     function transfer(address to, uint256 value) public returns(bool);
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98     function allowance(address owner, address spender) public view returns(uint256);
99 
100     function transferFrom(address from, address to, uint256 value) public returns(bool);
101 
102     function approve(address spender, uint256 value) public returns(bool);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 contract StakerToken {
107     uint256 public stakeStartTime;
108     uint256 public stakeMinAge;
109     uint256 public stakeMaxAge;
110 
111     function claimStake() public returns(bool);
112 
113     function coinAge() public view returns(uint256);
114 
115     function annualInterest() public view returns(uint256);
116     event ClaimStake(address indexed _address, uint _reward);
117 }
118 
119 contract OMNIS is ERC20, StakerToken, Ownable {
120     using SafeMath
121     for uint256;
122 
123     string public name = "OMNIS-BIT";
124     string public symbol = "OMNIS";
125     uint public decimals = 18;
126 
127     uint public chainStartTime;
128     uint public chainStartBlockNumber;
129     uint public stakeStartTime;
130     uint public stakeMinAge = 3 days;
131     uint public stakeMaxAge = 90 days;
132 
133     uint public totalSupply;
134     uint public maxTotalSupply;
135     uint public totalInitialSupply;
136 
137     struct Airdrop {
138         uint value;
139         bool claimed;
140     }
141 
142     mapping(address => Airdrop) public airdrops;
143 
144     //ESCROW RELATED
145     enum PaymentStatus {
146         Pending,
147         Completed,
148         Refunded
149     }
150 
151     event NewFeeRate(uint newFee);
152     event NewCollectionWallet(address newWallet);
153     event PaymentCreation(uint indexed orderId, address indexed customer, uint value);
154     event PaymentCompletion(uint indexed orderId, address indexed provider, address indexed customer, uint value, PaymentStatus status);
155 
156     struct Payment {
157         address provider;
158         address customer;
159         uint value;
160         PaymentStatus status;
161         bool refundApproved;
162     }
163 
164     uint escrowCounter;
165     uint public escrowFeePercent = 5; //0.5%
166 
167     mapping(uint => Payment) public payments;
168     address public collectionAddress;
169     //ESCROW SECTION END
170 
171     struct transferInStruct {
172         uint128 amount;
173         uint64 time;
174     }
175 
176     mapping(address => uint256) balances;
177     mapping(address => mapping(address => uint256)) allowed;
178     mapping(address => transferInStruct[]) transferIns;
179 
180     modifier canPoSclaimStake() {
181         require(totalSupply < maxTotalSupply);
182         _;
183     }
184 
185     constructor() public {
186         maxTotalSupply = 1000000000 * 10 ** 18;
187         totalInitialSupply = 820000000 * 10 ** 18;
188 
189         chainStartTime = now; //Original Time
190         chainStartBlockNumber = block.number; //Original Block
191 
192         totalSupply = totalInitialSupply;
193         
194         collectionAddress = msg.sender; //Initially collection address to owner
195 
196         balances[msg.sender] = totalInitialSupply;
197         emit Transfer(address(0), msg.sender, totalInitialSupply);
198     }
199 
200     function setCurrentEscrowFee(uint _newFee) onlyOwner public {
201         require(_newFee != 0 && _newFee < 1000);
202         escrowFeePercent = _newFee;
203         emit NewFeeRate(escrowFeePercent);
204     }
205 
206     function setCollectionWallet(address _newWallet) onlyOwner public {
207         require(_newWallet != address(0));
208         collectionAddress = _newWallet;
209         emit NewCollectionWallet(collectionAddress);
210     }
211 
212     function transfer(address _to, uint256 _value) public returns(bool) {
213         require(_to != address(0));
214 
215         if (msg.sender == _to) return claimStake();
216         balances[msg.sender] = balances[msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         emit Transfer(msg.sender, _to, _value);
219         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
220         uint64 _now = uint64(now);
221         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));
222         transferIns[_to].push(transferInStruct(uint128(_value), _now));
223         return true;
224     }
225 
226     function balanceOf(address _owner) public view returns(uint256 balance) {
227         return balances[_owner];
228     }
229 
230     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
231         require(_to != address(0));
232 
233         uint256 _allowance = allowed[_from][msg.sender];
234         balances[_from] = balances[_from].sub(_value);
235         balances[_to] = balances[_to].add(_value);
236         allowed[_from][msg.sender] = _allowance.sub(_value);
237         emit Transfer(_from, _to, _value);
238         if (transferIns[_from].length > 0) delete transferIns[_from];
239         uint64 _now = uint64(now);
240         transferIns[_from].push(transferInStruct(uint128(balances[_from]), _now));
241         transferIns[_to].push(transferInStruct(uint128(_value), _now));
242         return true;
243     }
244 
245     function approve(address _spender, uint256 _value) public returns(bool) {
246         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
247 
248         allowed[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252 
253     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
254         return allowed[_owner][_spender];
255     }
256 
257     /**
258      * @dev claimStake
259      * @dev Allow any user to claim stake earned
260      */
261     function claimStake() canPoSclaimStake public returns(bool) {
262         if (balances[msg.sender] <= 0) return false;
263         if (transferIns[msg.sender].length <= 0) return false;
264 
265         uint reward = getProofOfStakeReward(msg.sender);
266         if (reward <= 0) return false;
267 
268         totalSupply = totalSupply.add(reward);
269         balances[msg.sender] = balances[msg.sender].add(reward);
270         delete transferIns[msg.sender];
271         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), uint64(now)));
272 
273         emit Transfer(address(0),msg.sender,reward);
274         emit ClaimStake(msg.sender, reward);
275         return true;
276     }
277 
278     /**
279      * @dev getBlockNumber
280      * @dev Returns the block number since deployment
281      */
282     function getBlockNumber() public view returns(uint blockNumber) {
283         blockNumber = block.number.sub(chainStartBlockNumber);
284     }
285 
286     /**
287      * @dev coinAge
288      * @dev Returns the coinage for the callers account
289      */
290     function coinAge() public view returns(uint myCoinAge) {
291         myCoinAge = getCoinAge(msg.sender, now);
292     }
293 
294     /**
295      * @dev annualInterest
296      * @dev Returns the current interest rate
297      */
298     function annualInterest() public view returns(uint interest) {
299         uint _now = now;
300         interest = 0;
301         if ((_now.sub(stakeStartTime)).div(365 days) == 0) {
302             interest = (106 * 1e15);
303         } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {
304             interest = (49 * 1e15);
305         } else if ((_now.sub(stakeStartTime)).div(365 days) == 2) {
306             interest = (24 * 1e15);
307         } else if ((_now.sub(stakeStartTime)).div(365 days) == 3) {
308             interest = (13 * 1e15);
309         } else if ((_now.sub(stakeStartTime)).div(365 days) == 4) {
310             interest = (11 * 1e15);
311         }
312     }
313 
314     /**
315      * @dev getProofOfStakeReward
316      * @dev Returns the current stake of a wallet
317      * @param _address is the user wallet
318      */
319     function getProofOfStakeReward(address _address) public view returns(uint) {
320         require((now >= stakeStartTime) && (stakeStartTime > 0));
321 
322         uint _now = now;
323         uint _coinAge = getCoinAge(_address, _now);
324         if (_coinAge <= 0) return 0;
325 
326         uint interest = 0;
327 
328         if ((_now.sub(stakeStartTime)).div(365 days) == 0) {
329             interest = (106 * 1e15);
330         } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {
331             interest = (49 * 1e15);
332         } else if ((_now.sub(stakeStartTime)).div(365 days) == 2) {
333             interest = (24 * 1e15);
334         } else if ((_now.sub(stakeStartTime)).div(365 days) == 3) {
335             interest = (13 * 1e15);
336         } else if ((_now.sub(stakeStartTime)).div(365 days) == 4) {
337             interest = (11 * 1e1);
338         }
339 
340         return (_coinAge * interest).div(365 * (10 ** decimals));
341     }
342 
343     function getCoinAge(address _address, uint _now) internal view returns(uint _coinAge) {
344         if (transferIns[_address].length <= 0) return 0;
345 
346         for (uint i = 0; i < transferIns[_address].length; i++) {
347             if (_now < uint(transferIns[_address][i].time).add(stakeMinAge)) continue;
348 
349             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
350             if (nCoinSeconds > stakeMaxAge) nCoinSeconds = stakeMaxAge;
351 
352             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
353         }
354     }
355 
356 
357     /**
358      * @dev ownerSetStakeStartTime
359      * @dev Used by the owner to define the staking period start
360      * @param timestamp time in UNIX format
361      */
362     function ownerSetStakeStartTime(uint timestamp) onlyOwner public {
363         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
364         stakeStartTime = timestamp;
365     }
366 
367     /**
368      * @dev batchTransfer
369      * @dev Used by the owner to deliver several transfers at the same time (Airdrop)
370      * @param _recipients Array of addresses
371      * @param _values Array of values
372      */
373     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner external returns(bool) {
374         //Check data sizes
375         require(_recipients.length > 0 && _recipients.length == _values.length);
376         //Total value calc
377         uint total = 0;
378         for (uint i = 0; i < _values.length; i++) {
379             total = total.add(_values[i]);
380         }
381         //Sender must hold funds
382         require(total <= balances[msg.sender]);
383         //Make transfers
384         uint64 _now = uint64(now);
385         for (uint j = 0; j < _recipients.length; j++) {
386             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
387             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]), _now));
388             emit Transfer(msg.sender, _recipients[j], _values[j]);
389         }
390         //Reduce all balance on a single transaction from sender
391         balances[msg.sender] = balances[msg.sender].sub(total);
392         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
393         if (balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));
394 
395         return true;
396     }
397 
398     /**
399      * @dev dropSet
400      * @dev Used by the owner to set several self-claiming drops at the same time (Airdrop)
401      * @param _recipients Array of addresses
402      * @param _values Array of values
403      */
404     function dropSet(address[] _recipients, uint[] _values) onlyOwner external returns(bool) {
405         //Check data sizes 
406         require(_recipients.length > 0 && _recipients.length == _values.length);
407 
408         for (uint j = 0; j < _recipients.length; j++) {
409             //Store user drop info
410             airdrops[_recipients[j]].value = _values[j];
411             airdrops[_recipients[j]].claimed = false;
412         }
413 
414         return true;
415     }
416 
417     /**
418      * @dev claimAirdrop
419      * @dev Allow any user with a drop set to claim it
420      */
421     function claimAirdrop() external returns(bool) {
422         //Check if not claimed
423         require(airdrops[msg.sender].claimed == false);
424         require(airdrops[msg.sender].value != 0);
425 
426         //Set Claim to True
427         airdrops[msg.sender].claimed = true;
428         //Clear value
429         airdrops[msg.sender].value = 0;
430 
431         //Tokens are on owner wallet
432         address _from = owner;
433         //Tokens goes to costumer
434         address _to = msg.sender;
435         //Original value
436         uint _value = airdrops[msg.sender].value;
437 
438         balances[_from] = balances[_from].sub(_value);
439         balances[_to] = balances[_to].add(_value);
440         emit Transfer(_from, _to, _value);
441         if (transferIns[_from].length > 0) delete transferIns[_from];
442         uint64 _now = uint64(now);
443         transferIns[_from].push(transferInStruct(uint128(balances[_from]), _now));
444         transferIns[_to].push(transferInStruct(uint128(_value), _now));
445         return true;
446 
447     }
448 
449     //ESCROW SECTION
450     /**
451      * @dev createPayment
452      * @dev Allow a user to start a Escrow process
453      * @param _customer Counterpart that will receive payment on success
454      * @param _value Amount to be escrowed
455      */
456     function createPayment(address _customer, uint _value) external returns(uint) {
457 
458         address _to = address(this);
459         require(_value > 0);
460 
461         balances[msg.sender] = balances[msg.sender].sub(_value);
462         balances[_to] = balances[_to].add(_value);
463         emit Transfer(msg.sender, _to, _value);
464         if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
465         uint64 _now = uint64(now);
466         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));
467 
468         payments[escrowCounter] = Payment(msg.sender, _customer, _value, PaymentStatus.Pending, false);
469         emit PaymentCreation(escrowCounter, _customer, _value);
470 
471         escrowCounter = escrowCounter.add(1);
472         return escrowCounter - 1;
473     }
474 
475     /**
476      * @dev release
477      * @dev Allow a user to release a payment
478      * @param _orderId Ticket number of the escrow service
479      */
480     function release(uint _orderId) external returns(bool) {
481         //Get Payment Handler
482         Payment storage payment = payments[_orderId];
483         //Only if pending
484         require(payment.status == PaymentStatus.Pending);
485         //Only owner or token provider
486         require(msg.sender == owner || msg.sender == payment.provider);
487         //Tokens are on contract
488         address _from = address(this);
489         //Tokens goes to costumer
490         address _to = payment.customer;
491         //Original value
492         uint _value = payment.value;
493         //Fee calculation
494         uint _fee = _value.mul(escrowFeePercent).div(1000);
495         //Value less fees
496         _value = _value.sub(_fee);
497         //Costumer transfer
498         balances[_from] = balances[_from].sub(_value);
499         balances[_to] = balances[_to].add(_value);
500         emit Transfer(_from, _to, _value);
501         //collectionAddress fee recolection
502         balances[_from] = balances[_from].sub(_fee);
503         balances[collectionAddress] = balances[collectionAddress].add(_fee);
504         emit Transfer(_from, collectionAddress, _fee);
505         //Delete any staking from contract address itself
506         if (transferIns[_from].length > 0) delete transferIns[_from];
507         //Store staking information for receivers
508         uint64 _now = uint64(now);
509         //Costumer
510         transferIns[_to].push(transferInStruct(uint128(_value), _now));
511         //collectionAddress
512         transferIns[collectionAddress].push(transferInStruct(uint128(_fee), _now));
513         //Payment Escrow Completed
514         payment.status = PaymentStatus.Completed;
515         //Emit Event
516         emit PaymentCompletion(_orderId, payment.provider, payment.customer, payment.value, payment.status);
517 
518         return true;
519     }
520 
521     /**
522      * @dev refund
523      * @dev Allow a user to refund a payment
524      * @param _orderId Ticket number of the escrow service
525      */
526     function refund(uint _orderId) external returns(bool) {
527         //Get Payment Handler
528         Payment storage payment = payments[_orderId];
529         //Only if pending
530         require(payment.status == PaymentStatus.Pending);
531         //Only if refund was approved
532         require(payment.refundApproved);
533         //Tokens are on contract
534         address _from = address(this);
535         //Tokens go back to provider
536         address _to = payment.provider;
537         //Original value
538         uint _value = payment.value;
539         //Provider transfer
540         balances[_from] = balances[_from].sub(_value);
541         balances[_to] = balances[_to].add(_value);
542         emit Transfer(_from, _to, _value);
543         //Delete any staking from contract address itself
544         if (transferIns[_from].length > 0) delete transferIns[_from];
545         //Store staking information for receivers
546         uint64 _now = uint64(now);
547         transferIns[_to].push(transferInStruct(uint128(_value), _now));
548         //Payment Escrow Refunded
549         payment.status = PaymentStatus.Refunded;
550         //Emit Event
551         emit PaymentCompletion(_orderId, payment.provider, payment.customer, payment.value, payment.status);
552 
553         return true;
554     }
555 
556     /**
557      * @dev approveRefund
558      * @dev Allow a user to approve a refund
559      * @param _orderId Ticket number of the escrow service
560      */
561     function approveRefund(uint _orderId) external returns(bool) {
562         //Get Payment Handler
563         Payment storage payment = payments[_orderId];
564         //Only if pending
565         require(payment.status == PaymentStatus.Pending);
566         //Only owner or costumer
567         require(msg.sender == owner || msg.sender == payment.customer);
568         //Approve Refund
569         payment.refundApproved = true;
570 
571         return true;
572     }
573     //ESCROW SECTION END
574 }