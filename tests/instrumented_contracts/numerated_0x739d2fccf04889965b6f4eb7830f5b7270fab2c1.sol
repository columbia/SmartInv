1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     //Variables
41     address public owner;
42 
43     address public newOwner;
44 
45     //    Modifiers
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param _newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address _newOwner) public onlyOwner {
67         require(_newOwner != address(0));
68         newOwner = _newOwner;
69 
70     }
71 
72     function acceptOwnership() public {
73         if (msg.sender == newOwner) {
74             owner = newOwner;
75         }
76     }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85     uint256 public totalSupply;
86     function balanceOf(address who) public constant returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96 
97     using SafeMath for uint256;
98 
99     mapping (address => uint256) public balances;
100 
101     /**
102     * @dev transfer token for a specified address
103     * @param _to The address to transfer to.
104     * @param _value The amount to be transferred.
105     */
106     function transfer(address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109 
110         // SafeMath.sub will throw if there is not enough balance.
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126 }
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133     function allowance(address owner, address spender) public constant returns (uint256);
134     function transferFrom(address from, address to, uint256 value) public returns (bool);
135     function approve(address spender, uint256 value) public returns (bool);
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood:
145         https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149     mapping (address => mapping (address => uint256)) internal allowed;
150 
151     /**
152      * @dev Transfer tokens from one address to another
153      * @param _from address The address which you want to send tokens from
154      * @param _to address The address which you want to transfer to
155      * @param _value uint256 the amount of tokens to be transferred
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     /**
170      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171      *
172      * Beware that changing an allowance with this method brings the risk that someone may use both the old
173      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      * @param _spender The address which will spend the funds.
177      * @param _value The amount of tokens to be spent.
178      */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     /**
186      * @dev Function to check the amount of tokens that an owner allowed to a spender.
187      * @param _owner address The address which owns the funds.
188      * @param _spender address The address which will spend the funds.
189      * @return A uint256 specifying the amount of tokens still available for the spender.
190      */
191     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
192         return allowed[_owner][_spender];
193     }
194 
195     /**
196      * approve should be called when allowed[_spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      */
201     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218 }
219 
220 contract OCGERC20 is StandardToken, Ownable {
221 
222     using SafeMath for uint256;
223 
224     /* Public variables of the token */
225     uint256 public creationBlock;
226 
227     uint8 public decimals;
228 
229     string public name;
230 
231     string public symbol;
232 
233     string public standard;
234 
235     bool public locked;
236 
237     /* Initializes contract with initial supply tokens to the creator of the contract */
238     function OCGERC20(
239         uint256 _totalSupply,
240         string _tokenName,
241         uint8 _decimalUnits,
242         string _tokenSymbol,
243         bool _transferAllSupplyToOwner,
244         bool _locked
245     ) public {
246         standard = "ERC20 0.1";
247         locked = _locked;
248         totalSupply = _totalSupply;
249 
250         if (_transferAllSupplyToOwner) {
251             balances[msg.sender] = totalSupply;
252         } else {
253             balances[this] = totalSupply;
254         }
255         name = _tokenName;
256         // Set the name for display purposes
257         symbol = _tokenSymbol;
258         // Set the symbol for display purposes
259         decimals = _decimalUnits;
260         // Amount of decimals for display purposes
261         creationBlock = block.number;
262     }
263 
264     /* public methods */
265     function transfer(address _to, uint256 _value) public returns (bool) {
266         require(locked == false);
267         return super.transfer(_to, _value);
268     }
269 
270     function approve(address _spender, uint256 _value) public returns (bool success) {
271         if (locked) {
272             return false;
273         }
274         return super.approve(_spender, _value);
275     }
276 
277     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
278         if (locked) {
279             return false;
280         }
281         return super.increaseApproval(_spender, _addedValue);
282     }
283 
284     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
285         if (locked) {
286             return false;
287         }
288         return super.decreaseApproval(_spender, _subtractedValue);
289     }
290 
291     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
292         if (locked) {
293             return false;
294         }
295 
296         return super.transferFrom(_from, _to, _value);
297     }
298 
299     function transferFee(address _from, address _to, uint256 _value) internal returns (bool success) {
300         require(_to != address(0));
301         require(_value <= balances[_from]);
302 
303         balances[_from] = balances[_from].sub(_value);
304         balances[_to] = balances[_to].add(_value);
305 
306         return true;
307     }
308 
309     function burnInternal(address _address, uint256 _value) internal returns (bool) {
310         balances[_address] = balances[_address].sub(_value);
311         Transfer(_address, address(0), _value);
312         return true;
313     }
314 
315 }
316 
317 /*
318 This contract manages the minters and the modifier to allow mint to happen only if called by minters
319 This contract contains basic minting functionality though
320 */
321 contract MintingERC20 is OCGERC20 {
322 
323     // Variables
324     mapping (address => bool) public minters;
325 
326     // Modifiers
327     modifier onlyMinters() {
328         require(true == minters[msg.sender]);
329         _;
330     }
331 
332     function MintingERC20(
333         uint256 _initialSupply,
334         string _tokenName,
335         uint8 _decimals,
336         string _symbol,
337         bool _transferAllSupplyToOwner,
338         bool _locked
339     )
340     public OCGERC20(
341         _initialSupply,
342         _tokenName,
343         _decimals,
344         _symbol,
345         _transferAllSupplyToOwner,
346         _locked
347     )
348     {
349         standard = "MintingERC20 0.1";
350         minters[msg.sender] = true;
351     }
352 
353     function addMinter(address _newMinter) public onlyOwner {
354         minters[_newMinter] = true;
355     }
356 
357     function removeMinter(address _minter) public onlyOwner {
358         minters[_minter] = false;
359     }
360 
361     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
362         if (_amount == uint256(0)) {
363             return uint256(0);
364         }
365 
366         totalSupply = totalSupply.add(_amount);
367         balances[_addr] = balances[_addr].add(_amount);
368         Transfer(address(0), _addr, _amount);
369 
370         return _amount;
371     }
372 }
373 
374 contract OCG is MintingERC20 {
375 
376     OCGFee public fees;
377 
378     SellableToken public sellableToken;
379 
380     uint256 public deployedAt;
381 
382     address public burnAddress;
383 
384     bool public isInitialValuesFetched;
385 
386     mapping (address => uint256) public burnAmount;
387 
388     mapping (address => uint256) public lastCharge;
389 
390     event TransferFee(address indexed from, uint256 value);
391 
392     event StorageFee(address indexed from, uint256 value);
393 
394     modifier onlySellableContract() {
395         require(msg.sender == address(sellableToken));
396         _;
397     }
398 
399     function OCG(
400         string _tokenName,
401         string _tokenSymbol,
402         uint8 _decimalUnits,
403         address _burnAddress,
404         bool _locked
405     ) public MintingERC20(
406         0,
407         _tokenName,
408         _decimalUnits,
409         _tokenSymbol,
410         false,
411         _locked
412     ) {
413         standard = "OCG 0.1";
414         deployedAt = now;
415         require(_burnAddress != address(0));
416         burnAddress = _burnAddress;
417     }
418 
419     function fetchInitialValues(OCG _sourceAddress, address[7] _holders) public onlyOwner {
420         require(isInitialValuesFetched == false);
421         isInitialValuesFetched = true;
422 
423         for (uint256 i = 0; i < _holders.length; i++) {
424             mint(_holders[i], _sourceAddress.balanceOf(_holders[i]));
425         }
426     }
427 
428     function setLocked(bool _locked) public onlyOwner {
429         locked = _locked;
430     }
431 
432     function setOCGFee(address _fees) public onlyOwner {
433         require(_fees != address(0));
434         fees = OCGFee(_fees);
435     }
436 
437     function setSellableToken(address _sellable) public onlyOwner {
438         require(_sellable != address(0));
439         sellableToken = SellableToken(_sellable);
440     }
441 
442     function setBurnAddress(address _burnAddress) public onlyOwner {
443         require(_burnAddress != address(0));
444         burnAddress = _burnAddress;
445     }
446 
447     function burn(address _address) public onlyOwner {
448         if (burnAmount[_address] > 0) {
449             super.burnInternal(burnAddress, burnAmount[_address]);
450             burnAmount[_address] = 0;
451         }
452     }
453 
454     function transfer(address _to, uint256 _value) public returns (bool status) {
455         require(locked == false && msg.sender != burnAddress);
456 
457         uint256 valueToTransfer = _value;
458 
459         if (_to == burnAddress) {
460             burnAmount[msg.sender] = burnAmount[msg.sender].add(valueToTransfer);
461         } else {
462             uint256 feeValue = transferFees(msg.sender, _to, _value);
463 
464             valueToTransfer = _value.sub(feeValue);
465             if (valueToTransfer > balanceOf(msg.sender)) {
466                 valueToTransfer = balanceOf(msg.sender);
467             }
468         }
469 
470         status = super.transfer(_to, valueToTransfer);
471 
472         sellableToken.updateFreeStorage(msg.sender, balanceOf(msg.sender));
473     }
474 
475     function transferFrom(address _from, address _to, uint256 _value) public returns (bool status) {
476         require(locked == false && _from != burnAddress);
477 
478         uint256 valueToTransfer = _value;
479 
480         if (_to == burnAddress) {
481             burnAmount[_from] = burnAmount[_from].add(valueToTransfer);
482         } else {
483             uint256 feeValue = transferFees(_from, _to, _value);
484 
485             valueToTransfer = _value.sub(feeValue);
486             if (valueToTransfer > balanceOf(_from)) {
487                 valueToTransfer = balanceOf(_from);
488             }
489         }
490 
491         status = super.transferFrom(_from, _to, valueToTransfer);
492         require(status == true);
493 
494         sellableToken.updateFreeStorage(_from, balanceOf(_from));
495     }
496 
497     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
498         uint256 mintedAmount = super.mint(_addr, _amount);
499 
500         if (mintedAmount == _amount && lastCharge[_addr] == 0 && _amount > 0) {
501             lastCharge[_addr] = now;
502         }
503 
504         return mintedAmount;
505     }
506 
507     function payStorageFee(address _from) internal returns (bool) {
508         require(_from != address(0) && address(fees) != address(0) && address(sellableToken) != address(0));
509         uint256 _value = balanceOf(_from);
510         require(sellableToken.freeStorage(_from) <= _value);
511 
512         bool status = true;
513         uint256 additionalAmount = 0;
514 
515         if (sellableToken.freeStorage(_from) != 0) {
516             if (deployedAt.add(fees.offPeriod()) >= now) {
517                 _value = _value.sub(sellableToken.freeStorage(_from));
518             } else if (lastCharge[_from] < deployedAt.add(fees.offPeriod())) {
519                 additionalAmount = calculateStorageFee(
520                     _value.sub(sellableToken.freeStorage(_from)),
521                     deployedAt.add(fees.offPeriod()).sub(lastCharge[_from])
522                 );
523                 lastCharge[_from] = deployedAt.add(fees.offPeriod());
524             }
525         }
526 
527         uint256 amount = calculateStorageFee(_value, now.sub(lastCharge[_from])).add(additionalAmount);
528         if (amount != 0 && balanceOf(_from) >= amount) {
529             status = super.transferFee(_from, fees.feeAddress(), amount);
530             StorageFee(_from, amount);
531         }
532 
533         require(status == true);
534         lastCharge[_from] = now;
535 
536         return status;
537     }
538 
539     function calculateStorageFee(uint256 _value, uint256 _period) internal view returns (uint256) {
540         uint256 amount = 0;
541         if (_period.div(1 days) > 0 && _value > 0) {
542             amount = _value.mul(fees.feeAmount()).mul(_period).div(1 years).div(1000);
543         }
544 
545         return amount;
546     }
547 
548     function transferFees(address _from, address _to, uint256 _value) internal returns (uint256) {
549         require(address(fees) != address(0) && address(sellableToken) != address(0));
550 
551         bool status = false;
552 
553         if (fees.feeAmount() > 0) {
554             status = payStorageFee(_from);
555             if (status) {
556                 status = payStorageFee(_to);
557             }
558         }
559 
560         uint256 feeValue = 0;
561         if (fees.transferFee() > 0) {
562             feeValue = _value.mul(fees.transferFee()).div(uint(10) ** decimals);
563         }
564         if (status && feeValue > 0) {
565             status = super.transferFee(_from, fees.transferFeeAddress(), feeValue);
566             TransferFee(_from, feeValue);
567         }
568 
569         require(status == true);
570 
571         return feeValue;
572     }
573 
574 }
575 
576 contract OCGFee is Ownable {
577 
578     SellableToken public sellableToken;
579 
580     using SafeMath for uint256;
581 
582     uint256 public offPeriod = 3 years;
583 
584     uint256 public offThreshold;
585 
586     uint256 public feeAmount;
587 
588     address public feeAddress;
589 
590     address public transferFeeAddress;
591 
592     uint256 public transferFee;
593 
594     modifier onlySellableContract() {
595         require(msg.sender == address(sellableToken));
596         _;
597     }
598 
599     function OCGFee(
600         uint256 _offThreshold,
601         address _feeAddress,
602         uint256 _feeAmount,//0.5% -> 5
603         address _transferFeeAddress,
604         uint256 _transferFee //0.04% -> 0.04 * 10 ^ decimals
605     )
606         public
607     {
608         require(_feeAddress != address(0) && _feeAmount >= 0 && _offThreshold > 0);
609         offThreshold = _offThreshold;
610         feeAddress = _feeAddress;
611         feeAmount = _feeAmount;
612 
613         require(_transferFeeAddress != address(0) && _transferFee >= 0);
614         transferFeeAddress = _transferFeeAddress;
615         transferFee = _transferFee;
616     }
617 
618     function setSellableToken(address _sellable) public onlyOwner {
619         require(_sellable != address(0));
620         sellableToken = SellableToken(_sellable);
621     }
622 
623     function setStorageFee(
624         uint256 _offThreshold,
625         address _feeAddress,
626         uint256 _feeAmount //0.5% -> 5
627     ) public onlyOwner {
628         require(_feeAddress != address(0));
629 
630         offThreshold = _offThreshold;
631         feeAddress = _feeAddress;
632         feeAmount = _feeAmount;
633     }
634 
635     function decreaseThreshold(uint256 _value) public onlySellableContract {
636         if (offThreshold < _value) {
637             offThreshold = 0;
638         } else {
639             offThreshold = offThreshold.sub(_value);
640         }
641     }
642 
643     function setTransferFee(address _transferFeeAddress, uint256 _transferFee) public onlyOwner returns (bool) {
644         if (_transferFeeAddress != address(0) && _transferFee >= 0) {
645             transferFeeAddress = _transferFeeAddress;
646             transferFee = _transferFee;
647 
648             return true;
649         }
650 
651         return false;
652     }
653 
654 }
655 
656 contract Multivest is Ownable {
657     /* public variables */
658     mapping (address => bool) public allowedMultivests;
659 
660     /* events */
661     event MultivestSet(address multivest);
662 
663     event MultivestUnset(address multivest);
664 
665     event Contribution(address _holder, uint256 tokens);
666 
667     modifier onlyAllowedMultivests(address _address) {
668         require(true == allowedMultivests[_address]);
669         _;
670     }
671 
672     /* constructor */
673     function Multivest(address _multivest) public {
674         allowedMultivests[_multivest] = true;
675     }
676 
677     /* public methods */
678     function setAllowedMultivest(address _address) public onlyOwner {
679         allowedMultivests[_address] = true;
680     }
681 
682     function unsetAllowedMultivest(address _address) public onlyOwner {
683         allowedMultivests[_address] = false;
684     }
685 
686     function multivestBuy(
687         address _address,
688         uint256 _amount,
689         uint256 _value
690     ) public onlyAllowedMultivests(msg.sender) {
691         bool status = buy(_address, _amount, _value);
692 
693         require(status == true);
694     }
695 
696     function buy(address _address, uint256 _amount, uint256 _value) internal returns (bool);
697 
698 }
699 
700 contract SellableToken is Multivest {
701 
702     using SafeMath for uint256;
703 
704     // The token being sold
705     OCG public ocg;
706 
707     OCGFee public fees;
708 
709     // amount of sold tokens
710     uint256 public soldTokens;
711 
712     uint256 public minInvest;
713 
714     mapping (address => uint256) public freeStorage;
715 
716     modifier onlyOCGContract() {
717         require(msg.sender == address(ocg));
718         _;
719     }
720 
721     function SellableToken(
722         address _ocg,
723         uint256 _minInvest //0.1 tokens -> 0.1 * 10 ^ decimals
724     )
725         public Multivest(msg.sender)
726     {
727         require(_minInvest > 0);
728         ocg = OCG(_ocg);
729 
730         minInvest = _minInvest;
731     }
732 
733     function setOCG(address _ocg) public onlyOwner {
734         require(_ocg != address(0));
735         ocg = OCG(_ocg);
736     }
737 
738     function setOCGFee(address _fees) public onlyOwner {
739         require(_fees != address(0));
740         fees = OCGFee(_fees);
741     }
742 
743     function updateFreeStorage(address _address, uint256 _value) public onlyOCGContract {
744         if (freeStorage[_address] > _value) {
745             freeStorage[_address] = _value;
746         }
747     }
748 
749     function buy(address _address, uint256 _amount, uint256 _value) internal returns (bool) {
750         require(_address != address(0) && address(ocg) != address(0));
751 
752         if (_amount == 0 || _amount < minInvest || _value == 0) {
753             return false;
754         }
755 
756         uint256 mintedAmount = ocg.mint(_address, _amount);
757 
758         require(mintedAmount == _amount);
759 
760         onSuccessfulBuy(_address, _value, _amount);
761 
762         return true;
763     }
764 
765     function onSuccessfulBuy(address _address, uint256 _value, uint256 _amount) internal {
766         soldTokens = soldTokens.add(_amount);
767         if (fees.offThreshold() > 0) {
768             uint256 freeAmount = _amount;
769             if (fees.offThreshold() < _value) {
770                 freeAmount = _amount.sub(_value.sub(fees.offThreshold()).mul(_amount).div(_value));
771             }
772 
773             freeStorage[_address] = freeStorage[_address].add(freeAmount);
774         }
775 
776         fees.decreaseThreshold(_value);
777     }
778 
779 }
780 
781 contract Deposit is Multivest {
782 
783     address public etherHolder;
784 
785     function Deposit(
786         address _etherHolder
787     )
788         public Multivest(msg.sender)
789     {
790         require(_etherHolder != address(0));
791         etherHolder = _etherHolder;
792     }
793 
794     function setEtherHolder(address _etherHolder) public onlyOwner {
795         require(_etherHolder != address(0));
796         etherHolder = _etherHolder;
797     }
798 
799     function deposit(
800         address _address,
801         uint8 _v,
802         bytes32 _r,
803         bytes32 _s
804     ) public payable onlyAllowedMultivests(verify(keccak256(msg.sender), _v, _r, _s)) {
805         require(_address == msg.sender);
806         Contribution(msg.sender, msg.value);
807         etherHolder.transfer(msg.value);
808     }
809 
810     function verify(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
811         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
812 
813         return ecrecover(keccak256(prefix, _hash), _v, _r, _s);
814     }
815 
816     function buy(address _address, uint256 _amount, uint256 _value) internal returns (bool) {
817         _address = _address;
818         _amount = _amount;
819         _value = _value;
820         return true;
821     }
822 
823 }