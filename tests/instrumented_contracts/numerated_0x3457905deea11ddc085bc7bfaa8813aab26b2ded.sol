1 pragma solidity ^0.5.2;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      * @notice Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://eips.ethereum.org/EIPS/eip-20
79  */
80 interface IERC20 {
81     function transfer(address to, uint256 value) external returns (bool);
82 
83     function approve(address spender, uint256 value) external returns (bool);
84 
85     function transferFrom(address from, address to, uint256 value) external returns (bool);
86 
87     function totalSupply() external view returns (uint256);
88 
89     function balanceOf(address who) external view returns (uint256);
90 
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 
100 library StringLib {
101 
102     /// @notice converts bytes32 into a string.
103     /// @param bytesToConvert bytes32 array to convert
104     function bytes32ToString(bytes32 bytesToConvert) internal pure returns (string memory) {
105         bytes memory bytesArray = new bytes(32);
106         for (uint256 i; i < 32; i++) {
107             bytesArray[i] = bytesToConvert[i];
108         }
109         return string(bytesArray);
110     }
111 }/*
112     Copyright 2017-2019 Phillip A. Elsasser
113 
114     Licensed under the Apache License, Version 2.0 (the "License");
115     you may not use this file except in compliance with the License.
116     You may obtain a copy of the License at
117 
118     http://www.apache.org/licenses/LICENSE-2.0
119 
120     Unless required by applicable law or agreed to in writing, software
121     distributed under the License is distributed on an "AS IS" BASIS,
122     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
123     See the License for the specific language governing permissions and
124     limitations under the License.
125 */
126 
127 
128 
129 /*
130     Copyright 2017-2019 Phillip A. Elsasser
131 
132     Licensed under the Apache License, Version 2.0 (the "License");
133     you may not use this file except in compliance with the License.
134     You may obtain a copy of the License at
135 
136     http://www.apache.org/licenses/LICENSE-2.0
137 
138     Unless required by applicable law or agreed to in writing, software
139     distributed under the License is distributed on an "AS IS" BASIS,
140     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
141     See the License for the specific language governing permissions and
142     limitations under the License.
143 */
144 
145 
146 
147 /*
148     Copyright 2017-2019 Phillip A. Elsasser
149 
150     Licensed under the Apache License, Version 2.0 (the "License");
151     you may not use this file except in compliance with the License.
152     You may obtain a copy of the License at
153 
154     http://www.apache.org/licenses/LICENSE-2.0
155 
156     Unless required by applicable law or agreed to in writing, software
157     distributed under the License is distributed on an "AS IS" BASIS,
158     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
159     See the License for the specific language governing permissions and
160     limitations under the License.
161 */
162 
163 
164 
165 
166 
167 /*
168     Copyright 2017-2019 Phillip A. Elsasser
169 
170     Licensed under the Apache License, Version 2.0 (the "License");
171     you may not use this file except in compliance with the License.
172     You may obtain a copy of the License at
173 
174     http://www.apache.org/licenses/LICENSE-2.0
175 
176     Unless required by applicable law or agreed to in writing, software
177     distributed under the License is distributed on an "AS IS" BASIS,
178     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
179     See the License for the specific language governing permissions and
180     limitations under the License.
181 */
182 
183 
184 
185 /// @title Math function library with overflow protection inspired by Open Zeppelin
186 library MathLib {
187 
188     int256 constant INT256_MIN = int256((uint256(1) << 255));
189     int256 constant INT256_MAX = int256(~((uint256(1) << 255)));
190 
191     function multiply(uint256 a, uint256 b) pure internal returns (uint256) {
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b,  "MathLib: multiplication overflow");
198 
199         return c;
200     }
201 
202     function divideFractional(
203         uint256 a,
204         uint256 numerator,
205         uint256 denominator
206     ) pure internal returns (uint256)
207     {
208         return multiply(a, numerator) / denominator;
209     }
210 
211     function subtract(uint256 a, uint256 b) pure internal returns (uint256) {
212         require(b <= a, "MathLib: subtraction overflow");
213         return a - b;
214     }
215 
216     function add(uint256 a, uint256 b) pure internal returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "MathLib: addition overflow");
219         return c;
220     }
221 
222     /// @notice determines the amount of needed collateral for a given position (qty and price)
223     /// @param priceFloor lowest price the contract is allowed to trade before expiration
224     /// @param priceCap highest price the contract is allowed to trade before expiration
225     /// @param qtyMultiplier multiplier for qty from base units
226     /// @param longQty qty to redeem
227     /// @param shortQty qty to redeem
228     /// @param price of the trade
229     function calculateCollateralToReturn(
230         uint priceFloor,
231         uint priceCap,
232         uint qtyMultiplier,
233         uint longQty,
234         uint shortQty,
235         uint price
236     ) pure internal returns (uint)
237     {
238         uint neededCollateral = 0;
239         uint maxLoss;
240         if (longQty > 0) {   // calculate max loss from entry price to floor
241             if (price <= priceFloor) {
242                 maxLoss = 0;
243             } else {
244                 maxLoss = subtract(price, priceFloor);
245             }
246             neededCollateral = multiply(multiply(maxLoss, longQty),  qtyMultiplier);
247         }
248 
249         if (shortQty > 0) {  // calculate max loss from entry price to ceiling;
250             if (price >= priceCap) {
251                 maxLoss = 0;
252             } else {
253                 maxLoss = subtract(priceCap, price);
254             }
255             neededCollateral = add(neededCollateral, multiply(multiply(maxLoss, shortQty),  qtyMultiplier));
256         }
257         return neededCollateral;
258     }
259 
260     /// @notice determines the amount of needed collateral for minting a long and short position token
261     function calculateTotalCollateral(
262         uint priceFloor,
263         uint priceCap,
264         uint qtyMultiplier
265     ) pure internal returns (uint)
266     {
267         return multiply(subtract(priceCap, priceFloor), qtyMultiplier);
268     }
269 
270     /// @notice calculates the fee in terms of base units of the collateral token per unit pair minted.
271     function calculateFeePerUnit(
272         uint priceFloor,
273         uint priceCap,
274         uint qtyMultiplier,
275         uint feeInBasisPoints
276     ) pure internal returns (uint)
277     {
278         uint midPrice = add(priceCap, priceFloor) / 2;
279         return multiply(multiply(midPrice, qtyMultiplier), feeInBasisPoints) / 10000;
280     }
281 }
282 
283 
284 /*
285     Copyright 2017-2019 Phillip A. Elsasser
286 
287     Licensed under the Apache License, Version 2.0 (the "License");
288     you may not use this file except in compliance with the License.
289     You may obtain a copy of the License at
290 
291     http://www.apache.org/licenses/LICENSE-2.0
292 
293     Unless required by applicable law or agreed to in writing, software
294     distributed under the License is distributed on an "AS IS" BASIS,
295     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
296     See the License for the specific language governing permissions and
297     limitations under the License.
298 */
299 
300 
301 
302 
303 
304 
305 
306 
307 /**
308  * @title SafeMath
309  * @dev Unsigned math operations with safety checks that revert on error
310  */
311 library SafeMath {
312     /**
313      * @dev Multiplies two unsigned integers, reverts on overflow.
314      */
315     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
316         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
317         // benefit is lost if 'b' is also tested.
318         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
319         if (a == 0) {
320             return 0;
321         }
322 
323         uint256 c = a * b;
324         require(c / a == b);
325 
326         return c;
327     }
328 
329     /**
330      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
331      */
332     function div(uint256 a, uint256 b) internal pure returns (uint256) {
333         // Solidity only automatically asserts when dividing by 0
334         require(b > 0);
335         uint256 c = a / b;
336         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
337 
338         return c;
339     }
340 
341     /**
342      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
343      */
344     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
345         require(b <= a);
346         uint256 c = a - b;
347 
348         return c;
349     }
350 
351     /**
352      * @dev Adds two unsigned integers, reverts on overflow.
353      */
354     function add(uint256 a, uint256 b) internal pure returns (uint256) {
355         uint256 c = a + b;
356         require(c >= a);
357 
358         return c;
359     }
360 
361     /**
362      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
363      * reverts when dividing by zero.
364      */
365     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
366         require(b != 0);
367         return a % b;
368     }
369 }
370 
371 
372 /**
373  * @title Standard ERC20 token
374  *
375  * @dev Implementation of the basic standard token.
376  * https://eips.ethereum.org/EIPS/eip-20
377  * Originally based on code by FirstBlood:
378  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
379  *
380  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
381  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
382  * compliant implementations may not do it.
383  */
384 contract ERC20 is IERC20 {
385     using SafeMath for uint256;
386 
387     mapping (address => uint256) private _balances;
388 
389     mapping (address => mapping (address => uint256)) private _allowed;
390 
391     uint256 private _totalSupply;
392 
393     /**
394      * @dev Total number of tokens in existence
395      */
396     function totalSupply() public view returns (uint256) {
397         return _totalSupply;
398     }
399 
400     /**
401      * @dev Gets the balance of the specified address.
402      * @param owner The address to query the balance of.
403      * @return A uint256 representing the amount owned by the passed address.
404      */
405     function balanceOf(address owner) public view returns (uint256) {
406         return _balances[owner];
407     }
408 
409     /**
410      * @dev Function to check the amount of tokens that an owner allowed to a spender.
411      * @param owner address The address which owns the funds.
412      * @param spender address The address which will spend the funds.
413      * @return A uint256 specifying the amount of tokens still available for the spender.
414      */
415     function allowance(address owner, address spender) public view returns (uint256) {
416         return _allowed[owner][spender];
417     }
418 
419     /**
420      * @dev Transfer token to a specified address
421      * @param to The address to transfer to.
422      * @param value The amount to be transferred.
423      */
424     function transfer(address to, uint256 value) public returns (bool) {
425         _transfer(msg.sender, to, value);
426         return true;
427     }
428 
429     /**
430      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
431      * Beware that changing an allowance with this method brings the risk that someone may use both the old
432      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
433      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
434      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
435      * @param spender The address which will spend the funds.
436      * @param value The amount of tokens to be spent.
437      */
438     function approve(address spender, uint256 value) public returns (bool) {
439         _approve(msg.sender, spender, value);
440         return true;
441     }
442 
443     /**
444      * @dev Transfer tokens from one address to another.
445      * Note that while this function emits an Approval event, this is not required as per the specification,
446      * and other compliant implementations may not emit the event.
447      * @param from address The address which you want to send tokens from
448      * @param to address The address which you want to transfer to
449      * @param value uint256 the amount of tokens to be transferred
450      */
451     function transferFrom(address from, address to, uint256 value) public returns (bool) {
452         _transfer(from, to, value);
453         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
454         return true;
455     }
456 
457     /**
458      * @dev Increase the amount of tokens that an owner allowed to a spender.
459      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
460      * allowed value is better to use this function to avoid 2 calls (and wait until
461      * the first transaction is mined)
462      * From MonolithDAO Token.sol
463      * Emits an Approval event.
464      * @param spender The address which will spend the funds.
465      * @param addedValue The amount of tokens to increase the allowance by.
466      */
467     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
468         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
469         return true;
470     }
471 
472     /**
473      * @dev Decrease the amount of tokens that an owner allowed to a spender.
474      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
475      * allowed value is better to use this function to avoid 2 calls (and wait until
476      * the first transaction is mined)
477      * From MonolithDAO Token.sol
478      * Emits an Approval event.
479      * @param spender The address which will spend the funds.
480      * @param subtractedValue The amount of tokens to decrease the allowance by.
481      */
482     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
483         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
484         return true;
485     }
486 
487     /**
488      * @dev Transfer token for a specified addresses
489      * @param from The address to transfer from.
490      * @param to The address to transfer to.
491      * @param value The amount to be transferred.
492      */
493     function _transfer(address from, address to, uint256 value) internal {
494         require(to != address(0));
495 
496         _balances[from] = _balances[from].sub(value);
497         _balances[to] = _balances[to].add(value);
498         emit Transfer(from, to, value);
499     }
500 
501     /**
502      * @dev Internal function that mints an amount of the token and assigns it to
503      * an account. This encapsulates the modification of balances such that the
504      * proper events are emitted.
505      * @param account The account that will receive the created tokens.
506      * @param value The amount that will be created.
507      */
508     function _mint(address account, uint256 value) internal {
509         require(account != address(0));
510 
511         _totalSupply = _totalSupply.add(value);
512         _balances[account] = _balances[account].add(value);
513         emit Transfer(address(0), account, value);
514     }
515 
516     /**
517      * @dev Internal function that burns an amount of the token of a given
518      * account.
519      * @param account The account whose tokens will be burnt.
520      * @param value The amount that will be burnt.
521      */
522     function _burn(address account, uint256 value) internal {
523         require(account != address(0));
524 
525         _totalSupply = _totalSupply.sub(value);
526         _balances[account] = _balances[account].sub(value);
527         emit Transfer(account, address(0), value);
528     }
529 
530     /**
531      * @dev Approve an address to spend another addresses' tokens.
532      * @param owner The address that owns the tokens.
533      * @param spender The address that will spend the tokens.
534      * @param value The number of tokens that can be spent.
535      */
536     function _approve(address owner, address spender, uint256 value) internal {
537         require(spender != address(0));
538         require(owner != address(0));
539 
540         _allowed[owner][spender] = value;
541         emit Approval(owner, spender, value);
542     }
543 
544     /**
545      * @dev Internal function that burns an amount of the token of a given
546      * account, deducting from the sender's allowance for said account. Uses the
547      * internal burn function.
548      * Emits an Approval event (reflecting the reduced allowance).
549      * @param account The account whose tokens will be burnt.
550      * @param value The amount that will be burnt.
551      */
552     function _burnFrom(address account, uint256 value) internal {
553         _burn(account, value);
554         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
555     }
556 }
557 
558 
559 
560 
561 /// @title Position Token
562 /// @notice A token that represents a claim to a collateral pool and a short or long position.
563 /// The collateral pool acts as the owner of this contract and controls minting and redemption of these
564 /// tokens based on locked collateral in the pool.
565 /// NOTE: We eventually can move all of this logic into a library to avoid deploying all of the logic
566 /// every time a new market contract is deployed.
567 /// @author Phil Elsasser <phil@marketprotocol.io>
568 contract PositionToken is ERC20, Ownable {
569 
570     string public name;
571     string public symbol;
572     uint8 public decimals;
573 
574     MarketSide public MARKET_SIDE; // 0 = Long, 1 = Short
575     enum MarketSide { Long, Short}
576 
577     constructor(
578         string memory tokenName,
579         string memory tokenSymbol,
580         uint8 marketSide
581     ) public
582     {
583         name = tokenName;
584         symbol = tokenSymbol;
585         decimals = 5;
586         MARKET_SIDE = MarketSide(marketSide);
587     }
588 
589     /// @dev Called by our MarketContract (owner) to create a long or short position token. These tokens are minted,
590     /// and then transferred to our recipient who is the party who is minting these tokens.  The collateral pool
591     /// is the only caller (acts as the owner) because collateral must be deposited / locked prior to minting of new
592     /// position tokens
593     /// @param qtyToMint quantity of position tokens to mint (in base units)
594     /// @param recipient the person minting and receiving these position tokens.
595     function mintAndSendToken(
596         uint256 qtyToMint,
597         address recipient
598     ) external onlyOwner
599     {
600         _mint(recipient, qtyToMint);
601     }
602 
603     /// @dev Called by our MarketContract (owner) when redemption occurs.  This means that either a single user is redeeming
604     /// both short and long tokens in order to claim their collateral, or the contract has settled, and only a single
605     /// side of the tokens are needed to redeem (handled by the collateral pool)
606     /// @param qtyToRedeem quantity of tokens to burn (remove from supply / circulation)
607     /// @param redeemer the person redeeming these tokens (who are we taking the balance from)
608     function redeemToken(
609         uint256 qtyToRedeem,
610         address redeemer
611     ) external onlyOwner
612     {
613         _burn(redeemer, qtyToRedeem);
614     }
615 }
616 
617 
618 /// @title MarketContract base contract implement all needed functionality for trading.
619 /// @notice this is the abstract base contract that all contracts should inherit from to
620 /// implement different oracle solutions.
621 /// @author Phil Elsasser <phil@marketprotocol.io>
622 contract MarketContract is Ownable {
623     using StringLib for *;
624 
625     string public CONTRACT_NAME;
626     address public COLLATERAL_TOKEN_ADDRESS;
627     address public COLLATERAL_POOL_ADDRESS;
628     uint public PRICE_CAP;
629     uint public PRICE_FLOOR;
630     uint public PRICE_DECIMAL_PLACES;   // how to convert the pricing from decimal format (if valid) to integer
631     uint public QTY_MULTIPLIER;         // multiplier corresponding to the value of 1 increment in price to token base units
632     uint public COLLATERAL_PER_UNIT;    // required collateral amount for the full range of outcome tokens
633     uint public COLLATERAL_TOKEN_FEE_PER_UNIT;
634     uint public MKT_TOKEN_FEE_PER_UNIT;
635     uint public EXPIRATION;
636     uint public SETTLEMENT_DELAY = 1 days;
637     address public LONG_POSITION_TOKEN;
638     address public SHORT_POSITION_TOKEN;
639 
640     // state variables
641     uint public lastPrice;
642     uint public settlementPrice;
643     uint public settlementTimeStamp;
644     bool public isSettled = false;
645 
646     // events
647     event UpdatedLastPrice(uint256 price);
648     event ContractSettled(uint settlePrice);
649 
650     /// @param contractNames bytes32 array of names
651     ///     contractName            name of the market contract
652     ///     longTokenSymbol         symbol for the long token
653     ///     shortTokenSymbol        symbol for the short token
654     /// @param baseAddresses array of 2 addresses needed for our contract including:
655     ///     ownerAddress                    address of the owner of these contracts.
656     ///     collateralTokenAddress          address of the ERC20 token that will be used for collateral and pricing
657     ///     collateralPoolAddress           address of our collateral pool contract
658     /// @param contractSpecs array of unsigned integers including:
659     ///     floorPrice          minimum tradeable price of this contract, contract enters settlement if breached
660     ///     capPrice            maximum tradeable price of this contract, contract enters settlement if breached
661     ///     priceDecimalPlaces  number of decimal places to convert our queried price from a floating point to
662     ///                         an integer
663     ///     qtyMultiplier       multiply traded qty by this value from base units of collateral token.
664     ///     feeInBasisPoints    fee amount in basis points (Collateral token denominated) for minting.
665     ///     mktFeeInBasisPoints fee amount in basis points (MKT denominated) for minting.
666     ///     expirationTimeStamp seconds from epoch that this contract expires and enters settlement
667     constructor(
668         bytes32[3] memory contractNames,
669         address[3] memory baseAddresses,
670         uint[7] memory contractSpecs
671     ) public
672     {
673         PRICE_FLOOR = contractSpecs[0];
674         PRICE_CAP = contractSpecs[1];
675         require(PRICE_CAP > PRICE_FLOOR, "PRICE_CAP must be greater than PRICE_FLOOR");
676 
677         PRICE_DECIMAL_PLACES = contractSpecs[2];
678         QTY_MULTIPLIER = contractSpecs[3];
679         EXPIRATION = contractSpecs[6];
680         require(EXPIRATION > now, "EXPIRATION must be in the future");
681         require(QTY_MULTIPLIER != 0,"QTY_MULTIPLIER cannot be 0");
682 
683         COLLATERAL_TOKEN_ADDRESS = baseAddresses[1];
684         COLLATERAL_POOL_ADDRESS = baseAddresses[2];
685         COLLATERAL_PER_UNIT = MathLib.calculateTotalCollateral(PRICE_FLOOR, PRICE_CAP, QTY_MULTIPLIER);
686         COLLATERAL_TOKEN_FEE_PER_UNIT = MathLib.calculateFeePerUnit(
687             PRICE_FLOOR,
688             PRICE_CAP,
689             QTY_MULTIPLIER,
690             contractSpecs[4]
691         );
692         MKT_TOKEN_FEE_PER_UNIT = MathLib.calculateFeePerUnit(
693             PRICE_FLOOR,
694             PRICE_CAP,
695             QTY_MULTIPLIER,
696             contractSpecs[5]
697         );
698 
699         // create long and short tokens
700         CONTRACT_NAME = contractNames[0].bytes32ToString();
701         PositionToken longPosToken = new PositionToken(
702             "MARKET Protocol Long Position Token",
703             contractNames[1].bytes32ToString(),
704             uint8(PositionToken.MarketSide.Long)
705         );
706         PositionToken shortPosToken = new PositionToken(
707             "MARKET Protocol Short Position Token",
708             contractNames[2].bytes32ToString(),
709             uint8(PositionToken.MarketSide.Short)
710         );
711 
712         LONG_POSITION_TOKEN = address(longPosToken);
713         SHORT_POSITION_TOKEN = address(shortPosToken);
714 
715         transferOwnership(baseAddresses[0]);
716     }
717 
718     /*
719     // EXTERNAL - onlyCollateralPool METHODS
720     */
721 
722     /// @notice called only by our collateral pool to create long and short position tokens
723     /// @param qtyToMint    qty in base units of how many short and long tokens to mint
724     /// @param minter       address of minter to receive tokens
725     function mintPositionTokens(
726         uint256 qtyToMint,
727         address minter
728     ) external onlyCollateralPool
729     {
730         // mint and distribute short and long position tokens to our caller
731         PositionToken(LONG_POSITION_TOKEN).mintAndSendToken(qtyToMint, minter);
732         PositionToken(SHORT_POSITION_TOKEN).mintAndSendToken(qtyToMint, minter);
733     }
734 
735     /// @notice called only by our collateral pool to redeem long position tokens
736     /// @param qtyToRedeem  qty in base units of how many tokens to redeem
737     /// @param redeemer     address of person redeeming tokens
738     function redeemLongToken(
739         uint256 qtyToRedeem,
740         address redeemer
741     ) external onlyCollateralPool
742     {
743         // mint and distribute short and long position tokens to our caller
744         PositionToken(LONG_POSITION_TOKEN).redeemToken(qtyToRedeem, redeemer);
745     }
746 
747     /// @notice called only by our collateral pool to redeem short position tokens
748     /// @param qtyToRedeem  qty in base units of how many tokens to redeem
749     /// @param redeemer     address of person redeeming tokens
750     function redeemShortToken(
751         uint256 qtyToRedeem,
752         address redeemer
753     ) external onlyCollateralPool
754     {
755         // mint and distribute short and long position tokens to our caller
756         PositionToken(SHORT_POSITION_TOKEN).redeemToken(qtyToRedeem, redeemer);
757     }
758 
759     /*
760     // Public METHODS
761     */
762 
763     /// @notice checks to see if a contract is settled, and that the settlement delay has passed
764     function isPostSettlementDelay() public view returns (bool) {
765         return isSettled && (now >= (settlementTimeStamp + SETTLEMENT_DELAY));
766     }
767 
768     /*
769     // PRIVATE METHODS
770     */
771 
772     /// @dev checks our last query price to see if our contract should enter settlement due to it being past our
773     //  expiration date or outside of our tradeable ranges.
774     function checkSettlement() internal {
775         require(!isSettled, "Contract is already settled"); // already settled.
776 
777         uint newSettlementPrice;
778         if (now > EXPIRATION) {  // note: miners can cheat this by small increments of time (minutes, not hours)
779             isSettled = true;                   // time based expiration has occurred.
780             newSettlementPrice = lastPrice;
781         } else if (lastPrice >= PRICE_CAP) {    // price is greater or equal to our cap, settle to CAP price
782             isSettled = true;
783             newSettlementPrice = PRICE_CAP;
784         } else if (lastPrice <= PRICE_FLOOR) {  // price is lesser or equal to our floor, settle to FLOOR price
785             isSettled = true;
786             newSettlementPrice = PRICE_FLOOR;
787         }
788 
789         if (isSettled) {
790             settleContract(newSettlementPrice);
791         }
792     }
793 
794     /// @dev records our final settlement price and fires needed events.
795     /// @param finalSettlementPrice final query price at time of settlement
796     function settleContract(uint finalSettlementPrice) internal {
797         settlementTimeStamp = now;
798         settlementPrice = finalSettlementPrice;
799         emit ContractSettled(finalSettlementPrice);
800     }
801 
802     /// @notice only able to be called directly by our collateral pool which controls the position tokens
803     /// for this contract!
804     modifier onlyCollateralPool {
805         require(msg.sender == COLLATERAL_POOL_ADDRESS, "Only callable from the collateral pool");
806         _;
807     }
808 
809 }
810 
811 
812 
813 /// @title MarketContractMPX - a MarketContract designed to be used with our internal oracle service
814 /// @author Phil Elsasser <phil@marketprotocol.io>
815 contract MarketContractMPX is MarketContract {
816 
817     address public ORACLE_HUB_ADDRESS;
818     string public ORACLE_URL;
819     string public ORACLE_STATISTIC;
820 
821     /// @param contractNames bytes32 array of names
822     ///     contractName            name of the market contract
823     ///     longTokenSymbol         symbol for the long token
824     ///     shortTokenSymbol        symbol for the short token
825     /// @param baseAddresses array of 2 addresses needed for our contract including:
826     ///     ownerAddress                    address of the owner of these contracts.
827     ///     collateralTokenAddress          address of the ERC20 token that will be used for collateral and pricing
828     ///     collateralPoolAddress           address of our collateral pool contract
829     /// @param oracleHubAddress     address of our oracle hub providing the callbacks
830     /// @param contractSpecs array of unsigned integers including:
831     ///     floorPrice              minimum tradeable price of this contract, contract enters settlement if breached
832     ///     capPrice                maximum tradeable price of this contract, contract enters settlement if breached
833     ///     priceDecimalPlaces      number of decimal places to convert our queried price from a floating point to
834     ///                             an integer
835     ///     qtyMultiplier           multiply traded qty by this value from base units of collateral token.
836     ///     feeInBasisPoints    fee amount in basis points (Collateral token denominated) for minting.
837     ///     mktFeeInBasisPoints fee amount in basis points (MKT denominated) for minting.
838     ///     expirationTimeStamp     seconds from epoch that this contract expires and enters settlement
839     /// @param oracleURL url of data
840     /// @param oracleStatistic statistic type (lastPrice, vwap, etc)
841     constructor(
842         bytes32[3] memory contractNames,
843         address[3] memory baseAddresses,
844         address oracleHubAddress,
845         uint[7] memory contractSpecs,
846         string memory oracleURL,
847         string memory oracleStatistic
848     ) MarketContract(
849         contractNames,
850         baseAddresses,
851         contractSpecs
852     )  public
853     {
854         ORACLE_URL = oracleURL;
855         ORACLE_STATISTIC = oracleStatistic;
856         ORACLE_HUB_ADDRESS = oracleHubAddress;
857     }
858 
859     /*
860     // PUBLIC METHODS
861     */
862 
863     /// @dev called only by our oracle hub when a new price is available provided by our oracle.
864     /// @param price lastPrice provided by the oracle.
865     function oracleCallBack(uint256 price) public onlyOracleHub {
866         require(!isSettled);
867         lastPrice = price;
868         emit UpdatedLastPrice(price);
869         checkSettlement();  // Verify settlement at expiration or requested early settlement.
870     }
871 
872     /// @dev allows us to arbitrate a settlement price by updating the settlement value, and resetting the
873     /// delay for funds to be released. Could also be used to allow us to force a contract into early settlement
874     /// if a dispute arises that we believe is best resolved by early settlement.
875     /// @param price settlement price
876     function arbitrateSettlement(uint256 price) public onlyOwner {
877         require(price >= PRICE_FLOOR && price <= PRICE_CAP, "arbitration price must be within contract bounds");
878         lastPrice = price;
879         emit UpdatedLastPrice(price);
880         settleContract(price);
881         isSettled = true;
882     }
883 
884     /// @dev allows calls only from the oracle hub.
885     modifier onlyOracleHub() {
886         require(msg.sender == ORACLE_HUB_ADDRESS, "only callable by the oracle hub");
887         _;
888     }
889 
890     /// @dev allows for the owner of the contract to change the oracle hub address if needed
891     function setOracleHubAddress(address oracleHubAddress) public onlyOwner {
892         require(oracleHubAddress != address(0), "cannot set oracleHubAddress to null address");
893         ORACLE_HUB_ADDRESS = oracleHubAddress;
894     }
895 
896 }
897 /*
898     Copyright 2017-2019 Phillip A. Elsasser
899 
900     Licensed under the Apache License, Version 2.0 (the "License");
901     you may not use this file except in compliance with the License.
902     You may obtain a copy of the License at
903 
904     http://www.apache.org/licenses/LICENSE-2.0
905 
906     Unless required by applicable law or agreed to in writing, software
907     distributed under the License is distributed on an "AS IS" BASIS,
908     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
909     See the License for the specific language governing permissions and
910     limitations under the License.
911 */
912 
913 
914 
915 
916 contract MarketContractRegistryInterface {
917     function addAddressToWhiteList(address contractAddress) external;
918     function isAddressWhiteListed(address contractAddress) external view returns (bool);
919 }
920 
921 
922 
923 
924 
925 /// @title MarketContractFactoryMPX
926 /// @author Phil Elsasser <phil@marketprotocol.io>
927 contract MarketContractFactoryMPX is Ownable {
928 
929     address public marketContractRegistry;
930     address public oracleHub;
931     address public MARKET_COLLATERAL_POOL;
932 
933     event MarketContractCreated(address indexed creator, address indexed contractAddress);
934 
935     /// @dev deploys our factory and ties it to the supplied registry address
936     /// @param registryAddress - address of our MARKET registry
937     /// @param collateralPoolAddress - address of our MARKET Collateral pool
938     /// @param oracleHubAddress - address of the MPX oracle
939     constructor(
940         address registryAddress,
941         address collateralPoolAddress,
942         address oracleHubAddress
943     ) public {
944         require(registryAddress != address(0), "registryAddress can not be null");
945         require(collateralPoolAddress != address(0), "collateralPoolAddress can not be null");
946         require(oracleHubAddress != address(0), "oracleHubAddress can not be null");
947         
948         marketContractRegistry = registryAddress;
949         MARKET_COLLATERAL_POOL = collateralPoolAddress;
950         oracleHub = oracleHubAddress;
951     }
952 
953     /// @dev Deploys a new instance of a market contract and adds it to the whitelist.
954     /// @param contractNames bytes32 array of names
955     ///     contractName            name of the market contract
956     ///     longTokenSymbol         symbol for the long token
957     ///     shortTokenSymbol        symbol for the short token
958     /// @param collateralTokenAddress address of the ERC20 token that will be used for collateral and pricing
959     /// @param contractSpecs array of unsigned integers including:
960     ///     floorPrice              minimum tradeable price of this contract, contract enters settlement if breached
961     ///     capPrice                maximum tradeable price of this contract, contract enters settlement if breached
962     ///     priceDecimalPlaces      number of decimal places to convert our queried price from a floating point to
963     ///                             an integer
964     ///     qtyMultiplier           multiply traded qty by this value from base units of collateral token.
965     ///     feeInBasisPoints    fee amount in basis points (Collateral token denominated) for minting.
966     ///     mktFeeInBasisPoints fee amount in basis points (MKT denominated) for minting.
967     ///     expirationTimeStamp     seconds from epoch that this contract expires and enters settlement
968     /// @param oracleURL url of data
969     /// @param oracleStatistic statistic type (lastPrice, vwap, etc)
970     function deployMarketContractMPX(
971         bytes32[3] calldata contractNames,
972         address collateralTokenAddress,
973         uint[7] calldata contractSpecs,
974         string calldata oracleURL,
975         string calldata oracleStatistic
976     ) external onlyOwner
977     {
978         MarketContractMPX mktContract = new MarketContractMPX(
979             contractNames,
980             [
981             owner(),
982             collateralTokenAddress,
983             MARKET_COLLATERAL_POOL
984             ],
985             oracleHub,
986             contractSpecs,
987             oracleURL,
988             oracleStatistic
989         );
990 
991         MarketContractRegistryInterface(marketContractRegistry).addAddressToWhiteList(address(mktContract));
992         emit MarketContractCreated(msg.sender, address(mktContract));
993     }
994 
995     /// @dev allows for the owner to set the desired registry for contract creation.
996     /// @param registryAddress desired registry address.
997     function setRegistryAddress(address registryAddress) external onlyOwner {
998         require(registryAddress != address(0), "registryAddress can not be null");
999         marketContractRegistry = registryAddress;
1000     }
1001 
1002     /// @dev allows for the owner to set a new oracle hub address which is responsible for providing data to our
1003     /// contracts
1004     /// @param oracleHubAddress   address of the oracle hub, cannot be null address
1005     function setOracleHubAddress(address oracleHubAddress) external onlyOwner {
1006         require(oracleHubAddress != address(0), "oracleHubAddress can not be null");
1007         oracleHub = oracleHubAddress;
1008     }
1009 }