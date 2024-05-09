1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16 
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20      * account.
21      */
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param _newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address _newOwner) public onlyOwner {
39         _transferOwnership(_newOwner);
40     }
41 
42     /**
43      * @dev Transfers control of the contract to a newOwner.
44      * @param _newOwner The address to transfer ownership to.
45      */
46     function _transferOwnership(address _newOwner) internal {
47         require(_newOwner != address(0));
48         emit OwnershipTransferred(owner, _newOwner);
49         owner = _newOwner;
50     }
51 }
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58 
59     /**
60     * @dev Multiplies two numbers, throws on overflow.
61     */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
63         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         c = a * b;
71         assert(c / a == b);
72         return c;
73     }
74 
75     /**
76     * @dev Integer division of two numbers, truncating the quotient.
77     */
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         // uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return a / b;
83     }
84 
85     /**
86     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87     */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         assert(b <= a);
90         return a - b;
91     }
92 
93     /**
94     * @dev Adds two numbers, throws on overflow.
95     */
96     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
97         c = a + b;
98         assert(c >= a);
99         return c;
100     }
101 }
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * See https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109     function totalSupply() public view returns (uint256);
110     function balanceOf(address who) public view returns (uint256);
111     function transfer(address to, uint256 value) public returns (bool);
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120     function allowance(address owner, address spender)
121     public view returns (uint256);
122 
123     function transferFrom(address from, address to, uint256 value)
124     public returns (bool);
125 
126     function approve(address spender, uint256 value) public returns (bool);
127     event Approval(
128         address indexed owner,
129         address indexed spender,
130         uint256 value
131     );
132 }
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  */
138 contract BasicToken is ERC20Basic {
139     using SafeMath for uint256;
140 
141     mapping(address => uint256) balances;
142 
143     uint256 totalSupply_;
144 
145     /**
146     * @dev Total number of tokens in existence
147     */
148     function totalSupply() public view returns (uint256) {
149         return totalSupply_;
150     }
151 
152     /**
153     * @dev Transfer token for a specified address
154     * @param _to The address to transfer to.
155     * @param _value The amount to be transferred.
156     */
157     function transfer(address _to, uint256 _value) public returns (bool) {
158         require(_value <= balances[msg.sender]);
159         require(_to != address(0));
160 
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         emit Transfer(msg.sender, _to, _value);
164         return true;
165     }
166 
167     /**
168     * @dev Gets the balance of the specified address.
169     * @param _owner The address to query the the balance of.
170     * @return An uint256 representing the amount owned by the passed address.
171     */
172     function balanceOf(address _owner) public view returns (uint256) {
173         return balances[_owner];
174     }
175 
176 }
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://github.com/ethereum/EIPs/issues/20
183  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187     mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190     /**
191      * @dev Transfer tokens from one address to another
192      * @param _from address The address which you want to send tokens from
193      * @param _to address The address which you want to transfer to
194      * @param _value uint256 the amount of tokens to be transferred
195      */
196     function transferFrom(
197         address _from,
198         address _to,
199         uint256 _value
200     )
201         public
202         returns (bool)
203     {
204         require(_value <= balances[_from]);
205         require(_value <= allowed[_from][msg.sender]);
206         require(_to != address(0));
207 
208         balances[_from] = balances[_from].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211         emit Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217      * Beware that changing an allowance with this method brings the risk that someone may use both the old
218      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      * @param _spender The address which will spend the funds.
222      * @param _value The amount of tokens to be spent.
223      */
224     function approve(address _spender, uint256 _value) public returns (bool) {
225         allowed[msg.sender][_spender] = _value;
226         emit Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     /**
231      * @dev Function to check the amount of tokens that an owner allowed to a spender.
232      * @param _owner address The address which owns the funds.
233      * @param _spender address The address which will spend the funds.
234      * @return A uint256 specifying the amount of tokens still available for the spender.
235      */
236     function allowance(
237         address _owner,
238         address _spender
239     )
240         public
241         view
242         returns (uint256)
243     {
244         return allowed[_owner][_spender];
245     }
246 
247     /**
248      * @dev Increase the amount of tokens that an owner allowed to a spender.
249      * approve should be called when allowed[_spender] == 0. To increment
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * @param _spender The address which will spend the funds.
254      * @param _addedValue The amount of tokens to increase the allowance by.
255      */
256     function increaseApproval(
257         address _spender,
258         uint256 _addedValue
259     )
260         public
261         returns (bool)
262     {
263         allowed[msg.sender][_spender] = (
264         allowed[msg.sender][_spender].add(_addedValue));
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 
269     /**
270      * @dev Decrease the amount of tokens that an owner allowed to a spender.
271      * approve should be called when allowed[_spender] == 0. To decrement
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * @param _spender The address which will spend the funds.
276      * @param _subtractedValue The amount of tokens to decrease the allowance by.
277      */
278     function decreaseApproval(
279         address _spender,
280         uint256 _subtractedValue
281     )
282         public
283         returns (bool)
284     {
285         uint256 oldValue = allowed[msg.sender][_spender];
286         if (_subtractedValue >= oldValue) {
287             allowed[msg.sender][_spender] = 0;
288         } else {
289             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290         }
291         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292         return true;
293     }
294 
295 }
296 
297 contract BlockchainToken is StandardToken, Ownable {
298 
299     string public constant name = 'Blockchain Token 2.0';
300 
301     string public constant symbol = 'BCT';
302 
303     uint32 public constant decimals = 18;
304 
305     /**
306      *  how many USD cents for 1 * 10^18 token
307      */
308     uint public price = 210;
309 
310     function setPrice(uint _price) onlyOwner public {
311         price = _price;
312     }
313 
314     uint256 public INITIAL_SUPPLY = 21000000 * 1 ether;
315 
316     /**
317    * @dev Constructor that gives msg.sender all of existing tokens.
318    */
319     constructor() public {
320         totalSupply_ = INITIAL_SUPPLY;
321         balances[msg.sender] = INITIAL_SUPPLY;
322         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
323     }
324 
325 }
326 
327 /**
328  * @title Mintable token
329  * @dev Simple ERC20 Token example, with mintable token creation
330  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
331  */
332 contract MintableToken is StandardToken, Ownable {
333     event Mint(address indexed to, uint256 amount);
334     event Burn(address indexed burner, uint256 value);
335     event MintFinished();
336 
337     bool public mintingFinished = false;
338 
339 
340     modifier canMint() {
341         require(!mintingFinished);
342         _;
343     }
344 
345     modifier hasMintPermission() {
346         require(msg.sender == owner);
347         _;
348     }
349 
350     /**
351      * @dev Function to mint tokens
352      * @param _to The address that will receive the minted tokens.
353      * @param _amount The amount of tokens to mint.
354      * @return A boolean that indicates if the operation was successful.
355      */
356     function mint(
357         address _to,
358         uint256 _amount
359     )
360         public
361         hasMintPermission
362         canMint
363         returns (bool)
364     {
365         totalSupply_ = totalSupply_.add(_amount);
366         balances[_to] = balances[_to].add(_amount);
367         emit Mint(_to, _amount);
368         emit Transfer(address(0), _to, _amount);
369         return true;
370     }
371 
372     /**
373      * @dev Burns a specific amount of tokens.
374      * @param _addr The address that will have _amount of tokens burned
375      * @param _value The amount of token to be burned.
376      */
377     function burn(
378         address _addr,
379         uint256 _value
380     )
381         public onlyOwner
382     {
383         _burn(_addr, _value);
384     }
385 
386     function _burn(
387         address _who,
388         uint256 _value
389     )
390         internal
391     {
392         require(_value <= balances[_who]);
393         // no need to require value <= totalSupply, since that would imply the
394         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
395 
396         balances[_who] = balances[_who].sub(_value);
397         totalSupply_ = totalSupply_.sub(_value);
398         emit Burn(_who, _value);
399         emit Transfer(_who, address(0), _value);
400     }
401 
402     /**
403      * @dev Function to stop minting new tokens.
404      * @return True if the operation was successful.
405      */
406     function finishMinting() public onlyOwner canMint returns (bool) {
407         mintingFinished = true;
408         emit MintFinished();
409         return true;
410     }
411 }
412 
413 contract WealthBuilderToken is MintableToken {
414 
415     string public name = 'Wealth Builder Token';
416 
417     string public symbol = 'WBT';
418 
419     uint32 public decimals = 18;
420 
421     /**
422      *  how many {tokens*10^(-18)} get per 1wei
423      */
424     uint public rate = 10 ** 7;
425     /**
426      *  multiplicator for rate
427      */
428     uint public mrate = 10 ** 7;
429 
430     function setRate(uint _rate) onlyOwner public {
431         rate = _rate;
432     }
433 
434 }
435 
436 contract Data is Ownable {
437 
438     // node => its parent
439     mapping (address => address) private parent;
440 
441     // node => its status
442     mapping (address => uint8) public statuses;
443 
444     // node => sum of all his child deposits in USD cents
445     mapping (address => uint) public referralDeposits;
446 
447     // client => balance in wei*10^(-6) available for withdrawal
448     mapping(address => uint256) private balances;
449 
450     // investor => balance in wei*10^(-6) available for withdrawal
451     mapping(address => uint256) private investorBalances;
452 
453     function parentOf(address _addr) public constant returns (address) {
454         return parent[_addr];
455     }
456 
457     function balanceOf(address _addr) public constant returns (uint256) {
458         return balances[_addr] / 1000000;
459     }
460 
461     function investorBalanceOf(address _addr) public constant returns (uint256) {
462         return investorBalances[_addr] / 1000000;
463     }
464 
465     /**
466      * @dev The Data constructor to set up the first depositer
467      */
468     constructor() public {
469         // DirectorOfRegion - 7
470         statuses[msg.sender] = 7;
471     }
472 
473     function addBalance(address _addr, uint256 amount) onlyOwner public {
474         balances[_addr] += amount;
475     }
476 
477     function subtrBalance(address _addr, uint256 amount) onlyOwner public {
478         require(balances[_addr] >= amount);
479         balances[_addr] -= amount;
480     }
481 
482     function addInvestorBalance(address _addr, uint256 amount) onlyOwner public {
483         investorBalances[_addr] += amount;
484     }
485 
486     function subtrInvestorBalance(address _addr, uint256 amount) onlyOwner public {
487         require(investorBalances[_addr] >= amount);
488         investorBalances[_addr] -= amount;
489     }
490 
491     function addReferralDeposit(address _addr, uint256 amount) onlyOwner public {
492         referralDeposits[_addr] += amount;
493     }
494 
495     function subtrReferralDeposit(address _addr, uint256 amount) onlyOwner public {
496         referralDeposits[_addr] -= amount;
497     }
498 
499     function setStatus(address _addr, uint8 _status) onlyOwner public {
500         statuses[_addr] = _status;
501     }
502 
503     function setParent(address _addr, address _parent) onlyOwner public {
504         parent[_addr] = _parent;
505     }
506 
507 }
508 
509 contract Declaration {
510 
511     // threshold in USD => status
512     mapping (uint => uint8) statusThreshold;
513 
514     // status => (depositsNumber => percentage / 10)
515     mapping (uint8 => mapping (uint16 => uint256)) feeDistribution;
516 
517     // status thresholds in USD
518     uint[8] thresholds = [
519     0, 5000, 35000, 150000, 500000, 2500000, 5000000, 10000000
520     ];
521 
522     uint[5] referralFees = [50, 30, 20, 10, 5];
523     uint[5] serviceFees = [25, 20, 15, 10, 5];
524 
525 
526     /**
527      * @dev The Declaration constructor to define some constants
528      */
529     constructor() public {
530         setFeeDistributionsAndStatusThresholds();
531     }
532 
533 
534     /**
535      * @dev Set up fee distribution & status thresholds
536      */
537     function setFeeDistributionsAndStatusThresholds() private {
538         // Agent - 0
539         setFeeDistributionAndStatusThreshold(0, [uint16(120), uint16(80), uint16(50), uint16(20), uint16(10)], thresholds[0]);
540         // SilverAgent - 1
541         setFeeDistributionAndStatusThreshold(1, [uint16(160), uint16(100), uint16(60), uint16(30), uint16(20)], thresholds[1]);
542         // Manager - 2
543         setFeeDistributionAndStatusThreshold(2, [uint16(200), uint16(120), uint16(80), uint16(40), uint16(25)], thresholds[2]);
544         // ManagerOfGroup - 3
545         setFeeDistributionAndStatusThreshold(3, [uint16(250), uint16(150), uint16(100), uint16(50), uint16(30)], thresholds[3]);
546         // ManagerOfRegion - 4
547         setFeeDistributionAndStatusThreshold(4, [300, 180, 120, 60, 35], thresholds[4]);
548         // Director - 5
549         setFeeDistributionAndStatusThreshold(5, [350, 210, 140, 70, 40], thresholds[5]);
550         // DirectorOfGroup - 6
551         setFeeDistributionAndStatusThreshold(6, [400, 240, 160, 80, 45], thresholds[6]);
552         // DirectorOfRegion - 7
553         setFeeDistributionAndStatusThreshold(7, [500, 300, 200, 100, 50], thresholds[7]);
554     }
555 
556 
557     /**
558      * @dev Set up specific fee and status threshold
559      * @param _st The status to set up for
560      * @param _percentages Array of pecentages, which should go to member
561      * @param _threshold The minimum amount of sum of children deposits to get
562      *                   the status _st
563      */
564     function setFeeDistributionAndStatusThreshold(
565         uint8 _st,
566         uint16[5] _percentages,
567         uint _threshold
568     )
569         private
570     {
571         statusThreshold[_threshold] = _st;
572         for (uint8 i = 0; i < _percentages.length; i++) {
573             feeDistribution[_st][i] = _percentages[i];
574         }
575     }
576 
577 }
578 
579 contract Referral is Declaration, Ownable {
580 
581     using SafeMath for uint;
582 
583     // reference to WBT token contract
584     WealthBuilderToken private wbtToken;
585 
586     // reference to BCT2.0 token contract
587     BlockchainToken private bctToken;
588 
589     // reference to data contract
590     Data private data;
591 
592     /**
593      *  how many USD cents get per ETH
594      */
595     uint public ethUsdRate;
596 
597     /**
598      * @dev The Referral constructor to set up the first depositer,
599      * reference to system wbt token, bct token, data and set ethUsdRate
600      */
601     constructor(
602         uint _ethUsdRate,
603         address _wbtToken,
604         address _bctToken,
605         address _data
606     )
607         public
608     {
609         ethUsdRate = _ethUsdRate;
610 
611         // instantiate wbtToken & data contracts
612         wbtToken = WealthBuilderToken(_wbtToken);
613         bctToken = BlockchainToken(_bctToken);
614         data = Data(_data);
615     }
616 
617     /**
618      * @dev Callback function
619      */
620     function() payable public {
621     }
622 
623     /**
624      * @dev invest wbt token function
625      * @param _client to transfer WBT token
626      * @param _depositsCount num of the deposit
627      */
628     function invest(
629         address _client,
630         uint8 _depositsCount
631     )
632         payable public
633     {
634         uint amount = msg.value;
635 
636         // if less then 5 deposits
637         if (_depositsCount < 5) {
638 
639             uint serviceFee;
640 
641             serviceFee = amount * serviceFees[_depositsCount];
642 
643             uint referralFee = amount * referralFees[_depositsCount];
644 
645             // distribute deposit fee among users above on the branch & update users' statuses
646             distribute(data.parentOf(_client), 0, _depositsCount, amount);
647 
648             // update balance & number of deposits of user
649             uint active = (amount * 100).sub(referralFee).sub(serviceFee);
650 
651             wbtToken.mint(_client, active / 100 * wbtToken.rate() / wbtToken.mrate());
652 
653             // update owner`s balance
654             data.addBalance(owner, serviceFee * 10000);
655         } else {
656             wbtToken.mint(_client, amount * wbtToken.rate() / wbtToken.mrate());
657         }
658     }
659 
660     /**
661      * @dev invest bct token function
662      * @param _client to transfer BCT token
663      */
664     function investBct(
665         address _client
666     )
667         public payable
668     {
669         uint amount = msg.value;
670         // distribute deposit fee among users above on the branch & update users' statuses
671         distribute(data.parentOf(_client), 0, 0, amount);
672 
673         bctToken.transfer(_client, amount * ethUsdRate / bctToken.price());
674     }
675 
676 
677     /**
678      * @dev Recursively distribute deposit fee between parents
679      * @param _node Parent address
680      * @param _prevPercentage The percentage for previous parent
681      * @param _depositsCount Count of depositer deposits
682      * @param _amount The amount of deposit
683      */
684     function distribute(
685         address _node,
686         uint _prevPercentage,
687         uint8 _depositsCount,
688         uint _amount
689     )
690         private
691     {
692         address node = _node;
693         uint prevPercentage = _prevPercentage;
694 
695         // distribute deposit fee among users above on the branch & update users' statuses
696         while(node != address(0)) {
697             uint8 status = data.statuses(node);
698 
699             // count fee percentage of current node
700             uint nodePercentage = feeDistribution[status][_depositsCount];
701             uint percentage = nodePercentage.sub(prevPercentage);
702             data.addBalance(node, _amount * percentage * 1000);
703 
704             //update refferals sum amount
705             data.addReferralDeposit(node, _amount * ethUsdRate / 10**18);
706 
707             //update status
708             updateStatus(node, status);
709 
710             node = data.parentOf(node);
711             prevPercentage = nodePercentage;
712         }
713     }
714 
715 
716     /**
717      * @dev Update node status if children sum amount is enough
718      * @param _node Node address
719      * @param _status Node current status
720      */
721     function updateStatus(
722         address _node,
723         uint8 _status
724     )
725         private
726     {
727         uint refDep = data.referralDeposits(_node);
728 
729         for (uint i = thresholds.length - 1; i > _status; i--) {
730             uint threshold = thresholds[i] * 100;
731 
732             if (refDep >= threshold) {
733                 data.setStatus(_node, statusThreshold[thresholds[i]]);
734                 break;
735             }
736         }
737     }
738 
739 
740     /**
741      * @dev Set wbtToken exchange rate
742      * @param _rate wbt/eth rate
743      */
744     function setRate(
745         uint _rate
746     )
747         onlyOwner public
748     {
749         wbtToken.setRate(_rate);
750     }
751 
752 
753     /**
754      * @dev Set bctToken price
755      * @param _price bct/usd rate
756      */
757     function setPrice(
758         uint _price
759     )
760         onlyOwner public
761     {
762         bctToken.setPrice(_price);
763     }
764 
765 
766     /**
767      * @dev Set ETH exchange rate
768      * @param _ethUsdRate eth/usd rate
769      */
770     function setEthUsdRate(
771         uint _ethUsdRate
772     )
773         onlyOwner public
774     {
775         ethUsdRate = _ethUsdRate;
776     }
777 
778 
779     /**
780      * @dev Add new child
781      * @param _inviter parent
782      * @param _invitee child
783      */
784     function invite(
785         address _inviter,
786         address _invitee
787     )
788         public onlyOwner
789     {
790         data.setParent(_invitee, _inviter);
791         // Agent - 0
792         data.setStatus(_invitee, 0);
793     }
794 
795 
796     /**
797      * @dev Set _status for _addr
798      * @param _addr address
799      * @param _status ref. status
800      */
801     function setStatus(
802         address _addr,
803         uint8 _status
804     )
805         public onlyOwner
806     {
807         data.setStatus(_addr, _status);
808     }
809 
810 
811     /**
812      * @dev Withdraw _amount for _addr
813      * @param _addr withdrawal address
814      * @param _amount withdrawal amount
815      * @param investor is investor
816      */
817     function withdraw(
818         address _addr,
819         uint256 _amount,
820         bool investor
821     )
822         public onlyOwner
823     {
824         uint amount = investor ? data.investorBalanceOf(_addr) : data.balanceOf(_addr);
825         require(amount >= _amount && address(this).balance >= _amount);
826 
827         if (investor) {
828             data.subtrInvestorBalance(_addr, _amount * 1000000);
829         } else {
830             data.subtrBalance(_addr, _amount * 1000000);
831         }
832 
833         _addr.transfer(_amount);
834     }
835 
836 
837     /**
838      * @dev Withdraw contract balance to _addr
839      * @param _addr withdrawal address
840      */
841     function withdrawOwner(
842         address _addr,
843         uint256 _amount
844     )
845         public onlyOwner
846     {
847         require(address(this).balance >= _amount);
848         _addr.transfer(_amount);
849     }
850 
851 
852     /**
853      * @dev Withdraw corresponding amount of ETH to _addr and burn _value tokens
854      * @param _addr buyer address
855      * @param _amount amount of tokens to buy
856      */
857     function transferBctToken(
858         address _addr,
859         uint _amount
860     )
861         onlyOwner public
862     {
863         require(bctToken.balanceOf(this) >= _amount);
864         bctToken.transfer(_addr, _amount);
865     }
866 
867 
868     /**
869      * @dev Withdraw corresponding amount of ETH to _addr and burn _value tokens
870      * @param _addr withdrawal address
871      * @param _amount amount of tokens to sell
872      */
873     function withdrawWbtToken(
874         address _addr,
875         uint256 _amount
876     )
877         onlyOwner public
878     {
879         wbtToken.burn(_addr, _amount);
880         uint256 etherValue = _amount * wbtToken.mrate() / wbtToken.rate();
881         _addr.transfer(etherValue);
882     }
883 
884 
885     /**
886      * @dev Transfer ownership of wbtToken contract to _addr
887      * @param _addr address
888      */
889     function transferTokenOwnership(
890         address _addr
891     )
892         onlyOwner public
893     {
894         wbtToken.transferOwnership(_addr);
895     }
896 
897 
898     /**
899      * @dev Transfer ownership of data contract to _addr
900      * @param _addr address
901      */
902     function transferDataOwnership(
903         address _addr
904     )
905         onlyOwner public
906     {
907         data.transferOwnership(_addr);
908     }
909 
910 }