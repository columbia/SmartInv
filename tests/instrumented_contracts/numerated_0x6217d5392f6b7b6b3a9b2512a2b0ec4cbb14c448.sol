1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://eips.ethereum.org/EIPS/eip-20
71  */
72 interface IERC20 {
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address who) external view returns (uint256);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 
92 library StringLib {
93 
94     /// @notice converts bytes32 into a string.
95     /// @param bytesToConvert bytes32 array to convert
96     function bytes32ToString(bytes32 bytesToConvert) internal pure returns (string memory) {
97         bytes memory bytesArray = new bytes(32);
98         for (uint256 i; i < 32; i++) {
99             bytesArray[i] = bytesToConvert[i];
100         }
101         return string(bytesArray);
102     }
103 }/*
104     Copyright 2017-2019 Phillip A. Elsasser
105 
106     Licensed under the Apache License, Version 2.0 (the "License");
107     you may not use this file except in compliance with the License.
108     You may obtain a copy of the License at
109 
110     http://www.apache.org/licenses/LICENSE-2.0
111 
112     Unless required by applicable law or agreed to in writing, software
113     distributed under the License is distributed on an "AS IS" BASIS,
114     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
115     See the License for the specific language governing permissions and
116     limitations under the License.
117 */
118 
119 
120 
121 /// @title Math function library with overflow protection inspired by Open Zeppelin
122 library MathLib {
123 
124     int256 constant INT256_MIN = int256((uint256(1) << 255));
125     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
126 
127     function multiply(uint256 a, uint256 b) pure internal returns (uint256) {
128         if (a == 0) {
129             return 0;
130         }
131 
132         uint256 c = a * b;
133         require(c / a == b,  "MathLib: multiplication overflow");
134 
135         return c;
136     }
137 
138     function divideFractional(
139         uint256 a,
140         uint256 numerator,
141         uint256 denominator
142     ) pure internal returns (uint256)
143     {
144         return multiply(a, numerator) / denominator;
145     }
146 
147     function subtract(uint256 a, uint256 b) pure internal returns (uint256) {
148         require(b <= a, "MathLib: subtraction overflow");
149         return a - b;
150     }
151 
152     function add(uint256 a, uint256 b) pure internal returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, "MathLib: addition overflow");
155         return c;
156     }
157 
158     /// @notice determines the amount of needed collateral for a given position (qty and price)
159     /// @param priceFloor lowest price the contract is allowed to trade before expiration
160     /// @param priceCap highest price the contract is allowed to trade before expiration
161     /// @param qtyMultiplier multiplier for qty from base units
162     /// @param longQty qty to redeem
163     /// @param shortQty qty to redeem
164     /// @param price of the trade
165     function calculateCollateralToReturn(
166         uint priceFloor,
167         uint priceCap,
168         uint qtyMultiplier,
169         uint longQty,
170         uint shortQty,
171         uint price
172     ) pure internal returns (uint)
173     {
174         uint neededCollateral = 0;
175         uint maxLoss;
176         if (longQty > 0) {   // calculate max loss from entry price to floor
177             if (price <= priceFloor) {
178                 maxLoss = 0;
179             } else {
180                 maxLoss = subtract(price, priceFloor);
181             }
182             neededCollateral = multiply(multiply(maxLoss, longQty),  qtyMultiplier);
183         }
184 
185         if (shortQty > 0) {  // calculate max loss from entry price to ceiling;
186             if (price >= priceCap) {
187                 maxLoss = 0;
188             } else {
189                 maxLoss = subtract(priceCap, price);
190             }
191             neededCollateral = add(neededCollateral, multiply(multiply(maxLoss, shortQty),  qtyMultiplier));
192         }
193         return neededCollateral;
194     }
195 
196     /// @notice determines the amount of needed collateral for minting a long and short position token
197     function calculateTotalCollateral(
198         uint priceFloor,
199         uint priceCap,
200         uint qtyMultiplier
201     ) pure internal returns (uint)
202     {
203         return multiply(subtract(priceCap, priceFloor), qtyMultiplier);
204     }
205 
206     /// @notice calculates the fee in terms of base units of the collateral token per unit pair minted.
207     function calculateFeePerUnit(
208         uint priceFloor,
209         uint priceCap,
210         uint qtyMultiplier,
211         uint feeInBasisPoints
212     ) pure internal returns (uint)
213     {
214         uint midPrice = add(priceCap, priceFloor) / 2;
215         return multiply(multiply(midPrice, qtyMultiplier), feeInBasisPoints) / 10000;
216     }
217 }
218 /*
219     Copyright 2017-2019 Phillip A. Elsasser
220 
221     Licensed under the Apache License, Version 2.0 (the "License");
222     you may not use this file except in compliance with the License.
223     You may obtain a copy of the License at
224 
225     http://www.apache.org/licenses/LICENSE-2.0
226 
227     Unless required by applicable law or agreed to in writing, software
228     distributed under the License is distributed on an "AS IS" BASIS,
229     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
230     See the License for the specific language governing permissions and
231     limitations under the License.
232 */
233 
234 
235 
236 
237 /*
238     Copyright 2017-2019 Phillip A. Elsasser
239 
240     Licensed under the Apache License, Version 2.0 (the "License");
241     you may not use this file except in compliance with the License.
242     You may obtain a copy of the License at
243 
244     http://www.apache.org/licenses/LICENSE-2.0
245 
246     Unless required by applicable law or agreed to in writing, software
247     distributed under the License is distributed on an "AS IS" BASIS,
248     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
249     See the License for the specific language governing permissions and
250     limitations under the License.
251 */
252 
253 
254 
255 
256 
257 /**
258  * @title Ownable
259  * @dev The Ownable contract has an owner address, and provides basic authorization control
260  * functions, this simplifies the implementation of "user permissions".
261  */
262 contract Ownable {
263     address private _owner;
264 
265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
266 
267     /**
268      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
269      * account.
270      */
271     constructor () internal {
272         _owner = msg.sender;
273         emit OwnershipTransferred(address(0), _owner);
274     }
275 
276     /**
277      * @return the address of the owner.
278      */
279     function owner() public view returns (address) {
280         return _owner;
281     }
282 
283     /**
284      * @dev Throws if called by any account other than the owner.
285      */
286     modifier onlyOwner() {
287         require(isOwner());
288         _;
289     }
290 
291     /**
292      * @return true if `msg.sender` is the owner of the contract.
293      */
294     function isOwner() public view returns (bool) {
295         return msg.sender == _owner;
296     }
297 
298     /**
299      * @dev Allows the current owner to relinquish control of the contract.
300      * It will not be possible to call the functions with the `onlyOwner`
301      * modifier anymore.
302      * @notice Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public onlyOwner {
306         emit OwnershipTransferred(_owner, address(0));
307         _owner = address(0);
308     }
309 
310     /**
311      * @dev Allows the current owner to transfer control of the contract to a newOwner.
312      * @param newOwner The address to transfer ownership to.
313      */
314     function transferOwnership(address newOwner) public onlyOwner {
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers control of the contract to a newOwner.
320      * @param newOwner The address to transfer ownership to.
321      */
322     function _transferOwnership(address newOwner) internal {
323         require(newOwner != address(0));
324         emit OwnershipTransferred(_owner, newOwner);
325         _owner = newOwner;
326     }
327 }
328 
329 
330 
331 
332 
333 
334 
335 /// @title MarketContract base contract implement all needed functionality for trading.
336 /// @notice this is the abstract base contract that all contracts should inherit from to
337 /// implement different oracle solutions.
338 /// @author Phil Elsasser <phil@marketprotocol.io>
339 contract MarketContract is Ownable {
340     using StringLib for *;
341 
342     string public CONTRACT_NAME;
343     address public COLLATERAL_TOKEN_ADDRESS;
344     address public COLLATERAL_POOL_ADDRESS;
345     uint public PRICE_CAP;
346     uint public PRICE_FLOOR;
347     uint public PRICE_DECIMAL_PLACES;   // how to convert the pricing from decimal format (if valid) to integer
348     uint public QTY_MULTIPLIER;         // multiplier corresponding to the value of 1 increment in price to token base units
349     uint public COLLATERAL_PER_UNIT;    // required collateral amount for the full range of outcome tokens
350     uint public COLLATERAL_TOKEN_FEE_PER_UNIT;
351     uint public MKT_TOKEN_FEE_PER_UNIT;
352     uint public EXPIRATION;
353     uint public SETTLEMENT_DELAY = 1 days;
354     address public LONG_POSITION_TOKEN;
355     address public SHORT_POSITION_TOKEN;
356 
357     // state variables
358     uint public lastPrice;
359     uint public settlementPrice;
360     uint public settlementTimeStamp;
361     bool public isSettled = false;
362 
363     // events
364     event UpdatedLastPrice(uint256 price);
365     event ContractSettled(uint settlePrice);
366 
367     /// @param contractNames bytes32 array of names
368     ///     contractName            name of the market contract
369     ///     longTokenSymbol         symbol for the long token
370     ///     shortTokenSymbol        symbol for the short token
371     /// @param baseAddresses array of 2 addresses needed for our contract including:
372     ///     ownerAddress                    address of the owner of these contracts.
373     ///     collateralTokenAddress          address of the ERC20 token that will be used for collateral and pricing
374     ///     collateralPoolAddress           address of our collateral pool contract
375     /// @param contractSpecs array of unsigned integers including:
376     ///     floorPrice          minimum tradeable price of this contract, contract enters settlement if breached
377     ///     capPrice            maximum tradeable price of this contract, contract enters settlement if breached
378     ///     priceDecimalPlaces  number of decimal places to convert our queried price from a floating point to
379     ///                         an integer
380     ///     qtyMultiplier       multiply traded qty by this value from base units of collateral token.
381     ///     feeInBasisPoints    fee amount in basis points (Collateral token denominated) for minting.
382     ///     mktFeeInBasisPoints fee amount in basis points (MKT denominated) for minting.
383     ///     expirationTimeStamp seconds from epoch that this contract expires and enters settlement
384     constructor(
385         bytes32[3] memory contractNames,
386         address[3] memory baseAddresses,
387         uint[7] memory contractSpecs
388     ) public
389     {
390         PRICE_FLOOR = contractSpecs[0];
391         PRICE_CAP = contractSpecs[1];
392         require(PRICE_CAP > PRICE_FLOOR, "PRICE_CAP must be greater than PRICE_FLOOR");
393 
394         PRICE_DECIMAL_PLACES = contractSpecs[2];
395         QTY_MULTIPLIER = contractSpecs[3];
396         EXPIRATION = contractSpecs[6];
397         require(EXPIRATION > now, "EXPIRATION must be in the future");
398         require(QTY_MULTIPLIER != 0,"QTY_MULTIPLIER cannot be 0");
399 
400         COLLATERAL_TOKEN_ADDRESS = baseAddresses[1];
401         COLLATERAL_POOL_ADDRESS = baseAddresses[2];
402         COLLATERAL_PER_UNIT = MathLib.calculateTotalCollateral(PRICE_FLOOR, PRICE_CAP, QTY_MULTIPLIER);
403         COLLATERAL_TOKEN_FEE_PER_UNIT = MathLib.calculateFeePerUnit(
404             PRICE_FLOOR,
405             PRICE_CAP,
406             QTY_MULTIPLIER,
407             contractSpecs[4]
408         );
409         MKT_TOKEN_FEE_PER_UNIT = MathLib.calculateFeePerUnit(
410             PRICE_FLOOR,
411             PRICE_CAP,
412             QTY_MULTIPLIER,
413             contractSpecs[5]
414         );
415 
416         // create long and short tokens
417         CONTRACT_NAME = contractNames[0].bytes32ToString();
418         PositionToken longPosToken = new PositionToken(
419             "MARKET Protocol Long Position Token",
420             contractNames[1].bytes32ToString(),
421             uint8(PositionToken.MarketSide.Long)
422         );
423         PositionToken shortPosToken = new PositionToken(
424             "MARKET Protocol Short Position Token",
425             contractNames[2].bytes32ToString(),
426             uint8(PositionToken.MarketSide.Short)
427         );
428 
429         LONG_POSITION_TOKEN = address(longPosToken);
430         SHORT_POSITION_TOKEN = address(shortPosToken);
431 
432         transferOwnership(baseAddresses[0]);
433     }
434 
435     /*
436     // EXTERNAL - onlyCollateralPool METHODS
437     */
438 
439     /// @notice called only by our collateral pool to create long and short position tokens
440     /// @param qtyToMint    qty in base units of how many short and long tokens to mint
441     /// @param minter       address of minter to receive tokens
442     function mintPositionTokens(
443         uint256 qtyToMint,
444         address minter
445     ) external onlyCollateralPool
446     {
447         // mint and distribute short and long position tokens to our caller
448         PositionToken(LONG_POSITION_TOKEN).mintAndSendToken(qtyToMint, minter);
449         PositionToken(SHORT_POSITION_TOKEN).mintAndSendToken(qtyToMint, minter);
450     }
451 
452     /// @notice called only by our collateral pool to redeem long position tokens
453     /// @param qtyToRedeem  qty in base units of how many tokens to redeem
454     /// @param redeemer     address of person redeeming tokens
455     function redeemLongToken(
456         uint256 qtyToRedeem,
457         address redeemer
458     ) external onlyCollateralPool
459     {
460         // mint and distribute short and long position tokens to our caller
461         PositionToken(LONG_POSITION_TOKEN).redeemToken(qtyToRedeem, redeemer);
462     }
463 
464     /// @notice called only by our collateral pool to redeem short position tokens
465     /// @param qtyToRedeem  qty in base units of how many tokens to redeem
466     /// @param redeemer     address of person redeeming tokens
467     function redeemShortToken(
468         uint256 qtyToRedeem,
469         address redeemer
470     ) external onlyCollateralPool
471     {
472         // mint and distribute short and long position tokens to our caller
473         PositionToken(SHORT_POSITION_TOKEN).redeemToken(qtyToRedeem, redeemer);
474     }
475 
476     /*
477     // Public METHODS
478     */
479 
480     /// @notice checks to see if a contract is settled, and that the settlement delay has passed
481     function isPostSettlementDelay() public view returns (bool) {
482         return isSettled && (now >= (settlementTimeStamp + SETTLEMENT_DELAY));
483     }
484 
485     /*
486     // PRIVATE METHODS
487     */
488 
489     /// @dev checks our last query price to see if our contract should enter settlement due to it being past our
490     //  expiration date or outside of our tradeable ranges.
491     function checkSettlement() internal {
492         require(!isSettled, "Contract is already settled"); // already settled.
493 
494         uint newSettlementPrice;
495         if (now > EXPIRATION) {  // note: miners can cheat this by small increments of time (minutes, not hours)
496             isSettled = true;                   // time based expiration has occurred.
497             newSettlementPrice = lastPrice;
498         } else if (lastPrice >= PRICE_CAP) {    // price is greater or equal to our cap, settle to CAP price
499             isSettled = true;
500             newSettlementPrice = PRICE_CAP;
501         } else if (lastPrice <= PRICE_FLOOR) {  // price is lesser or equal to our floor, settle to FLOOR price
502             isSettled = true;
503             newSettlementPrice = PRICE_FLOOR;
504         }
505 
506         if (isSettled) {
507             settleContract(newSettlementPrice);
508         }
509     }
510 
511     /// @dev records our final settlement price and fires needed events.
512     /// @param finalSettlementPrice final query price at time of settlement
513     function settleContract(uint finalSettlementPrice) internal {
514         settlementTimeStamp = now;
515         settlementPrice = finalSettlementPrice;
516         emit ContractSettled(finalSettlementPrice);
517     }
518 
519     /// @notice only able to be called directly by our collateral pool which controls the position tokens
520     /// for this contract!
521     modifier onlyCollateralPool {
522         require(msg.sender == COLLATERAL_POOL_ADDRESS, "Only callable from the collateral pool");
523         _;
524     }
525 
526 }
527 
528 /*
529     Copyright 2017-2019 Phillip A. Elsasser
530 
531     Licensed under the Apache License, Version 2.0 (the "License");
532     you may not use this file except in compliance with the License.
533     You may obtain a copy of the License at
534 
535     http://www.apache.org/licenses/LICENSE-2.0
536 
537     Unless required by applicable law or agreed to in writing, software
538     distributed under the License is distributed on an "AS IS" BASIS,
539     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
540     See the License for the specific language governing permissions and
541     limitations under the License.
542 */
543 
544 
545 
546 
547 
548 
549 
550 
551 /**
552  * @title Standard ERC20 token
553  *
554  * @dev Implementation of the basic standard token.
555  * https://eips.ethereum.org/EIPS/eip-20
556  * Originally based on code by FirstBlood:
557  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
558  *
559  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
560  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
561  * compliant implementations may not do it.
562  */
563 contract ERC20 is IERC20 {
564     using SafeMath for uint256;
565 
566     mapping (address => uint256) private _balances;
567 
568     mapping (address => mapping (address => uint256)) private _allowed;
569 
570     uint256 private _totalSupply;
571 
572     /**
573      * @dev Total number of tokens in existence
574      */
575     function totalSupply() public view returns (uint256) {
576         return _totalSupply;
577     }
578 
579     /**
580      * @dev Gets the balance of the specified address.
581      * @param owner The address to query the balance of.
582      * @return A uint256 representing the amount owned by the passed address.
583      */
584     function balanceOf(address owner) public view returns (uint256) {
585         return _balances[owner];
586     }
587 
588     /**
589      * @dev Function to check the amount of tokens that an owner allowed to a spender.
590      * @param owner address The address which owns the funds.
591      * @param spender address The address which will spend the funds.
592      * @return A uint256 specifying the amount of tokens still available for the spender.
593      */
594     function allowance(address owner, address spender) public view returns (uint256) {
595         return _allowed[owner][spender];
596     }
597 
598     /**
599      * @dev Transfer token to a specified address
600      * @param to The address to transfer to.
601      * @param value The amount to be transferred.
602      */
603     function transfer(address to, uint256 value) public returns (bool) {
604         _transfer(msg.sender, to, value);
605         return true;
606     }
607 
608     /**
609      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
610      * Beware that changing an allowance with this method brings the risk that someone may use both the old
611      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
612      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
613      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
614      * @param spender The address which will spend the funds.
615      * @param value The amount of tokens to be spent.
616      */
617     function approve(address spender, uint256 value) public returns (bool) {
618         _approve(msg.sender, spender, value);
619         return true;
620     }
621 
622     /**
623      * @dev Transfer tokens from one address to another.
624      * Note that while this function emits an Approval event, this is not required as per the specification,
625      * and other compliant implementations may not emit the event.
626      * @param from address The address which you want to send tokens from
627      * @param to address The address which you want to transfer to
628      * @param value uint256 the amount of tokens to be transferred
629      */
630     function transferFrom(address from, address to, uint256 value) public returns (bool) {
631         _transfer(from, to, value);
632         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
633         return true;
634     }
635 
636     /**
637      * @dev Increase the amount of tokens that an owner allowed to a spender.
638      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
639      * allowed value is better to use this function to avoid 2 calls (and wait until
640      * the first transaction is mined)
641      * From MonolithDAO Token.sol
642      * Emits an Approval event.
643      * @param spender The address which will spend the funds.
644      * @param addedValue The amount of tokens to increase the allowance by.
645      */
646     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
647         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
648         return true;
649     }
650 
651     /**
652      * @dev Decrease the amount of tokens that an owner allowed to a spender.
653      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
654      * allowed value is better to use this function to avoid 2 calls (and wait until
655      * the first transaction is mined)
656      * From MonolithDAO Token.sol
657      * Emits an Approval event.
658      * @param spender The address which will spend the funds.
659      * @param subtractedValue The amount of tokens to decrease the allowance by.
660      */
661     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
662         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
663         return true;
664     }
665 
666     /**
667      * @dev Transfer token for a specified addresses
668      * @param from The address to transfer from.
669      * @param to The address to transfer to.
670      * @param value The amount to be transferred.
671      */
672     function _transfer(address from, address to, uint256 value) internal {
673         require(to != address(0));
674 
675         _balances[from] = _balances[from].sub(value);
676         _balances[to] = _balances[to].add(value);
677         emit Transfer(from, to, value);
678     }
679 
680     /**
681      * @dev Internal function that mints an amount of the token and assigns it to
682      * an account. This encapsulates the modification of balances such that the
683      * proper events are emitted.
684      * @param account The account that will receive the created tokens.
685      * @param value The amount that will be created.
686      */
687     function _mint(address account, uint256 value) internal {
688         require(account != address(0));
689 
690         _totalSupply = _totalSupply.add(value);
691         _balances[account] = _balances[account].add(value);
692         emit Transfer(address(0), account, value);
693     }
694 
695     /**
696      * @dev Internal function that burns an amount of the token of a given
697      * account.
698      * @param account The account whose tokens will be burnt.
699      * @param value The amount that will be burnt.
700      */
701     function _burn(address account, uint256 value) internal {
702         require(account != address(0));
703 
704         _totalSupply = _totalSupply.sub(value);
705         _balances[account] = _balances[account].sub(value);
706         emit Transfer(account, address(0), value);
707     }
708 
709     /**
710      * @dev Approve an address to spend another addresses' tokens.
711      * @param owner The address that owns the tokens.
712      * @param spender The address that will spend the tokens.
713      * @param value The number of tokens that can be spent.
714      */
715     function _approve(address owner, address spender, uint256 value) internal {
716         require(spender != address(0));
717         require(owner != address(0));
718 
719         _allowed[owner][spender] = value;
720         emit Approval(owner, spender, value);
721     }
722 
723     /**
724      * @dev Internal function that burns an amount of the token of a given
725      * account, deducting from the sender's allowance for said account. Uses the
726      * internal burn function.
727      * Emits an Approval event (reflecting the reduced allowance).
728      * @param account The account whose tokens will be burnt.
729      * @param value The amount that will be burnt.
730      */
731     function _burnFrom(address account, uint256 value) internal {
732         _burn(account, value);
733         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
734     }
735 }
736 
737 
738 
739 
740 /// @title Position Token
741 /// @notice A token that represents a claim to a collateral pool and a short or long position.
742 /// The collateral pool acts as the owner of this contract and controls minting and redemption of these
743 /// tokens based on locked collateral in the pool.
744 /// NOTE: We eventually can move all of this logic into a library to avoid deploying all of the logic
745 /// every time a new market contract is deployed.
746 /// @author Phil Elsasser <phil@marketprotocol.io>
747 contract PositionToken is ERC20, Ownable {
748 
749     string public name;
750     string public symbol;
751     uint8 public decimals;
752 
753     MarketSide public MARKET_SIDE; // 0 = Long, 1 = Short
754     enum MarketSide { Long, Short}
755 
756     constructor(
757         string memory tokenName,
758         string memory tokenSymbol,
759         uint8 marketSide
760     ) public
761     {
762         name = tokenName;
763         symbol = tokenSymbol;
764         decimals = 5;
765         MARKET_SIDE = MarketSide(marketSide);
766     }
767 
768     /// @dev Called by our MarketContract (owner) to create a long or short position token. These tokens are minted,
769     /// and then transferred to our recipient who is the party who is minting these tokens.  The collateral pool
770     /// is the only caller (acts as the owner) because collateral must be deposited / locked prior to minting of new
771     /// position tokens
772     /// @param qtyToMint quantity of position tokens to mint (in base units)
773     /// @param recipient the person minting and receiving these position tokens.
774     function mintAndSendToken(
775         uint256 qtyToMint,
776         address recipient
777     ) external onlyOwner
778     {
779         _mint(recipient, qtyToMint);
780     }
781 
782     /// @dev Called by our MarketContract (owner) when redemption occurs.  This means that either a single user is redeeming
783     /// both short and long tokens in order to claim their collateral, or the contract has settled, and only a single
784     /// side of the tokens are needed to redeem (handled by the collateral pool)
785     /// @param qtyToRedeem quantity of tokens to burn (remove from supply / circulation)
786     /// @param redeemer the person redeeming these tokens (who are we taking the balance from)
787     function redeemToken(
788         uint256 qtyToRedeem,
789         address redeemer
790     ) external onlyOwner
791     {
792         _burn(redeemer, qtyToRedeem);
793     }
794 }
795 /*
796     Copyright 2017-2019 Phillip A. Elsasser
797 
798     Licensed under the Apache License, Version 2.0 (the "License");
799     you may not use this file except in compliance with the License.
800     You may obtain a copy of the License at
801 
802     http://www.apache.org/licenses/LICENSE-2.0
803 
804     Unless required by applicable law or agreed to in writing, software
805     distributed under the License is distributed on an "AS IS" BASIS,
806     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
807     See the License for the specific language governing permissions and
808     limitations under the License.
809 */
810 
811 
812 
813 
814 contract MarketContractRegistryInterface {
815     function addAddressToWhiteList(address contractAddress) external;
816     function isAddressWhiteListed(address contractAddress) external view returns (bool);
817 }
818 
819 
820 
821 
822 
823 
824 
825 
826 /**
827  * Utility library of inline functions on addresses
828  */
829 library Address {
830     /**
831      * Returns whether the target address is a contract
832      * @dev This function will return false if invoked during the constructor of a contract,
833      * as the code is not actually created until after the constructor finishes.
834      * @param account address of the account to check
835      * @return whether the target address is a contract
836      */
837     function isContract(address account) internal view returns (bool) {
838         uint256 size;
839         // XXX Currently there is no better way to check if there is a contract in an address
840         // than to check the size of the code at that address.
841         // See https://ethereum.stackexchange.com/a/14016/36603
842         // for more details about how this works.
843         // TODO Check this again before the Serenity release, because all addresses will be
844         // contracts then.
845         // solhint-disable-next-line no-inline-assembly
846         assembly { size := extcodesize(account) }
847         return size > 0;
848     }
849 }
850 
851 
852 /**
853  * @title SafeERC20
854  * @dev Wrappers around ERC20 operations that throw on failure (when the token
855  * contract returns false). Tokens that return no value (and instead revert or
856  * throw on failure) are also supported, non-reverting calls are assumed to be
857  * successful.
858  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
859  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
860  */
861 library SafeERC20 {
862     using SafeMath for uint256;
863     using Address for address;
864 
865     function safeTransfer(IERC20 token, address to, uint256 value) internal {
866         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
867     }
868 
869     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
870         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
871     }
872 
873     function safeApprove(IERC20 token, address spender, uint256 value) internal {
874         // safeApprove should only be called when setting an initial allowance,
875         // or when resetting it to zero. To increase and decrease it, use
876         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
877         require((value == 0) || (token.allowance(address(this), spender) == 0));
878         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
879     }
880 
881     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
882         uint256 newAllowance = token.allowance(address(this), spender).add(value);
883         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
884     }
885 
886     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
887         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
888         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
889     }
890 
891     /**
892      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
893      * on the return value: the return value is optional (but if data is returned, it must equal true).
894      * @param token The token targeted by the call.
895      * @param data The call data (encoded using abi.encode or one of its variants).
896      */
897     function callOptionalReturn(IERC20 token, bytes memory data) private {
898         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
899         // we're implementing it ourselves.
900 
901         // A Solidity high level call has three parts:
902         //  1. The target address is checked to verify it contains contract code
903         //  2. The call itself is made, and success asserted
904         //  3. The return value is decoded, which in turn checks the size of the returned data.
905 
906         require(address(token).isContract());
907 
908         // solhint-disable-next-line avoid-low-level-calls
909         (bool success, bytes memory returndata) = address(token).call(data);
910         require(success);
911 
912         if (returndata.length > 0) { // Return data is optional
913             require(abi.decode(returndata, (bool)));
914         }
915     }
916 }
917 
918 
919 
920 
921 
922 /// @title MarketCollateralPool
923 /// @notice This collateral pool houses all of the collateral for all market contracts currently in circulation.
924 /// This pool facilitates locking of collateral and minting / redemption of position tokens for that collateral.
925 /// @author Phil Elsasser <phil@marketprotocol.io>
926 contract MarketCollateralPool is Ownable {
927     using MathLib for uint;
928     using MathLib for int;
929     using SafeERC20 for ERC20;
930 
931     address public marketContractRegistry;
932     address public mktToken;
933 
934     mapping(address => uint) public contractAddressToCollateralPoolBalance;                 // current balance of all collateral committed
935     mapping(address => uint) public feesCollectedByTokenAddress;
936 
937     event TokensMinted(
938         address indexed marketContract,
939         address indexed user,
940         address indexed feeToken,
941         uint qtyMinted,
942         uint collateralLocked,
943         uint feesPaid
944     );
945 
946     event TokensRedeemed (
947         address indexed marketContract,
948         address indexed user,
949         uint longQtyRedeemed,
950         uint shortQtyRedeemed,
951         uint collateralUnlocked
952     );
953 
954     constructor(address marketContractRegistryAddress, address mktTokenAddress) public {
955         marketContractRegistry = marketContractRegistryAddress;
956         mktToken = mktTokenAddress;
957     }
958 
959     /*
960     // EXTERNAL METHODS
961     */
962 
963     /// @notice Called by a user that would like to mint a new set of long and short token for a specified
964     /// market contract.  This will transfer and lock the correct amount of collateral into the pool
965     /// and issue them the requested qty of long and short tokens
966     /// @param marketContractAddress            address of the market contract to redeem tokens for
967     /// @param qtyToMint                      quantity of long / short tokens to mint.
968     /// @param isAttemptToPayInMKT            if possible, attempt to pay fee's in MKT rather than collateral tokens
969     function mintPositionTokens(
970         address marketContractAddress,
971         uint qtyToMint,
972         bool isAttemptToPayInMKT
973     ) external onlyWhiteListedAddress(marketContractAddress)
974     {
975 
976         MarketContract marketContract = MarketContract(marketContractAddress);
977         require(!marketContract.isSettled(), "Contract is already settled");
978 
979         address collateralTokenAddress = marketContract.COLLATERAL_TOKEN_ADDRESS();
980         uint neededCollateral = MathLib.multiply(qtyToMint, marketContract.COLLATERAL_PER_UNIT());
981         // the user has selected to pay fees in MKT and those fees are non zero (allowed) OR
982         // the user has selected not to pay fees in MKT, BUT the collateral token fees are disabled (0) AND the
983         // MKT fees are enabled (non zero).  (If both are zero, no fee exists)
984         bool isPayFeesInMKT = (isAttemptToPayInMKT &&
985             marketContract.MKT_TOKEN_FEE_PER_UNIT() != 0) ||
986             (!isAttemptToPayInMKT &&
987             marketContract.MKT_TOKEN_FEE_PER_UNIT() != 0 &&
988             marketContract.COLLATERAL_TOKEN_FEE_PER_UNIT() == 0);
989 
990         uint feeAmount;
991         uint totalCollateralTokenTransferAmount;
992         address feeToken;
993         if (isPayFeesInMKT) { // fees are able to be paid in MKT
994             feeAmount = MathLib.multiply(qtyToMint, marketContract.MKT_TOKEN_FEE_PER_UNIT());
995             totalCollateralTokenTransferAmount = neededCollateral;
996             feeToken = mktToken;
997 
998             // EXTERNAL CALL - transferring ERC20 tokens from sender to this contract.  User must have called
999             // ERC20.approve in order for this call to succeed.
1000             ERC20(mktToken).safeTransferFrom(msg.sender, address(this), feeAmount);
1001         } else { // fee are either zero, or being paid in the collateral token
1002             feeAmount = MathLib.multiply(qtyToMint, marketContract.COLLATERAL_TOKEN_FEE_PER_UNIT());
1003             totalCollateralTokenTransferAmount = neededCollateral.add(feeAmount);
1004             feeToken = collateralTokenAddress;
1005             // we will transfer collateral and fees all at once below.
1006         }
1007 
1008         // EXTERNAL CALL - transferring ERC20 tokens from sender to this contract.  User must have called
1009         // ERC20.approve in order for this call to succeed.
1010         ERC20(marketContract.COLLATERAL_TOKEN_ADDRESS()).safeTransferFrom(msg.sender, address(this), totalCollateralTokenTransferAmount);
1011 
1012         if (feeAmount != 0) {
1013             // update the fee's collected balance
1014             feesCollectedByTokenAddress[feeToken] = feesCollectedByTokenAddress[feeToken].add(feeAmount);
1015         }
1016 
1017         // Update the collateral pool locked balance.
1018         contractAddressToCollateralPoolBalance[marketContractAddress] = contractAddressToCollateralPoolBalance[
1019             marketContractAddress
1020         ].add(neededCollateral);
1021 
1022         // mint and distribute short and long position tokens to our caller
1023         marketContract.mintPositionTokens(qtyToMint, msg.sender);
1024 
1025         emit TokensMinted(
1026             marketContractAddress,
1027             msg.sender,
1028             feeToken,
1029             qtyToMint,
1030             neededCollateral,
1031             feeAmount
1032         );
1033     }
1034 
1035     /// @notice Called by a user that currently holds both short and long position tokens and would like to redeem them
1036     /// for their collateral.
1037     /// @param marketContractAddress            address of the market contract to redeem tokens for
1038     /// @param qtyToRedeem                      quantity of long / short tokens to redeem.
1039     function redeemPositionTokens(
1040         address marketContractAddress,
1041         uint qtyToRedeem
1042     ) external onlyWhiteListedAddress(marketContractAddress)
1043     {
1044         MarketContract marketContract = MarketContract(marketContractAddress);
1045 
1046         marketContract.redeemLongToken(qtyToRedeem, msg.sender);
1047         marketContract.redeemShortToken(qtyToRedeem, msg.sender);
1048 
1049         // calculate collateral to return and update pool balance
1050         uint collateralToReturn = MathLib.multiply(qtyToRedeem, marketContract.COLLATERAL_PER_UNIT());
1051         contractAddressToCollateralPoolBalance[marketContractAddress] = contractAddressToCollateralPoolBalance[
1052             marketContractAddress
1053         ].subtract(collateralToReturn);
1054 
1055         // EXTERNAL CALL
1056         // transfer collateral back to user
1057         ERC20(marketContract.COLLATERAL_TOKEN_ADDRESS()).safeTransfer(msg.sender, collateralToReturn);
1058 
1059         emit TokensRedeemed(
1060             marketContractAddress,
1061             msg.sender,
1062             qtyToRedeem,
1063             qtyToRedeem,
1064             collateralToReturn
1065         );
1066     }
1067 
1068     // @notice called by a user after settlement has occurred.  This function will finalize all accounting around any
1069     // outstanding positions and return all remaining collateral to the caller. This should only be called after
1070     // settlement has occurred.
1071     /// @param marketContractAddress address of the MARKET Contract being traded.
1072     /// @param longQtyToRedeem qty to redeem of long tokens
1073     /// @param shortQtyToRedeem qty to redeem of short tokens
1074     function settleAndClose(
1075         address marketContractAddress,
1076         uint longQtyToRedeem,
1077         uint shortQtyToRedeem
1078     ) external onlyWhiteListedAddress(marketContractAddress)
1079     {
1080         MarketContract marketContract = MarketContract(marketContractAddress);
1081         require(marketContract.isPostSettlementDelay(), "Contract is not past settlement delay");
1082 
1083         // burn tokens being redeemed.
1084         if (longQtyToRedeem > 0) {
1085             marketContract.redeemLongToken(longQtyToRedeem, msg.sender);
1086         }
1087 
1088         if (shortQtyToRedeem > 0) {
1089             marketContract.redeemShortToken(shortQtyToRedeem, msg.sender);
1090         }
1091 
1092 
1093         // calculate amount of collateral to return and update pool balances
1094         uint collateralToReturn = MathLib.calculateCollateralToReturn(
1095             marketContract.PRICE_FLOOR(),
1096             marketContract.PRICE_CAP(),
1097             marketContract.QTY_MULTIPLIER(),
1098             longQtyToRedeem,
1099             shortQtyToRedeem,
1100             marketContract.settlementPrice()
1101         );
1102 
1103         contractAddressToCollateralPoolBalance[marketContractAddress] = contractAddressToCollateralPoolBalance[
1104             marketContractAddress
1105         ].subtract(collateralToReturn);
1106 
1107         // return collateral tokens
1108         ERC20(marketContract.COLLATERAL_TOKEN_ADDRESS()).safeTransfer(msg.sender, collateralToReturn);
1109 
1110         emit TokensRedeemed(
1111             marketContractAddress,
1112             msg.sender,
1113             longQtyToRedeem,
1114             shortQtyToRedeem,
1115             collateralToReturn
1116         );
1117     }
1118 
1119     /// @dev allows the owner to remove the fees paid into this contract for minting
1120     /// @param feeTokenAddress - address of the erc20 token fees have been paid in
1121     /// @param feeRecipient - Recipient address of fees
1122     function withdrawFees(address feeTokenAddress, address feeRecipient) public onlyOwner {
1123         uint feesAvailableForWithdrawal = feesCollectedByTokenAddress[feeTokenAddress];
1124         require(feesAvailableForWithdrawal != 0, "No fees available for withdrawal");
1125         require(feeRecipient != address(0), "Cannot send fees to null address");
1126         feesCollectedByTokenAddress[feeTokenAddress] = 0;
1127         // EXTERNAL CALL
1128         ERC20(feeTokenAddress).safeTransfer(feeRecipient, feesAvailableForWithdrawal);
1129     }
1130 
1131     /// @dev allows the owner to update the mkt token address in use for fees
1132     /// @param mktTokenAddress address of new MKT token
1133     function setMKTTokenAddress(address mktTokenAddress) public onlyOwner {
1134         require(mktTokenAddress != address(0), "Cannot set MKT Token Address To Null");
1135         mktToken = mktTokenAddress;
1136     }
1137 
1138     /// @dev allows the owner to update the mkt token address in use for fees
1139     /// @param marketContractRegistryAddress address of new contract registry
1140     function setMarketContractRegistryAddress(address marketContractRegistryAddress) public onlyOwner {
1141         require(marketContractRegistryAddress != address(0), "Cannot set Market Contract Registry Address To Null");
1142         marketContractRegistry = marketContractRegistryAddress;
1143     }
1144 
1145     /*
1146     // MODIFIERS
1147     */
1148 
1149     /// @notice only can be called with a market contract address that currently exists in our whitelist
1150     /// this ensure's it is a market contract that has been created by us and therefore has a uniquely created
1151     /// long and short token address.  If it didn't we could have spoofed contracts minting tokens with a
1152     /// collateral token that wasn't the same as the intended token.
1153     modifier onlyWhiteListedAddress(address marketContractAddress) {
1154         require(
1155             MarketContractRegistryInterface(marketContractRegistry).isAddressWhiteListed(marketContractAddress),
1156             "Contract is not whitelisted"
1157         );
1158         _;
1159     }
1160 }