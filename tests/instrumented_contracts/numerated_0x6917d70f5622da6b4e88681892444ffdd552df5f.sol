1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20 Basic smart contract
5  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
6  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
10  * @author modification: Dmitriy Khizhinskiy @McFly.aero
11  */
12 contract ERC20Basic {
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address who) public view returns (uint256);
15     function transfer(address to, uint256 value) public returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title LengthValidator smart contract - fix ERC20 short address attack
21  * @author Copyright (c) 2018 McFly.aero
22  * @author Dmitriy Khizhinskiy
23  * @author "MIT"
24  */
25 contract LengthValidator {
26     modifier valid_short(uint _cntArgs) {
27         assert(msg.data.length == (_cntArgs * 32 + 4));
28         _;
29     }
30 }
31 
32 /**
33  * @title Ownable smart contract
34  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
35  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
36  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
37  * @author modification: Dmitriy Khizhinskiy @McFly.aero
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43     address public candidate;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49     * account.
50     */
51     function Ownable() public {
52         owner = msg.sender;
53     }
54 
55 
56     /**
57     * @dev Throws if called by any account other than the owner.
58     */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64 
65     /**
66     * @dev Allows the current owner to _request_ transfer control of the contract to a newOwner.
67     * @param newOwner The address to transfer ownership to.
68     */
69     function requestOwnership(address newOwner) onlyOwner public {
70         require(newOwner != address(0));
71         candidate = newOwner;
72     }
73 
74 
75     /**
76     * @dev Allows the _NEW_ candidate to complete transfer control of the contract to him.
77     */
78     function confirmOwnership() public {
79         require(candidate == msg.sender);
80         owner = candidate;
81         OwnershipTransferred(owner, candidate);        
82     }
83 }
84 
85 
86 /**
87  * @title MultiOwners smart contract
88  * @author Copyright (c) 2018 McFly.aero
89  * @author Dmitriy Khizhinskiy
90  * @author "MIT"
91  */
92 contract MultiOwners {
93 
94     event AccessGrant(address indexed owner);
95     event AccessRevoke(address indexed owner);
96     
97     mapping(address => bool) owners;
98     address public publisher;
99 
100 
101     function MultiOwners() public {
102         owners[msg.sender] = true;
103         publisher = msg.sender;
104     }
105 
106 
107     modifier onlyOwner() { 
108         require(owners[msg.sender] == true);
109         _; 
110     }
111 
112 
113     function isOwner() constant public returns (bool) {
114         return owners[msg.sender] ? true : false;
115     }
116 
117 
118     function checkOwner(address maybe_owner) constant public returns (bool) {
119         return owners[maybe_owner] ? true : false;
120     }
121 
122 
123     function grant(address _owner) onlyOwner public {
124         owners[_owner] = true;
125         AccessGrant(_owner);
126     }
127 
128 
129     function revoke(address _owner) onlyOwner public {
130         require(_owner != publisher);
131         require(msg.sender != _owner);
132 
133         owners[_owner] = false;
134         AccessRevoke(_owner);
135     }
136 }
137 
138 
139 
140 
141 /**
142  * @title SafeMath
143  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
144  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
145  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
146  * @dev Math operations with safety checks that throw on error
147  */
148 library SafeMath {
149     /**
150     * @dev Multiplies two numbers, throws on overflow.
151     */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         if (a == 0) {
154             return 0;
155         }
156         uint256 c = a * b;
157         assert(c / a == b);
158         return c;
159     }
160 
161 
162     /**
163     * @dev Integer division of two numbers, truncating the quotient.
164     */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         // assert(b > 0); // Solidity automatically throws when dividing by 0
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169         return c;
170     }
171 
172 
173     /**
174     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
175     */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         assert(b <= a);
178         return a - b;
179     }
180 
181 
182     /**
183     * @dev Adds two numbers, throws on overflow.
184     */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a + b;
187         assert(c >= a);
188         return c;
189     }
190 }
191 
192 
193 
194 
195 
196 
197 
198 
199 
200 
201 
202 /**
203  * @title BasicToken smart contract
204  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
205  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
206  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
207  * @author modification: Dmitriy Khizhinskiy @McFly.aero
208  */
209 
210 
211 
212 
213 
214 
215 /**
216  * @title Basic token
217  * @dev Basic version of StandardToken, with no allowances.
218  */
219 contract BasicToken is ERC20Basic, LengthValidator {
220     using SafeMath for uint256;
221 
222     mapping(address => uint256) balances;
223 
224     uint256 totalSupply_;
225 
226     /**
227     * @dev total number of tokens in existence
228     */
229     function totalSupply() public view returns (uint256) {
230         return totalSupply_;
231     }
232 
233 
234     /**
235     * @dev transfer token for a specified address
236     * @param _to The address to transfer to.
237     * @param _value The amount to be transferred.
238     */
239     function transfer(address _to, uint256 _value) valid_short(2) public returns (bool) {
240         require(_to != address(0));
241         require(_value <= balances[msg.sender]);
242 
243         // SafeMath.sub will throw if there is not enough balance.
244         balances[msg.sender] = balances[msg.sender].sub(_value);
245         balances[_to] = balances[_to].add(_value);
246         Transfer(msg.sender, _to, _value);
247         return true;
248     }
249 
250 
251     /**
252     * @dev Gets the balance of the specified address.
253     * @param _owner The address to query the the balance of.
254     * @return An uint256 representing the amount owned by the passed address.
255     */
256     function balanceOf(address _owner) public view returns (uint256 balance) {
257         return balances[_owner];
258     }
259 
260 }
261 
262 
263 /**
264  * @title ERC20 smart contract
265  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
266  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
267  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
268  * @author modification: Dmitriy Khizhinskiy @McFly.aero
269  */
270 
271 
272 
273 
274 /**
275  * @title ERC20 interface
276  * @dev see https://github.com/ethereum/EIPs/issues/20
277  */
278 contract ERC20 is ERC20Basic {
279     function allowance(address owner, address spender) public view returns (uint256);
280     function transferFrom(address from, address to, uint256 value) public returns (bool);
281     function approve(address spender, uint256 value) public returns (bool);
282     event Approval(address indexed owner, address indexed spender, uint256 value);
283 }
284 
285 /**
286  * @title Standard ERC20 token
287  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
288  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
289  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
290  * @author modification: Dmitriy Khizhinskiy @McFly.aero
291  * @dev Implementation of the basic standard token.
292  * @dev https://github.com/ethereum/EIPs/issues/20
293  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
294  */
295 contract StandardToken is ERC20, BasicToken {
296 
297     mapping (address => mapping (address => uint256)) internal allowed;
298   
299     /** 
300     * @dev Transfer tokens from one address to another
301     * @param _from address The address which you want to send tokens from
302     * @param _to address The address which you want to transfer to
303     * @param _value uint256 the amount of tokens to be transferred
304     */
305     function transferFrom(address _from, address _to, uint256 _value) valid_short(3) public returns (bool) {
306         require(_to != address(0));
307         require(_value <= balances[_from]);
308         require(_value <= allowed[_from][msg.sender]);
309 
310         balances[_from] = balances[_from].sub(_value);
311         balances[_to] = balances[_to].add(_value);
312         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
313         Transfer(_from, _to, _value);
314         return true;
315     }
316 
317 
318     /**
319     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
320     *
321     * Beware that changing an allowance with this method brings the risk that someone may use both the old
322     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
323     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
324     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325     * @param _spender The address which will spend the funds.
326     * @param _value The amount of tokens to be spent.
327     */
328     function approve(address _spender, uint256 _value) valid_short(2) public returns (bool) {
329         allowed[msg.sender][_spender] = _value;
330         Approval(msg.sender, _spender, _value);
331         return true;
332     }
333 
334 
335     /**
336     * @dev Function to check the amount of tokens that an owner allowed to a spender.
337     * @param _owner address The address which owns the funds.
338     * @param _spender address The address which will spend the funds.
339     * @return A uint256 specifying the amount of tokens still available for the spender.
340     */
341     function allowance(address _owner, address _spender) public view returns (uint256) {
342         return allowed[_owner][_spender];
343     }
344 
345 
346     /**
347     * @dev Increase the amount of tokens that an owner allowed to a spender.
348     *
349     * approve should be called when allowed[_spender] == 0. To increment
350     * allowed value is better to use this function to avoid 2 calls (and wait until
351     * the first transaction is mined)
352     * From MonolithDAO Token.sol
353     * @param _spender The address which will spend the funds.
354     * @param _addedValue The amount of tokens to increase the allowance by.
355     */
356     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
357         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
358         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359         return true;
360     }
361 
362 
363     /**
364     * @dev Decrease the amount of tokens that an owner allowed to a spender.
365     *
366     * approve should be called when allowed[_spender] == 0. To decrement
367     * allowed value is better to use this function to avoid 2 calls (and wait until
368     * the first transaction is mined)
369     * From MonolithDAO Token.sol
370     * @param _spender The address which will spend the funds.
371     * @param _subtractedValue The amount of tokens to decrease the allowance by.
372     */
373     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
374         uint oldValue = allowed[msg.sender][_spender];
375         if (_subtractedValue > oldValue) {
376             allowed[msg.sender][_spender] = 0;
377         } else {
378             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
379         }
380         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381         return true;
382     }
383 }
384 
385 
386 /**
387  * @title Mintable token smart contract
388  * @author Copyright (c) 2016 Smart Contract Solutions, Inc.
389  * @author "Manuel Araoz <manuelaraoz@gmail.com>"
390  * @dev license: "MIT", source: https://github.com/OpenZeppelin/zeppelin-solidity
391  * @author modification: Dmitriy Khizhinskiy @McFly.aero
392  * @dev Simple ERC20 Token example, with mintable token creation
393  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
394  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
395  */
396 contract MintableToken is StandardToken, Ownable {
397     event Mint(address indexed to, uint256 amount);
398     event MintFinished();
399 
400     bool public mintingFinished = false;
401 
402     modifier canMint() {
403         require(!mintingFinished);
404         _;
405     }
406 
407 
408     /**
409     * @dev Function to mint tokens
410     * @param _to The address that will receive the minted tokens.
411     * @param _amount The amount of tokens to mint.
412     * @return A boolean that indicates if the operation was successful.
413     */
414     function mint(address _to, uint256 _amount) onlyOwner canMint valid_short(2) public returns (bool) {
415         totalSupply_ = totalSupply_.add(_amount);
416         balances[_to] = balances[_to].add(_amount);
417         Mint(_to, _amount);
418         Transfer(address(0), _to, _amount);
419         return true;
420     }
421 
422 
423     /**
424     * @dev Function to stop minting new tokens.
425     * @return True if the operation was successful.
426     */
427     function finishMinting() onlyOwner canMint public returns (bool) {
428         mintingFinished = true;
429         MintFinished();
430         return true;
431     }
432 }
433 
434 
435 /**
436  * @title McFly token smart contract
437  * @author Copyright (c) 2018 McFly.aero
438  * @author Dmitriy Khizhinskiy
439  * @author "MIT"
440  */
441 contract McFlyToken is MintableToken {
442     string public constant name = "McFlyToken";
443     string public constant symbol = "McFly";
444     uint8 public constant decimals = 18;
445 
446     /// @dev mapping for whitelist
447     mapping(address=>bool) whitelist;
448 
449     /// @dev event throw when allowed to transfer address added to whitelist
450     /// @param from address
451     event AllowTransfer(address from);
452 
453     /// @dev check for allowence of transfer
454     modifier canTransfer() {
455         require(mintingFinished || whitelist[msg.sender]);
456         _;        
457     }
458 
459     /// @dev add address to whitelist
460     /// @param from address to add
461     function allowTransfer(address from) onlyOwner public {
462         whitelist[from] = true;
463         AllowTransfer(from);
464     }
465 
466     /// @dev Do the transfer from address to address value
467     /// @param from address from
468     /// @param to address to
469     /// @param value uint256
470     function transferFrom(address from, address to, uint256 value) canTransfer public returns (bool) {
471         return super.transferFrom(from, to, value);
472     }
473 
474     /// @dev Do the transfer from token address to "to" address value
475     /// @param to address to
476     /// @param value uint256 value
477     function transfer(address to, uint256 value) canTransfer public returns (bool) {
478         return super.transfer(to, value);
479     }
480 }
481 
482 
483 
484 
485 
486 
487 
488 /**
489  * @title Haltable smart contract - controls owner access
490  * @author Copyright (c) 2018 McFly.aero
491  * @author Dmitriy Khizhinskiy
492  * @author "MIT"
493  */
494 contract Haltable is MultiOwners {
495     bool public halted;
496 
497     modifier stopInEmergency {
498         require(!halted);
499         _;
500     }
501 
502 
503     modifier onlyInEmergency {
504         require(halted);
505         _;
506     }
507 
508 
509     /// @dev called by the owner on emergency, triggers stopped state
510     function halt() external onlyOwner {
511         halted = true;
512     }
513 
514 
515     /// @dev called by the owner on end of emergency, returns to normal state
516     function unhalt() external onlyOwner onlyInEmergency {
517         halted = false;
518     }
519 
520 }
521 
522 
523 
524 /**
525  * @title McFly crowdsale smart contract
526  * @author Copyright (c) 2018 McFly.aero
527  * @author Dmitriy Khizhinskiy
528  * @author "MIT"
529  * @dev inherited from MultiOwners & Haltable
530  */
531 contract McFlyCrowd is MultiOwners, Haltable {
532     using SafeMath for uint256;
533 
534     /// @dev Total ETH received during WAVES, TLP1.2 & window[1-5]
535     uint256 public counter_in; // tlp2
536     
537     /// @dev minimum ETH to partisipate in window 1-5
538     uint256 public minETHin = 1e18; // 1 ETH
539 
540     /// @dev Token
541     McFlyToken public token;
542 
543     /// @dev Withdraw wallet
544     address public wallet;
545 
546     /// @dev start and end timestamp for TLP 1.2, other values callculated
547     uint256 public sT2; // startTimeTLP2
548     uint256 constant dTLP2 = 118 days; // days of TLP2
549     uint256 constant dBt = 60 days; // days between Windows
550     uint256 constant dW = 12 days; // 12 days for 3,4,5,6,7 windows;
551 
552     /// @dev Cap maximum possible tokens for minting
553     uint256 public constant hardCapInTokens = 1800e24; // 1,800,000,000 MFL
554 
555     /// @dev maximum possible tokens for sell 
556     uint256 public constant mintCapInTokens = 1260e24; // 1,260,000,000 MFL
557 
558     /// @dev tokens crowd within TLP2
559     uint256 public crowdTokensTLP2;
560 
561     /// @dev tokens crowd before this contract (MFL tokens)
562     uint256 preMcFlyTotalSupply;
563 
564     /// @dev maximum possible tokens for fund minting
565     uint256 constant fundTokens = 270e24; // 270,000,000 MFL
566     uint256 public fundTotalSupply;
567     address public fundMintingAgent;
568                                                           
569     /// @dev maximum possible tokens to convert from WAVES
570     uint256 wavesTokens = 100e24; // 100,000,000 MFL
571     address public wavesAgent;
572     address public wavesGW;
573 
574     /// @dev Vesting param for team, advisory, reserve.
575     uint256 VestingPeriodInSeconds = 30 days; // 24 month
576     uint256 VestingPeriodsCount = 24;
577 
578     /// @dev Team 10%
579     uint256 _teamTokens;
580     uint256 public teamTotalSupply;
581     address public teamWallet;
582 
583     /// @dev Bounty 5% (2% + 3%)
584     /// @dev Bounty online 2%
585     uint256 _bountyOnlineTokens;
586     address public bountyOnlineWallet;
587     address public bountyOnlineGW;
588 
589     /// @dev Bounty offline 3%
590     uint256 _bountyOfflineTokens;
591     address public bountyOfflineWallet;
592 
593     /// @dev Advisory 5%
594     uint256 _advisoryTokens;
595     uint256 public advisoryTotalSupply;
596     address public advisoryWallet;
597 
598     /// @dev Reserved for future 9%
599     uint256 _reservedTokens;
600     uint256 public reservedTotalSupply;
601     address public reservedWallet;
602 
603     /// @dev AirDrop 1%
604     uint256 _airdropTokens;
605     address public airdropWallet;
606     address public airdropGW;
607 
608     /// @dev PreMcFly wallet (MFL)
609     uint256 _preMcFlyTokens;
610     address public preMcFlyWallet;
611 
612     /// @dev Ppl structure for Win1-5
613     struct Ppl {
614         address addr;
615         uint256 amount;
616     }
617     mapping (uint32 => Ppl) public ppls;
618 
619     /// @dev Window structure for Win1-5
620     struct Window {
621         bool active;
622         uint256 totalEthInWindow;
623         uint32 totalTransCnt;
624         uint32 refundIndex;
625         uint256 tokenPerWindow;
626     } 
627     mapping (uint8 => Window) public ww;
628 
629 
630     /// @dev Events
631     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
632     event TokenPurchaseInWindow(address indexed beneficiary, uint256 value, uint8 winnum, uint32 totalcnt, uint256 totaleth1);
633     event TransferOddEther(address indexed beneficiary, uint256 value);
634     event FundMinting(address indexed beneficiary, uint256 value);
635     event WithdrawVesting(address indexed beneficiary, uint256 period, uint256 value, uint256 valueTotal);
636     event TokenWithdrawAtWindow(address indexed beneficiary, uint256 value);
637     event SetFundMintingAgent(address newAgent);
638     event SetTeamWallet(address newTeamWallet);
639     event SetAdvisoryWallet(address newAdvisoryWallet);
640     event SetReservedWallet(address newReservedWallet);
641     event SetStartTimeTLP2(uint256 newStartTimeTLP2);
642     event SetMinETHincome(uint256 newMinETHin);
643     event NewWindow(uint8 winNum, uint256 amountTokensPerWin);
644     event TokenETH(uint256 totalEth, uint32 totalCnt);
645 
646 
647     /// @dev check for Non zero value
648     modifier validPurchase() {
649         bool nonZeroPurchase = msg.value != 0;
650         require(nonZeroPurchase);
651         _;        
652     }
653 
654     // comment this functions after test passed !!
655     /*function getPpls(uint32 index) constant public returns (uint256) {
656         return (ppls[index].amount);
657     }
658     function getPplsAddr(uint32 index) constant public returns (address) {
659         return (ppls[index].addr);
660     }
661     function getWtotalEth(uint8 winNum) constant public returns (uint256) {
662         return (ww[winNum].totalEthInWindow);
663     }
664     function getWtoken(uint8 winNum) constant public returns (uint256) {
665         return (ww[winNum].tokenPerWindow);
666     }
667     function getWactive(uint8 winNum) constant public returns (bool) {
668         return (ww[winNum].active);
669     }
670     function getWtotalTransCnt(uint8 winNum) constant public returns (uint32) {
671         return (ww[winNum].totalTransCnt);
672     }
673     function getWrefundIndex(uint8 winNum) constant public returns (uint32) {
674         return (ww[winNum].refundIndex);
675     }*/
676     // END comment this functions after test passed !!
677 
678 
679     /**
680      * @dev conctructor of contract, set main params, create new token, do minting for some wallets
681      * @param _startTimeTLP2 - set date time of starting of TLP2 (main date!)
682      * @param _preMcFlyTotalSupply - set amount in wei total supply of previouse contract (MFL)
683      * @param _wallet - wallet for transfer ETH to it
684      * @param _wavesAgent - wallet for WAVES gw
685      * @param _wavesGW    - wallet for WAVES gw
686      * @param _fundMintingAgent - wallet who allowed to mint before TLP2
687      * @param _teamWallet - wallet for team vesting
688      * @param _bountyOnlineWallet - wallet for online bounty
689      * @param _bountyOnlineGW - wallet for online bounty GW
690      * @param _bountyOfflineWallet - wallet for offline bounty
691      * @param _advisoryWallet - wallet for advisory vesting
692      * @param _reservedWallet - wallet for reserved vesting
693      * @param _airdropWallet - wallet for airdrop
694      * @param _airdropGW - wallet for airdrop GW
695      * @param _preMcFlyWallet - wallet for transfer old MFL->McFly (once)
696      */
697     function McFlyCrowd(
698         uint256 _startTimeTLP2,
699         uint256 _preMcFlyTotalSupply,
700         address _wallet,
701         address _wavesAgent,
702         address _wavesGW,
703         address _fundMintingAgent,
704         address _teamWallet,
705         address _bountyOnlineWallet,
706         address _bountyOnlineGW,
707         address _bountyOfflineWallet,
708         address _advisoryWallet,
709         address _reservedWallet,
710         address _airdropWallet,
711         address _airdropGW,
712         address _preMcFlyWallet
713     ) public 
714     {   
715         require(_startTimeTLP2 >= block.timestamp);
716         require(_preMcFlyTotalSupply > 0);
717         require(_wallet != 0x0);
718         require(_wavesAgent != 0x0);
719         require(_wavesGW != 0x0);
720         require(_fundMintingAgent != 0x0);
721         require(_teamWallet != 0x0);
722         require(_bountyOnlineWallet != 0x0);
723         require(_bountyOnlineGW != 0x0);
724         require(_bountyOfflineWallet != 0x0);
725         require(_advisoryWallet != 0x0);
726         require(_reservedWallet != 0x0);
727         require(_airdropWallet != 0x0);
728         require(_airdropGW != 0x0);
729         require(_preMcFlyWallet != 0x0);
730 
731         token = new McFlyToken();
732 
733         wallet = _wallet;
734 
735         sT2 = _startTimeTLP2;
736         setStartEndTimeTLP(_startTimeTLP2);
737 
738         wavesAgent = _wavesAgent;
739         wavesGW = _wavesGW;
740 
741         fundMintingAgent = _fundMintingAgent;
742 
743         teamWallet = _teamWallet;
744         bountyOnlineWallet = _bountyOnlineWallet;
745         bountyOnlineGW = _bountyOnlineGW;
746         bountyOfflineWallet = _bountyOfflineWallet;
747         advisoryWallet = _advisoryWallet;
748         reservedWallet = _reservedWallet;
749         airdropWallet = _airdropWallet;
750         airdropGW = _airdropGW;
751         preMcFlyWallet = _preMcFlyWallet;
752 
753         /// @dev Mint all tokens and than control it by vesting
754         _preMcFlyTokens = _preMcFlyTotalSupply; // McFly for thansfer to old MFL owners
755         token.mint(preMcFlyWallet, _preMcFlyTokens);
756         token.allowTransfer(preMcFlyWallet);
757         crowdTokensTLP2 = crowdTokensTLP2.add(_preMcFlyTokens);
758 
759         token.mint(wavesAgent, wavesTokens); // 100,000,000 MFL
760         token.allowTransfer(wavesAgent);
761         token.allowTransfer(wavesGW);
762         crowdTokensTLP2 = crowdTokensTLP2.add(wavesTokens);
763 
764         _teamTokens = 180e24; // 180,000,000 MFL
765         token.mint(this, _teamTokens); // mint to contract address
766 
767         _bountyOnlineTokens = 36e24; // 36,000,000 MFL
768         token.mint(bountyOnlineWallet, _bountyOnlineTokens);
769         token.allowTransfer(bountyOnlineWallet);
770         token.allowTransfer(bountyOnlineGW);
771 
772         _bountyOfflineTokens = 54e24; // 54,000,000 MFL
773         token.mint(bountyOfflineWallet, _bountyOfflineTokens);
774         token.allowTransfer(bountyOfflineWallet);
775 
776         _advisoryTokens = 90e24; // 90,000,000 MFL
777         token.mint(this, _advisoryTokens);
778 
779         _reservedTokens = 162e24; // 162,000,000 MFL
780         token.mint(this, _reservedTokens);
781 
782         _airdropTokens = 18e24; // 18,000,000 MFL
783         token.mint(airdropWallet, _airdropTokens);
784         token.allowTransfer(airdropWallet);
785         token.allowTransfer(airdropGW);
786     }
787 
788 
789     /**
790      * @dev check is TLP2 is active?
791      * @return false if crowd TLP2 event was ended
792      */
793     function withinPeriod() constant public returns (bool) {
794         bool withinPeriodTLP2 = (now >= sT2 && now <= (sT2+dTLP2));
795         return withinPeriodTLP2;
796     }
797 
798 
799     /**
800      * @dev check is TLP2 is active and minting Not finished
801      * @return false if crowd event was ended
802      */
803     function running() constant public returns (bool) {
804         return withinPeriod() && !token.mintingFinished();
805     }
806 
807 
808     /**
809      * @dev check current stage name
810      * @return uint8 stage number
811      */
812     function stageName() constant public returns (uint8) {
813         uint256 eT2 = sT2+dTLP2;
814 
815         if (now < sT2) {return 101;} // not started
816         if (now >= sT2 && now <= eT2) {return (102);} // TLP1.2
817 
818         if (now > eT2 && now < eT2+dBt) {return (103);} // preTLP1.3
819         if (now >= (eT2+dBt) && now <= (eT2+dBt+dW)) {return (0);} // TLP1.3
820         if (now > (eT2+dBt+dW) && now < (eT2+dBt+dW+dBt)) {return (104);} // preTLP1.4
821         if (now >= (eT2+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW)) {return (1);} // TLP1.4
822         if (now > (eT2+dBt+dW+dBt+dW) && now < (eT2+dBt+dW+dBt+dW+dBt)) {return (105);} // preTLP1.5
823         if (now >= (eT2+dBt+dW+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW+dBt+dW)) {return (2);} // TLP1.5
824         if (now > (eT2+dBt+dW+dBt+dW+dBt+dW) && now < (eT2+dBt+dW+dBt+dW+dBt+dW+dBt)) {return (106);} // preTLP1.6
825         if (now >= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW)) {return (3);} // TLP1.6
826         if (now > (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW) && now < (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt)) {return (107);} // preTLP1.7
827         if (now >= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt) && now <= (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt+dW)) {return (4);} // TLP1.7"
828         if (now > (eT2+dBt+dW+dBt+dW+dBt+dW+dBt+dW+dBt+dW)) {return (200);} // Finished
829         return (201); // unknown
830     }
831 
832 
833     /** 
834      * @dev change agent for minting
835      * @param agent - new agent address
836      */
837     function setFundMintingAgent(address agent) onlyOwner public {
838         fundMintingAgent = agent;
839         SetFundMintingAgent(agent);
840     }
841 
842 
843     /** 
844      * @dev change wallet for team vesting (this make possible to set smart-contract address later)
845      * @param _newTeamWallet - new wallet address
846      */
847     function setTeamWallet(address _newTeamWallet) onlyOwner public {
848         teamWallet = _newTeamWallet;
849         SetTeamWallet(_newTeamWallet);
850     }
851 
852 
853     /** 
854      * @dev change wallet for advisory vesting (this make possible to set smart-contract address later)
855      * @param _newAdvisoryWallet - new wallet address
856      */
857     function setAdvisoryWallet(address _newAdvisoryWallet) onlyOwner public {
858         advisoryWallet = _newAdvisoryWallet;
859         SetAdvisoryWallet(_newAdvisoryWallet);
860     }
861 
862 
863     /** 
864      * @dev change wallet for reserved vesting (this make possible to set smart-contract address later)
865      * @param _newReservedWallet - new wallet address
866      */
867     function setReservedWallet(address _newReservedWallet) onlyOwner public {
868         reservedWallet = _newReservedWallet;
869         SetReservedWallet(_newReservedWallet);
870     }
871 
872 
873     /**
874      * @dev change min ETH income during Window1-5
875      * @param _minETHin - new limit
876      */
877     function setMinETHin(uint256 _minETHin) onlyOwner public {
878         minETHin = _minETHin;
879         SetMinETHincome(_minETHin);
880     }
881 
882 
883     /**
884      * @dev set TLP1.X (2-7) start & end dates
885      * @param _at - new or old start date
886      */
887     function setStartEndTimeTLP(uint256 _at) onlyOwner public {
888         require(block.timestamp < sT2); // forbid change time when TLP1.2 is active
889         require(block.timestamp < _at); // should be great than current block timestamp
890 
891         sT2 = _at;
892         SetStartTimeTLP2(_at);
893     }
894 
895 
896     /**
897      * @dev Large Token Holder minting 
898      * @param to - mint to address
899      * @param amount - how much mint
900      */
901     function fundMinting(address to, uint256 amount) stopInEmergency public {
902         require(msg.sender == fundMintingAgent || isOwner());
903         require(block.timestamp < sT2);
904         require(fundTotalSupply + amount <= fundTokens);
905         require(token.totalSupply() + amount <= hardCapInTokens);
906 
907         fundTotalSupply = fundTotalSupply.add(amount);
908         token.mint(to, amount);
909         FundMinting(to, amount);
910     }
911 
912 
913     /**
914      * @dev calculate amount
915      * @param  amount - ether to be converted to tokens
916      * @param  at - current time
917      * @param  _totalSupply - total supplied tokens
918      * @return tokens amount that we should send to our dear ppl
919      * @return odd ethers amount, which contract should send back
920      */
921     function calcAmountAt(
922         uint256 amount,
923         uint256 at,
924         uint256 _totalSupply
925     ) public constant returns (uint256, uint256) 
926     {
927         uint256 estimate;
928         uint256 price;
929         
930         if (at >= sT2 && at <= (sT2+dTLP2)) {
931             if (at <= sT2 + 15 days) {price = 12e13;} else if (at <= sT2 + 30 days) {
932                 price = 14e13;} else if (at <= sT2 + 45 days) {
933                     price = 16e13;} else if (at <= sT2 + 60 days) {
934                         price = 18e13;} else if (at <= sT2 + 75 days) {
935                             price = 20e13;} else if (at <= sT2 + 90 days) {
936                                 price = 22e13;} else if (at <= sT2 + 105 days) {
937                                     price = 24e13;} else if (at <= sT2 + 118 days) {
938                                         price = 26e13;} else {revert();}
939         } else {revert();}
940 
941         estimate = _totalSupply.add(amount.mul(1e18).div(price));
942 
943         if (estimate > hardCapInTokens) {
944             return (
945                 hardCapInTokens.sub(_totalSupply),
946                 estimate.sub(hardCapInTokens).mul(price).div(1e18)
947             );
948         }
949         return (estimate.sub(_totalSupply), 0);
950     }
951 
952 
953     /**
954      * @dev fallback for processing ether
955      */
956     function() payable public {
957         return getTokens(msg.sender);
958     }
959 
960 
961     /**
962      * @dev sell token and send to contributor address
963      * @param contributor address
964      */
965     function getTokens(address contributor) payable stopInEmergency validPurchase public {
966         uint256 amount;
967         uint256 oddEthers;
968         uint256 ethers;
969         uint256 _at;
970         uint8 _winNum;
971 
972         _at = block.timestamp;
973 
974         require(contributor != 0x0);
975        
976         if (withinPeriod()) {
977         
978             (amount, oddEthers) = calcAmountAt(msg.value, _at, token.totalSupply());  // recheck!!!
979   
980             require(amount + token.totalSupply() <= hardCapInTokens);
981 
982             ethers = msg.value.sub(oddEthers);
983 
984             token.mint(contributor, amount); // fail if minting is finished
985             TokenPurchase(contributor, ethers, amount);
986             counter_in = counter_in.add(ethers);
987             crowdTokensTLP2 = crowdTokensTLP2.add(amount);
988 
989             if (oddEthers > 0) {
990                 require(oddEthers < msg.value);
991                 contributor.transfer(oddEthers);
992                 TransferOddEther(contributor, oddEthers);
993             }
994 
995             wallet.transfer(ethers);
996         } else {
997             require(msg.value >= minETHin); // checks min ETH income
998             _winNum = stageName();
999             require(_winNum >= 0 && _winNum < 5);
1000             Window storage w = ww[_winNum];
1001 
1002             require(w.tokenPerWindow > 0); // check that we have tokens!
1003 
1004             w.totalEthInWindow = w.totalEthInWindow.add(msg.value);
1005             ppls[w.totalTransCnt].addr = contributor;
1006             ppls[w.totalTransCnt].amount = msg.value;
1007             w.totalTransCnt++;
1008             TokenPurchaseInWindow(contributor, msg.value, _winNum, w.totalTransCnt, w.totalEthInWindow);
1009         }
1010     }
1011 
1012 
1013     /**
1014      * @dev close Window and transfer Eth to wallet address
1015      * @param _winNum - number of window 0-4 to close
1016      */
1017     function closeWindow(uint8 _winNum) onlyOwner stopInEmergency public {
1018         require(ww[_winNum].active);
1019         ww[_winNum].active = false;
1020 
1021         wallet.transfer(this.balance);
1022     }
1023 
1024 
1025     /**
1026      * @dev transfer tokens to ppl accts (window1-5)
1027      * @param _winNum - number of window 0-4 to close
1028      */
1029     function sendTokensWindow(uint8 _winNum) onlyOwner stopInEmergency public {
1030         uint256 _tokenPerETH;
1031         uint256 _tokenToSend = 0;
1032         address _tempAddr;
1033         uint32 index = ww[_winNum].refundIndex;
1034 
1035         TokenETH(ww[_winNum].totalEthInWindow, ww[_winNum].totalTransCnt);
1036 
1037         require(ww[_winNum].active);
1038         require(ww[_winNum].totalEthInWindow > 0);
1039         require(ww[_winNum].totalTransCnt > 0);
1040 
1041         _tokenPerETH = ww[_winNum].tokenPerWindow.div(ww[_winNum].totalEthInWindow); // max McFly in window / ethInWindow
1042 
1043         while (index < ww[_winNum].totalTransCnt && msg.gas > 100000) {
1044             _tokenToSend = _tokenPerETH.mul(ppls[index].amount);
1045             ppls[index].amount = 0;
1046             _tempAddr = ppls[index].addr;
1047             ppls[index].addr = 0;
1048             index++;
1049             token.transfer(_tempAddr, _tokenToSend);
1050             TokenWithdrawAtWindow(_tempAddr, _tokenToSend);
1051         }
1052         ww[_winNum].refundIndex = index;
1053     }
1054 
1055 
1056     /**
1057      * @dev open new window 0-5 and write totl token per window in structure
1058      * @param _winNum - number of window 0-4 to close
1059      * @param _tokenPerWindow - total token for window 0-4
1060      */
1061     function newWindow(uint8 _winNum, uint256 _tokenPerWindow) private {
1062         ww[_winNum] = Window(true, 0, 0, 0, _tokenPerWindow);
1063         NewWindow(_winNum, _tokenPerWindow);
1064     }
1065 
1066 
1067     /**
1068      * @dev Finish crowdsale TLP1.2 period and open window1-5 crowdsale
1069      */
1070     function finishCrowd() onlyOwner public {
1071         uint256 _tokenPerWindow;
1072         require(now > (sT2.add(dTLP2)) || hardCapInTokens == token.totalSupply());
1073         require(!token.mintingFinished());
1074 
1075         _tokenPerWindow = (mintCapInTokens.sub(crowdTokensTLP2).sub(fundTotalSupply)).div(5);
1076         token.mint(this, _tokenPerWindow.mul(5)); // mint to contract address
1077         // shoud be MAX tokens minted!!! 1,800,000,000
1078         for (uint8 y = 0; y < 5; y++) {
1079             newWindow(y, _tokenPerWindow);
1080         }
1081 
1082         token.finishMinting();
1083     }
1084 
1085 
1086     /**
1087      * @dev withdraw tokens amount within vesting rules for team, advisory and reserved
1088      * @param withdrawWallet - wallet to transfer tokens
1089      * @param withdrawTokens - amount of tokens to transfer to
1090      * @param withdrawTotalSupply - total amount of tokens transfered to account
1091      * @return unit256 total amount of tokens after transfer
1092      */
1093     function vestingWithdraw(address withdrawWallet, uint256 withdrawTokens, uint256 withdrawTotalSupply) private returns (uint256) {
1094         require(token.mintingFinished());
1095         require(msg.sender == withdrawWallet || isOwner());
1096 
1097         uint256 currentPeriod = (block.timestamp.sub(sT2.add(dTLP2))).div(VestingPeriodInSeconds);
1098         if (currentPeriod > VestingPeriodsCount) {
1099             currentPeriod = VestingPeriodsCount;
1100         }
1101         uint256 tokenAvailable = withdrawTokens.mul(currentPeriod).div(VestingPeriodsCount).sub(withdrawTotalSupply);  // RECHECK!!!!!
1102 
1103         require(withdrawTotalSupply + tokenAvailable <= withdrawTokens);
1104 
1105         uint256 _withdrawTotalSupply = withdrawTotalSupply + tokenAvailable;
1106 
1107         token.transfer(withdrawWallet, tokenAvailable);
1108         WithdrawVesting(withdrawWallet, currentPeriod, tokenAvailable, _withdrawTotalSupply);
1109 
1110         return _withdrawTotalSupply;
1111     }
1112 
1113 
1114     /**
1115      * @dev withdraw tokens amount within vesting rules for team
1116      */
1117     function teamWithdraw() public {
1118         teamTotalSupply = vestingWithdraw(teamWallet, _teamTokens, teamTotalSupply);
1119     }
1120 
1121 
1122     /**
1123      * @dev withdraw tokens amount within vesting rules for advisory
1124      */
1125     function advisoryWithdraw() public {
1126         advisoryTotalSupply = vestingWithdraw(advisoryWallet, _advisoryTokens, advisoryTotalSupply);
1127     }
1128 
1129 
1130     /**
1131      * @dev withdraw tokens amount within vesting rules for reserved wallet
1132      */
1133     function reservedWithdraw() public {
1134         reservedTotalSupply = vestingWithdraw(reservedWallet, _reservedTokens, reservedTotalSupply);
1135     }
1136 }