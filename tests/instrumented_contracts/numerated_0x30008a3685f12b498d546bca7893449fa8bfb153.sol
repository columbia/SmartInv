1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
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
76 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title SafeMath
82  * @dev Unsigned math operations with safety checks that revert on error
83  */
84 library SafeMath {
85     /**
86     * @dev Multiplies two unsigned integers, reverts on overflow.
87     */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
104     */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116     */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125     * @dev Adds two unsigned integers, reverts on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
136     * reverts when dividing by zero.
137     */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 // File: openzeppelin-solidity/contracts/access/Roles.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * @title Roles
150  * @dev Library for managing addresses assigned to a Role.
151  */
152 library Roles {
153     struct Role {
154         mapping (address => bool) bearer;
155     }
156 
157     /**
158      * @dev give an account access to this role
159      */
160     function add(Role storage role, address account) internal {
161         require(account != address(0));
162         require(!has(role, account));
163 
164         role.bearer[account] = true;
165     }
166 
167     /**
168      * @dev remove an account's access to this role
169      */
170     function remove(Role storage role, address account) internal {
171         require(account != address(0));
172         require(has(role, account));
173 
174         role.bearer[account] = false;
175     }
176 
177     /**
178      * @dev check if an account has this role
179      * @return bool
180      */
181     function has(Role storage role, address account) internal view returns (bool) {
182         require(account != address(0));
183         return role.bearer[account];
184     }
185 }
186 
187 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
188 
189 pragma solidity ^0.5.0;
190 
191 
192 contract PauserRole {
193     using Roles for Roles.Role;
194 
195     event PauserAdded(address indexed account);
196     event PauserRemoved(address indexed account);
197 
198     Roles.Role private _pausers;
199 
200     constructor () internal {
201         _addPauser(msg.sender);
202     }
203 
204     modifier onlyPauser() {
205         require(isPauser(msg.sender));
206         _;
207     }
208 
209     function isPauser(address account) public view returns (bool) {
210         return _pausers.has(account);
211     }
212 
213     function addPauser(address account) public onlyPauser {
214         _addPauser(account);
215     }
216 
217     function renouncePauser() public {
218         _removePauser(msg.sender);
219     }
220 
221     function _addPauser(address account) internal {
222         _pausers.add(account);
223         emit PauserAdded(account);
224     }
225 
226     function _removePauser(address account) internal {
227         _pausers.remove(account);
228         emit PauserRemoved(account);
229     }
230 }
231 
232 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
233 
234 pragma solidity ^0.5.0;
235 
236 
237 /**
238  * @title Pausable
239  * @dev Base contract which allows children to implement an emergency stop mechanism.
240  */
241 contract Pausable is PauserRole {
242     event Paused(address account);
243     event Unpaused(address account);
244 
245     bool private _paused;
246 
247     constructor () internal {
248         _paused = false;
249     }
250 
251     /**
252      * @return true if the contract is paused, false otherwise.
253      */
254     function paused() public view returns (bool) {
255         return _paused;
256     }
257 
258     /**
259      * @dev Modifier to make a function callable only when the contract is not paused.
260      */
261     modifier whenNotPaused() {
262         require(!_paused);
263         _;
264     }
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is paused.
268      */
269     modifier whenPaused() {
270         require(_paused);
271         _;
272     }
273 
274     /**
275      * @dev called by the owner to pause, triggers stopped state
276      */
277     function pause() public onlyPauser whenNotPaused {
278         _paused = true;
279         emit Paused(msg.sender);
280     }
281 
282     /**
283      * @dev called by the owner to unpause, returns to normal state
284      */
285     function unpause() public onlyPauser whenPaused {
286         _paused = false;
287         emit Unpaused(msg.sender);
288     }
289 }
290 
291 // File: contracts/libs/Strings.sol
292 
293 pragma solidity 0.5.0;
294 
295 library Strings {
296 
297     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
298     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
299         bytes memory _ba = bytes(_a);
300         bytes memory _bb = bytes(_b);
301         bytes memory _bc = bytes(_c);
302         bytes memory _bd = bytes(_d);
303         bytes memory _be = bytes(_e);
304         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
305         bytes memory babcde = bytes(abcde);
306         uint k = 0;
307         uint i = 0;
308         for (i = 0; i < _ba.length; i++) {
309             babcde[k++] = _ba[i];
310         }
311         for (i = 0; i < _bb.length; i++) {
312             babcde[k++] = _bb[i];
313         }
314         for (i = 0; i < _bc.length; i++) {
315             babcde[k++] = _bc[i];
316         }
317         for (i = 0; i < _bd.length; i++) {
318             babcde[k++] = _bd[i];
319         }
320         for (i = 0; i < _be.length; i++) {
321             babcde[k++] = _be[i];
322         }
323         return string(babcde);
324     }
325 
326     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
327         return strConcat(_a, _b, "", "", "");
328     }
329 
330     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
331         return strConcat(_a, _b, _c, "", "");
332     }
333 
334     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
335         if (_i == 0) {
336             return "0";
337         }
338         uint j = _i;
339         uint len;
340         while (j != 0) {
341             len++;
342             j /= 10;
343         }
344         bytes memory bstr = new bytes(len);
345         uint k = len - 1;
346         while (_i != 0) {
347             bstr[k--] = byte(uint8(48 + _i % 10));
348             _i /= 10;
349         }
350         return string(bstr);
351     }
352 }
353 
354 // File: contracts/INiftyTradingCardCreator.sol
355 
356 pragma solidity 0.5.0;
357 
358 interface INiftyTradingCardCreator {
359     function mintCard(
360         uint256 _cardType,
361         uint256 _nationality,
362         uint256 _position,
363         uint256 _ethnicity,
364         uint256 _kit,
365         uint256 _colour,
366         address _to
367     ) external returns (uint256 _tokenId);
368 
369     function setAttributes(
370         uint256 _tokenId,
371         uint256 _strength,
372         uint256 _speed,
373         uint256 _intelligence,
374         uint256 _skill
375     ) external returns (bool);
376 
377     function setName(
378         uint256 _tokenId,
379         uint256 _firstName,
380         uint256 _lastName
381     ) external returns (bool);
382 
383     function setAttributesAndName(
384         uint256 _tokenId,
385         uint256 _strength,
386         uint256 _speed,
387         uint256 _intelligence,
388         uint256 _skill,
389         uint256 _firstName,
390         uint256 _lastName
391     ) external returns (bool);
392 }
393 
394 // File: contracts/generators/INiftyFootballTradingCardGenerator.sol
395 
396 pragma solidity 0.5.0;
397 
398 contract INiftyFootballTradingCardGenerator {
399     function generateCard(address _sender) external returns (uint256 _nationality, uint256 _position, uint256 _ethnicity, uint256 _kit, uint256 _colour);
400 
401     function generateAttributes(address _sender, uint256 _base) external returns (uint256 strength, uint256 speed, uint256 intelligence, uint256 skill);
402 
403     function generateName(address _sender) external returns (uint256 firstName, uint256 lastName);
404 }
405 
406 // File: contracts/FundsSplitter.sol
407 
408 pragma solidity ^0.5.0;
409 
410 
411 
412 contract FundsSplitter is Ownable {
413     using SafeMath for uint256;
414 
415     address payable public platform;
416     address payable public partner;
417 
418     uint256 public partnerRate = 7;
419 
420     constructor (address payable _platform, address payable _partner) public {
421         platform = _platform;
422         partner = _partner;
423     }
424 
425     function splitFunds(uint256 _totalPrice) internal {
426         if (msg.value > 0) {
427             uint256 refund = msg.value.sub(_totalPrice);
428 
429             // overpaid...
430             if (refund > 0) {
431                 msg.sender.transfer(refund);
432             }
433 
434             // work out the amount to split and send it
435             uint256 partnerAmount = _totalPrice.div(100).mul(partnerRate);
436             partner.transfer(partnerAmount);
437 
438             // send remaining amount to partner wallet
439             uint256 remaining = _totalPrice.sub(partnerAmount);
440             platform.transfer(remaining);
441         }
442     }
443 
444     function updatePartnerAddress(address payable _partner) onlyOwner public {
445         partner = _partner;
446     }
447 
448     function updatePartnerRate(uint256 _techPartnerRate) onlyOwner public {
449         partnerRate = _techPartnerRate;
450     }
451 
452     function updatePlatformAddress(address payable _platform) onlyOwner public {
453         platform = _platform;
454     }
455 
456     function withdraw() public onlyOwner returns (bool) {
457         platform.transfer(address(this).balance);
458         return true;
459     }
460 }
461 
462 // File: contracts/NiftyFootballTradingCardEliteBlindPack.sol
463 
464 pragma solidity 0.5.0;
465 
466 
467 
468 
469 
470 
471 
472 
473 
474 contract NiftyFootballTradingCardEliteBlindPack is Ownable, Pausable, FundsSplitter {
475     using SafeMath for uint256;
476 
477     event PriceInWeiChanged(uint256 _old, uint256 _new);
478 
479     event DefaultCardTypeChanged(uint256 _new);
480 
481     event AttributesBaseChanged(uint256 _new);
482 
483     event FutballCardsGeneratorChanged(INiftyFootballTradingCardGenerator _new);
484 
485     INiftyFootballTradingCardGenerator public generator;
486     INiftyTradingCardCreator public creator;
487 
488     uint256 public totalPurchasesInWei = 0;
489     uint256 public cardTypeDefault = 0;
490     uint256 public attributesBase = 60; // Standard 60-100
491 
492     uint256[] public pricePerCard = [
493     // single cards
494     16000000000000000, // 1 @ = 0.016 ETH / $2.50
495     16000000000000000, // 2 @ = 0.016 ETH / $2.50
496 
497     // 1 packs
498     14500000000000000, //  3 @ = 0.0145 ETH / $2.30
499     14500000000000000, //  4 @ = 0.0145 ETH / $2.30
500     14500000000000000, //  5 @ = 0.0145 ETH / $2.30
501 
502     // 2 packs
503     13500000000000000, //  6 @ = 0.0135 ETH / $2.15
504     13500000000000000, //  7 @ = 0.0135 ETH / $2.15
505     13500000000000000, //  8 @ = 0.0135 ETH / $2.15
506 
507     // 3 packs or more
508     12500000000000000, //  9 @ = 0.0125 ETH / $2
509     12500000000000000 //  10 @ = 0.0125 ETH / $2
510     ];
511 
512     constructor (
513         address payable _wallet,
514         address payable _partnerAddress,
515         INiftyFootballTradingCardGenerator _generator,
516         INiftyTradingCardCreator _creator
517     ) public FundsSplitter(_wallet, _partnerAddress) {
518         generator = _generator;
519         creator = _creator;
520     }
521 
522     function blindPack() whenNotPaused public payable {
523         blindPackTo(msg.sender);
524     }
525 
526     function blindPackTo(address _to) whenNotPaused public payable {
527         uint256 _totalPrice = totalPrice(1);
528         require(
529             msg.value >= _totalPrice,
530             "Must supply at least the required minimum purchase value"
531         );
532         require(!isContract(msg.sender), "Unable to buy packs from another contract");
533 
534         _generateAndAssignCard(_to);
535 
536         _takePayment(1, _totalPrice);
537     }
538 
539     function buyBatch(uint256 _numberOfCards) whenNotPaused public payable {
540         return buyBatchTo(msg.sender, _numberOfCards);
541     }
542 
543     function buyBatchTo(address _to, uint256 _numberOfCards) whenNotPaused public payable {
544         uint256 _totalPrice = totalPrice(_numberOfCards);
545         require(
546             msg.value >= _totalPrice,
547             "Must supply at least the required minimum purchase value"
548         );
549         require(!isContract(msg.sender), "Unable to buy packs from another contract");
550 
551         for (uint i = 0; i < _numberOfCards; i++) {
552             _generateAndAssignCard(_to);
553         }
554 
555         _takePayment(_numberOfCards, _totalPrice);
556     }
557 
558     function _generateAndAssignCard(address _to) internal {
559         // Generate card
560         (uint256 _nationality, uint256 _position, uint256 _ethnicity, uint256 _kit, uint256 _colour) = generator.generateCard(msg.sender);
561 
562         // cardType is 0 for genesis (initially)
563         uint256 tokenId = creator.mintCard(cardTypeDefault, _nationality, _position, _ethnicity, _kit, _colour, _to);
564         
565         // Generate attributes
566         (uint256 _strength, uint256 _speed, uint256 _intelligence, uint256 _skill) = generator.generateAttributes(msg.sender, attributesBase);
567         (uint256 _firstName, uint256 _lastName) = generator.generateName(msg.sender);
568 
569         creator.setAttributesAndName(tokenId, _strength, _speed, _intelligence, _skill, _firstName, _lastName);
570     }
571 
572     function _takePayment(uint256 _numberOfCards, uint256 _totalPrice) internal {
573         // any trapped ether can be withdrawn with withdraw()
574         totalPurchasesInWei = totalPurchasesInWei.add(_totalPrice);
575         splitFunds(_totalPrice);
576     }
577 
578     function setCardTypeDefault(uint256 _newDefaultCardType) public onlyOwner returns (bool) {
579         cardTypeDefault = _newDefaultCardType;
580 
581         emit DefaultCardTypeChanged(_newDefaultCardType);
582 
583         return true;
584     }
585 
586     function setAttributesBase(uint256 _newAttributesBase) public onlyOwner returns (bool) {
587         attributesBase = _newAttributesBase;
588 
589         emit AttributesBaseChanged(_newAttributesBase);
590 
591         return true;
592     }
593 
594     function setFutballCardsGenerator(INiftyFootballTradingCardGenerator _futballCardsGenerator) public onlyOwner returns (bool) {
595         generator = _futballCardsGenerator;
596 
597         emit FutballCardsGeneratorChanged(_futballCardsGenerator);
598 
599         return true;
600     }
601 
602     function updatePricePerCardAtIndex(uint256 _index, uint256 _priceInWei) public onlyOwner returns (bool) {
603         pricePerCard[_index] = _priceInWei;
604         return true;
605     }
606 
607     function updatePricePerCard(uint256[] memory _pricePerCard) public onlyOwner returns (bool) {
608         pricePerCard = _pricePerCard;
609         return true;
610     }
611 
612     function totalPrice(uint256 _numberOfCards) public view returns (uint256) {
613         if (_numberOfCards > pricePerCard.length) {
614             return pricePerCard[pricePerCard.length - 1].mul(_numberOfCards);
615         }
616         return pricePerCard[_numberOfCards - 1].mul(_numberOfCards);
617     }
618 
619     /**
620      * Returns whether the target address is a contract
621      * Based on OpenZeppelin Address library
622      * @dev This function will return false if invoked during the constructor of a contract,
623      * as the code is not actually created until after the constructor finishes.
624      * @param account address of the account to check
625      * @return whether the target address is a contract
626      */
627     function isContract(address account) internal view returns (bool) {
628         uint256 size;
629         // XXX Currently there is no better way to check if there is a contract in an address
630         // than to check the size of the code at that address.
631         // See https://ethereum.stackexchange.com/a/14016/36603
632         // for more details about how this works.
633         // contracts then.
634         // solhint-disable-next-line no-inline-assembly
635         assembly {size := extcodesize(account)}
636         return size > 0;
637     }
638 }