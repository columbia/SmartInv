1 pragma solidity ^0.4.19;
2 
3 /**
4  *
5  * @title McFly.aero - main contract
6  * @author Copyright (c) 2018 McFly.aero
7  * @author Dmitriy Khizhinskiy
8  * @author "MIT"
9  *
10  */ 
11 
12 /**
13  * @title ERC20 Basic smart contract
14  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
15  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
16  * @dev Simpler version of ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/179
18  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
19  * @author modification: Dmitriy Khizhinskiy @McFly.aero
20  */
21 contract ERC20Basic {
22     function totalSupply() public view returns (uint256);
23     function balanceOf(address who) public view returns (uint256);
24     function transfer(address to, uint256 value) public returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 /**
29  * @title Ownable smart contract
30  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
31  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
32  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
33  * @author modification: Dmitriy Khizhinskiy @McFly.aero
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38     address public owner;
39     address public candidate;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45     * account.
46     */
47     function Ownable() public {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53     * @dev Throws if called by any account other than the owner.
54     */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62     * @dev Allows the current owner to _request_ transfer control of the contract to a newOwner.
63     * @param newOwner The address to transfer ownership to.
64     */
65     function requestOwnership(address newOwner) onlyOwner public {
66         require(newOwner != address(0));
67         candidate = newOwner;
68     }
69 
70 
71     /**
72     * @dev Allows the _NEW_ candidate to complete transfer control of the contract to him.
73     */
74     function confirmOwnership() public {
75         require(candidate == msg.sender);
76         owner = candidate;
77         OwnershipTransferred(owner, candidate);        
78     }
79 }
80 
81 
82 /**
83  * @title MultiOwners smart contract
84  * @author Copyright (c) 2018 McFly.aero
85  * @author Dmitriy Khizhinskiy
86  * @author "MIT"
87  */
88 contract MultiOwners {
89 
90     event AccessGrant(address indexed owner);
91     event AccessRevoke(address indexed owner);
92     
93     mapping(address => bool) owners;
94     address public publisher;
95 
96 
97     function MultiOwners() public {
98         owners[msg.sender] = true;
99         publisher = msg.sender;
100     }
101 
102 
103     modifier onlyOwner() { 
104         require(owners[msg.sender] == true);
105         _; 
106     }
107 
108 
109     function isOwner() constant public returns (bool) {
110         return owners[msg.sender] ? true : false;
111     }
112 
113 
114     function checkOwner(address maybe_owner) constant public returns (bool) {
115         return owners[maybe_owner] ? true : false;
116     }
117 
118 
119     function grant(address _owner) onlyOwner public {
120         owners[_owner] = true;
121         AccessGrant(_owner);
122     }
123 
124 
125     function revoke(address _owner) onlyOwner public {
126         require(_owner != publisher);
127         require(msg.sender != _owner);
128 
129         owners[_owner] = false;
130         AccessRevoke(_owner);
131     }
132 }
133 
134 
135 
136 
137 /**
138  * @title SafeMath
139  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
140  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
141  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
142  * @dev Math operations with safety checks that throw on error
143  */
144 library SafeMath {
145     /**
146     * @dev Multiplies two numbers, throws on overflow.
147     */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         if (a == 0) {
150             return 0;
151         }
152         uint256 c = a * b;
153         assert(c / a == b);
154         return c;
155     }
156 
157 
158     /**
159     * @dev Integer division of two numbers, truncating the quotient.
160     */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // assert(b > 0); // Solidity automatically throws when dividing by 0
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165         return c;
166     }
167 
168 
169     /**
170     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
171     */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         assert(b <= a);
174         return a - b;
175     }
176 
177 
178     /**
179     * @dev Adds two numbers, throws on overflow.
180     */
181     function add(uint256 a, uint256 b) internal pure returns (uint256) {
182         uint256 c = a + b;
183         assert(c >= a);
184         return c;
185     }
186 }
187 
188 
189 
190 
191 
192 
193 
194 
195 
196 
197 
198 /**
199  * @title BasicToken smart contract
200  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
201  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
202  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
203  * @author modification: Dmitriy Khizhinskiy @McFly.aero
204  */
205 
206 
207 
208 
209 
210 /**
211  * @title Basic token
212  * @dev Basic version of StandardToken, with no allowances.
213  */
214 contract BasicToken is ERC20Basic {
215     using SafeMath for uint256;
216 
217     mapping(address => uint256) balances;
218 
219     uint256 totalSupply_;
220 
221     /**
222     * @dev total number of tokens in existence
223     */
224     function totalSupply() public view returns (uint256) {
225         return totalSupply_;
226     }
227 
228 
229     /**
230     * @dev transfer token for a specified address
231     * @param _to The address to transfer to.
232     * @param _value The amount to be transferred.
233     */
234     function transfer(address _to, uint256 _value) public returns (bool) {
235         require(_to != address(0));
236         require(_value <= balances[msg.sender]);
237 
238         // SafeMath.sub will throw if there is not enough balance.
239         balances[msg.sender] = balances[msg.sender].sub(_value);
240         balances[_to] = balances[_to].add(_value);
241         Transfer(msg.sender, _to, _value);
242         return true;
243     }
244 
245 
246     /**
247     * @dev Gets the balance of the specified address.
248     * @param _owner The address to query the the balance of.
249     * @return An uint256 representing the amount owned by the passed address.
250     */
251     function balanceOf(address _owner) public view returns (uint256 balance) {
252         return balances[_owner];
253     }
254 
255 }
256 
257 
258 /**
259  * @title ERC20 smart contract
260  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
261  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
262  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
263  * @author modification: Dmitriy Khizhinskiy @McFly.aero
264  */
265 
266 
267 
268 
269 /**
270  * @title ERC20 interface
271  * @dev see https://github.com/ethereum/EIPs/issues/20
272  */
273 contract ERC20 is ERC20Basic {
274     function allowance(address owner, address spender) public view returns (uint256);
275     function transferFrom(address from, address to, uint256 value) public returns (bool);
276     function approve(address spender, uint256 value) public returns (bool);
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 /**
281  * @title Standard ERC20 token
282  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
283  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
284  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
285  * @author modification: Dmitriy Khizhinskiy @McFly.aero
286  * @dev Implementation of the basic standard token.
287  * @dev https://github.com/ethereum/EIPs/issues/20
288  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
289  */
290 contract StandardToken is ERC20, BasicToken {
291 
292     mapping (address => mapping (address => uint256)) internal allowed;
293   
294     /** 
295     * @dev Transfer tokens from one address to another
296     * @param _from address The address which you want to send tokens from
297     * @param _to address The address which you want to transfer to
298     * @param _value uint256 the amount of tokens to be transferred
299     */
300     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
301         require(_to != address(0));
302         require(_value <= balances[_from]);
303         require(_value <= allowed[_from][msg.sender]);
304 
305         balances[_from] = balances[_from].sub(_value);
306         balances[_to] = balances[_to].add(_value);
307         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308         Transfer(_from, _to, _value);
309         return true;
310     }
311 
312 
313     /**
314     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
315     *
316     * Beware that changing an allowance with this method brings the risk that someone may use both the old
317     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
318     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
319     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320     * @param _spender The address which will spend the funds.
321     * @param _value The amount of tokens to be spent.
322     */
323     function approve(address _spender, uint256 _value) public returns (bool) {
324         allowed[msg.sender][_spender] = _value;
325         Approval(msg.sender, _spender, _value);
326         return true;
327     }
328 
329 
330     /**
331     * @dev Function to check the amount of tokens that an owner allowed to a spender.
332     * @param _owner address The address which owns the funds.
333     * @param _spender address The address which will spend the funds.
334     * @return A uint256 specifying the amount of tokens still available for the spender.
335     */
336     function allowance(address _owner, address _spender) public view returns (uint256) {
337         return allowed[_owner][_spender];
338     }
339 
340 
341     /**
342     * @dev Increase the amount of tokens that an owner allowed to a spender.
343     *
344     * approve should be called when allowed[_spender] == 0. To increment
345     * allowed value is better to use this function to avoid 2 calls (and wait until
346     * the first transaction is mined)
347     * From MonolithDAO Token.sol
348     * @param _spender The address which will spend the funds.
349     * @param _addedValue The amount of tokens to increase the allowance by.
350     */
351     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
352         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
353         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
354         return true;
355     }
356 
357 
358     /**
359     * @dev Decrease the amount of tokens that an owner allowed to a spender.
360     *
361     * approve should be called when allowed[_spender] == 0. To decrement
362     * allowed value is better to use this function to avoid 2 calls (and wait until
363     * the first transaction is mined)
364     * From MonolithDAO Token.sol
365     * @param _spender The address which will spend the funds.
366     * @param _subtractedValue The amount of tokens to decrease the allowance by.
367     */
368     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
369         uint oldValue = allowed[msg.sender][_spender];
370         if (_subtractedValue > oldValue) {
371             allowed[msg.sender][_spender] = 0;
372         } else {
373             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374         }
375         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376         return true;
377     }
378 }
379 
380 /**
381  * @title Mintable token smart contract
382  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
383  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
384  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
385  * @author modification: Dmitriy Khizhinskiy @McFly.aero
386  * @dev Simple ERC20 Token example, with mintable token creation
387  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
388  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
389  */
390 contract MintableToken is StandardToken, Ownable {
391     event Mint(address indexed to, uint256 amount);
392     event MintFinished();
393 
394     bool public mintingFinished = false;
395 
396     modifier canMint() {
397         require(!mintingFinished);
398         _;
399     }
400 
401 
402     /**
403     * @dev Function to mint tokens
404     * @param _to The address that will receive the minted tokens.
405     * @param _amount The amount of tokens to mint.
406     * @return A boolean that indicates if the operation was successful.
407     */
408     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
409         totalSupply_ = totalSupply_.add(_amount);
410         balances[_to] = balances[_to].add(_amount);
411         Mint(_to, _amount);
412         Transfer(address(0), _to, _amount);
413         return true;
414     }
415 
416 
417     /**
418     * @dev Function to stop minting new tokens.
419     * @return True if the operation was successful.
420     */
421     function finishMinting() onlyOwner canMint public returns (bool) {
422         mintingFinished = true;
423         MintFinished();
424         return true;
425     }
426 }
427 
428 
429 /**
430  * @title McFly token smart contract
431  * @author Copyright (c) 2018 McFly.aero
432  * @author Dmitriy Khizhinskiy
433  * @author "MIT"
434  */
435 contract McFlyToken is MintableToken {
436     string public constant name = "McFlyToken";
437     string public constant symbol = "McFLY";
438     uint8 public constant decimals = 18;
439 
440     /// @dev mapping for whitelist
441     mapping(address=>bool) whitelist;
442 
443     /// @dev event throw when allowed to transfer address added to whitelist
444     /// @param from address
445     event AllowTransfer(address from);
446 
447     /// @dev check for allowence of transfer
448     modifier canTransfer() {
449         require(mintingFinished || whitelist[msg.sender]);
450         _;        
451     }
452 
453     /// @dev add address to whitelist
454     /// @param from address to add
455     function allowTransfer(address from) onlyOwner public {
456         whitelist[from] = true;
457         AllowTransfer(from);
458     }
459 
460     /// @dev Do the transfer from address to address value
461     /// @param from address from
462     /// @param to address to
463     /// @param value uint256
464     function transferFrom(address from, address to, uint256 value) canTransfer public returns (bool) {
465         return super.transferFrom(from, to, value);
466     }
467 
468     /// @dev Do the transfer from token address to "to" address value
469     /// @param to address to
470     /// @param value uint256 value
471     function transfer(address to, uint256 value) canTransfer public returns (bool) {
472         return super.transfer(to, value);
473     }
474 }
475 
476 
477 
478 
479 
480 
481 
482 /**
483  * @title Haltable smart contract - controls owner access
484  * @author Copyright (c) 2018 McFly.aero
485  * @author Dmitriy Khizhinskiy
486  * @author "MIT"
487  */
488 contract Haltable is MultiOwners {
489     bool public halted;
490 
491     modifier stopInEmergency {
492         require(!halted);
493         _;
494     }
495 
496 
497     modifier onlyInEmergency {
498         require(halted);
499         _;
500     }
501 
502 
503     /// @dev called by the owner on emergency, triggers stopped state
504     function halt() external onlyOwner {
505         halted = true;
506     }
507 
508 
509     /// @dev called by the owner on end of emergency, returns to normal state
510     function unhalt() external onlyOwner onlyInEmergency {
511         halted = false;
512     }
513 
514 }
515 
516 
517 
518 /**
519  * @title McFly crowdsale smart contract 
520  * @author Copyright (c) 2018 McFly.aero
521  * @author Dmitriy Khizhinskiy
522  * @author "MIT"
523  * @dev inherited from MultiOwners & Haltable
524  */
525 contract McFlyCrowd is MultiOwners, Haltable {
526     using SafeMath for uint256;
527 
528     /// @dev Total ETH received during WAVES, TLP1.2 & window[1-5]
529     uint256 public counter_in; // tlp2
530     
531     /// @dev minimum ETH to partisipate in window 1-5
532     uint256 public minETHin = 1e18; // 1 ETH
533 
534     /// @dev Token
535     McFlyToken public token;
536 
537     /// @dev Withdraw wallet
538     address public wallet;
539 
540     /// @dev start and end timestamp for TLP 1.2, other values callculated
541     uint256 public sT2; // startTimeTLP2
542     uint256 constant dTLP2 = 118 days; // days of TLP2
543     uint256 constant dBt = 60 days; // days between Windows
544     uint256 constant dW = 12 days; // 12 days for 3,4,5,6,7 windows;
545 
546     /// @dev Cap maximum possible tokens for minting
547     uint256 public constant hardCapInTokens = 1800e24; // 1,800,000,000 MFL
548 
549     /// @dev maximum possible tokens for sell 
550     uint256 public constant mintCapInTokens = 1260e24; // 1,260,000,000 MFL
551 
552     /// @dev tokens crowd within TLP2
553     uint256 public crowdTokensTLP2;
554 
555     uint256 public _preMcFly;
556 
557     /// @dev maximum possible tokens for fund minting
558     uint256 constant fundTokens = 270e24; // 270,000,000 MFL
559     uint256 public fundTotalSupply;
560     address public fundMintingAgent;
561 
562     /// @dev maximum possible tokens to convert from WAVES
563     uint256 constant wavesTokens = 100e24; // 100,000,000 MFL
564     address public wavesAgent;
565     address public wavesGW;
566 
567     /// @dev Vesting param for team, advisory, reserve.
568     uint256 constant VestingPeriodInSeconds = 30 days; // 24 month
569     uint256 constant VestingPeriodsCount = 24;
570 
571     /// @dev Team 10%
572     uint256 constant _teamTokens = 180e24;
573     uint256 public teamTotalSupply;
574     address public teamWallet;
575 
576     /// @dev Bounty 5% (2% + 3%)
577     /// @dev Bounty online 2%
578     uint256 constant _bountyOnlineTokens = 36e24;
579     address public bountyOnlineWallet;
580     address public bountyOnlineGW;
581 
582     /// @dev Bounty offline 3%
583     uint256 constant _bountyOfflineTokens = 54e24;
584     address public bountyOfflineWallet;
585 
586     /// @dev Advisory 5%
587     uint256 constant _advisoryTokens = 90e24;
588     uint256 public advisoryTotalSupply;
589     address public advisoryWallet;
590 
591     /// @dev Reserved for future 9%
592     uint256 constant _reservedTokens = 162e24;
593     uint256 public reservedTotalSupply;
594     address public reservedWallet;
595 
596     /// @dev AirDrop 1%
597     uint256 constant _airdropTokens = 18e24;
598     address public airdropWallet;
599     address public airdropGW;
600 
601     /// @dev PreMcFly wallet (MFL)
602     address public preMcFlyWallet;
603 
604     /// @dev Ppl structure for Win1-5
605     struct Ppl {
606         address addr;
607         uint256 amount;
608     }
609     mapping (uint32 => Ppl) public ppls;
610 
611     /// @dev Window structure for Win1-5
612     struct Window {
613         bool active;
614         uint256 totalEthInWindow;
615         uint32 totalTransCnt;
616         uint32 refundIndex;
617         uint256 tokenPerWindow;
618     } 
619     mapping (uint8 => Window) public ww;
620 
621 
622     /// @dev Events
623     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
624     event TokenPurchaseInWindow(address indexed beneficiary, uint256 value, uint8 winnum, uint32 totalcnt, uint256 totaleth1);
625     event TransferOddEther(address indexed beneficiary, uint256 value);
626     event FundMinting(address indexed beneficiary, uint256 value);
627     event WithdrawVesting(address indexed beneficiary, uint256 period, uint256 value, uint256 valueTotal);
628     event TokenWithdrawAtWindow(address indexed beneficiary, uint256 value);
629     event SetFundMintingAgent(address newAgent);
630     event SetTeamWallet(address newTeamWallet);
631     event SetAdvisoryWallet(address newAdvisoryWallet);
632     event SetReservedWallet(address newReservedWallet);
633     event SetStartTimeTLP2(uint256 newStartTimeTLP2);
634     event SetMinETHincome(uint256 newMinETHin);
635     event NewWindow(uint8 winNum, uint256 amountTokensPerWin);
636     event TokenETH(uint256 totalEth, uint32 totalCnt);
637 
638 
639     /// @dev check for Non zero value
640     modifier validPurchase() {
641         require(msg.value != 0);
642         _;        
643     }
644 
645 
646     /**
647      * @dev conctructor of contract, set main params, create new token, do minting for some wallets
648      * @param _startTimeTLP2 - set date time of starting of TLP2 (main date!)
649      * @param _preMcFlyTotalSupply - set amount in wei total supply of previouse contract (MFL)
650      * @param _wallet - wallet for transfer ETH to it
651      * @param _wavesAgent - wallet for WAVES gw
652      * @param _wavesGW    - wallet for WAVES gw
653      * @param _fundMintingAgent - wallet who allowed to mint before TLP2
654      * @param _teamWallet - wallet for team vesting
655      * @param _bountyOnlineWallet - wallet for online bounty
656      * @param _bountyOnlineGW - wallet for online bounty GW
657      * @param _bountyOfflineWallet - wallet for offline bounty
658      * @param _advisoryWallet - wallet for advisory vesting
659      * @param _reservedWallet - wallet for reserved vesting
660      * @param _airdropWallet - wallet for airdrop
661      * @param _airdropGW - wallet for airdrop GW
662      * @param _preMcFlyWallet - wallet for transfer old MFL->McFly (once)
663      */
664     function McFlyCrowd(
665         uint256 _startTimeTLP2,
666         uint256 _preMcFlyTotalSupply,
667         address _wallet,
668         address _wavesAgent,
669         address _wavesGW,
670         address _fundMintingAgent,
671         address _teamWallet,
672         address _bountyOnlineWallet,
673         address _bountyOnlineGW,
674         address _bountyOfflineWallet,
675         address _advisoryWallet,
676         address _reservedWallet,
677         address _airdropWallet,
678         address _airdropGW,
679         address _preMcFlyWallet
680     ) public 
681     {   
682         require(_startTimeTLP2 >= block.timestamp);
683         require(_preMcFlyTotalSupply > 0);
684         require(_wallet != 0x0);
685         require(_wavesAgent != 0x0);
686         require(_wavesGW != 0x0);
687         require(_fundMintingAgent != 0x0);
688         require(_teamWallet != 0x0);
689         require(_bountyOnlineWallet != 0x0);
690         require(_bountyOnlineGW != 0x0);
691         require(_bountyOfflineWallet != 0x0);
692         require(_advisoryWallet != 0x0);
693         require(_reservedWallet != 0x0);
694         require(_airdropWallet != 0x0);
695         require(_airdropGW != 0x0);
696         require(_preMcFlyWallet != 0x0);
697 
698         token = new McFlyToken();
699 
700         wallet = _wallet;
701 
702         sT2 = _startTimeTLP2;
703 
704         wavesAgent = _wavesAgent;
705         wavesGW = _wavesGW;
706 
707         fundMintingAgent = _fundMintingAgent;
708 
709         teamWallet = _teamWallet;
710         bountyOnlineWallet = _bountyOnlineWallet;
711         bountyOnlineGW = _bountyOnlineGW;
712         bountyOfflineWallet = _bountyOfflineWallet;
713         advisoryWallet = _advisoryWallet;
714         reservedWallet = _reservedWallet;
715         airdropWallet = _airdropWallet;
716         airdropGW = _airdropGW;
717         preMcFlyWallet = _preMcFlyWallet;
718 
719         /// @dev Mint all tokens and than control it by vesting
720         _preMcFly = _preMcFlyTotalSupply;
721         token.mint(preMcFlyWallet, _preMcFly); // McFly for thansfer to old MFL owners
722         token.allowTransfer(preMcFlyWallet);
723         crowdTokensTLP2 = crowdTokensTLP2.add(_preMcFly);
724 
725         token.mint(wavesAgent, wavesTokens); // 100,000,000 MFL
726         token.allowTransfer(wavesAgent);
727         token.allowTransfer(wavesGW);
728         crowdTokensTLP2 = crowdTokensTLP2.add(wavesTokens);
729 
730         token.mint(this, _teamTokens); // mint to contract address
731 
732         token.mint(bountyOnlineWallet, _bountyOnlineTokens);
733         token.allowTransfer(bountyOnlineWallet);
734         token.allowTransfer(bountyOnlineGW);
735 
736         token.mint(bountyOfflineWallet, _bountyOfflineTokens);
737         token.allowTransfer(bountyOfflineWallet);
738 
739         token.mint(this, _advisoryTokens);
740 
741         token.mint(this, _reservedTokens);
742 
743         token.mint(airdropWallet, _airdropTokens);
744         token.allowTransfer(airdropWallet);
745         token.allowTransfer(airdropGW);
746     }
747 
748 
749     /**
750      * @dev check is TLP2 is active?
751      * @return false if crowd TLP2 event was ended
752      */
753     function withinPeriod() constant public returns (bool) {
754         return (now >= sT2 && now <= (sT2+dTLP2));
755     }
756 
757 
758     /**
759      * @dev check is TLP2 is active and minting Not finished
760      * @return false if crowd event was ended
761      */
762     function running() constant public returns (bool) {
763         return withinPeriod() && !token.mintingFinished();
764     }
765 
766 
767     /**
768      * @dev check current stage name
769      * @return uint8 stage number
770      */
771     function stageName() constant public returns (uint8) {
772         uint256 eT2 = sT2+dTLP2;
773 
774         if (now < sT2) {return 101;} // not started
775         if (now >= sT2 && now <= eT2) {return (102);} // TLP1.2
776 
777         if (now > eT2 && now < eT2+dBt) {return (103);} // preTLP1.3
778         if (now >= (eT2+dBt) && now <= (eT2+dBt+dW)) {return (0);} // TLP1.3
779         if (now > (eT2+dBt+dW) && now < (eT2+dBt+dW+dBt)) {return (104);} // preTLP1.4
780         if (now >= (eT2+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW)) {return (1);} // TLP1.4
781         if (now > (eT2+dBt+dW+dBt+dW) && now < (eT2+dBt+dW+dBt+dW+dBt)) {return (105);} // preTLP1.5
782         if (now >= (eT2+dBt+dW+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW+dBt+dW)) {return (2);} // TLP1.5
783         if (now > (eT2+dBt+dW+dBt+dW+dBt+dW) && now < (eT2+dBt+dW+dBt+dW+dBt+dW+dBt)) {return (106);} // preTLP1.6
784         if (now >= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW)) {return (3);} // TLP1.6
785         if (now > (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW) && now < (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt)) {return (107);} // preTLP1.7
786         if (now >= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt+dW)) {return (4);} // TLP1.7"
787         if (now > (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt+dW)) {return (200);} // Finished
788         return (201); // unknown
789     }
790 
791 
792     /** 
793      * @dev change agent for minting
794      * @param agent - new agent address
795      */
796     function setFundMintingAgent(address agent) onlyOwner public {
797         fundMintingAgent = agent;
798         SetFundMintingAgent(agent);
799     }
800 
801 
802     /** 
803      * @dev change wallet for team vesting (this make possible to set smart-contract address later)
804      * @param _newTeamWallet - new wallet address
805      */
806     function setTeamWallet(address _newTeamWallet) onlyOwner public {
807         teamWallet = _newTeamWallet;
808         SetTeamWallet(_newTeamWallet);
809     }
810 
811 
812     /** 
813      * @dev change wallet for advisory vesting (this make possible to set smart-contract address later)
814      * @param _newAdvisoryWallet - new wallet address
815      */
816     function setAdvisoryWallet(address _newAdvisoryWallet) onlyOwner public {
817         advisoryWallet = _newAdvisoryWallet;
818         SetAdvisoryWallet(_newAdvisoryWallet);
819     }
820 
821 
822     /** 
823      * @dev change wallet for reserved vesting (this make possible to set smart-contract address later)
824      * @param _newReservedWallet - new wallet address
825      */
826     function setReservedWallet(address _newReservedWallet) onlyOwner public {
827         reservedWallet = _newReservedWallet;
828         SetReservedWallet(_newReservedWallet);
829     }
830 
831 
832     /**
833      * @dev change min ETH income during Window1-5
834      * @param _minETHin - new limit
835      */
836     function setMinETHin(uint256 _minETHin) onlyOwner public {
837         minETHin = _minETHin;
838         SetMinETHincome(_minETHin);
839     }
840 
841 
842     /**
843      * @dev set TLP1.X (2-7) start & end dates
844      * @param _at - new or old start date
845      */
846     function setStartEndTimeTLP(uint256 _at) onlyOwner public {
847         require(block.timestamp < sT2); // forbid change time when TLP1.2 is active
848         require(block.timestamp < _at); // should be great than current block timestamp
849 
850         sT2 = _at;
851         SetStartTimeTLP2(_at);
852     }
853 
854 
855     /**
856      * @dev Large Token Holder minting 
857      * @param to - mint to address
858      * @param amount - how much mint
859      */
860     function fundMinting(address to, uint256 amount) stopInEmergency public {
861         require(msg.sender == fundMintingAgent || isOwner());
862         require(block.timestamp < sT2);
863         require(fundTotalSupply.add(amount) <= fundTokens);
864         require(token.totalSupply().add(amount) <= hardCapInTokens);
865 
866         fundTotalSupply = fundTotalSupply.add(amount);
867         token.mint(to, amount);
868         FundMinting(to, amount);
869     }
870 
871 
872     /**
873      * @dev calculate amount
874      * @param  amount - ether to be converted to tokens
875      * @param  at - current time
876      * @param  _totalSupply - total supplied tokens
877      * @return tokens amount that we should send to our dear ppl
878      * @return odd ethers amount, which contract should send back
879      */
880     function calcAmountAt(
881         uint256 amount,
882         uint256 at,
883         uint256 _totalSupply
884     ) public constant returns (uint256, uint256) 
885     {
886         uint256 estimate;
887         uint256 price;
888         
889         if (at >= sT2 && at <= (sT2+dTLP2)) {
890             if (at <= sT2 + 15 days) {price = 12e13;} else if (at <= sT2 + 30 days) {
891                 price = 14e13;} else if (at <= sT2 + 45 days) {
892                     price = 16e13;} else if (at <= sT2 + 60 days) {
893                         price = 18e13;} else if (at <= sT2 + 75 days) {
894                             price = 20e13;} else if (at <= sT2 + 90 days) {
895                                 price = 22e13;} else if (at <= sT2 + 105 days) {
896                                     price = 24e13;} else if (at <= sT2 + 118 days) {
897                                         price = 26e13;} else {revert();}
898         } else {revert();}
899 
900         estimate = _totalSupply.add(amount.mul(1e18).div(price));
901 
902         if (estimate > hardCapInTokens) {
903             return (
904                 hardCapInTokens.sub(_totalSupply),
905                 estimate.sub(hardCapInTokens).mul(price).div(1e18)
906             );
907         }
908         return (estimate.sub(_totalSupply), 0);
909     }
910 
911 
912     /**
913      * @dev fallback for processing ether
914      */
915     function() external payable {
916         return getTokens(msg.sender);
917     }
918 
919 
920     /**
921      * @dev sell token and send to contributor address
922      * @param contributor address
923      */
924     function getTokens(address contributor) payable stopInEmergency validPurchase public {
925         uint256 amount;
926         uint256 oddEthers;
927         uint256 ethers;
928         uint256 _at;
929         uint8 _winNum;
930 
931         _at = block.timestamp;
932 
933         require(contributor != 0x0);
934        
935         if (withinPeriod()) {
936         
937             (amount, oddEthers) = calcAmountAt(msg.value, _at, token.totalSupply());
938   
939             require(amount.add(token.totalSupply()) <= hardCapInTokens);
940 
941             ethers = msg.value.sub(oddEthers);
942 
943             token.mint(contributor, amount); // fail if minting is finished
944             TokenPurchase(contributor, ethers, amount);
945             counter_in = counter_in.add(ethers);
946             crowdTokensTLP2 = crowdTokensTLP2.add(amount);
947 
948             if (oddEthers > 0) {
949                 require(oddEthers < msg.value);
950                 contributor.transfer(oddEthers);
951                 TransferOddEther(contributor, oddEthers);
952             }
953 
954             wallet.transfer(ethers);
955         } else {
956             require(msg.value >= minETHin); // checks min ETH income
957             _winNum = stageName();
958             require(_winNum >= 0 && _winNum < 5);
959             Window storage w = ww[_winNum];
960 
961             require(w.tokenPerWindow > 0); // check that we have tokens!
962 
963             w.totalEthInWindow = w.totalEthInWindow.add(msg.value);
964             ppls[w.totalTransCnt].addr = contributor;
965             ppls[w.totalTransCnt].amount = msg.value;
966             w.totalTransCnt++;
967             TokenPurchaseInWindow(contributor, msg.value, _winNum, w.totalTransCnt, w.totalEthInWindow);
968         }
969     }
970 
971 
972     /**
973      * @dev close Window and transfer Eth to wallet address
974      * @param _winNum - number of window 0-4 to close
975      */
976     function closeWindow(uint8 _winNum) onlyOwner stopInEmergency public {
977         require(ww[_winNum].active);
978         ww[_winNum].active = false;
979 
980         wallet.transfer(this.balance);
981     }
982 
983 
984     /**
985      * @dev transfer tokens to ppl accts (window1-5)
986      * @param _winNum - number of window 0-4 to close
987      */
988     function sendTokensWindow(uint8 _winNum) onlyOwner stopInEmergency public {
989         uint256 _tokenPerETH;
990         uint256 _tokenToSend = 0;
991         address _tempAddr;
992         uint32 index = ww[_winNum].refundIndex;
993 
994         TokenETH(ww[_winNum].totalEthInWindow, ww[_winNum].totalTransCnt);
995 
996         require(ww[_winNum].active);
997         require(ww[_winNum].totalEthInWindow > 0);
998         require(ww[_winNum].totalTransCnt > 0);
999 
1000         _tokenPerETH = ww[_winNum].tokenPerWindow.div(ww[_winNum].totalEthInWindow); // max McFly in window / ethInWindow
1001 
1002         while (index < ww[_winNum].totalTransCnt && msg.gas > 100000) {
1003             _tokenToSend = _tokenPerETH.mul(ppls[index].amount);
1004             ppls[index].amount = 0;
1005             _tempAddr = ppls[index].addr;
1006             ppls[index].addr = 0;
1007             index++;
1008             token.transfer(_tempAddr, _tokenToSend);
1009             TokenWithdrawAtWindow(_tempAddr, _tokenToSend);
1010         }
1011         ww[_winNum].refundIndex = index;
1012     }
1013 
1014 
1015     /**
1016      * @dev open new window 0-5 and write totl token per window in structure
1017      * @param _winNum - number of window 0-4 to close
1018      * @param _tokenPerWindow - total token for window 0-4
1019      */
1020     function newWindow(uint8 _winNum, uint256 _tokenPerWindow) private {
1021         ww[_winNum] = Window(true, 0, 0, 0, _tokenPerWindow);
1022         NewWindow(_winNum, _tokenPerWindow);
1023     }
1024 
1025 
1026     /**
1027      * @dev Finish crowdsale TLP1.2 period and open window1-5 crowdsale
1028      */
1029     function finishCrowd() onlyOwner public {
1030         uint256 _tokenPerWindow;
1031         require(now > (sT2.add(dTLP2)) || hardCapInTokens == token.totalSupply());
1032         require(!token.mintingFinished());
1033 
1034         _tokenPerWindow = (mintCapInTokens.sub(crowdTokensTLP2).sub(fundTotalSupply)).div(5);
1035         token.mint(this, _tokenPerWindow.mul(5)); // mint to contract address
1036         // shoud be MAX tokens minted!!! 1,800,000,000
1037         for (uint8 y = 0; y < 5; y++) {
1038             newWindow(y, _tokenPerWindow);
1039         }
1040 
1041         token.finishMinting();
1042     }
1043 
1044 
1045     /**
1046      * @dev withdraw tokens amount within vesting rules for team, advisory and reserved
1047      * @param withdrawWallet - wallet to transfer tokens
1048      * @param withdrawTokens - amount of tokens to transfer to
1049      * @param withdrawTotalSupply - total amount of tokens transfered to account
1050      * @return unit256 total amount of tokens after transfer
1051      */
1052     function vestingWithdraw(address withdrawWallet, uint256 withdrawTokens, uint256 withdrawTotalSupply) private returns (uint256) {
1053         require(token.mintingFinished());
1054         require(msg.sender == withdrawWallet || isOwner());
1055 
1056         uint256 currentPeriod = (block.timestamp.sub(sT2.add(dTLP2))).div(VestingPeriodInSeconds);
1057         if (currentPeriod > VestingPeriodsCount) {
1058             currentPeriod = VestingPeriodsCount;
1059         }
1060         uint256 tokenAvailable = withdrawTokens.mul(currentPeriod).div(VestingPeriodsCount).sub(withdrawTotalSupply);  // RECHECK!!!!!
1061 
1062         require((withdrawTotalSupply.add(tokenAvailable)) <= withdrawTokens);
1063 
1064         uint256 _withdrawTotalSupply = withdrawTotalSupply.add(tokenAvailable);
1065 
1066         token.transfer(withdrawWallet, tokenAvailable);
1067         WithdrawVesting(withdrawWallet, currentPeriod, tokenAvailable, _withdrawTotalSupply);
1068 
1069         return _withdrawTotalSupply;
1070     }
1071 
1072 
1073     /**
1074      * @dev withdraw tokens amount within vesting rules for team
1075      */
1076     function teamWithdraw() public {
1077         teamTotalSupply = vestingWithdraw(teamWallet, _teamTokens, teamTotalSupply);
1078     }
1079 
1080 
1081     /**
1082      * @dev withdraw tokens amount within vesting rules for advisory
1083      */
1084     function advisoryWithdraw() public {
1085         advisoryTotalSupply = vestingWithdraw(advisoryWallet, _advisoryTokens, advisoryTotalSupply);
1086     }
1087 
1088 
1089     /**
1090      * @dev withdraw tokens amount within vesting rules for reserved wallet
1091      */
1092     function reservedWithdraw() public {
1093         reservedTotalSupply = vestingWithdraw(reservedWallet, _reservedTokens, reservedTotalSupply);
1094     }
1095 }