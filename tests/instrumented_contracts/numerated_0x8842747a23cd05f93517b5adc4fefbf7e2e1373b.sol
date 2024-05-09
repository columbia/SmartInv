1 pragma solidity ^0.4.20;
2 
3 contract GenesisProtected {
4     modifier addrNotNull(address _address) {
5         require(_address != address(0));
6         _;
7     }
8 }
9 
10 
11 // ----------------------------------------------------------------------------
12 // The original code is taken from:
13 // https://github.com/OpenZeppelin/zeppelin-solidity:
14 //     master branch from zeppelin-solidity/contracts/ownership/Ownable.sol
15 // Changed function name: transferOwnership -> setOwner.
16 // Added inheritance from GenesisProtected (address != 0x0).
17 // setOwner refactored for emitting after owner replacing.
18 // ----------------------------------------------------------------------------
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable is GenesisProtected {
26     address public owner;
27 
28     /**
29      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30      * account.
31      */
32     function Ownable() public {
33         owner = msg.sender;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /**
45      * @dev Allows the current owner to transfer control of the contract to a _new.
46      * @param a The address to transfer ownership to.
47      */
48     function setOwner(address a) external onlyOwner addrNotNull(a) {
49         owner = a;
50         emit OwnershipReplaced(msg.sender, a);
51     }
52 
53     event OwnershipReplaced(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 }
58 
59 
60 contract Enums {
61     // Type for mapping uint (index) => name for baskets types described in WP
62     enum BasketType {
63         unknown, // 0 unknown
64         team, // 1 Team
65         foundation, // 2 Foundation
66         arr, // 3 Advertisement, Referral program, Reward
67         advisors, // 4 Advisors
68         bounty, // 5 Bounty
69         referral, // 6 Referral
70         referrer // 7 Referrer
71     }
72 }
73 
74 
75 contract WPTokensBaskets is Ownable, Enums {
76     // This mapping holds all accounts ever used as baskets forever
77     mapping (address => BasketType) internal types;
78 
79     // Baskets for tokens
80     address public team;
81     address public foundation;
82     address public arr;
83     address public advisors;
84     address public bounty;
85 
86     // Public constructor
87     function WPTokensBaskets(
88         address _team,
89         address _foundation,
90         address _arr,
91         address _advisors,
92         address _bounty
93     )
94         public
95     {
96         setTeam(_team);
97         setFoundation(_foundation);
98         setARR(_arr);
99         setAdvisors(_advisors);
100         setBounty(_bounty);
101     }
102 
103     // Fallback function - do not apply any ether to this contract.
104     function () external payable {
105         revert();
106     }
107 
108     // Last resort to return ether.
109     // See the last warning at
110     // http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function
111     // for such cases.
112     function transferEtherTo(address a) external onlyOwner addrNotNull(a) {
113         a.transfer(address(this).balance);
114     }
115 
116     function typeOf(address a) public view returns (BasketType) {
117         return types[a];
118     }
119 
120     // Return truth if given address is not registered as token basket.
121     function isUnknown(address a) public view returns (bool) {
122         return types[a] == BasketType.unknown;
123     }
124 
125     function isTeam(address a) public view returns (bool) {
126         return types[a] == BasketType.team;
127     }
128 
129     function isFoundation(address a) public view returns (bool) {
130         return types[a] == BasketType.foundation;
131     }
132 
133     function setTeam(address a) public onlyOwner addrNotNull(a) {
134         require(isUnknown(a));
135         types[team = a] = BasketType.team;
136     }
137 
138     function setFoundation(address a) public onlyOwner addrNotNull(a) {
139         require(isUnknown(a));
140         types[foundation = a] = BasketType.foundation;
141     }
142 
143     function setARR(address a) public onlyOwner addrNotNull(a) {
144         require(isUnknown(a));
145         types[arr = a] = BasketType.arr;
146     }
147 
148     function setAdvisors(address a) public onlyOwner addrNotNull(a) {
149         require(isUnknown(a));
150         types[advisors = a] = BasketType.advisors;
151     }
152 
153     function setBounty(address a) public onlyOwner addrNotNull(a) {
154         require(types[a] == BasketType.unknown);
155         types[bounty = a] = BasketType.bounty;
156     }
157 }
158 
159 // ----------------------------------------------------------------------------
160 // The original code is taken from:
161 // https://github.com/OpenZeppelin/zeppelin-solidity:
162 //     master branch from zeppelin-solidity/contracts/math/SafeMath.sol
163 // ----------------------------------------------------------------------------
164 
165 /**
166  * @title SafeMath
167  * @dev Math operations with safety checks that throw on error
168  */
169 library SafeMath {
170     /**
171      * @dev Multiplies two numbers, throws on overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         if (a == 0)
175             return 0;
176         uint256 c = a * b;
177         assert(c / a == b);
178         return c;
179     }
180 
181     /**
182      * @dev Integer division of two numbers, truncating the quotient.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         // assert(b > 0); // Solidity automatically throws when dividing by 0
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188         return c;
189     }
190 
191     /**
192      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is
193      * greater than minuend).
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         assert(b <= a);
197         return a - b;
198     }
199 
200     /**
201      * @dev Adds two numbers, throws on overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         assert(c >= a);
206         return c;
207     }
208 }
209 
210 // ----------------------------------------------------------------------------
211 // ERC Token Standard #20 Interface
212 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
213 // The original code is taken from:
214 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
215 // ----------------------------------------------------------------------------
216 contract ERC20Interface {
217     function totalSupply() public constant returns (uint);
218     function balanceOf(address tokenOwner)
219         public constant returns (uint balance);
220     function allowance(address tokenOwner, address spender)
221         public constant returns (uint remaining);
222     function transfer(address to, uint tokens) public returns (bool success);
223     function approve(address spender, uint tokens)
224         public returns (bool success);
225     function transferFrom(address from, address to, uint tokens)
226         public returns (bool success);
227 
228     event Transfer(address indexed from, address indexed to, uint tokens);
229     event Approval(
230         address indexed tokenOwner,
231         address indexed spender,
232         uint tokens
233     );
234 }
235 
236 
237 contract Token is Ownable, ERC20Interface, Enums {
238     using SafeMath for uint;
239 
240     // Token full name
241     string private constant NAME = "EnvisionX EXCHAIN Token";
242     // Token symbol name
243     string private constant SYMBOL = "EXT";
244     // Token max fraction, in decimal signs after the point
245     uint8 private constant DECIMALS = 18;
246 
247     // Tokens max supply, in EXTwei
248     uint public constant MAX_SUPPLY = 3000000000 * (10**uint(DECIMALS));
249 
250     // Tokens balances map
251     mapping(address => uint) internal balances;
252 
253     // Maps with allowed amounts fot TransferFrom
254     mapping (address => mapping (address => uint)) internal allowed;
255 
256     // Total amount of issued tokens, in EXTwei
257     uint internal _totalSupply;
258 
259     // Map with Ether founds amount by address (using when refunds)
260     mapping(address => uint) internal etherFunds;
261     uint internal _earnedFunds;
262     // Map with refunded addreses (Black List)
263     mapping(address => bool) internal refunded;
264 
265     // Address of sale agent (a contract) which can mint new tokens
266     address public mintAgent;
267 
268     // Token transfer allowed only when token minting is finished
269     bool public isMintingFinished = false;
270     // When minting was finished
271     uint public mintingStopDate;
272 
273     // Total amount of tokens minted to team basket, in EXTwei.
274     // This will not include tokens, transferred to team basket
275     // after minting is finished.
276     uint public teamTotal;
277     // Amount of tokens spent by team in first 96 weeks since
278     // minting finish date. Used to calculate team spend
279     // restrictions according to ICO White Paper.
280     uint public spentByTeam;
281 
282     // Address of WPTokensBaskets contract
283     WPTokensBaskets public wpTokensBaskets;
284 
285     // Constructor
286     function Token(WPTokensBaskets baskets) public {
287         wpTokensBaskets = baskets;
288         mintAgent = owner;
289     }
290 
291     // Fallback function - do not apply any ether to this contract.
292     function () external payable {
293         revert();
294     }
295 
296     // Last resort to return ether.
297     // See the last warning at
298     // http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function
299     // for such cases.
300     function transferEtherTo(address a) external onlyOwner addrNotNull(a) {
301         a.transfer(address(this).balance);
302     }
303 
304     /**
305     ----------------------------------------------------------------------
306     ERC20 Interface implementation
307     */
308 
309     // Return token full name
310     function name() public pure returns (string) {
311         return NAME;
312     }
313 
314     // Return token symbol name
315     function symbol() public pure returns (string) {
316         return SYMBOL;
317     }
318 
319     // Return amount of decimals after point
320     function decimals() public pure returns (uint8) {
321         return DECIMALS;
322     }
323 
324     // Return total amount of issued tokens, in EXTwei
325     function totalSupply() public constant returns (uint) {
326         return _totalSupply;
327     }
328 
329     // Return account balance in tokens (in EXTwei)
330     function balanceOf(address _address) public constant returns (uint) {
331         return balances[_address];
332     }
333 
334     // Transfer tokens to another account
335     function transfer(address to, uint value)
336         public
337         addrNotNull(to)
338         returns (bool)
339     {
340         if (balances[msg.sender] < value)
341             return false;
342         if (isFrozen(wpTokensBaskets.typeOf(msg.sender), value))
343             return false;
344         balances[msg.sender] = balances[msg.sender].sub(value);
345         balances[to] = balances[to].add(value);
346         saveTeamSpent(msg.sender, value);
347         emit Transfer(msg.sender, to, value);
348         return true;
349     }
350 
351     // Transfer tokens from one account to another,
352     // using permissions defined with approve() method.
353     function transferFrom(address from, address to, uint value)
354         public
355         addrNotNull(to)
356         returns (bool)
357     {
358         if (balances[from] < value)
359             return false;
360         if (allowance(from, msg.sender) < value)
361             return false;
362         if (isFrozen(wpTokensBaskets.typeOf(from), value))
363             return false;
364         balances[from] = balances[from].sub(value);
365         balances[to] = balances[to].add(value);
366         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
367         saveTeamSpent(from, value);
368         emit Transfer(from, to, value);
369         return true;
370     }
371 
372     // Allow to transfer given amount of tokens (in EXTwei)
373     // to account which is not owner.
374     function approve(address spender, uint value) public returns (bool) {
375         if (msg.sender == spender)
376             return false;
377         allowed[msg.sender][spender] = value;
378         emit Approval(msg.sender, spender, value);
379         return true;
380     }
381 
382     // Return amount of tokens (in EXTwei) which allowed to
383     // be transferred by non-owner spender
384     function allowance(address _owner, address spender)
385         public
386         constant
387         returns (uint)
388     {
389         return allowed[_owner][spender];
390     }
391 
392     /**
393     ----------------------------------------------------------------------
394     Other methods
395     */
396 
397     // Return account funds in ether (in wei)
398     function etherFundsOf(address _address) public constant returns (uint) {
399         return etherFunds[_address];
400     }
401 
402     // Return total amount of funded ether, in wei
403     function earnedFunds() public constant returns (uint) {
404         return _earnedFunds;
405     }
406 
407     // Return true if given address have been refunded
408     function isRefunded(address _address) public view returns (bool) {
409         return refunded[_address];
410     }
411 
412     // Set new address of sale agent contract.
413     // Will be called for each sale stage: PrivateSale, PreSale, MainSale.
414     function setMintAgent(address a) public onlyOwner addrNotNull(a) {
415         emit MintAgentReplaced(mintAgent, a);
416         mintAgent = a;
417     }
418 
419     // Interface for sale agent contract - mint new tokens
420     function mint(address to, uint256 extAmount, uint256 etherAmount) public {
421         require(!isMintingFinished);
422         require(msg.sender == mintAgent);
423         require(!refunded[to]);
424         _totalSupply = _totalSupply.add(extAmount);
425         require(_totalSupply <= MAX_SUPPLY);
426         balances[to] = balances[to].add(extAmount);
427         if (wpTokensBaskets.isUnknown(to)) {
428             _earnedFunds = _earnedFunds.add(etherAmount);
429             etherFunds[to] = etherFunds[to].add(etherAmount);
430         } else if (wpTokensBaskets.isTeam(to)) {
431             teamTotal = teamTotal.add(extAmount);
432         }
433         emit Mint(to, extAmount);
434         emit Transfer(msg.sender, to, extAmount);
435     }
436 
437     // Destroy minted tokens and refund ether spent by investor.
438     // Used in AML (Anti Money Laundering) workflow.
439     // Will be called only by humans because there is no way
440     // to withdraw crowdfunded ether from Beneficiary account
441     // from context of this account.
442     // Important note: all tokens minted to team, foundation etc.
443     // will NOT be burned, because they in general are spent
444     // during the sale and its too expensive to track all these
445     // transactions.
446     function burnTokensAndRefund(address _address)
447         external
448         payable
449         addrNotNull(_address)
450         onlyOwner()
451     {
452         require(msg.value > 0 && msg.value == etherFunds[_address]);
453         _totalSupply = _totalSupply.sub(balances[_address]);
454         balances[_address] = 0;
455         _earnedFunds = _earnedFunds.sub(msg.value);
456         etherFunds[_address] = 0;
457         refunded[_address] = true;
458         _address.transfer(msg.value);
459     }
460 
461     // Stop tokens minting forever.
462     function finishMinting() external onlyOwner {
463         require(!isMintingFinished);
464         isMintingFinished = true;
465         mintingStopDate = now;
466         emit MintingFinished();
467     }
468 
469     /**
470     ----------------------------------------------------------------------
471     Tokens freeze logic, according to ICO White Paper
472     */
473 
474     // Return truth if given _value amount of tokens (in EXTwei)
475     // cannot be transferred from account due to spend restrictions
476     // defined in ICO White Paper.
477     // !!!Caveat of current implementaion!!!
478     // Say,
479     //  1. There was 100 tokens minted to the team basket;
480     //  2. Minting was finished and 24 weeks elapsed, and now
481     //    team can spend up to 25 tokens till next 24 weeks;
482     //  3. Someone transfers another 100 tokens to the team basket;
483     //  4. ...
484     // Problem is, actually, you can't spend any of these extra 100
485     // tokens until 96 weeks will elapse since minting finish date.
486     // That's because after next 24 weeks will be unlocked only
487     // 25 tokens more (25% of *minted* tokens) and so on.
488     // So, DO NOT send tokens to the team basket until 96 weeks elapse!
489     function isFrozen(
490         BasketType _basketType,
491         uint _value
492     )
493         public view returns (bool)
494     {
495         if (!isMintingFinished) {
496             // Allow spend only after minting is finished
497             return true;
498         }
499         if (_basketType == BasketType.foundation) {
500             // Allow to spend foundation tokens only after
501             // 48 weeks after minting is finished
502             return now < mintingStopDate + 48 weeks;
503         }
504         if (_basketType == BasketType.team) {
505             // Team allowed to spend tokens:
506             //  25%  - after minting finished date + 24 weeks;
507             //  50%  - after minting finished date + 48 weeks;
508             //  75%  - after minting finished date + 72 weeks;
509             //  100% - after minting finished date + 96 weeks.
510             if (mintingStopDate + 96 weeks <= now) {
511                 return false;
512             }
513             if (now < mintingStopDate + 24 weeks)
514                 return true;
515             // Calculate fraction as percents multipled to 10^10.
516             // Without this owner will be able to spend fractions
517             // less than 1% per transaction.
518             uint fractionSpent =
519                 spentByTeam.add(_value).mul(1000000000000).div(teamTotal);
520             if (now < mintingStopDate + 48 weeks) {
521                 return 250000000000 < fractionSpent;
522             }
523             if (now < mintingStopDate + 72 weeks) {
524                 return 500000000000 < fractionSpent;
525             }
526             // from 72 to 96 weeks elapsed
527             return 750000000000 < fractionSpent;
528         }
529         // No restrictions for other token holders
530         return false;
531     }
532 
533     // Save amount of spent tokens by team till 96 weeks after minting
534     // finish date. This is vital because without the check we'll eventually
535     // overflow the uint256.
536     function saveTeamSpent(address _owner, uint _value) internal {
537         if (wpTokensBaskets.isTeam(_owner)) {
538             if (now < mintingStopDate + 96 weeks)
539                 spentByTeam = spentByTeam.add(_value);
540         }
541     }
542 
543     /**
544     ----------------------------------------------------------------------
545     Events
546     */
547 
548     // Emitted when mint agent (address of a sale contract)
549     // replaced with new one
550     event MintAgentReplaced(
551         address indexed previousMintAgent,
552         address indexed newMintAgent
553     );
554 
555     // Emitted when new tokens were created and funded to account
556     event Mint(address indexed to, uint256 amount);
557 
558     // Emitted when tokens minting is finished.
559     event MintingFinished();
560 }
561 
562 
563 contract Killable is Ownable {
564     function kill(address a) external onlyOwner addrNotNull(a) {
565         selfdestruct(a);
566     }
567 }
568 
569 
570 contract Beneficiary is Killable {
571 
572     // Address of account which will receive all ether
573     // gathered from ICO
574     address public beneficiary;
575 
576     // Constructor
577     function Beneficiary() public {
578         beneficiary = owner;
579     }
580 
581     // Fallback function - do not apply any ether to this contract.
582     function () external payable {
583         revert();
584     }
585 
586     // Set new beneficiary for ICO
587     function setBeneficiary(address a) external onlyOwner addrNotNull(a) {
588         beneficiary = a;
589     }
590 }
591 
592 
593 contract TokenSale is Killable, Enums {
594     using SafeMath for uint256;
595 
596     // Type describing:
597     //  - the address of the beneficiary of the tokens;
598     //  - the final amount of tokens calculated according to the
599     //    terms of the WP;
600     //  - the amount of Ether (in Wei) if the beneficiary is an investor
601     // This type is used in arrays[8] that should be declare in the heir
602     // contracts.
603     struct tokens {
604         address beneficiary;
605         uint256 extAmount;
606         uint256 ethAmount;
607     }
608 
609     // Sale stage start date/time, Unix timestamp
610     uint32 public start;
611     // Sale stage stop date/time, Unix timestamp
612     uint32 public stop;
613     // Min ether amount for purchase
614     uint256 public minBuyingAmount;
615     // Price of one token, in wei
616     uint256 public currentPrice;
617 
618     // Amount of tokens available, in EXTwei
619     uint256 public remainingSupply;
620     // Amount of earned funds, in wei
621     uint256 public earnedFunds;
622 
623     // Address of Token contract
624     Token public token;
625     // Address of Beneficiary contract - a container
626     // for the beneficiary address
627     Beneficiary internal _beneficiary;
628 
629     // Equals to 10^decimals.
630     // Internally tokens stored as EXTwei (token count * 10^decimals).
631     // Used to convert EXT to EXTwei and vice versa.
632     uint256 internal dec;
633 
634     // Constructor
635     function TokenSale(
636         Token _token, // address of EXT ERC20 token contract
637         Beneficiary beneficiary, // address of container for Ether beneficiary
638         uint256 _supplyAmount // in EXT
639     )
640         public
641     {
642         token = _token;
643         _beneficiary = beneficiary;
644 
645         // Factor for convertation EXT to EXTwei and vice versa
646         dec = 10 ** uint256(token.decimals());
647         // convert to EXTwei
648         remainingSupply = _supplyAmount.mul(dec);
649     }
650 
651     // Fallback function. Here we'll receive all investments.
652     function() external payable {
653         purchase();
654     }
655 
656     // Investments receive logic. Must be overrided in
657     // arbitrary sale agent (per each sale stage).
658     function purchase() public payable;
659 
660     // Return truth if purchase with given _value of ether
661     // (in wei) can be made
662     function canPurchase(uint256 _value) public view returns (bool) {
663         return start <= now && now <= stop &&
664             minBuyingAmount <= _value &&
665             toEXTwei(_value) <= remainingSupply;
666     }
667 
668     // Return address of crowdfunding beneficiary address.
669     function beneficiary() public view returns (address) {
670         return _beneficiary.beneficiary();
671     }
672 
673     // Return truth if there are tokens which can be purchased.
674     function isActive() public view returns (bool) {
675         return canPurchase(minBuyingAmount);
676     }
677 
678     // Initialize tokensArray records with actual addresses of WP tokens baskets
679     function setBaskets(tokens[8] memory _tokensArray) internal view {
680         _tokensArray[uint8(BasketType.unknown)].beneficiary =
681             msg.sender;
682         _tokensArray[uint8(BasketType.team)].beneficiary =
683             token.wpTokensBaskets().team();
684         _tokensArray[uint8(BasketType.foundation)].beneficiary =
685             token.wpTokensBaskets().foundation();
686         _tokensArray[uint8(BasketType.arr)].beneficiary =
687             token.wpTokensBaskets().arr();
688         _tokensArray[uint8(BasketType.advisors)].beneficiary =
689             token.wpTokensBaskets().advisors();
690         _tokensArray[uint8(BasketType.bounty)].beneficiary =
691             token.wpTokensBaskets().bounty();
692     }
693 
694     // Return amount of tokens (in EXTwei) which can be purchased
695     // at the moment for given amount of ether (in wei).
696     function toEXTwei(uint256 _value) public view returns (uint256) {
697         return _value.mul(dec).div(currentPrice);
698     }
699 
700     // Return amount of bonus tokens (in EXTwei)
701     // Receive amount of tokens (in EXTwei) that will be sale, and bonus percent
702     function bonus(uint256 _tokens, uint8 _bonus)
703         internal
704         pure
705         returns (uint256)
706     {
707         return _tokens.mul(_bonus).div(100);
708     }
709 
710     // Initialize tokensArray records with actual amounts of tokens
711     function calcWPTokens(tokens[8] memory a, uint8 _bonus) internal pure {
712         a[uint8(BasketType.unknown)].extAmount =
713            a[uint8(BasketType.unknown)].extAmount.add(
714                bonus(
715                    a[uint8(BasketType.unknown)].extAmount,
716                    _bonus
717                )
718            );
719         uint256 n = a[uint8(BasketType.unknown)].extAmount;
720         a[uint8(BasketType.team)].extAmount = n.mul(24).div(40);
721         a[uint8(BasketType.foundation)].extAmount = n.mul(20).div(40);
722         a[uint8(BasketType.arr)].extAmount = n.mul(10).div(40);
723         a[uint8(BasketType.advisors)].extAmount = n.mul(4).div(40);
724         a[uint8(BasketType.bounty)].extAmount = n.mul(2).div(40);
725     }
726 
727     // Send received ether (in wei) to beneficiary
728     function transferFunds(uint256 _value) internal {
729         beneficiary().transfer(_value);
730         earnedFunds = earnedFunds.add(_value);
731     }
732 
733     // Method for call mint() in EXT ERC20 contract.
734     // mint() will be called for each record if amount of tokens > 0
735     function createTokens(tokens[8] memory _tokensArray) internal {
736         for (uint i = 0; i < _tokensArray.length; i++) {
737             if (_tokensArray[i].extAmount > 0) {
738                 token.mint(
739                     _tokensArray[i].beneficiary,
740                     _tokensArray[i].extAmount,
741                     _tokensArray[i].ethAmount
742                 );
743             }
744         }
745     }
746 }
747 
748 
749 contract PrivateSale is TokenSale {
750     using SafeMath for uint256;
751 
752     // List of investors allowed to buy tokens at PrivateSale
753     mapping(address => bool) internal allowedInvestors;
754 
755     function PrivateSale(Token _token, Beneficiary _beneficiary)
756         TokenSale(_token, _beneficiary, uint256(400000000))
757         public
758     {
759         start = 1522627620;
760         stop = 1525046399;
761         minBuyingAmount = 70 szabo;
762         currentPrice = 70 szabo;
763     }
764 
765     function purchase() public payable {
766         require(isInvestorAllowed(msg.sender));
767         require(canPurchase(msg.value));
768         transferFunds(msg.value);
769         tokens[8] memory tokensArray;
770         tokensArray[uint8(BasketType.unknown)].extAmount = toEXTwei(msg.value);
771         setBaskets(tokensArray);
772         remainingSupply = remainingSupply.sub(
773             tokensArray[uint8(BasketType.unknown)].extAmount
774         );
775         calcWPTokens(tokensArray, 30);
776         tokensArray[uint8(BasketType.unknown)].ethAmount = msg.value;
777         createTokens(tokensArray);
778     }
779 
780     // Register new investor
781     function allowInvestor(address a) public onlyOwner addrNotNull(a) {
782         allowedInvestors[a] = true;
783     }
784 
785     // Discard existing investor
786     function denyInvestor(address a) public onlyOwner addrNotNull(a) {
787         delete allowedInvestors[a];
788     }
789 
790     // Return truth if given account is allowed to buy tokens
791     function isInvestorAllowed(address a) public view returns (bool) {
792         return allowedInvestors[a];
793     }
794 }