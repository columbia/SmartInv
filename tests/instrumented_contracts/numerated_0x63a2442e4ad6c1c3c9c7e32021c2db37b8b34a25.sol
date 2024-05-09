1 pragma solidity ^0.4.13;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x);
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x);
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x);
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42 
43     // This famous algorithm is called "exponentiation by squaring"
44     // and calculates x^n with x as fixed-point and n as regular unsigned.
45     //
46     // It's O(log n), instead of O(n) for naive repeated multiplication.
47     //
48     // These facts are why it works:
49     //
50     //  If n is even, then x^n = (x^2)^(n/2).
51     //  If n is odd,  then x^n = x * x^(n-1),
52     //   and applying the equation for even x gives
53     //    x^n = x * (x^2)^((n-1) / 2).
54     //
55     //  Also, EVM division is flooring and
56     //    floor[(n-1) / 2] = floor[n / 2].
57     //
58     function rpow(uint x, uint n) internal pure returns (uint z) {
59         z = n % 2 != 0 ? x : RAY;
60 
61         for (n /= 2; n != 0; n /= 2) {
62             x = rmul(x, x);
63 
64             if (n % 2 != 0) {
65                 z = rmul(z, x);
66             }
67         }
68     }
69 }
70 
71 contract WETH9_ {
72     string public name     = "Wrapped Ether";
73     string public symbol   = "WETH";
74     uint8  public decimals = 18;
75 
76     event  Approval(address indexed src, address indexed guy, uint wad);
77     event  Transfer(address indexed src, address indexed dst, uint wad);
78     event  Deposit(address indexed dst, uint wad);
79     event  Withdrawal(address indexed src, uint wad);
80 
81     mapping (address => uint)                       public  balanceOf;
82     mapping (address => mapping (address => uint))  public  allowance;
83 
84     function() public payable {
85         deposit();
86     }
87     function deposit() public payable {
88         balanceOf[msg.sender] += msg.value;
89         Deposit(msg.sender, msg.value);
90     }
91     function withdraw(uint wad) public {
92         require(balanceOf[msg.sender] >= wad);
93         balanceOf[msg.sender] -= wad;
94         msg.sender.transfer(wad);
95         Withdrawal(msg.sender, wad);
96     }
97 
98     function totalSupply() public view returns (uint) {
99         return this.balance;
100     }
101 
102     function approve(address guy, uint wad) public returns (bool) {
103         allowance[msg.sender][guy] = wad;
104         Approval(msg.sender, guy, wad);
105         return true;
106     }
107 
108     function transfer(address dst, uint wad) public returns (bool) {
109         return transferFrom(msg.sender, dst, wad);
110     }
111 
112     function transferFrom(address src, address dst, uint wad)
113         public
114         returns (bool)
115     {
116         require(balanceOf[src] >= wad);
117 
118         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
119             require(allowance[src][msg.sender] >= wad);
120             allowance[src][msg.sender] -= wad;
121         }
122 
123         balanceOf[src] -= wad;
124         balanceOf[dst] += wad;
125 
126         Transfer(src, dst, wad);
127 
128         return true;
129     }
130 }
131 
132 interface FundInterface {
133 
134     // EVENTS
135 
136     event PortfolioContent(uint holdings, uint price, uint decimals);
137     event RequestUpdated(uint id);
138     event Invested(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
139     event Redeemed(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
140     event SpendingApproved(address onConsigned, address ofAsset, uint amount);
141     event FeesConverted(uint atTimestamp, uint shareQuantityConverted, uint unclaimed);
142     event CalculationUpdate(uint atTimestamp, uint managementFee, uint performanceFee, uint nav, uint sharePrice, uint totalSupply);
143     event OrderUpdated(uint id);
144     event LogError(uint ERROR_CODE);
145     event ErrorMessage(string errorMessage);
146 
147     // EXTERNAL METHODS
148     // Compliance by Investor
149     function requestInvestment(uint giveQuantity, uint shareQuantity, bool isNativeAsset) external;
150     function requestRedemption(uint shareQuantity, uint receiveQuantity, bool isNativeAsset) external;
151     function executeRequest(uint requestId) external;
152     function cancelRequest(uint requestId) external;
153     function redeemAllOwnedAssets(uint shareQuantity) external returns (bool);
154     // Administration by Manager
155     function enableInvestment() external;
156     function disableInvestment() external;
157     function enableRedemption() external;
158     function disableRedemption() external;
159     function shutDown() external;
160     // Managing by Manager
161     function makeOrder(uint exchangeId, address sellAsset, address buyAsset, uint sellQuantity, uint buyQuantity) external;
162     function takeOrder(uint exchangeId, uint id, uint quantity) external;
163     function cancelOrder(uint exchangeId, uint id) external;
164 
165     // PUBLIC METHODS
166     function emergencyRedeem(uint shareQuantity, address[] requestedAssets) public returns (bool success);
167     // Fees by Manager
168     function allocateUnclaimedFees();
169 
170     // PUBLIC VIEW METHODS
171     // Get general information
172     function getModules() view returns (address, address, address);
173     function getLastOrderId() view returns (uint);
174     function getLastRequestId() view returns (uint);
175     function getNameHash() view returns (bytes32);
176     function getManager() view returns (address);
177 
178     // Get accounting information
179     function performCalculations() view returns (uint, uint, uint, uint, uint, uint, uint);
180     function calcSharePrice() view returns (uint);
181 }
182 
183 interface AssetInterface {
184     /*
185      * Implements ERC 20 standard.
186      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
187      * https://github.com/ethereum/EIPs/issues/20
188      *
189      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
190      *  https://github.com/ethereum/EIPs/issues/223
191      */
192 
193     // Events
194     event Transfer(address indexed _from, address indexed _to, uint _value);
195     event Approval(address indexed _owner, address indexed _spender, uint _value);
196 
197     // There is no ERC223 compatible Transfer event, with `_data` included.
198 
199     //ERC 223
200     // PUBLIC METHODS
201     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
202 
203     // ERC 20
204     // PUBLIC METHODS
205     function transfer(address _to, uint _value) public returns (bool success);
206     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
207     function approve(address _spender, uint _value) public returns (bool success);
208     // PUBLIC VIEW METHODS
209     function balanceOf(address _owner) view public returns (uint balance);
210     function allowance(address _owner, address _spender) public view returns (uint remaining);
211 }
212 
213 interface ERC223Interface {
214     function balanceOf(address who) constant returns (uint);
215     function transfer(address to, uint value) returns (bool);
216     function transfer(address to, uint value, bytes data) returns (bool);
217     event Transfer(address indexed from, address indexed to, uint value, bytes data);
218 }
219 
220 contract Asset is DSMath, AssetInterface, ERC223Interface {
221 
222     // DATA STRUCTURES
223 
224     mapping (address => uint) balances;
225     mapping (address => mapping (address => uint)) allowed;
226     uint public totalSupply;
227 
228     // PUBLIC METHODS
229 
230     /**
231      * @notice Send `_value` tokens to `_to` from `msg.sender`
232      * @dev Transfers sender's tokens to a given address
233      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
234      * @param _to Address of token receiver
235      * @param _value Number of tokens to transfer
236      * @return Returns success of function call
237      */
238     function transfer(address _to, uint _value)
239         public
240         returns (bool success)
241     {
242         uint codeLength;
243         bytes memory empty;
244 
245         assembly {
246             // Retrieve the size of the code on target address, this needs assembly.
247             codeLength := extcodesize(_to)
248         }
249  
250         require(balances[msg.sender] >= _value); // sanity checks
251         require(balances[_to] + _value >= balances[_to]);
252 
253         balances[msg.sender] = sub(balances[msg.sender], _value);
254         balances[_to] = add(balances[_to], _value);
255         // if (codeLength > 0) {
256         //     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
257         //     receiver.tokenFallback(msg.sender, _value, empty);
258         // }
259         Transfer(msg.sender, _to, _value, empty);
260         return true;
261     }
262 
263     /**
264      * @notice Send `_value` tokens to `_to` from `msg.sender` and trigger tokenFallback if sender is a contract
265      * @dev Function that is called when a user or contract wants to transfer funds
266      * @param _to Address of token receiver
267      * @param _value Number of tokens to transfer
268      * @param _data Data to be sent to tokenFallback
269      * @return Returns success of function call
270      */
271     function transfer(address _to, uint _value, bytes _data)
272         public
273         returns (bool success)
274     {
275         uint codeLength;
276 
277         assembly {
278             // Retrieve the size of the code on target address, this needs assembly.
279             codeLength := extcodesize(_to)
280         }
281 
282         require(balances[msg.sender] >= _value); // sanity checks
283         require(balances[_to] + _value >= balances[_to]);
284 
285         balances[msg.sender] = sub(balances[msg.sender], _value);
286         balances[_to] = add(balances[_to], _value);
287         // if (codeLength > 0) {
288         //     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
289         //     receiver.tokenFallback(msg.sender, _value, _data);
290         // }
291         Transfer(msg.sender, _to, _value);
292         return true;
293     }
294 
295     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
296     /// @notice Restriction: An account can only use this function to send to itself
297     /// @dev Allows for an approved third party to transfer tokens from one
298     /// address to another. Returns success.
299     /// @param _from Address from where tokens are withdrawn.
300     /// @param _to Address to where tokens are sent.
301     /// @param _value Number of tokens to transfer.
302     /// @return Returns success of function call.
303     function transferFrom(address _from, address _to, uint _value)
304         public
305         returns (bool)
306     {
307         require(_from != 0x0);
308         require(_to != 0x0);
309         require(_to != address(this));
310         require(balances[_from] >= _value);
311         require(allowed[_from][msg.sender] >= _value);
312         require(balances[_to] + _value >= balances[_to]);
313         // require(_to == msg.sender); // can only use transferFrom to send to self
314 
315         balances[_to] += _value;
316         balances[_from] -= _value;
317         allowed[_from][msg.sender] -= _value;
318 
319         Transfer(_from, _to, _value);
320         return true;
321     }
322 
323     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
324     /// @dev Sets approved amount of tokens for spender. Returns success.
325     /// @param _spender Address of allowed account.
326     /// @param _value Number of approved tokens.
327     /// @return Returns success of function call.
328     function approve(address _spender, uint _value) public returns (bool) {
329         require(_spender != 0x0);
330 
331         // To change the approve amount you first have to reduce the addresses`
332         // allowance to zero by calling `approve(_spender, 0)` if it is not
333         // already 0 to mitigate the race condition described here:
334         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
335         // require(_value == 0 || allowed[msg.sender][_spender] == 0);
336 
337         allowed[msg.sender][_spender] = _value;
338         Approval(msg.sender, _spender, _value);
339         return true;
340     }
341 
342     // PUBLIC VIEW METHODS
343 
344     /// @dev Returns number of allowed tokens that a spender can transfer on
345     /// behalf of a token owner.
346     /// @param _owner Address of token owner.
347     /// @param _spender Address of token spender.
348     /// @return Returns remaining allowance for spender.
349     function allowance(address _owner, address _spender)
350         constant
351         public
352         returns (uint)
353     {
354         return allowed[_owner][_spender];
355     }
356 
357     /// @dev Returns number of tokens owned by the given address.
358     /// @param _owner Address of token owner.
359     /// @return Returns balance of owner.
360     function balanceOf(address _owner) constant public returns (uint) {
361         return balances[_owner];
362     }
363 
364 }
365 
366 interface ERC223ReceivingContract {
367 
368     /// @dev Function that is called when a user or another contract wants to transfer funds.
369     /// @param _from Transaction initiator, analogue of msg.sender
370     /// @param _value Number of tokens to transfer.
371     /// @param _data Data containing a function signature and/or parameters
372     function tokenFallback(address _from, uint256 _value, bytes _data) public;
373 }
374 
375 interface NativeAssetInterface {
376 
377     // PUBLIC METHODS
378     function deposit() public payable;
379     function withdraw(uint wad) public;
380 }
381 
382 interface SharesInterface {
383 
384     event Created(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
385     event Annihilated(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
386 
387     // VIEW METHODS
388 
389     function getName() view returns (string);
390     function getSymbol() view returns (string);
391     function getDecimals() view returns (uint);
392     function getCreationTime() view returns (uint);
393     function toSmallestShareUnit(uint quantity) view returns (uint);
394     function toWholeShareUnit(uint quantity) view returns (uint);
395 
396 }
397 
398 contract Shares is Asset, SharesInterface {
399 
400     // FIELDS
401 
402     // Constructor fields
403     string public name;
404     string public symbol;
405     uint public decimal;
406     uint public creationTime;
407 
408     // METHODS
409 
410     // CONSTRUCTOR
411 
412     /// @param _name Name these shares
413     /// @param _symbol Symbol of shares
414     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
415     /// @param _creationTime Timestamp of share creation
416     function Shares(string _name, string _symbol, uint _decimal, uint _creationTime) {
417         name = _name;
418         symbol = _symbol;
419         decimal = _decimal;
420         creationTime = _creationTime;
421     }
422 
423     // PUBLIC METHODS
424     // PUBLIC VIEW METHODS
425 
426     function getName() view returns (string) { return name; }
427     function getSymbol() view returns (string) { return symbol; }
428     function getDecimals() view returns (uint) { return decimal; }
429     function getCreationTime() view returns (uint) { return creationTime; }
430     function toSmallestShareUnit(uint quantity) view returns (uint) { return mul(quantity, 10 ** getDecimals()); }
431     function toWholeShareUnit(uint quantity) view returns (uint) { return quantity / (10 ** getDecimals()); }
432 
433     // INTERNAL METHODS
434 
435     /// @param recipient Address the new shares should be sent to
436     /// @param shareQuantity Number of shares to be created
437     function createShares(address recipient, uint shareQuantity) internal {
438         totalSupply = add(totalSupply, shareQuantity);
439         balances[recipient] = add(balances[recipient], shareQuantity);
440         Created(msg.sender, now, shareQuantity);
441     }
442 
443     /// @param recipient Address the new shares should be taken from when destroyed
444     /// @param shareQuantity Number of shares to be annihilated
445     function annihilateShares(address recipient, uint shareQuantity) internal {
446         totalSupply = sub(totalSupply, shareQuantity);
447         balances[recipient] = sub(balances[recipient], shareQuantity);
448         Annihilated(msg.sender, now, shareQuantity);
449     }
450 }
451 
452 contract RestrictedShares is Shares {
453 
454     // CONSTRUCTOR
455 
456     /// @param _name Name these shares
457     /// @param _symbol Symbol of shares
458     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
459     /// @param _creationTime Timestamp of share creation
460     function RestrictedShares(
461         string _name,
462         string _symbol,
463         uint _decimal,
464         uint _creationTime
465     ) Shares(_name, _symbol, _decimal, _creationTime) {}
466 
467     // PUBLIC METHODS
468 
469     /**
470      * @notice Send `_value` tokens to `_to` from `msg.sender`
471      * @dev Transfers sender's tokens to a given address
472      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
473      * @param _to Address of token receiver
474      * @param _value Number of tokens to transfer
475      * @return Returns success of function call
476      */
477     function transfer(address _to, uint _value)
478         public
479         returns (bool success)
480     {
481         require(msg.sender == address(this) || _to == address(this));
482         uint codeLength;
483         bytes memory empty;
484 
485         assembly {
486             // Retrieve the size of the code on target address, this needs assembly.
487             codeLength := extcodesize(_to)
488         }
489 
490         require(balances[msg.sender] >= _value); // sanity checks
491         require(balances[_to] + _value >= balances[_to]);
492 
493         balances[msg.sender] = sub(balances[msg.sender], _value);
494         balances[_to] = add(balances[_to], _value);
495         if (codeLength > 0) {
496             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
497             receiver.tokenFallback(msg.sender, _value, empty);
498         }
499         Transfer(msg.sender, _to, _value, empty);
500         return true;
501     }
502 
503     /**
504      * @notice Send `_value` tokens to `_to` from `msg.sender` and trigger tokenFallback if sender is a contract
505      * @dev Function that is called when a user or contract wants to transfer funds
506      * @param _to Address of token receiver
507      * @param _value Number of tokens to transfer
508      * @param _data Data to be sent to tokenFallback
509      * @return Returns success of function call
510      */
511     function transfer(address _to, uint _value, bytes _data)
512         public
513         returns (bool success)
514     {
515         require(msg.sender == address(this) || _to == address(this));
516         uint codeLength;
517 
518         assembly {
519             // Retrieve the size of the code on target address, this needs assembly.
520             codeLength := extcodesize(_to)
521         }
522 
523         require(balances[msg.sender] >= _value); // sanity checks
524         require(balances[_to] + _value >= balances[_to]);
525 
526         balances[msg.sender] = sub(balances[msg.sender], _value);
527         balances[_to] = add(balances[_to], _value);
528         if (codeLength > 0) {
529             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
530             receiver.tokenFallback(msg.sender, _value, _data);
531         }
532         Transfer(msg.sender, _to, _value);
533         return true;
534     }
535 
536     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
537     /// @dev Sets approved amount of tokens for spender. Returns success.
538     /// @param _spender Address of allowed account.
539     /// @param _value Number of approved tokens.
540     /// @return Returns success of function call.
541     function approve(address _spender, uint _value) public returns (bool) {
542         require(msg.sender == address(this));
543         require(_spender != 0x0);
544 
545         // To change the approve amount you first have to reduce the addresses`
546         // allowance to zero by calling `approve(_spender, 0)` if it is not
547         // already 0 to mitigate the race condition described here:
548         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
549         require(_value == 0 || allowed[msg.sender][_spender] == 0);
550 
551         allowed[msg.sender][_spender] = _value;
552         Approval(msg.sender, _spender, _value);
553         return true;
554     }
555 
556 }
557 
558 interface ComplianceInterface {
559 
560     // PUBLIC VIEW METHODS
561 
562     /// @notice Checks whether investment is permitted for a participant
563     /// @param ofParticipant Address requesting to invest in a Melon fund
564     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
565     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
566     /// @return Whether identity is eligible to invest in a Melon fund.
567     function isInvestmentPermitted(
568         address ofParticipant,
569         uint256 giveQuantity,
570         uint256 shareQuantity
571     ) view returns (bool);
572 
573     /// @notice Checks whether redemption is permitted for a participant
574     /// @param ofParticipant Address requesting to redeem from a Melon fund
575     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
576     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
577     /// @return Whether identity is eligible to redeem from a Melon fund.
578     function isRedemptionPermitted(
579         address ofParticipant,
580         uint256 shareQuantity,
581         uint256 receiveQuantity
582     ) view returns (bool);
583 }
584 
585 contract DBC {
586 
587     // MODIFIERS
588 
589     modifier pre_cond(bool condition) {
590         require(condition);
591         _;
592     }
593 
594     modifier post_cond(bool condition) {
595         _;
596         assert(condition);
597     }
598 
599     modifier invariant(bool condition) {
600         require(condition);
601         _;
602         assert(condition);
603     }
604 }
605 
606 contract Owned is DBC {
607 
608     // FIELDS
609 
610     address public owner;
611 
612     // NON-CONSTANT METHODS
613 
614     function Owned() { owner = msg.sender; }
615 
616     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
617 
618     // PRE, POST, INVARIANT CONDITIONS
619 
620     function isOwner() internal returns (bool) { return msg.sender == owner; }
621 
622 }
623 
624 contract Fund is DSMath, DBC, Owned, RestrictedShares, FundInterface, ERC223ReceivingContract {
625     // TYPES
626 
627     struct Modules { // Describes all modular parts, standardised through an interface
628         PriceFeedInterface pricefeed; // Provides all external data
629         ComplianceInterface compliance; // Boolean functions regarding invest/redeem
630         RiskMgmtInterface riskmgmt; // Boolean functions regarding make/take orders
631     }
632 
633     struct Calculations { // List of internal calculations
634         uint gav; // Gross asset value
635         uint managementFee; // Time based fee
636         uint performanceFee; // Performance based fee measured against QUOTE_ASSET
637         uint unclaimedFees; // Fees not yet allocated to the fund manager
638         uint nav; // Net asset value
639         uint highWaterMark; // A record of best all-time fund performance
640         uint totalSupply; // Total supply of shares
641         uint timestamp; // Time when calculations are performed in seconds
642     }
643 
644     enum RequestStatus { active, cancelled, executed }
645     enum RequestType { invest, redeem, tokenFallbackRedeem }
646     struct Request { // Describes and logs whenever asset enter and leave fund due to Participants
647         address participant; // Participant in Melon fund requesting investment or redemption
648         RequestStatus status; // Enum: active, cancelled, executed; Status of request
649         RequestType requestType; // Enum: invest, redeem, tokenFallbackRedeem
650         address requestAsset; // Address of the asset being requested
651         uint shareQuantity; // Quantity of Melon fund shares
652         uint giveQuantity; // Quantity in Melon asset to give to Melon fund to receive shareQuantity
653         uint receiveQuantity; // Quantity in Melon asset to receive from Melon fund for given shareQuantity
654         uint timestamp;     // Time of request creation in seconds
655         uint atUpdateId;    // Pricefeed updateId when this request was created
656     }
657 
658     enum OrderStatus { active, partiallyFilled, fullyFilled, cancelled }
659     enum OrderType { make, take }
660     struct Order { // Describes and logs whenever assets enter and leave fund due to Manager
661         uint exchangeId; // Id as returned from exchange
662         OrderStatus status; // Enum: active, partiallyFilled, fullyFilled, cancelled
663         OrderType orderType; // Enum: make, take
664         address sellAsset; // Asset (as registered in Asset registrar) to be sold
665         address buyAsset; // Asset (as registered in Asset registrar) to be bought
666         uint sellQuantity; // Quantity of sellAsset to be sold
667         uint buyQuantity; // Quantity of sellAsset to be bought
668         uint timestamp; // Time of order creation in seconds
669         uint fillQuantity; // Buy quantity filled; Always less than buy_quantity
670     }
671 
672     struct Exchange {
673         address exchange; // Address of the exchange
674         ExchangeInterface exchangeAdapter; //Exchange adapter contracts respective to the exchange
675         bool isApproveOnly; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
676     }
677 
678     // FIELDS
679 
680     // Constant fields
681     uint public constant MAX_FUND_ASSETS = 90; // Max ownable assets by the fund supported by gas limits
682     // Constructor fields
683     uint public MANAGEMENT_FEE_RATE; // Fee rate in QUOTE_ASSET per delta improvement in WAD
684     uint public PERFORMANCE_FEE_RATE; // Fee rate in QUOTE_ASSET per managed seconds in WAD
685     address public VERSION; // Address of Version contract
686     Asset public QUOTE_ASSET; // QUOTE asset as ERC20 contract
687     NativeAssetInterface public NATIVE_ASSET; // Native asset as ERC20 contract
688     // Methods fields
689     Modules public module; // Struct which holds all the initialised module instances
690     Exchange[] public exchanges; // Array containing exchanges this fund supports
691     Calculations public atLastUnclaimedFeeAllocation; // Calculation results at last allocateUnclaimedFees() call
692     bool public isShutDown; // Security feature, if yes than investing, managing, allocateUnclaimedFees gets blocked
693     Request[] public requests; // All the requests this fund received from participants
694     bool public isInvestAllowed; // User option, if false fund rejects Melon investments
695     bool public isRedeemAllowed; // User option, if false fund rejects Melon redemptions; Redemptions using slices always possible
696     Order[] public orders; // All the orders this fund placed on exchanges
697     mapping (uint => mapping(address => uint)) public exchangeIdsToOpenMakeOrderIds; // exchangeIndex to: asset to open make order ID ; if no open make orders, orderID is zero
698     address[] public ownedAssets; // List of all assets owned by the fund or for which the fund has open make orders
699     mapping (address => bool) public isInAssetList; // Mapping from asset to whether the asset exists in ownedAssets
700     mapping (address => bool) public isInOpenMakeOrder; // Mapping from asset to whether the asset is in a open make order as buy asset
701 
702     // METHODS
703 
704     // CONSTRUCTOR
705 
706     /// @dev Should only be called via Version.setupFund(..)
707     /// @param withName human-readable descriptive name (not necessarily unique)
708     /// @param ofQuoteAsset Asset against which mgmt and performance fee is measured against and which can be used to invest/redeem using this single asset
709     /// @param ofManagementFee A time based fee expressed, given in a number which is divided by 1 WAD
710     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 1 WAD
711     /// @param ofCompliance Address of compliance module
712     /// @param ofRiskMgmt Address of risk management module
713     /// @param ofPriceFeed Address of price feed module
714     /// @param ofExchanges Addresses of exchange on which this fund can trade
715     /// @param ofExchangeAdapters Addresses of exchange adapters
716     /// @return Deployed Fund with manager set as ofManager
717     function Fund(
718         address ofManager,
719         string withName,
720         address ofQuoteAsset,
721         uint ofManagementFee,
722         uint ofPerformanceFee,
723         address ofNativeAsset,
724         address ofCompliance,
725         address ofRiskMgmt,
726         address ofPriceFeed,
727         address[] ofExchanges,
728         address[] ofExchangeAdapters
729     )
730         RestrictedShares(withName, "MLNF", 18, now)
731     {
732         isInvestAllowed = true;
733         isRedeemAllowed = true;
734         owner = ofManager;
735         require(ofManagementFee < 10 ** 18); // Require management fee to be less than 100 percent
736         MANAGEMENT_FEE_RATE = ofManagementFee; // 1 percent is expressed as 0.01 * 10 ** 18
737         require(ofPerformanceFee < 10 ** 18); // Require performance fee to be less than 100 percent
738         PERFORMANCE_FEE_RATE = ofPerformanceFee; // 1 percent is expressed as 0.01 * 10 ** 18
739         VERSION = msg.sender;
740         module.compliance = ComplianceInterface(ofCompliance);
741         module.riskmgmt = RiskMgmtInterface(ofRiskMgmt);
742         module.pricefeed = PriceFeedInterface(ofPriceFeed);
743         // Bridged to Melon exchange interface by exchangeAdapter library
744         for (uint i = 0; i < ofExchanges.length; ++i) {
745             ExchangeInterface adapter = ExchangeInterface(ofExchangeAdapters[i]);
746             bool isApproveOnly = adapter.isApproveOnly();
747             exchanges.push(Exchange({
748                 exchange: ofExchanges[i],
749                 exchangeAdapter: adapter,
750                 isApproveOnly: isApproveOnly
751             }));
752         }
753         // Require Quote assets exists in pricefeed
754         QUOTE_ASSET = Asset(ofQuoteAsset);
755         NATIVE_ASSET = NativeAssetInterface(ofNativeAsset);
756         require(address(QUOTE_ASSET) == module.pricefeed.getQuoteAsset()); // Sanity check
757         atLastUnclaimedFeeAllocation = Calculations({
758             gav: 0,
759             managementFee: 0,
760             performanceFee: 0,
761             unclaimedFees: 0,
762             nav: 0,
763             highWaterMark: 10 ** getDecimals(),
764             totalSupply: totalSupply,
765             timestamp: now
766         });
767     }
768 
769     // EXTERNAL METHODS
770 
771     // EXTERNAL : ADMINISTRATION
772 
773     function enableInvestment() external pre_cond(isOwner()) { isInvestAllowed = true; }
774     function disableInvestment() external pre_cond(isOwner()) { isInvestAllowed = false; }
775     function enableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = true; }
776     function disableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = false; }
777     function shutDown() external pre_cond(msg.sender == VERSION) { isShutDown = true; }
778 
779 
780     // EXTERNAL : PARTICIPATION
781 
782     /// @notice Give melon tokens to receive shares of this fund
783     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
784     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
785     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
786     function requestInvestment(
787         uint giveQuantity,
788         uint shareQuantity,
789         bool isNativeAsset
790     )
791         external
792         pre_cond(!isShutDown)
793         pre_cond(isInvestAllowed) // investment using Melon has not been deactivated by the Manager
794         pre_cond(module.compliance.isInvestmentPermitted(msg.sender, giveQuantity, shareQuantity))    // Compliance Module: Investment permitted
795     {
796         requests.push(Request({
797             participant: msg.sender,
798             status: RequestStatus.active,
799             requestType: RequestType.invest,
800             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
801             shareQuantity: shareQuantity,
802             giveQuantity: giveQuantity,
803             receiveQuantity: shareQuantity,
804             timestamp: now,
805             atUpdateId: module.pricefeed.getLastUpdateId()
806         }));
807         RequestUpdated(getLastRequestId());
808     }
809 
810     /// @notice Give shares of this fund to receive melon tokens
811     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
812     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
813     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
814     function requestRedemption(
815         uint shareQuantity,
816         uint receiveQuantity,
817         bool isNativeAsset
818       )
819         external
820         pre_cond(!isShutDown)
821         pre_cond(isRedeemAllowed) // Redemption using Melon has not been deactivated by Manager
822         pre_cond(module.compliance.isRedemptionPermitted(msg.sender, shareQuantity, receiveQuantity)) // Compliance Module: Redemption permitted
823     {
824         requests.push(Request({
825             participant: msg.sender,
826             status: RequestStatus.active,
827             requestType: RequestType.redeem,
828             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
829             shareQuantity: shareQuantity,
830             giveQuantity: shareQuantity,
831             receiveQuantity: receiveQuantity,
832             timestamp: now,
833             atUpdateId: module.pricefeed.getLastUpdateId()
834         }));
835         RequestUpdated(getLastRequestId());
836     }
837 
838     /// @notice Executes active investment and redemption requests, in a way that minimises information advantages of investor
839     /// @dev Distributes melon and shares according to the request
840     /// @param id Index of request to be executed
841     /// @dev Active investment or redemption request executed
842     function executeRequest(uint id)
843         external
844         pre_cond(!isShutDown)
845         pre_cond(requests[id].status == RequestStatus.active)
846         pre_cond(requests[id].requestType != RequestType.redeem || requests[id].shareQuantity <= balances[requests[id].participant]) // request owner does not own enough shares
847         pre_cond(
848             totalSupply == 0 ||
849             (
850                 now >= add(requests[id].timestamp, module.pricefeed.getInterval()) &&
851                 module.pricefeed.getLastUpdateId() >= add(requests[id].atUpdateId, 2)
852             )
853         )   // PriceFeed Module: Wait at least one interval time and two updates before continuing (unless it is the first investment)
854          // PriceFeed Module: No recent updates for fund asset list
855     {
856         // sharePrice quoted in QUOTE_ASSET and multiplied by 10 ** fundDecimals
857         // based in QUOTE_ASSET and multiplied by 10 ** fundDecimals
858         require(module.pricefeed.hasRecentPrice(address(QUOTE_ASSET)));
859         require(module.pricefeed.hasRecentPrices(ownedAssets));
860         var (isRecent, , ) = module.pricefeed.getInvertedPrice(address(QUOTE_ASSET));
861         // TODO: check precision of below otherwise use; uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePrice()));
862         // By definition quoteDecimals == fundDecimals
863         Request request = requests[id];
864 
865         uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePrice()));
866         if (request.requestAsset == address(NATIVE_ASSET)) {
867             var (isPriceRecent, invertedNativeAssetPrice, nativeAssetDecimal) = module.pricefeed.getInvertedPrice(address(NATIVE_ASSET));
868             if (!isPriceRecent) {
869                 revert();
870             }
871             costQuantity = mul(costQuantity, invertedNativeAssetPrice) / 10 ** nativeAssetDecimal;
872         }
873 
874         if (
875             isInvestAllowed &&
876             request.requestType == RequestType.invest &&
877             costQuantity <= request.giveQuantity
878         ) {
879             if (!isInAssetList[address(QUOTE_ASSET)]) {
880                 ownedAssets.push(address(QUOTE_ASSET));
881                 isInAssetList[address(QUOTE_ASSET)] = true;
882             }
883             request.status = RequestStatus.executed;
884             assert(AssetInterface(request.requestAsset).transferFrom(request.participant, this, costQuantity)); // Allocate Value
885             createShares(request.participant, request.shareQuantity); // Accounting
886         } else if (
887             isRedeemAllowed &&
888             request.requestType == RequestType.redeem &&
889             request.receiveQuantity <= costQuantity
890         ) {
891             request.status = RequestStatus.executed;
892             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
893             annihilateShares(request.participant, request.shareQuantity); // Accounting
894         } else if (
895             isRedeemAllowed &&
896             request.requestType == RequestType.tokenFallbackRedeem &&
897             request.receiveQuantity <= costQuantity
898         ) {
899             request.status = RequestStatus.executed;
900             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
901             annihilateShares(this, request.shareQuantity); // Accounting
902         } else {
903             revert(); // Invalid Request or invalid giveQuantity / receiveQuantity
904         }
905     }
906 
907     /// @notice Cancels active investment and redemption requests
908     /// @param id Index of request to be executed
909     function cancelRequest(uint id)
910         external
911         pre_cond(requests[id].status == RequestStatus.active) // Request is active
912         pre_cond(requests[id].participant == msg.sender || isShutDown) // Either request creator or fund is shut down
913     {
914         requests[id].status = RequestStatus.cancelled;
915     }
916 
917     /// @notice Redeems by allocating an ownership percentage of each asset to the participant
918     /// @dev Independent of running price feed!
919     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
920     /// @return Whether all assets sent to shareholder or not
921     function redeemAllOwnedAssets(uint shareQuantity)
922         external
923         returns (bool success)
924     {
925         return emergencyRedeem(shareQuantity, ownedAssets);
926     }
927 
928     // EXTERNAL : MANAGING
929 
930     /// @notice Makes an order on the selected exchange
931     /// @dev These are orders that are not expected to settle immediately.  Sufficient balance (== sellQuantity) of sellAsset
932     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
933     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
934     /// @param sellQuantity Quantity of sellAsset to be sold
935     /// @param buyQuantity Quantity of buyAsset to be bought
936     function makeOrder(
937         uint exchangeNumber,
938         address sellAsset,
939         address buyAsset,
940         uint sellQuantity,
941         uint buyQuantity
942     )
943         external
944         pre_cond(isOwner())
945         pre_cond(!isShutDown)
946     {
947         require(buyAsset != address(this)); // Prevent buying of own fund token
948         require(quantityHeldInCustodyOfExchange(sellAsset) == 0); // Curr only one make order per sellAsset allowed. Please wait or cancel existing make order.
949         require(module.pricefeed.existsPriceOnAssetPair(sellAsset, buyAsset)); // PriceFeed module: Requested asset pair not valid
950         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(sellAsset, buyAsset);
951         require(isRecent);  // Reference price is required to be recent
952         require(
953             module.riskmgmt.isMakePermitted(
954                 module.pricefeed.getOrderPrice(
955                     sellAsset,
956                     buyAsset,
957                     sellQuantity,
958                     buyQuantity
959                 ),
960                 referencePrice,
961                 sellAsset,
962                 buyAsset,
963                 sellQuantity,
964                 buyQuantity
965             )
966         ); // RiskMgmt module: Make order not permitted
967         require(isInAssetList[buyAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
968         require(AssetInterface(sellAsset).approve(exchanges[exchangeNumber].exchange, sellQuantity)); // Approve exchange to spend assets
969 
970         // Since there is only one openMakeOrder allowed for each asset, we can assume that openMakeOrderId is set as zero by quantityHeldInCustodyOfExchange() function
971         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("makeOrder(address,address,address,uint256,uint256)")), exchanges[exchangeNumber].exchange, sellAsset, buyAsset, sellQuantity, buyQuantity));
972         exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] = exchanges[exchangeNumber].exchangeAdapter.getLastOrderId(exchanges[exchangeNumber].exchange);
973 
974         // Success defined as non-zero order id
975         require(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] != 0);
976 
977         // Update ownedAssets array and isInAssetList, isInOpenMakeOrder mapping
978         isInOpenMakeOrder[sellAsset] = true;
979         if (!isInAssetList[buyAsset]) {
980             ownedAssets.push(buyAsset);
981             isInAssetList[buyAsset] = true;
982         }
983 
984         orders.push(Order({
985             exchangeId: exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset],
986             status: OrderStatus.active,
987             orderType: OrderType.make,
988             sellAsset: sellAsset,
989             buyAsset: buyAsset,
990             sellQuantity: sellQuantity,
991             buyQuantity: buyQuantity,
992             timestamp: now,
993             fillQuantity: 0
994         }));
995 
996         OrderUpdated(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset]);
997     }
998 
999     /// @notice Takes an active order on the selected exchange
1000     /// @dev These are orders that are expected to settle immediately
1001     /// @param id Active order id
1002     /// @param receiveQuantity Buy quantity of what others are selling on selected Exchange
1003     function takeOrder(uint exchangeNumber, uint id, uint receiveQuantity)
1004         external
1005         pre_cond(isOwner())
1006         pre_cond(!isShutDown)
1007     {
1008         // Get information of order by order id
1009         Order memory order; // Inverse variable terminology! Buying what another person is selling
1010         (
1011             order.sellAsset,
1012             order.buyAsset,
1013             order.sellQuantity,
1014             order.buyQuantity
1015         ) = exchanges[exchangeNumber].exchangeAdapter.getOrder(exchanges[exchangeNumber].exchange, id);
1016         // Check pre conditions
1017         require(order.sellAsset != address(this)); // Prevent buying of own fund token
1018         require(module.pricefeed.existsPriceOnAssetPair(order.buyAsset, order.sellAsset)); // PriceFeed module: Requested asset pair not valid
1019         require(isInAssetList[order.sellAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
1020         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(order.buyAsset, order.sellAsset);
1021         require(isRecent); // Reference price is required to be recent
1022         require(receiveQuantity <= order.sellQuantity); // Not enough quantity of order for what is trying to be bought
1023         uint spendQuantity = mul(receiveQuantity, order.buyQuantity) / order.sellQuantity;
1024         require(AssetInterface(order.buyAsset).approve(exchanges[exchangeNumber].exchange, spendQuantity)); // Could not approve spending of spendQuantity of order.buyAsset
1025         require(
1026             module.riskmgmt.isTakePermitted(
1027             module.pricefeed.getOrderPrice(
1028                 order.buyAsset,
1029                 order.sellAsset,
1030                 order.buyQuantity, // spendQuantity
1031                 order.sellQuantity // receiveQuantity
1032             ),
1033             referencePrice,
1034             order.buyAsset,
1035             order.sellAsset,
1036             order.buyQuantity,
1037             order.sellQuantity
1038         )); // RiskMgmt module: Take order not permitted
1039 
1040         // Execute request
1041         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("takeOrder(address,uint256,uint256)")), exchanges[exchangeNumber].exchange, id, receiveQuantity));
1042 
1043         // Update ownedAssets array and isInAssetList mapping
1044         if (!isInAssetList[order.sellAsset]) {
1045             ownedAssets.push(order.sellAsset);
1046             isInAssetList[order.sellAsset] = true;
1047         }
1048 
1049         order.exchangeId = id;
1050         order.status = OrderStatus.fullyFilled;
1051         order.orderType = OrderType.take;
1052         order.timestamp = now;
1053         order.fillQuantity = receiveQuantity;
1054         orders.push(order);
1055         OrderUpdated(id);
1056     }
1057 
1058     /// @notice Cancels orders that were not expected to settle immediately, i.e. makeOrders
1059     /// @dev Reduce exposure with exchange interaction
1060     /// @param id Active order id of this order array with order owner of this contract on selected Exchange
1061     function cancelOrder(uint exchangeNumber, uint id)
1062         external
1063         pre_cond(isOwner() || isShutDown)
1064     {
1065         // Get information of fund order by order id
1066         Order order = orders[id];
1067 
1068         // Execute request
1069         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("cancelOrder(address,uint256)")), exchanges[exchangeNumber].exchange, order.exchangeId));
1070 
1071         order.status = OrderStatus.cancelled;
1072         OrderUpdated(id);
1073     }
1074 
1075 
1076     // PUBLIC METHODS
1077 
1078     // PUBLIC METHODS : ERC223
1079 
1080     /// @dev Standard ERC223 function that handles incoming token transfers.
1081     /// @dev This type of redemption can be seen as a "market order", where price is calculated at execution time
1082     /// @param ofSender  Token sender address.
1083     /// @param tokenAmount Amount of tokens sent.
1084     /// @param metadata  Transaction metadata.
1085     function tokenFallback(
1086         address ofSender,
1087         uint tokenAmount,
1088         bytes metadata
1089     ) {
1090         if (msg.sender != address(this)) {
1091             // when ofSender is a recognized exchange, receive tokens, otherwise revert
1092             for (uint i; i < exchanges.length; i++) {
1093                 if (exchanges[i].exchange == ofSender) return; // receive tokens and do nothing
1094             }
1095             revert();
1096         } else {    // otherwise, make a redemption request
1097             requests.push(Request({
1098                 participant: ofSender,
1099                 status: RequestStatus.active,
1100                 requestType: RequestType.tokenFallbackRedeem,
1101                 requestAsset: address(QUOTE_ASSET), // redeem in QUOTE_ASSET
1102                 shareQuantity: tokenAmount,
1103                 giveQuantity: tokenAmount,              // shares being sent
1104                 receiveQuantity: 0,          // value of the shares at request time
1105                 timestamp: now,
1106                 atUpdateId: module.pricefeed.getLastUpdateId()
1107             }));
1108             RequestUpdated(getLastRequestId());
1109         }
1110     }
1111 
1112 
1113     // PUBLIC METHODS : ACCOUNTING
1114 
1115     /// @notice Calculates gross asset value of the fund
1116     /// @dev Decimals in assets must be equal to decimals in PriceFeed for all entries in AssetRegistrar
1117     /// @dev Assumes that module.pricefeed.getPrice(..) returns recent prices
1118     /// @return gav Gross asset value quoted in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1119     function calcGav() returns (uint gav) {
1120         // prices quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
1121         address[] memory tempOwnedAssets; // To store ownedAssets
1122         tempOwnedAssets = ownedAssets;
1123         delete ownedAssets;
1124         for (uint i = 0; i < tempOwnedAssets.length; ++i) {
1125             address ofAsset = tempOwnedAssets[i];
1126             // assetHoldings formatting: mul(exchangeHoldings, 10 ** assetDecimal)
1127             uint assetHoldings = add(
1128                 uint(AssetInterface(ofAsset).balanceOf(this)), // asset base units held by fund
1129                 quantityHeldInCustodyOfExchange(ofAsset)
1130             );
1131             // assetPrice formatting: mul(exchangePrice, 10 ** assetDecimal)
1132             var (isRecent, assetPrice, assetDecimals) = module.pricefeed.getPrice(ofAsset);
1133             if (!isRecent) {
1134                 revert();
1135             }
1136             // gav as sum of mul(assetHoldings, assetPrice) with formatting: mul(mul(exchangeHoldings, exchangePrice), 10 ** shareDecimals)
1137             gav = add(gav, mul(assetHoldings, assetPrice) / (10 ** uint256(assetDecimals)));   // Sum up product of asset holdings of this vault and asset prices
1138             if (assetHoldings != 0 || ofAsset == address(QUOTE_ASSET) || isInOpenMakeOrder[ofAsset]) { // Check if asset holdings is not zero or is address(QUOTE_ASSET) or in open make order
1139                 ownedAssets.push(ofAsset);
1140             } else {
1141                 isInAssetList[ofAsset] = false; // Remove from ownedAssets if asset holdings are zero
1142             }
1143             PortfolioContent(assetHoldings, assetPrice, assetDecimals);
1144         }
1145     }
1146 
1147     /**
1148     @notice Calculates unclaimed fees of the fund manager
1149     @param gav Gross asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1150     @return {
1151       "managementFees": "A time (seconds) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1152       "performanceFees": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1153       "unclaimedfees": "The sum of both managementfee and performancefee in QUOTE_ASSET and multiplied by 10 ** shareDecimals"
1154     }
1155     */
1156     function calcUnclaimedFees(uint gav)
1157         view
1158         returns (
1159             uint managementFee,
1160             uint performanceFee,
1161             uint unclaimedFees)
1162     {
1163         // Management fee calculation
1164         uint timePassed = sub(now, atLastUnclaimedFeeAllocation.timestamp);
1165         uint gavPercentage = mul(timePassed, gav) / (1 years);
1166         managementFee = wmul(gavPercentage, MANAGEMENT_FEE_RATE);
1167 
1168         // Performance fee calculation
1169         // Handle potential division through zero by defining a default value
1170         uint valuePerShareExclMgmtFees = totalSupply > 0 ? calcValuePerShare(sub(gav, managementFee), totalSupply) : toSmallestShareUnit(1);
1171         if (valuePerShareExclMgmtFees > atLastUnclaimedFeeAllocation.highWaterMark) {
1172             uint gainInSharePrice = sub(valuePerShareExclMgmtFees, atLastUnclaimedFeeAllocation.highWaterMark);
1173             uint investmentProfits = wmul(gainInSharePrice, totalSupply);
1174             performanceFee = wmul(investmentProfits, PERFORMANCE_FEE_RATE);
1175         }
1176 
1177         // Sum of all FEES
1178         unclaimedFees = add(managementFee, performanceFee);
1179     }
1180 
1181     /// @notice Calculates the Net asset value of this fund
1182     /// @param gav Gross asset value of this fund in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1183     /// @param unclaimedFees The sum of both managementFee and performanceFee in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1184     /// @return nav Net asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1185     function calcNav(uint gav, uint unclaimedFees)
1186         view
1187         returns (uint nav)
1188     {
1189         nav = sub(gav, unclaimedFees);
1190     }
1191 
1192     /// @notice Calculates the share price of the fund
1193     /// @dev Convention for valuePerShare (== sharePrice) formatting: mul(totalValue / numShares, 10 ** decimal), to avoid floating numbers
1194     /// @dev Non-zero share supply; value denominated in [base unit of melonAsset]
1195     /// @param totalValue the total value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1196     /// @param numShares the number of shares multiplied by 10 ** shareDecimals
1197     /// @return valuePerShare Share price denominated in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1198     function calcValuePerShare(uint totalValue, uint numShares)
1199         view
1200         pre_cond(numShares > 0)
1201         returns (uint valuePerShare)
1202     {
1203         valuePerShare = toSmallestShareUnit(totalValue) / numShares;
1204     }
1205 
1206     /**
1207     @notice Calculates essential fund metrics
1208     @return {
1209       "gav": "Gross asset value of this fund denominated in [base unit of melonAsset]",
1210       "managementFee": "A time (seconds) based fee",
1211       "performanceFee": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee",
1212       "unclaimedFees": "The sum of both managementFee and performanceFee denominated in [base unit of melonAsset]",
1213       "feesShareQuantity": "The number of shares to be given as fees to the manager",
1214       "nav": "Net asset value denominated in [base unit of melonAsset]",
1215       "sharePrice": "Share price denominated in [base unit of melonAsset]"
1216     }
1217     */
1218     function performCalculations()
1219         view
1220         returns (
1221             uint gav,
1222             uint managementFee,
1223             uint performanceFee,
1224             uint unclaimedFees,
1225             uint feesShareQuantity,
1226             uint nav,
1227             uint sharePrice
1228         )
1229     {
1230         gav = calcGav(); // Reflects value independent of fees
1231         (managementFee, performanceFee, unclaimedFees) = calcUnclaimedFees(gav);
1232         nav = calcNav(gav, unclaimedFees);
1233 
1234         // The value of unclaimedFees measured in shares of this fund at current value
1235         feesShareQuantity = (gav == 0) ? 0 : mul(totalSupply, unclaimedFees) / gav;
1236         // The total share supply including the value of unclaimedFees, measured in shares of this fund
1237         uint totalSupplyAccountingForFees = add(totalSupply, feesShareQuantity);
1238         sharePrice = nav > 0 ? calcValuePerShare(nav, totalSupplyAccountingForFees) : toSmallestShareUnit(1); // Handle potential division through zero by defining a default value
1239     }
1240 
1241     /// @notice Converts unclaimed fees of the manager into fund shares
1242     /// @dev Only Owner
1243     function allocateUnclaimedFees()
1244         pre_cond(isOwner())
1245     {
1246         var (
1247             gav,
1248             managementFee,
1249             performanceFee,
1250             unclaimedFees,
1251             feesShareQuantity,
1252             nav,
1253             sharePrice
1254         ) = performCalculations();
1255 
1256         createShares(owner, feesShareQuantity); // Updates totalSupply by creating shares allocated to manager
1257 
1258         // Update Calculations
1259         uint highWaterMark = atLastUnclaimedFeeAllocation.highWaterMark >= sharePrice ? atLastUnclaimedFeeAllocation.highWaterMark : sharePrice;
1260         atLastUnclaimedFeeAllocation = Calculations({
1261             gav: gav,
1262             managementFee: managementFee,
1263             performanceFee: performanceFee,
1264             unclaimedFees: unclaimedFees,
1265             nav: nav,
1266             highWaterMark: highWaterMark,
1267             totalSupply: totalSupply,
1268             timestamp: now
1269         });
1270 
1271         FeesConverted(now, feesShareQuantity, unclaimedFees);
1272         CalculationUpdate(now, managementFee, performanceFee, nav, sharePrice, totalSupply);
1273     }
1274 
1275     // PUBLIC : REDEEMING
1276 
1277     /// @notice Redeems by allocating an ownership percentage only of requestedAssets to the participant
1278     /// @dev Independent of running price feed! Note: if requestedAssets != ownedAssets then participant misses out on some owned value
1279     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
1280     /// @param requestedAssets List of addresses that consitute a subset of ownedAssets.
1281     /// @return Whether all assets sent to shareholder or not
1282     function emergencyRedeem(uint shareQuantity, address[] requestedAssets)
1283         public
1284         pre_cond(balances[msg.sender] >= shareQuantity)  // sender owns enough shares
1285         returns (bool)
1286     {
1287         uint[] memory ownershipQuantities = new uint[](requestedAssets.length);
1288 
1289         // Check whether enough assets held by fund
1290         for (uint i = 0; i < requestedAssets.length; ++i) {
1291             address ofAsset = requestedAssets[i];
1292             uint assetHoldings = add(
1293                 uint(AssetInterface(ofAsset).balanceOf(this)),
1294                 quantityHeldInCustodyOfExchange(ofAsset)
1295             );
1296 
1297             if (assetHoldings == 0) continue;
1298 
1299             // participant's ownership percentage of asset holdings
1300             ownershipQuantities[i] = mul(assetHoldings, shareQuantity) / totalSupply;
1301 
1302             // CRITICAL ERR: Not enough fund asset balance for owed ownershipQuantitiy, eg in case of unreturned asset quantity at address(exchanges[i].exchange) address
1303             if (uint(AssetInterface(ofAsset).balanceOf(this)) < ownershipQuantities[i]) {
1304                 isShutDown = true;
1305                 ErrorMessage("CRITICAL ERR: Not enough assetHoldings for owed ownershipQuantitiy");
1306                 return false;
1307             }
1308         }
1309 
1310         // Annihilate shares before external calls to prevent reentrancy
1311         annihilateShares(msg.sender, shareQuantity);
1312 
1313         // Transfer ownershipQuantity of Assets
1314         for (uint j = 0; j < ownershipQuantities.length; ++j) {
1315             // Failed to send owed ownershipQuantity from fund to participant
1316             if (!AssetInterface(ofAsset).transfer(msg.sender, ownershipQuantities[j])) {
1317                 revert();
1318             }
1319         }
1320         Redeemed(msg.sender, now, shareQuantity);
1321         return true;
1322     }
1323 
1324     // PUBLIC : FEES
1325 
1326     /// @dev Quantity of asset held in exchange according to associated order id
1327     /// @param ofAsset Address of asset
1328     /// @return Quantity of input asset held in exchange
1329     function quantityHeldInCustodyOfExchange(address ofAsset) returns (uint) {
1330         uint totalSellQuantity;     // quantity in custody across exchanges
1331         uint totalSellQuantityInApprove; // quantity of asset in approve (allowance) but not custody of exchange
1332         for (uint i; i < exchanges.length; i++) {
1333             if (exchangeIdsToOpenMakeOrderIds[i][ofAsset] == 0) {
1334                 continue;
1335             }
1336             var (sellAsset, , sellQuantity, ) = exchanges[i].exchangeAdapter.getOrder(exchanges[i].exchange, exchangeIdsToOpenMakeOrderIds[i][ofAsset]);
1337             if (sellQuantity == 0) {
1338                 exchangeIdsToOpenMakeOrderIds[i][ofAsset] = 0;
1339             }
1340             totalSellQuantity = add(totalSellQuantity, sellQuantity);
1341             if (exchanges[i].isApproveOnly) {
1342                 totalSellQuantityInApprove += sellQuantity;
1343             }
1344         }
1345         if (totalSellQuantity == 0) {
1346             isInOpenMakeOrder[sellAsset] = false;
1347         }
1348         return sub(totalSellQuantity, totalSellQuantityInApprove); // Since quantity in approve is not actually in custody
1349     }
1350 
1351     // PUBLIC VIEW METHODS
1352 
1353     /// @notice Calculates sharePrice denominated in [base unit of melonAsset]
1354     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1355     function calcSharePrice() view returns (uint sharePrice) {
1356         (, , , , , sharePrice) = performCalculations();
1357         return sharePrice;
1358     }
1359 
1360     function getModules() view returns (address, address, address) {
1361         return (
1362             address(module.pricefeed),
1363             address(module.compliance),
1364             address(module.riskmgmt)
1365         );
1366     }
1367 
1368     function getLastOrderId() view returns (uint) { return orders.length - 1; }
1369     function getLastRequestId() view returns (uint) { return requests.length - 1; }
1370     function getNameHash() view returns (bytes32) { return bytes32(keccak256(name)); }
1371     function getManager() view returns (address) { return owner; }
1372 }
1373 
1374 interface ExchangeInterface {
1375 
1376     // EVENTS
1377 
1378     event OrderUpdated(uint id);
1379 
1380     // METHODS
1381     // EXTERNAL METHODS
1382 
1383     function makeOrder(
1384         address onExchange,
1385         address sellAsset,
1386         address buyAsset,
1387         uint sellQuantity,
1388         uint buyQuantity
1389     ) external returns (uint);
1390     function takeOrder(address onExchange, uint id, uint quantity) external returns (bool);
1391     function cancelOrder(address onExchange, uint id) external returns (bool);
1392 
1393 
1394     // PUBLIC METHODS
1395     // PUBLIC VIEW METHODS
1396 
1397     function isApproveOnly() view returns (bool);
1398     function getLastOrderId(address onExchange) view returns (uint);
1399     function isActive(address onExchange, uint id) view returns (bool);
1400     function getOwner(address onExchange, uint id) view returns (address);
1401     function getOrder(address onExchange, uint id) view returns (address, address, uint, uint);
1402     function getTimestamp(address onExchange, uint id) view returns (uint);
1403 
1404 }
1405 
1406 interface PriceFeedInterface {
1407 
1408     // EVENTS
1409 
1410     event PriceUpdated(uint timestamp);
1411 
1412     // PUBLIC METHODS
1413 
1414     function update(address[] ofAssets, uint[] newPrices);
1415 
1416     // PUBLIC VIEW METHODS
1417 
1418     // Get asset specific information
1419     function getName(address ofAsset) view returns (string);
1420     function getSymbol(address ofAsset) view returns (string);
1421     function getDecimals(address ofAsset) view returns (uint);
1422     // Get price feed operation specific information
1423     function getQuoteAsset() view returns (address);
1424     function getInterval() view returns (uint);
1425     function getValidity() view returns (uint);
1426     function getLastUpdateId() view returns (uint);
1427     // Get asset specific information as updated in price feed
1428     function hasRecentPrice(address ofAsset) view returns (bool isRecent);
1429     function hasRecentPrices(address[] ofAssets) view returns (bool areRecent);
1430     function getPrice(address ofAsset) view returns (bool isRecent, uint price, uint decimal);
1431     function getPrices(address[] ofAssets) view returns (bool areRecent, uint[] prices, uint[] decimals);
1432     function getInvertedPrice(address ofAsset) view returns (bool isRecent, uint invertedPrice, uint decimal);
1433     function getReferencePrice(address ofBase, address ofQuote) view returns (bool isRecent, uint referencePrice, uint decimal);
1434     function getOrderPrice(
1435         address sellAsset,
1436         address buyAsset,
1437         uint sellQuantity,
1438         uint buyQuantity
1439     ) view returns (uint orderPrice);
1440     function existsPriceOnAssetPair(address sellAsset, address buyAsset) view returns (bool isExistent);
1441 }
1442 
1443 interface RiskMgmtInterface {
1444 
1445     // METHODS
1446     // PUBLIC VIEW METHODS
1447 
1448     /// @notice Checks if the makeOrder price is reasonable and not manipulative
1449     /// @param orderPrice Price of Order
1450     /// @param referencePrice Reference price obtained through PriceFeed contract
1451     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
1452     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
1453     /// @param sellQuantity Quantity of sellAsset to be sold
1454     /// @param buyQuantity Quantity of buyAsset to be bought
1455     /// @return If makeOrder is permitted
1456     function isMakePermitted(
1457         uint orderPrice,
1458         uint referencePrice,
1459         address sellAsset,
1460         address buyAsset,
1461         uint sellQuantity,
1462         uint buyQuantity
1463     ) view returns (bool);
1464 
1465     /// @notice Checks if the takeOrder price is reasonable and not manipulative
1466     /// @param orderPrice Price of Order
1467     /// @param referencePrice Reference price obtained through PriceFeed contract
1468     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
1469     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
1470     /// @param sellQuantity Quantity of sellAsset to be sold
1471     /// @param buyQuantity Quantity of buyAsset to be bought
1472     /// @return If takeOrder is permitted
1473     function isTakePermitted(
1474         uint orderPrice,
1475         uint referencePrice,
1476         address sellAsset,
1477         address buyAsset,
1478         uint sellQuantity,
1479         uint buyQuantity
1480     ) view returns (bool);
1481 }
1482 
1483 interface VersionInterface {
1484 
1485     // EVENTS
1486 
1487     event FundUpdated(uint id);
1488 
1489     // PUBLIC METHODS
1490 
1491     function shutDown() external;
1492 
1493     function setupFund(
1494         string ofFundName,
1495         address ofQuoteAsset,
1496         uint ofManagementFee,
1497         uint ofPerformanceFee,
1498         address ofCompliance,
1499         address ofRiskMgmt,
1500         address ofPriceFeed,
1501         address[] ofExchanges,
1502         address[] ofExchangeAdapters,
1503         uint8 v,
1504         bytes32 r,
1505         bytes32 s
1506     );
1507     function shutDownFund(address ofFund);
1508 
1509     // PUBLIC VIEW METHODS
1510 
1511     function getNativeAsset() view returns (address);
1512     function getFundById(uint withId) view returns (address);
1513     function getLastFundId() view returns (uint);
1514     function getFundByManager(address ofManager) view returns (address);
1515     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
1516 
1517 }
1518 
1519 contract Version is DBC, Owned, VersionInterface {
1520     // FIELDS
1521 
1522     // Constant fields
1523     bytes32 public constant TERMS_AND_CONDITIONS = 0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad; // Hashed terms and conditions as displayed on IPFS.
1524     // Constructor fields
1525     string public VERSION_NUMBER; // SemVer of Melon protocol version
1526     address public NATIVE_ASSET; // Address of wrapped native asset contract
1527     address public GOVERNANCE; // Address of Melon protocol governance contract
1528     // Methods fields
1529     bool public isShutDown; // Governance feature, if yes than setupFund gets blocked and shutDownFund gets opened
1530     address[] public listOfFunds; // A complete list of fund addresses created using this version
1531     mapping (address => address) public managerToFunds; // Links manager address to fund address created using this version
1532 
1533     // EVENTS
1534 
1535     event FundUpdated(address ofFund);
1536 
1537     // METHODS
1538 
1539     // CONSTRUCTOR
1540 
1541     /// @param versionNumber SemVer of Melon protocol version
1542     /// @param ofGovernance Address of Melon governance contract
1543     /// @param ofNativeAsset Address of wrapped native asset contract
1544     function Version(
1545         string versionNumber,
1546         address ofGovernance,
1547         address ofNativeAsset
1548     ) {
1549         VERSION_NUMBER = versionNumber;
1550         GOVERNANCE = ofGovernance;
1551         NATIVE_ASSET = ofNativeAsset;
1552     }
1553 
1554     // EXTERNAL METHODS
1555 
1556     function shutDown() external pre_cond(msg.sender == GOVERNANCE) { isShutDown = true; }
1557 
1558     // PUBLIC METHODS
1559 
1560     /// @param ofFundName human-readable descriptive name (not necessarily unique)
1561     /// @param ofQuoteAsset Asset against which performance fee is measured against
1562     /// @param ofManagementFee A time based fee, given in a number which is divided by 10 ** 15
1563     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 10 ** 15
1564     /// @param ofCompliance Address of participation module
1565     /// @param ofRiskMgmt Address of risk management module
1566     /// @param ofPriceFeed Address of price feed module
1567     /// @param ofExchanges Addresses of exchange on which this fund can trade
1568     /// @param ofExchangeAdapters Addresses of exchange adapters
1569     /// @param v ellipitc curve parameter v
1570     /// @param r ellipitc curve parameter r
1571     /// @param s ellipitc curve parameter s
1572     function setupFund(
1573         string ofFundName,
1574         address ofQuoteAsset,
1575         uint ofManagementFee,
1576         uint ofPerformanceFee,
1577         address ofCompliance,
1578         address ofRiskMgmt,
1579         address ofPriceFeed,
1580         address[] ofExchanges,
1581         address[] ofExchangeAdapters,
1582         uint8 v,
1583         bytes32 r,
1584         bytes32 s
1585     ) {
1586         require(!isShutDown);
1587         require(termsAndConditionsAreSigned(v, r, s));
1588         // Either novel fund name or previous owner of fund name
1589         require(managerToFunds[msg.sender] == 0); // Add limitation for simpler migration process of shutting down and setting up fund
1590         address ofFund = new Fund(
1591             msg.sender,
1592             ofFundName,
1593             ofQuoteAsset,
1594             ofManagementFee,
1595             ofPerformanceFee,
1596             NATIVE_ASSET,
1597             ofCompliance,
1598             ofRiskMgmt,
1599             ofPriceFeed,
1600             ofExchanges,
1601             ofExchangeAdapters
1602         );
1603         listOfFunds.push(ofFund);
1604         managerToFunds[msg.sender] = ofFund;
1605         FundUpdated(ofFund);
1606     }
1607 
1608     /// @dev Dereference Fund and trigger selfdestruct
1609     /// @param ofFund Address of the fund to be shut down
1610     function shutDownFund(address ofFund)
1611         pre_cond(isShutDown || managerToFunds[msg.sender] == ofFund)
1612     {
1613         Fund fund = Fund(ofFund);
1614         delete managerToFunds[msg.sender];
1615         fund.shutDown();
1616         FundUpdated(ofFund);
1617     }
1618 
1619     // PUBLIC VIEW METHODS
1620 
1621     /// @dev Proof that terms and conditions have been read and understood
1622     /// @param v ellipitc curve parameter v
1623     /// @param r ellipitc curve parameter r
1624     /// @param s ellipitc curve parameter s
1625     /// @return signed Whether or not terms and conditions have been read and understood
1626     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed) {
1627         return ecrecover(
1628             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
1629             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
1630             //  it will return rsv (same as geth; where v is [27, 28]).
1631             // Note that if you are using ecrecover, v will be either "00" or "01".
1632             //  As a result, in order to use this value, you will have to parse it to an
1633             //  integer and then add 27. This will result in either a 27 or a 28.
1634             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
1635             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
1636             v,
1637             r,
1638             s
1639         ) == msg.sender; // Has sender signed TERMS_AND_CONDITIONS
1640     }
1641 
1642     function getNativeAsset() view returns (address) { return NATIVE_ASSET; }
1643     function getFundById(uint withId) view returns (address) { return listOfFunds[withId]; }
1644     function getLastFundId() view returns (uint) { return listOfFunds.length - 1; }
1645     function getFundByManager(address ofManager) view returns (address) { return managerToFunds[ofManager]; }
1646 }