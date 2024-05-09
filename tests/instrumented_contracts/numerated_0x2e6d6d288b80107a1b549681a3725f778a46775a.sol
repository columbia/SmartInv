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
363 }
364 
365 interface ERC223ReceivingContract {
366 
367     /// @dev Function that is called when a user or another contract wants to transfer funds.
368     /// @param _from Transaction initiator, analogue of msg.sender
369     /// @param _value Number of tokens to transfer.
370     /// @param _data Data containing a function signature and/or parameters
371     function tokenFallback(address _from, uint256 _value, bytes _data) public;
372 }
373 
374 interface NativeAssetInterface {
375 
376     // PUBLIC METHODS
377     function deposit() public payable;
378     function withdraw(uint wad) public;
379 }
380 
381 interface SharesInterface {
382 
383     event Created(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
384     event Annihilated(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
385 
386     // VIEW METHODS
387 
388     function getName() view returns (string);
389     function getSymbol() view returns (string);
390     function getDecimals() view returns (uint);
391     function getCreationTime() view returns (uint);
392     function toSmallestShareUnit(uint quantity) view returns (uint);
393     function toWholeShareUnit(uint quantity) view returns (uint);
394 
395 }
396 
397 contract Shares is Asset, SharesInterface {
398 
399     // FIELDS
400 
401     // Constructor fields
402     string public name;
403     string public symbol;
404     uint public decimal;
405     uint public creationTime;
406 
407     // METHODS
408 
409     // CONSTRUCTOR
410 
411     /// @param _name Name these shares
412     /// @param _symbol Symbol of shares
413     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
414     /// @param _creationTime Timestamp of share creation
415     function Shares(string _name, string _symbol, uint _decimal, uint _creationTime) {
416         name = _name;
417         symbol = _symbol;
418         decimal = _decimal;
419         creationTime = _creationTime;
420     }
421 
422     // PUBLIC METHODS
423     // PUBLIC VIEW METHODS
424 
425     function getName() view returns (string) { return name; }
426     function getSymbol() view returns (string) { return symbol; }
427     function getDecimals() view returns (uint) { return decimal; }
428     function getCreationTime() view returns (uint) { return creationTime; }
429     function toSmallestShareUnit(uint quantity) view returns (uint) { return mul(quantity, 10 ** getDecimals()); }
430     function toWholeShareUnit(uint quantity) view returns (uint) { return quantity / (10 ** getDecimals()); }
431     function transfer(address _to, uint256 _value) public returns (bool) { require(_to == address(this)); }
432     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) { require(_to == address(this)); }
433     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) { require(_to == address(this)); }
434 
435     // INTERNAL METHODS
436 
437     /// @param recipient Address the new shares should be sent to
438     /// @param shareQuantity Number of shares to be created
439     function createShares(address recipient, uint shareQuantity) internal {
440         totalSupply = add(totalSupply, shareQuantity);
441         balances[recipient] = add(balances[recipient], shareQuantity);
442         Created(msg.sender, now, shareQuantity);
443     }
444 
445     /// @param recipient Address the new shares should be taken from when destroyed
446     /// @param shareQuantity Number of shares to be annihilated
447     function annihilateShares(address recipient, uint shareQuantity) internal {
448         totalSupply = sub(totalSupply, shareQuantity);
449         balances[recipient] = sub(balances[recipient], shareQuantity);
450         Annihilated(msg.sender, now, shareQuantity);
451     }
452 }
453 
454 contract RestrictedShares is Shares {
455 
456     // CONSTRUCTOR
457 
458     /// @param _name Name these shares
459     /// @param _symbol Symbol of shares
460     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
461     /// @param _creationTime Timestamp of share creation
462     function RestrictedShares(
463         string _name,
464         string _symbol,
465         uint _decimal,
466         uint _creationTime
467     ) Shares(_name, _symbol, _decimal, _creationTime) {}
468 
469     // PUBLIC METHODS
470 
471     /**
472      * @notice Send `_value` tokens to `_to` from `msg.sender`
473      * @dev Transfers sender's tokens to a given address
474      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
475      * @param _to Address of token receiver
476      * @param _value Number of tokens to transfer
477      * @return Returns success of function call
478      */
479     function transfer(address _to, uint _value)
480         public
481         returns (bool success)
482     {
483         require(msg.sender == address(this) || _to == address(this));
484         uint codeLength;
485         bytes memory empty;
486 
487         assembly {
488             // Retrieve the size of the code on target address, this needs assembly.
489             codeLength := extcodesize(_to)
490         }
491 
492         require(balances[msg.sender] >= _value); // sanity checks
493         require(balances[_to] + _value >= balances[_to]);
494 
495         balances[msg.sender] = sub(balances[msg.sender], _value);
496         balances[_to] = add(balances[_to], _value);
497         if (codeLength > 0) {
498             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
499             receiver.tokenFallback(msg.sender, _value, empty);
500         }
501         Transfer(msg.sender, _to, _value, empty);
502         return true;
503     }
504 
505     /**
506      * @notice Send `_value` tokens to `_to` from `msg.sender` and trigger tokenFallback if sender is a contract
507      * @dev Function that is called when a user or contract wants to transfer funds
508      * @param _to Address of token receiver
509      * @param _value Number of tokens to transfer
510      * @param _data Data to be sent to tokenFallback
511      * @return Returns success of function call
512      */
513     function transfer(address _to, uint _value, bytes _data)
514         public
515         returns (bool success)
516     {
517         require(msg.sender == address(this) || _to == address(this));
518         uint codeLength;
519 
520         assembly {
521             // Retrieve the size of the code on target address, this needs assembly.
522             codeLength := extcodesize(_to)
523         }
524 
525         require(balances[msg.sender] >= _value); // sanity checks
526         require(balances[_to] + _value >= balances[_to]);
527 
528         balances[msg.sender] = sub(balances[msg.sender], _value);
529         balances[_to] = add(balances[_to], _value);
530         if (codeLength > 0) {
531             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
532             receiver.tokenFallback(msg.sender, _value, _data);
533         }
534         Transfer(msg.sender, _to, _value);
535         return true;
536     }
537 
538     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
539     /// @dev Sets approved amount of tokens for spender. Returns success.
540     /// @param _spender Address of allowed account.
541     /// @param _value Number of approved tokens.
542     /// @return Returns success of function call.
543     function approve(address _spender, uint _value) public returns (bool) {
544         require(msg.sender == address(this));
545         require(_spender != 0x0);
546 
547         // To change the approve amount you first have to reduce the addresses`
548         // allowance to zero by calling `approve(_spender, 0)` if it is not
549         // already 0 to mitigate the race condition described here:
550         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
551         require(_value == 0 || allowed[msg.sender][_spender] == 0);
552 
553         allowed[msg.sender][_spender] = _value;
554         Approval(msg.sender, _spender, _value);
555         return true;
556     }
557 
558 }
559 
560 interface ComplianceInterface {
561 
562     // PUBLIC VIEW METHODS
563 
564     /// @notice Checks whether investment is permitted for a participant
565     /// @param ofParticipant Address requesting to invest in a Melon fund
566     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
567     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
568     /// @return Whether identity is eligible to invest in a Melon fund.
569     function isInvestmentPermitted(
570         address ofParticipant,
571         uint256 giveQuantity,
572         uint256 shareQuantity
573     ) view returns (bool);
574 
575     /// @notice Checks whether redemption is permitted for a participant
576     /// @param ofParticipant Address requesting to redeem from a Melon fund
577     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
578     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
579     /// @return Whether identity is eligible to redeem from a Melon fund.
580     function isRedemptionPermitted(
581         address ofParticipant,
582         uint256 shareQuantity,
583         uint256 receiveQuantity
584     ) view returns (bool);
585 }
586 
587 contract DBC {
588 
589     // MODIFIERS
590 
591     modifier pre_cond(bool condition) {
592         require(condition);
593         _;
594     }
595 
596     modifier post_cond(bool condition) {
597         _;
598         assert(condition);
599     }
600 
601     modifier invariant(bool condition) {
602         require(condition);
603         _;
604         assert(condition);
605     }
606 }
607 
608 contract Owned is DBC {
609 
610     // FIELDS
611 
612     address public owner;
613 
614     // NON-CONSTANT METHODS
615 
616     function Owned() { owner = msg.sender; }
617 
618     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
619 
620     // PRE, POST, INVARIANT CONDITIONS
621 
622     function isOwner() internal returns (bool) { return msg.sender == owner; }
623 
624 }
625 
626 contract Fund is DSMath, DBC, Owned, RestrictedShares, FundInterface, ERC223ReceivingContract {
627     // TYPES
628 
629     struct Modules { // Describes all modular parts, standardised through an interface
630         PriceFeedInterface pricefeed; // Provides all external data
631         ComplianceInterface compliance; // Boolean functions regarding invest/redeem
632         RiskMgmtInterface riskmgmt; // Boolean functions regarding make/take orders
633     }
634 
635     struct Calculations { // List of internal calculations
636         uint gav; // Gross asset value
637         uint managementFee; // Time based fee
638         uint performanceFee; // Performance based fee measured against QUOTE_ASSET
639         uint unclaimedFees; // Fees not yet allocated to the fund manager
640         uint nav; // Net asset value
641         uint highWaterMark; // A record of best all-time fund performance
642         uint totalSupply; // Total supply of shares
643         uint timestamp; // Time when calculations are performed in seconds
644     }
645 
646     enum RequestStatus { active, cancelled, executed }
647     enum RequestType { invest, redeem, tokenFallbackRedeem }
648     struct Request { // Describes and logs whenever asset enter and leave fund due to Participants
649         address participant; // Participant in Melon fund requesting investment or redemption
650         RequestStatus status; // Enum: active, cancelled, executed; Status of request
651         RequestType requestType; // Enum: invest, redeem, tokenFallbackRedeem
652         address requestAsset; // Address of the asset being requested
653         uint shareQuantity; // Quantity of Melon fund shares
654         uint giveQuantity; // Quantity in Melon asset to give to Melon fund to receive shareQuantity
655         uint receiveQuantity; // Quantity in Melon asset to receive from Melon fund for given shareQuantity
656         uint timestamp;     // Time of request creation in seconds
657         uint atUpdateId;    // Pricefeed updateId when this request was created
658     }
659 
660     enum OrderStatus { active, partiallyFilled, fullyFilled, cancelled }
661     enum OrderType { make, take }
662     struct Order { // Describes and logs whenever assets enter and leave fund due to Manager
663         uint exchangeId; // Id as returned from exchange
664         OrderStatus status; // Enum: active, partiallyFilled, fullyFilled, cancelled
665         OrderType orderType; // Enum: make, take
666         address sellAsset; // Asset (as registered in Asset registrar) to be sold
667         address buyAsset; // Asset (as registered in Asset registrar) to be bought
668         uint sellQuantity; // Quantity of sellAsset to be sold
669         uint buyQuantity; // Quantity of sellAsset to be bought
670         uint timestamp; // Time of order creation in seconds
671         uint fillQuantity; // Buy quantity filled; Always less than buy_quantity
672     }
673 
674     struct Exchange {
675         address exchange; // Address of the exchange
676         ExchangeInterface exchangeAdapter; //Exchange adapter contracts respective to the exchange
677         bool isApproveOnly; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
678     }
679 
680     // FIELDS
681 
682     // Constant fields
683     uint public constant MAX_FUND_ASSETS = 90; // Max ownable assets by the fund supported by gas limits
684     // Constructor fields
685     uint public MANAGEMENT_FEE_RATE; // Fee rate in QUOTE_ASSET per delta improvement in WAD
686     uint public PERFORMANCE_FEE_RATE; // Fee rate in QUOTE_ASSET per managed seconds in WAD
687     address public VERSION; // Address of Version contract
688     Asset public QUOTE_ASSET; // QUOTE asset as ERC20 contract
689     NativeAssetInterface public NATIVE_ASSET; // Native asset as ERC20 contract
690     // Methods fields
691     Modules public module; // Struct which holds all the initialised module instances
692     Exchange[] public exchanges; // Array containing exchanges this fund supports
693     Calculations public atLastUnclaimedFeeAllocation; // Calculation results at last allocateUnclaimedFees() call
694     bool public isShutDown; // Security feature, if yes than investing, managing, allocateUnclaimedFees gets blocked
695     Request[] public requests; // All the requests this fund received from participants
696     bool public isInvestAllowed; // User option, if false fund rejects Melon investments
697     bool public isRedeemAllowed; // User option, if false fund rejects Melon redemptions; Redemptions using slices always possible
698     Order[] public orders; // All the orders this fund placed on exchanges
699     mapping (uint => mapping(address => uint)) public exchangeIdsToOpenMakeOrderIds; // exchangeIndex to: asset to open make order ID ; if no open make orders, orderID is zero
700     address[] public ownedAssets; // List of all assets owned by the fund or for which the fund has open make orders
701     mapping (address => bool) public isInAssetList; // Mapping from asset to whether the asset exists in ownedAssets
702     mapping (address => bool) public isInOpenMakeOrder; // Mapping from asset to whether the asset is in a open make order as buy asset
703 
704     // METHODS
705 
706     // CONSTRUCTOR
707 
708     /// @dev Should only be called via Version.setupFund(..)
709     /// @param withName human-readable descriptive name (not necessarily unique)
710     /// @param ofQuoteAsset Asset against which mgmt and performance fee is measured against and which can be used to invest/redeem using this single asset
711     /// @param ofManagementFee A time based fee expressed, given in a number which is divided by 1 WAD
712     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 1 WAD
713     /// @param ofCompliance Address of compliance module
714     /// @param ofRiskMgmt Address of risk management module
715     /// @param ofPriceFeed Address of price feed module
716     /// @param ofExchanges Addresses of exchange on which this fund can trade
717     /// @param ofExchangeAdapters Addresses of exchange adapters
718     /// @return Deployed Fund with manager set as ofManager
719     function Fund(
720         address ofManager,
721         string withName,
722         address ofQuoteAsset,
723         uint ofManagementFee,
724         uint ofPerformanceFee,
725         address ofNativeAsset,
726         address ofCompliance,
727         address ofRiskMgmt,
728         address ofPriceFeed,
729         address[] ofExchanges,
730         address[] ofExchangeAdapters
731     )
732         RestrictedShares(withName, "MLNF", 18, now)
733     {
734         isInvestAllowed = true;
735         isRedeemAllowed = true;
736         owner = ofManager;
737         require(ofManagementFee < 10 ** 18); // Require management fee to be less than 100 percent
738         MANAGEMENT_FEE_RATE = ofManagementFee; // 1 percent is expressed as 0.01 * 10 ** 18
739         require(ofPerformanceFee < 10 ** 18); // Require performance fee to be less than 100 percent
740         PERFORMANCE_FEE_RATE = ofPerformanceFee; // 1 percent is expressed as 0.01 * 10 ** 18
741         VERSION = msg.sender;
742         module.compliance = ComplianceInterface(ofCompliance);
743         module.riskmgmt = RiskMgmtInterface(ofRiskMgmt);
744         module.pricefeed = PriceFeedInterface(ofPriceFeed);
745         // Bridged to Melon exchange interface by exchangeAdapter library
746         for (uint i = 0; i < ofExchanges.length; ++i) {
747             ExchangeInterface adapter = ExchangeInterface(ofExchangeAdapters[i]);
748             bool isApproveOnly = adapter.isApproveOnly();
749             exchanges.push(Exchange({
750                 exchange: ofExchanges[i],
751                 exchangeAdapter: adapter,
752                 isApproveOnly: isApproveOnly
753             }));
754         }
755         // Require Quote assets exists in pricefeed
756         QUOTE_ASSET = Asset(ofQuoteAsset);
757         NATIVE_ASSET = NativeAssetInterface(ofNativeAsset);
758         // Quote Asset and Native asset always in owned assets list
759         ownedAssets.push(ofQuoteAsset);
760         isInAssetList[ofQuoteAsset] = true;
761         ownedAssets.push(ofNativeAsset);
762         isInAssetList[ofNativeAsset] = true;
763         require(address(QUOTE_ASSET) == module.pricefeed.getQuoteAsset()); // Sanity check
764         atLastUnclaimedFeeAllocation = Calculations({
765             gav: 0,
766             managementFee: 0,
767             performanceFee: 0,
768             unclaimedFees: 0,
769             nav: 0,
770             highWaterMark: 10 ** getDecimals(),
771             totalSupply: totalSupply,
772             timestamp: now
773         });
774     }
775 
776     // EXTERNAL METHODS
777 
778     // EXTERNAL : ADMINISTRATION
779 
780     function enableInvestment() external pre_cond(isOwner()) { isInvestAllowed = true; }
781     function disableInvestment() external pre_cond(isOwner()) { isInvestAllowed = false; }
782     function enableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = true; }
783     function disableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = false; }
784     function shutDown() external pre_cond(msg.sender == VERSION) { isShutDown = true; }
785 
786 
787     // EXTERNAL : PARTICIPATION
788 
789     /// @notice Give melon tokens to receive shares of this fund
790     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
791     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
792     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
793     function requestInvestment(
794         uint giveQuantity,
795         uint shareQuantity,
796         bool isNativeAsset
797     )
798         external
799         pre_cond(!isShutDown)
800         pre_cond(isInvestAllowed) // investment using Melon has not been deactivated by the Manager
801         pre_cond(module.compliance.isInvestmentPermitted(msg.sender, giveQuantity, shareQuantity))    // Compliance Module: Investment permitted
802     {
803         requests.push(Request({
804             participant: msg.sender,
805             status: RequestStatus.active,
806             requestType: RequestType.invest,
807             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
808             shareQuantity: shareQuantity,
809             giveQuantity: giveQuantity,
810             receiveQuantity: shareQuantity,
811             timestamp: now,
812             atUpdateId: module.pricefeed.getLastUpdateId()
813         }));
814         RequestUpdated(getLastRequestId());
815     }
816 
817     /// @notice Give shares of this fund to receive melon tokens
818     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
819     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
820     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
821     function requestRedemption(
822         uint shareQuantity,
823         uint receiveQuantity,
824         bool isNativeAsset
825       )
826         external
827         pre_cond(!isShutDown)
828         pre_cond(isRedeemAllowed) // Redemption using Melon has not been deactivated by Manager
829         pre_cond(module.compliance.isRedemptionPermitted(msg.sender, shareQuantity, receiveQuantity)) // Compliance Module: Redemption permitted
830     {
831         requests.push(Request({
832             participant: msg.sender,
833             status: RequestStatus.active,
834             requestType: RequestType.redeem,
835             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
836             shareQuantity: shareQuantity,
837             giveQuantity: shareQuantity,
838             receiveQuantity: receiveQuantity,
839             timestamp: now,
840             atUpdateId: module.pricefeed.getLastUpdateId()
841         }));
842         RequestUpdated(getLastRequestId());
843     }
844 
845     /// @notice Executes active investment and redemption requests, in a way that minimises information advantages of investor
846     /// @dev Distributes melon and shares according to the request
847     /// @param id Index of request to be executed
848     /// @dev Active investment or redemption request executed
849     function executeRequest(uint id)
850         external
851         pre_cond(!isShutDown)
852         pre_cond(requests[id].status == RequestStatus.active)
853         pre_cond(requests[id].requestType != RequestType.redeem || requests[id].shareQuantity <= balances[requests[id].participant]) // request owner does not own enough shares
854         pre_cond(
855             totalSupply == 0 ||
856             (
857                 now >= add(requests[id].timestamp, module.pricefeed.getInterval()) &&
858                 module.pricefeed.getLastUpdateId() >= add(requests[id].atUpdateId, 2)
859             )
860         )   // PriceFeed Module: Wait at least one interval time and two updates before continuing (unless it is the first investment)
861          // PriceFeed Module: No recent updates for fund asset list
862     {
863         // sharePrice quoted in QUOTE_ASSET and multiplied by 10 ** fundDecimals
864         // based in QUOTE_ASSET and multiplied by 10 ** fundDecimals
865         require(module.pricefeed.hasRecentPrice(address(QUOTE_ASSET)));
866         require(module.pricefeed.hasRecentPrices(ownedAssets));
867         var (isRecent, , ) = module.pricefeed.getInvertedPrice(address(QUOTE_ASSET));
868         // TODO: check precision of below otherwise use; uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePrice()));
869         // By definition quoteDecimals == fundDecimals
870         Request request = requests[id];
871 
872         uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePrice()));
873         if (request.requestAsset == address(NATIVE_ASSET)) {
874             var (isPriceRecent, invertedNativeAssetPrice, nativeAssetDecimal) = module.pricefeed.getInvertedPrice(address(NATIVE_ASSET));
875             if (!isPriceRecent) {
876                 revert();
877             }
878             costQuantity = mul(costQuantity, invertedNativeAssetPrice) / 10 ** nativeAssetDecimal;
879         }
880 
881         if (
882             isInvestAllowed &&
883             request.requestType == RequestType.invest &&
884             costQuantity <= request.giveQuantity
885         ) {
886             request.status = RequestStatus.executed;
887             assert(AssetInterface(request.requestAsset).transferFrom(request.participant, this, costQuantity)); // Allocate Value
888             createShares(request.participant, request.shareQuantity); // Accounting
889         } else if (
890             isRedeemAllowed &&
891             request.requestType == RequestType.redeem &&
892             request.receiveQuantity <= costQuantity
893         ) {
894             request.status = RequestStatus.executed;
895             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
896             annihilateShares(request.participant, request.shareQuantity); // Accounting
897         } else if (
898             isRedeemAllowed &&
899             request.requestType == RequestType.tokenFallbackRedeem &&
900             request.receiveQuantity <= costQuantity
901         ) {
902             request.status = RequestStatus.executed;
903             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
904             annihilateShares(this, request.shareQuantity); // Accounting
905         } else {
906             revert(); // Invalid Request or invalid giveQuantity / receiveQuantity
907         }
908     }
909 
910     /// @notice Cancels active investment and redemption requests
911     /// @param id Index of request to be executed
912     function cancelRequest(uint id)
913         external
914         pre_cond(requests[id].status == RequestStatus.active) // Request is active
915         pre_cond(requests[id].participant == msg.sender || isShutDown) // Either request creator or fund is shut down
916     {
917         requests[id].status = RequestStatus.cancelled;
918     }
919 
920     /// @notice Redeems by allocating an ownership percentage of each asset to the participant
921     /// @dev Independent of running price feed!
922     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
923     /// @return Whether all assets sent to shareholder or not
924     function redeemAllOwnedAssets(uint shareQuantity)
925         external
926         returns (bool success)
927     {
928         return emergencyRedeem(shareQuantity, ownedAssets);
929     }
930 
931     // EXTERNAL : MANAGING
932 
933     /// @notice Makes an order on the selected exchange
934     /// @dev These are orders that are not expected to settle immediately.  Sufficient balance (== sellQuantity) of sellAsset
935     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
936     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
937     /// @param sellQuantity Quantity of sellAsset to be sold
938     /// @param buyQuantity Quantity of buyAsset to be bought
939     function makeOrder(
940         uint exchangeNumber,
941         address sellAsset,
942         address buyAsset,
943         uint sellQuantity,
944         uint buyQuantity
945     )
946         external
947         pre_cond(isOwner())
948         pre_cond(!isShutDown)
949     {
950         require(buyAsset != address(this)); // Prevent buying of own fund token
951         require(quantityHeldInCustodyOfExchange(sellAsset) == 0); // Curr only one make order per sellAsset allowed. Please wait or cancel existing make order.
952         require(module.pricefeed.existsPriceOnAssetPair(sellAsset, buyAsset)); // PriceFeed module: Requested asset pair not valid
953         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(sellAsset, buyAsset);
954         require(isRecent);  // Reference price is required to be recent
955         require(
956             module.riskmgmt.isMakePermitted(
957                 module.pricefeed.getOrderPrice(
958                     sellAsset,
959                     buyAsset,
960                     sellQuantity,
961                     buyQuantity
962                 ),
963                 referencePrice,
964                 sellAsset,
965                 buyAsset,
966                 sellQuantity,
967                 buyQuantity
968             )
969         ); // RiskMgmt module: Make order not permitted
970         require(isInAssetList[buyAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
971         require(AssetInterface(sellAsset).approve(exchanges[exchangeNumber].exchange, sellQuantity)); // Approve exchange to spend assets
972 
973         // Since there is only one openMakeOrder allowed for each asset, we can assume that openMakeOrderId is set as zero by quantityHeldInCustodyOfExchange() function
974         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("makeOrder(address,address,address,uint256,uint256)")), exchanges[exchangeNumber].exchange, sellAsset, buyAsset, sellQuantity, buyQuantity));
975         exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] = exchanges[exchangeNumber].exchangeAdapter.getLastOrderId(exchanges[exchangeNumber].exchange);
976 
977         // Success defined as non-zero order id
978         require(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] != 0);
979 
980         // Update ownedAssets array and isInAssetList, isInOpenMakeOrder mapping
981         isInOpenMakeOrder[buyAsset] = true;
982         if (!isInAssetList[buyAsset]) {
983             ownedAssets.push(buyAsset);
984             isInAssetList[buyAsset] = true;
985         }
986 
987         orders.push(Order({
988             exchangeId: exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset],
989             status: OrderStatus.active,
990             orderType: OrderType.make,
991             sellAsset: sellAsset,
992             buyAsset: buyAsset,
993             sellQuantity: sellQuantity,
994             buyQuantity: buyQuantity,
995             timestamp: now,
996             fillQuantity: 0
997         }));
998 
999         OrderUpdated(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset]);
1000     }
1001 
1002     /// @notice Takes an active order on the selected exchange
1003     /// @dev These are orders that are expected to settle immediately
1004     /// @param id Active order id
1005     /// @param receiveQuantity Buy quantity of what others are selling on selected Exchange
1006     function takeOrder(uint exchangeNumber, uint id, uint receiveQuantity)
1007         external
1008         pre_cond(isOwner())
1009         pre_cond(!isShutDown)
1010     {
1011         // Get information of order by order id
1012         Order memory order; // Inverse variable terminology! Buying what another person is selling
1013         (
1014             order.sellAsset,
1015             order.buyAsset,
1016             order.sellQuantity,
1017             order.buyQuantity
1018         ) = exchanges[exchangeNumber].exchangeAdapter.getOrder(exchanges[exchangeNumber].exchange, id);
1019         // Check pre conditions
1020         require(order.sellAsset != address(this)); // Prevent buying of own fund token
1021         require(module.pricefeed.existsPriceOnAssetPair(order.buyAsset, order.sellAsset)); // PriceFeed module: Requested asset pair not valid
1022         require(isInAssetList[order.sellAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
1023         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(order.buyAsset, order.sellAsset);
1024         require(isRecent); // Reference price is required to be recent
1025         require(receiveQuantity <= order.sellQuantity); // Not enough quantity of order for what is trying to be bought
1026         uint spendQuantity = mul(receiveQuantity, order.buyQuantity) / order.sellQuantity;
1027         require(AssetInterface(order.buyAsset).approve(exchanges[exchangeNumber].exchange, spendQuantity)); // Could not approve spending of spendQuantity of order.buyAsset
1028         require(
1029             module.riskmgmt.isTakePermitted(
1030             module.pricefeed.getOrderPrice(
1031                 order.buyAsset,
1032                 order.sellAsset,
1033                 order.buyQuantity, // spendQuantity
1034                 order.sellQuantity // receiveQuantity
1035             ),
1036             referencePrice,
1037             order.buyAsset,
1038             order.sellAsset,
1039             order.buyQuantity,
1040             order.sellQuantity
1041         )); // RiskMgmt module: Take order not permitted
1042 
1043         // Execute request
1044         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("takeOrder(address,uint256,uint256)")), exchanges[exchangeNumber].exchange, id, receiveQuantity));
1045 
1046         // Update ownedAssets array and isInAssetList mapping
1047         if (!isInAssetList[order.sellAsset]) {
1048             ownedAssets.push(order.sellAsset);
1049             isInAssetList[order.sellAsset] = true;
1050         }
1051 
1052         order.exchangeId = id;
1053         order.status = OrderStatus.fullyFilled;
1054         order.orderType = OrderType.take;
1055         order.timestamp = now;
1056         order.fillQuantity = receiveQuantity;
1057         orders.push(order);
1058         OrderUpdated(id);
1059     }
1060 
1061     /// @notice Cancels orders that were not expected to settle immediately, i.e. makeOrders
1062     /// @dev Reduce exposure with exchange interaction
1063     /// @param id Active order id of this order array with order owner of this contract on selected Exchange
1064     function cancelOrder(uint exchangeNumber, uint id)
1065         external
1066         pre_cond(isOwner() || isShutDown)
1067     {
1068         // Get information of fund order by order id
1069         Order order = orders[id];
1070 
1071         // Execute request
1072         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("cancelOrder(address,uint256)")), exchanges[exchangeNumber].exchange, order.exchangeId));
1073 
1074         order.status = OrderStatus.cancelled;
1075         OrderUpdated(id);
1076     }
1077 
1078 
1079     // PUBLIC METHODS
1080 
1081     // PUBLIC METHODS : ERC223
1082 
1083     /// @dev Standard ERC223 function that handles incoming token transfers.
1084     /// @dev This type of redemption can be seen as a "market order", where price is calculated at execution time
1085     /// @param ofSender  Token sender address.
1086     /// @param tokenAmount Amount of tokens sent.
1087     /// @param metadata  Transaction metadata.
1088     function tokenFallback(
1089         address ofSender,
1090         uint tokenAmount,
1091         bytes metadata
1092     ) {
1093         if (msg.sender != address(this)) {
1094             // when ofSender is a recognized exchange, receive tokens, otherwise revert
1095             for (uint i; i < exchanges.length; i++) {
1096                 if (exchanges[i].exchange == ofSender) return; // receive tokens and do nothing
1097             }
1098             revert();
1099         } else {    // otherwise, make a redemption request
1100             requests.push(Request({
1101                 participant: ofSender,
1102                 status: RequestStatus.active,
1103                 requestType: RequestType.tokenFallbackRedeem,
1104                 requestAsset: address(QUOTE_ASSET), // redeem in QUOTE_ASSET
1105                 shareQuantity: tokenAmount,
1106                 giveQuantity: tokenAmount,              // shares being sent
1107                 receiveQuantity: 0,          // value of the shares at request time
1108                 timestamp: now,
1109                 atUpdateId: module.pricefeed.getLastUpdateId()
1110             }));
1111             RequestUpdated(getLastRequestId());
1112         }
1113     }
1114 
1115 
1116     // PUBLIC METHODS : ACCOUNTING
1117 
1118     /// @notice Calculates gross asset value of the fund
1119     /// @dev Decimals in assets must be equal to decimals in PriceFeed for all entries in AssetRegistrar
1120     /// @dev Assumes that module.pricefeed.getPrice(..) returns recent prices
1121     /// @return gav Gross asset value quoted in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1122     function calcGav() returns (uint gav) {
1123         // prices quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
1124         address[] memory tempOwnedAssets; // To store ownedAssets
1125         tempOwnedAssets = ownedAssets;
1126         delete ownedAssets;
1127         for (uint i = 0; i < tempOwnedAssets.length; ++i) {
1128             address ofAsset = tempOwnedAssets[i];
1129             // assetHoldings formatting: mul(exchangeHoldings, 10 ** assetDecimal)
1130             uint assetHoldings = add(
1131                 uint(AssetInterface(ofAsset).balanceOf(this)), // asset base units held by fund
1132                 quantityHeldInCustodyOfExchange(ofAsset)
1133             );
1134             // assetPrice formatting: mul(exchangePrice, 10 ** assetDecimal)
1135             var (isRecent, assetPrice, assetDecimals) = module.pricefeed.getPrice(ofAsset);
1136             if (!isRecent) {
1137                 revert();
1138             }
1139             // gav as sum of mul(assetHoldings, assetPrice) with formatting: mul(mul(exchangeHoldings, exchangePrice), 10 ** shareDecimals)
1140             gav = add(gav, mul(assetHoldings, assetPrice) / (10 ** uint256(assetDecimals)));   // Sum up product of asset holdings of this vault and asset prices
1141             if (assetHoldings != 0 || ofAsset == address(QUOTE_ASSET) || ofAsset == address(NATIVE_ASSET) || isInOpenMakeOrder[ofAsset]) { // Check if asset holdings is not zero or is address(QUOTE_ASSET) or in open make order
1142                 ownedAssets.push(ofAsset);
1143             } else {
1144                 isInAssetList[ofAsset] = false; // Remove from ownedAssets if asset holdings are zero
1145             }
1146             PortfolioContent(assetHoldings, assetPrice, assetDecimals);
1147         }
1148     }
1149 
1150     /**
1151     @notice Calculates unclaimed fees of the fund manager
1152     @param gav Gross asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1153     @return {
1154       "managementFees": "A time (seconds) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1155       "performanceFees": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1156       "unclaimedfees": "The sum of both managementfee and performancefee in QUOTE_ASSET and multiplied by 10 ** shareDecimals"
1157     }
1158     */
1159     function calcUnclaimedFees(uint gav)
1160         view
1161         returns (
1162             uint managementFee,
1163             uint performanceFee,
1164             uint unclaimedFees)
1165     {
1166         // Management fee calculation
1167         uint timePassed = sub(now, atLastUnclaimedFeeAllocation.timestamp);
1168         uint gavPercentage = mul(timePassed, gav) / (1 years);
1169         managementFee = wmul(gavPercentage, MANAGEMENT_FEE_RATE);
1170 
1171         // Performance fee calculation
1172         // Handle potential division through zero by defining a default value
1173         uint valuePerShareExclMgmtFees = totalSupply > 0 ? calcValuePerShare(sub(gav, managementFee), totalSupply) : toSmallestShareUnit(1);
1174         if (valuePerShareExclMgmtFees > atLastUnclaimedFeeAllocation.highWaterMark) {
1175             uint gainInSharePrice = sub(valuePerShareExclMgmtFees, atLastUnclaimedFeeAllocation.highWaterMark);
1176             uint investmentProfits = wmul(gainInSharePrice, totalSupply);
1177             performanceFee = wmul(investmentProfits, PERFORMANCE_FEE_RATE);
1178         }
1179 
1180         // Sum of all FEES
1181         unclaimedFees = add(managementFee, performanceFee);
1182     }
1183 
1184     /// @notice Calculates the Net asset value of this fund
1185     /// @param gav Gross asset value of this fund in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1186     /// @param unclaimedFees The sum of both managementFee and performanceFee in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1187     /// @return nav Net asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1188     function calcNav(uint gav, uint unclaimedFees)
1189         view
1190         returns (uint nav)
1191     {
1192         nav = sub(gav, unclaimedFees);
1193     }
1194 
1195     /// @notice Calculates the share price of the fund
1196     /// @dev Convention for valuePerShare (== sharePrice) formatting: mul(totalValue / numShares, 10 ** decimal), to avoid floating numbers
1197     /// @dev Non-zero share supply; value denominated in [base unit of melonAsset]
1198     /// @param totalValue the total value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1199     /// @param numShares the number of shares multiplied by 10 ** shareDecimals
1200     /// @return valuePerShare Share price denominated in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1201     function calcValuePerShare(uint totalValue, uint numShares)
1202         view
1203         pre_cond(numShares > 0)
1204         returns (uint valuePerShare)
1205     {
1206         valuePerShare = toSmallestShareUnit(totalValue) / numShares;
1207     }
1208 
1209     /**
1210     @notice Calculates essential fund metrics
1211     @return {
1212       "gav": "Gross asset value of this fund denominated in [base unit of melonAsset]",
1213       "managementFee": "A time (seconds) based fee",
1214       "performanceFee": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee",
1215       "unclaimedFees": "The sum of both managementFee and performanceFee denominated in [base unit of melonAsset]",
1216       "feesShareQuantity": "The number of shares to be given as fees to the manager",
1217       "nav": "Net asset value denominated in [base unit of melonAsset]",
1218       "sharePrice": "Share price denominated in [base unit of melonAsset]"
1219     }
1220     */
1221     function performCalculations()
1222         view
1223         returns (
1224             uint gav,
1225             uint managementFee,
1226             uint performanceFee,
1227             uint unclaimedFees,
1228             uint feesShareQuantity,
1229             uint nav,
1230             uint sharePrice
1231         )
1232     {
1233         gav = calcGav(); // Reflects value independent of fees
1234         (managementFee, performanceFee, unclaimedFees) = calcUnclaimedFees(gav);
1235         nav = calcNav(gav, unclaimedFees);
1236 
1237         // The value of unclaimedFees measured in shares of this fund at current value
1238         feesShareQuantity = (gav == 0) ? 0 : mul(totalSupply, unclaimedFees) / gav;
1239         // The total share supply including the value of unclaimedFees, measured in shares of this fund
1240         uint totalSupplyAccountingForFees = add(totalSupply, feesShareQuantity);
1241         sharePrice = nav > 0 ? calcValuePerShare(nav, totalSupplyAccountingForFees) : toSmallestShareUnit(1); // Handle potential division through zero by defining a default value
1242     }
1243 
1244     /// @notice Converts unclaimed fees of the manager into fund shares
1245     /// @dev Only Owner
1246     function allocateUnclaimedFees()
1247         pre_cond(isOwner())
1248     {
1249         var (
1250             gav,
1251             managementFee,
1252             performanceFee,
1253             unclaimedFees,
1254             feesShareQuantity,
1255             nav,
1256             sharePrice
1257         ) = performCalculations();
1258 
1259         createShares(owner, feesShareQuantity); // Updates totalSupply by creating shares allocated to manager
1260 
1261         // Update Calculations
1262         uint highWaterMark = atLastUnclaimedFeeAllocation.highWaterMark >= sharePrice ? atLastUnclaimedFeeAllocation.highWaterMark : sharePrice;
1263         atLastUnclaimedFeeAllocation = Calculations({
1264             gav: gav,
1265             managementFee: managementFee,
1266             performanceFee: performanceFee,
1267             unclaimedFees: unclaimedFees,
1268             nav: nav,
1269             highWaterMark: highWaterMark,
1270             totalSupply: totalSupply,
1271             timestamp: now
1272         });
1273 
1274         FeesConverted(now, feesShareQuantity, unclaimedFees);
1275         CalculationUpdate(now, managementFee, performanceFee, nav, sharePrice, totalSupply);
1276     }
1277 
1278     // PUBLIC : REDEEMING
1279 
1280     /// @notice Redeems by allocating an ownership percentage only of requestedAssets to the participant
1281     /// @dev Independent of running price feed! Note: if requestedAssets != ownedAssets then participant misses out on some owned value
1282     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
1283     /// @param requestedAssets List of addresses that consitute a subset of ownedAssets.
1284     /// @return Whether all assets sent to shareholder or not
1285     function emergencyRedeem(uint shareQuantity, address[] requestedAssets)
1286         public
1287         pre_cond(balances[msg.sender] >= shareQuantity)  // sender owns enough shares
1288         returns (bool)
1289     {
1290         uint[] memory ownershipQuantities = new uint[](requestedAssets.length);
1291 
1292         // Check whether enough assets held by fund
1293         for (uint i = 0; i < requestedAssets.length; ++i) {
1294             address ofAsset = requestedAssets[i];
1295             uint assetHoldings = add(
1296                 uint(AssetInterface(ofAsset).balanceOf(this)),
1297                 quantityHeldInCustodyOfExchange(ofAsset)
1298             );
1299 
1300             if (assetHoldings == 0) continue;
1301 
1302             // participant's ownership percentage of asset holdings
1303             ownershipQuantities[i] = mul(assetHoldings, shareQuantity) / totalSupply;
1304 
1305             // CRITICAL ERR: Not enough fund asset balance for owed ownershipQuantitiy, eg in case of unreturned asset quantity at address(exchanges[i].exchange) address
1306             if (uint(AssetInterface(ofAsset).balanceOf(this)) < ownershipQuantities[i]) {
1307                 isShutDown = true;
1308                 ErrorMessage("CRITICAL ERR: Not enough assetHoldings for owed ownershipQuantitiy");
1309                 return false;
1310             }
1311         }
1312 
1313         // Annihilate shares before external calls to prevent reentrancy
1314         annihilateShares(msg.sender, shareQuantity);
1315 
1316         // Transfer ownershipQuantity of Assets
1317         for (uint j = 0; j < ownershipQuantities.length; ++j) {
1318             // Failed to send owed ownershipQuantity from fund to participant
1319             if (!AssetInterface(ofAsset).transfer(msg.sender, ownershipQuantities[j])) {
1320                 revert();
1321             }
1322         }
1323         Redeemed(msg.sender, now, shareQuantity);
1324         return true;
1325     }
1326 
1327     // PUBLIC : FEES
1328 
1329     /// @dev Quantity of asset held in exchange according to associated order id
1330     /// @param ofAsset Address of asset
1331     /// @return Quantity of input asset held in exchange
1332     function quantityHeldInCustodyOfExchange(address ofAsset) returns (uint) {
1333         uint totalSellQuantity;     // quantity in custody across exchanges
1334         uint totalSellQuantityInApprove; // quantity of asset in approve (allowance) but not custody of exchange
1335         for (uint i; i < exchanges.length; i++) {
1336             if (exchangeIdsToOpenMakeOrderIds[i][ofAsset] == 0) {
1337                 continue;
1338             }
1339             var (sellAsset, , sellQuantity, ) = exchanges[i].exchangeAdapter.getOrder(exchanges[i].exchange, exchangeIdsToOpenMakeOrderIds[i][ofAsset]);
1340             if (sellQuantity == 0) {
1341                 exchangeIdsToOpenMakeOrderIds[i][ofAsset] = 0;
1342             }
1343             totalSellQuantity = add(totalSellQuantity, sellQuantity);
1344             if (exchanges[i].isApproveOnly) {
1345                 totalSellQuantityInApprove += sellQuantity;
1346             }
1347         }
1348         if (totalSellQuantity == 0) {
1349             isInOpenMakeOrder[sellAsset] = false;
1350         }
1351         return sub(totalSellQuantity, totalSellQuantityInApprove); // Since quantity in approve is not actually in custody
1352     }
1353 
1354     // PUBLIC VIEW METHODS
1355 
1356     /// @notice Calculates sharePrice denominated in [base unit of melonAsset]
1357     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1358     function calcSharePrice() view returns (uint sharePrice) {
1359         (, , , , , sharePrice) = performCalculations();
1360         return sharePrice;
1361     }
1362 
1363     function getModules() view returns (address, address, address) {
1364         return (
1365             address(module.pricefeed),
1366             address(module.compliance),
1367             address(module.riskmgmt)
1368         );
1369     }
1370 
1371     function getLastOrderId() view returns (uint) { return orders.length - 1; }
1372     function getLastRequestId() view returns (uint) { return requests.length - 1; }
1373     function getNameHash() view returns (bytes32) { return bytes32(keccak256(name)); }
1374     function getManager() view returns (address) { return owner; }
1375 }
1376 
1377 interface ExchangeInterface {
1378 
1379     // EVENTS
1380 
1381     event OrderUpdated(uint id);
1382 
1383     // METHODS
1384     // EXTERNAL METHODS
1385 
1386     function makeOrder(
1387         address onExchange,
1388         address sellAsset,
1389         address buyAsset,
1390         uint sellQuantity,
1391         uint buyQuantity
1392     ) external returns (uint);
1393     function takeOrder(address onExchange, uint id, uint quantity) external returns (bool);
1394     function cancelOrder(address onExchange, uint id) external returns (bool);
1395 
1396 
1397     // PUBLIC METHODS
1398     // PUBLIC VIEW METHODS
1399 
1400     function isApproveOnly() view returns (bool);
1401     function getLastOrderId(address onExchange) view returns (uint);
1402     function isActive(address onExchange, uint id) view returns (bool);
1403     function getOwner(address onExchange, uint id) view returns (address);
1404     function getOrder(address onExchange, uint id) view returns (address, address, uint, uint);
1405     function getTimestamp(address onExchange, uint id) view returns (uint);
1406 
1407 }
1408 
1409 interface PriceFeedInterface {
1410 
1411     // EVENTS
1412 
1413     event PriceUpdated(uint timestamp);
1414 
1415     // PUBLIC METHODS
1416 
1417     function update(address[] ofAssets, uint[] newPrices);
1418 
1419     // PUBLIC VIEW METHODS
1420 
1421     // Get asset specific information
1422     function getName(address ofAsset) view returns (string);
1423     function getSymbol(address ofAsset) view returns (string);
1424     function getDecimals(address ofAsset) view returns (uint);
1425     // Get price feed operation specific information
1426     function getQuoteAsset() view returns (address);
1427     function getInterval() view returns (uint);
1428     function getValidity() view returns (uint);
1429     function getLastUpdateId() view returns (uint);
1430     // Get asset specific information as updated in price feed
1431     function hasRecentPrice(address ofAsset) view returns (bool isRecent);
1432     function hasRecentPrices(address[] ofAssets) view returns (bool areRecent);
1433     function getPrice(address ofAsset) view returns (bool isRecent, uint price, uint decimal);
1434     function getPrices(address[] ofAssets) view returns (bool areRecent, uint[] prices, uint[] decimals);
1435     function getInvertedPrice(address ofAsset) view returns (bool isRecent, uint invertedPrice, uint decimal);
1436     function getReferencePrice(address ofBase, address ofQuote) view returns (bool isRecent, uint referencePrice, uint decimal);
1437     function getOrderPrice(
1438         address sellAsset,
1439         address buyAsset,
1440         uint sellQuantity,
1441         uint buyQuantity
1442     ) view returns (uint orderPrice);
1443     function existsPriceOnAssetPair(address sellAsset, address buyAsset) view returns (bool isExistent);
1444 }
1445 
1446 interface RiskMgmtInterface {
1447 
1448     // METHODS
1449     // PUBLIC VIEW METHODS
1450 
1451     /// @notice Checks if the makeOrder price is reasonable and not manipulative
1452     /// @param orderPrice Price of Order
1453     /// @param referencePrice Reference price obtained through PriceFeed contract
1454     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
1455     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
1456     /// @param sellQuantity Quantity of sellAsset to be sold
1457     /// @param buyQuantity Quantity of buyAsset to be bought
1458     /// @return If makeOrder is permitted
1459     function isMakePermitted(
1460         uint orderPrice,
1461         uint referencePrice,
1462         address sellAsset,
1463         address buyAsset,
1464         uint sellQuantity,
1465         uint buyQuantity
1466     ) view returns (bool);
1467 
1468     /// @notice Checks if the takeOrder price is reasonable and not manipulative
1469     /// @param orderPrice Price of Order
1470     /// @param referencePrice Reference price obtained through PriceFeed contract
1471     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
1472     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
1473     /// @param sellQuantity Quantity of sellAsset to be sold
1474     /// @param buyQuantity Quantity of buyAsset to be bought
1475     /// @return If takeOrder is permitted
1476     function isTakePermitted(
1477         uint orderPrice,
1478         uint referencePrice,
1479         address sellAsset,
1480         address buyAsset,
1481         uint sellQuantity,
1482         uint buyQuantity
1483     ) view returns (bool);
1484 }
1485 
1486 interface VersionInterface {
1487 
1488     // EVENTS
1489 
1490     event FundUpdated(uint id);
1491 
1492     // PUBLIC METHODS
1493 
1494     function shutDown() external;
1495 
1496     function setupFund(
1497         string ofFundName,
1498         address ofQuoteAsset,
1499         uint ofManagementFee,
1500         uint ofPerformanceFee,
1501         address ofCompliance,
1502         address ofRiskMgmt,
1503         address ofPriceFeed,
1504         address[] ofExchanges,
1505         address[] ofExchangeAdapters,
1506         uint8 v,
1507         bytes32 r,
1508         bytes32 s
1509     );
1510     function shutDownFund(address ofFund);
1511 
1512     // PUBLIC VIEW METHODS
1513 
1514     function getNativeAsset() view returns (address);
1515     function getFundById(uint withId) view returns (address);
1516     function getLastFundId() view returns (uint);
1517     function getFundByManager(address ofManager) view returns (address);
1518     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
1519 
1520 }
1521 
1522 contract Version is DBC, Owned, VersionInterface {
1523     // FIELDS
1524 
1525     // Constant fields
1526     bytes32 public constant TERMS_AND_CONDITIONS = 0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad; // Hashed terms and conditions as displayed on IPFS.
1527     // Constructor fields
1528     string public VERSION_NUMBER; // SemVer of Melon protocol version
1529     address public NATIVE_ASSET; // Address of wrapped native asset contract
1530     address public GOVERNANCE; // Address of Melon protocol governance contract
1531     // Methods fields
1532     bool public isShutDown; // Governance feature, if yes than setupFund gets blocked and shutDownFund gets opened
1533     address[] public listOfFunds; // A complete list of fund addresses created using this version
1534     mapping (address => address) public managerToFunds; // Links manager address to fund address created using this version
1535 
1536     // EVENTS
1537 
1538     event FundUpdated(address ofFund);
1539 
1540     // METHODS
1541 
1542     // CONSTRUCTOR
1543 
1544     /// @param versionNumber SemVer of Melon protocol version
1545     /// @param ofGovernance Address of Melon governance contract
1546     /// @param ofNativeAsset Address of wrapped native asset contract
1547     function Version(
1548         string versionNumber,
1549         address ofGovernance,
1550         address ofNativeAsset
1551     ) {
1552         VERSION_NUMBER = versionNumber;
1553         GOVERNANCE = ofGovernance;
1554         NATIVE_ASSET = ofNativeAsset;
1555     }
1556 
1557     // EXTERNAL METHODS
1558 
1559     function shutDown() external pre_cond(msg.sender == GOVERNANCE) { isShutDown = true; }
1560 
1561     // PUBLIC METHODS
1562 
1563     /// @param ofFundName human-readable descriptive name (not necessarily unique)
1564     /// @param ofQuoteAsset Asset against which performance fee is measured against
1565     /// @param ofManagementFee A time based fee, given in a number which is divided by 10 ** 15
1566     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 10 ** 15
1567     /// @param ofCompliance Address of participation module
1568     /// @param ofRiskMgmt Address of risk management module
1569     /// @param ofPriceFeed Address of price feed module
1570     /// @param ofExchanges Addresses of exchange on which this fund can trade
1571     /// @param ofExchangeAdapters Addresses of exchange adapters
1572     /// @param v ellipitc curve parameter v
1573     /// @param r ellipitc curve parameter r
1574     /// @param s ellipitc curve parameter s
1575     function setupFund(
1576         string ofFundName,
1577         address ofQuoteAsset,
1578         uint ofManagementFee,
1579         uint ofPerformanceFee,
1580         address ofCompliance,
1581         address ofRiskMgmt,
1582         address ofPriceFeed,
1583         address[] ofExchanges,
1584         address[] ofExchangeAdapters,
1585         uint8 v,
1586         bytes32 r,
1587         bytes32 s
1588     ) {
1589         require(!isShutDown);
1590         require(termsAndConditionsAreSigned(v, r, s));
1591         // Either novel fund name or previous owner of fund name
1592         require(managerToFunds[msg.sender] == 0); // Add limitation for simpler migration process of shutting down and setting up fund
1593         address ofFund = new Fund(
1594             msg.sender,
1595             ofFundName,
1596             ofQuoteAsset,
1597             ofManagementFee,
1598             ofPerformanceFee,
1599             NATIVE_ASSET,
1600             ofCompliance,
1601             ofRiskMgmt,
1602             ofPriceFeed,
1603             ofExchanges,
1604             ofExchangeAdapters
1605         );
1606         listOfFunds.push(ofFund);
1607         managerToFunds[msg.sender] = ofFund;
1608         FundUpdated(ofFund);
1609     }
1610 
1611     /// @dev Dereference Fund and trigger selfdestruct
1612     /// @param ofFund Address of the fund to be shut down
1613     function shutDownFund(address ofFund)
1614         pre_cond(isShutDown || managerToFunds[msg.sender] == ofFund)
1615     {
1616         Fund fund = Fund(ofFund);
1617         delete managerToFunds[msg.sender];
1618         fund.shutDown();
1619         FundUpdated(ofFund);
1620     }
1621 
1622     // PUBLIC VIEW METHODS
1623 
1624     /// @dev Proof that terms and conditions have been read and understood
1625     /// @param v ellipitc curve parameter v
1626     /// @param r ellipitc curve parameter r
1627     /// @param s ellipitc curve parameter s
1628     /// @return signed Whether or not terms and conditions have been read and understood
1629     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed) {
1630         return ecrecover(
1631             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
1632             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
1633             //  it will return rsv (same as geth; where v is [27, 28]).
1634             // Note that if you are using ecrecover, v will be either "00" or "01".
1635             //  As a result, in order to use this value, you will have to parse it to an
1636             //  integer and then add 27. This will result in either a 27 or a 28.
1637             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
1638             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
1639             v,
1640             r,
1641             s
1642         ) == msg.sender; // Has sender signed TERMS_AND_CONDITIONS
1643     }
1644 
1645     function getNativeAsset() view returns (address) { return NATIVE_ASSET; }
1646     function getFundById(uint withId) view returns (address) { return listOfFunds[withId]; }
1647     function getLastFundId() view returns (uint) { return listOfFunds.length - 1; }
1648     function getFundByManager(address ofManager) view returns (address) { return managerToFunds[ofManager]; }
1649 }