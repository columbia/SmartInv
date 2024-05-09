1 pragma solidity 0.4.15;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     //Variables
11     address public owner;
12 
13     address public newOwner;
14 
15     //    Modifiers
16     /**
17      * @dev Throws if called by any account other than the owner.
18      */
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     /**
25      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26      * account.
27      */
28     function Ownable() public {
29         owner = msg.sender;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param _newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address _newOwner) public onlyOwner {
37         require(_newOwner != address(0));
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         if (msg.sender == newOwner) {
43             owner = newOwner;
44             newOwner = address(0);
45         }
46     }
47 }
48 
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 library SafeMath {
55     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
56         uint256 c = a * b;
57         assert(a == 0 || c / a == b);
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal constant returns (uint256) {
62         // assert(b > 0); // Solidity automatically throws when dividing by 0
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65         return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
69         assert(b <= a);
70         return a - b;
71     }
72 
73     function add(uint256 a, uint256 b) internal constant returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 contract TokenRecipient {
81     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
82 }
83 
84 
85 contract ERC20 is Ownable {
86     using SafeMath for uint256;
87 
88     /* Public variables of the token */
89     uint256 public initialSupply;
90 
91     uint256 public creationBlock;
92 
93     uint8 public decimals;
94 
95     string public name;
96 
97     string public symbol;
98 
99     string public standard;
100 
101     bool public locked;
102 
103     bool public transferFrozen;
104 
105     mapping (address => uint256) public balances;
106 
107     mapping (address => mapping (address => uint256)) public allowed;
108 
109     /* This generates a public event on the blockchain that will notify clients */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111     event Approval(address indexed _owner, address indexed _spender, uint _value);
112 
113     modifier onlyPayloadSize(uint _numwords) {
114         assert(msg.data.length == _numwords * 32 + 4);
115         _;
116     }
117 
118     /* Initializes contract with initial supply tokens to the creator of the contract */
119     function ERC20(
120         uint256 _initialSupply,
121         string _tokenName,
122         uint8 _decimalUnits,
123         string _tokenSymbol,
124         bool _transferAllSupplyToOwner,
125         bool _locked
126     )
127         public
128     {
129         standard = "ERC20 0.1";
130 
131         initialSupply = _initialSupply;
132 
133         if (_transferAllSupplyToOwner) {
134             setBalance(msg.sender, initialSupply);
135         } else {
136             setBalance(this, initialSupply);
137         }
138 
139         name = _tokenName;
140         // Set the name for display purposes
141         symbol = _tokenSymbol;
142         // Set the symbol for display purposes
143         decimals = _decimalUnits;
144         // Amount of decimals for display purposes
145         locked = _locked;
146         creationBlock = block.number;
147     }
148 
149     /* public methods */
150     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
151         require(locked == false);
152         require(transferFrozen == false);
153     
154         bool status = transferInternal(msg.sender, _to, _value);
155 
156         require(status == true);
157 
158         return true;
159     }
160 
161     function approve(address _spender, uint256 _value) public returns (bool success) {
162         if (locked) {
163             return false;
164         }
165 
166         allowed[msg.sender][_spender] = _value;
167 
168         Approval(msg.sender, _spender, _value);
169 
170         return true;
171     }
172 
173     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
174         if (locked) {
175             return false;
176         }
177 
178         TokenRecipient spender = TokenRecipient(_spender);
179 
180         if (approve(_spender, _value)) {
181             spender.receiveApproval(msg.sender, _value, this, _extraData);
182             return true;
183         }
184     }
185 
186     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success) {
187         if (locked) {
188             return false;
189         }
190 
191         if (transferFrozen) {
192             return false;
193         }
194 
195         if (allowed[_from][msg.sender] < _value) {
196             return false;
197         }
198 
199         bool _success = transferInternal(_from, _to, _value);
200 
201         if (_success) {
202             allowed[_from][msg.sender] -= _value;
203         }
204 
205         return _success;
206     }
207 
208     /*constant functions*/
209     function totalSupply() public constant returns (uint256) {
210         return initialSupply;
211     }
212 
213     function balanceOf(address _address) public constant returns (uint256 balance) {
214         return balances[_address];
215     }
216 
217     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
218         return allowed[_owner][_spender];
219     }
220 
221     /* internal functions*/
222     function setBalance(address _holder, uint256 _amount) internal {
223         balances[_holder] = _amount;
224     }
225 
226     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
227         require(locked == false);
228         require(transferFrozen == false);
229 
230         if (_value == 0) {
231             Transfer(_from, _to, _value);
232 
233             return true;
234         }
235 
236         if (balances[_from] < _value) {
237             return false;
238         }
239 
240         setBalance(_from, balances[_from].sub(_value));
241         setBalance(_to, balances[_to].add(_value));
242 
243         Transfer(_from, _to, _value);
244 
245         return true;
246     }
247 }
248 
249 contract ERC223 {
250     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
251     function transfer(address to, uint value, bytes data) public returns (bool ok);
252     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
253 }
254 
255 
256 contract ContractReceiver {
257     function tokenFallback(address _from, uint _value, bytes _data) public;
258 }
259 
260 /*
261     Based on https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol
262 */
263 
264 contract ERC223Token is ERC223, ERC20 {
265     function ERC223Token(
266         uint256 _initialSupply,
267         string tokenName,
268         uint8 decimalUnits,
269         string tokenSymbol,
270         bool transferAllSupplyToOwner,
271         bool _locked
272     )
273         public
274         ERC20(_initialSupply, tokenName, decimalUnits, tokenSymbol, transferAllSupplyToOwner, _locked)
275     {
276         
277     }
278 
279     function transfer(address to, uint256 value, bytes data) public returns (bool success) {
280         require(locked == false);
281         
282         bool status = transferInternal(msg.sender, to, value, data);
283 
284         return status;
285     }
286 
287     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool success) {
288         require(locked == false);
289 
290         bool status = transferInternal(msg.sender, to, value, data, true, customFallback);
291 
292         return status;
293     }
294 
295 // rollback changes to transferInternal for transferFrom
296     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success) {
297         if (locked) {
298             return false;
299         }
300 
301         if (transferFrozen) {
302             return false;
303         }
304 
305         if (allowed[_from][msg.sender] < _value) {
306             return false;
307         }
308 
309         bool _success = super.transferInternal(_from, _to, _value);
310 
311         if (_success) {
312             allowed[_from][msg.sender] -= _value;
313         }
314 
315         return _success;
316     }
317 
318     function transferInternal(address from, address to, uint256 value, bytes data) internal returns (bool success) {
319         return transferInternal(from, to, value, data, false, "");
320     }
321 
322     function transferInternal(
323         address from,
324         address to,
325         uint256 value,
326         bytes data,
327         bool useCustomFallback,
328         string customFallback
329     )
330         internal returns (bool success)
331     {
332         bool status = super.transferInternal(from, to, value);
333 
334         if (status) {
335             if (isContract(to)) {
336                 ContractReceiver receiver = ContractReceiver(to);
337 
338                 if (useCustomFallback) {
339                     // solhint-disable-next-line avoid-call-value
340                     require(receiver.call.value(0)(bytes4(keccak256(customFallback)), from, value, data) == true);
341                 } else {
342                     receiver.tokenFallback(from, value, data);
343                 }
344             }
345 
346             Transfer(from, to, value, data);
347         }
348 
349         return status;
350     }
351 
352     function transferInternal(address from, address to, uint256 value) internal returns (bool success) {
353         require(locked == false);
354 
355         bytes memory data;
356 
357         return transferInternal(from, to, value, data, false, "");
358     }
359 
360     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
361     function isContract(address _addr) private returns (bool) {
362         uint length;
363         assembly {
364         //retrieve the size of the code on target address, this needs assembly
365             length := extcodesize(_addr)
366         }
367         return (length > 0);
368     }
369 }
370 
371 /*
372 This contract manages the minters and the modifier to allow mint to happen only if called by minters
373 This contract contains basic minting functionality though
374 */
375 contract MintingERC20 is ERC223Token {
376 
377     using SafeMath for uint256;
378 
379     uint256 public maxSupply;
380 
381     mapping (address => bool) public minters;
382 
383     modifier onlyMinters () {
384         require(true == minters[msg.sender]);
385         _;
386     }
387 
388     function MintingERC20(
389         uint256 _initialSupply,
390         uint256 _maxSupply,
391         string _tokenName,
392         uint8 _decimals,
393         string _symbol,
394         bool _transferAllSupplyToOwner,
395         bool _locked
396     )
397         ERC223Token(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
398     {
399         minters[msg.sender] = true;
400         maxSupply = _maxSupply;
401     }
402 
403     function addMinter(address _newMinter) public onlyOwner {
404         minters[_newMinter] = true;
405     }
406 
407     function removeMinter(address _minter) public onlyOwner {
408         minters[_minter] = false;
409     }
410 
411     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
412         return internalMint(_addr, _amount);
413     }
414 
415     function internalMint(address _addr, uint256 _amount) internal returns (uint256) {
416         if (_amount == uint256(0)) {
417             return uint256(0);
418         }
419 
420         if (totalSupply().add(_amount) > maxSupply) {
421             return uint256(0);
422         }
423 
424         initialSupply = initialSupply.add(_amount);
425         balances[_addr] = balances[_addr].add(_amount);
426         Transfer(0, _addr, _amount);
427 
428         return _amount;
429     }
430 }
431 
432 
433 contract AbstractClaimableToken {
434     function claimedTokens(address _holder, uint256 _tokens) public;
435 }
436 
437 
438 contract GenesisToken is MintingERC20 {
439     using SafeMath for uint256;
440 
441     /* variables */
442     uint256 public emitTokensSince;
443 
444     TokenEmission[] public emissions;
445 
446     mapping(address => uint256) public lastClaims;
447 
448     /* structs */
449     struct TokenEmission {
450         uint256 blockDuration;      // duration of block in secs
451         uint256 blockTokens;        // tokens per block
452         uint256 periodEndsAt;     // duration in secs
453         bool removed;
454     }
455 
456     /* events */
457     event ClaimedTokens(address _holder, uint256 _since, uint256 _till, uint256 _tokens);
458 
459     /* constructor */
460     function GenesisToken(
461         uint256 _totalSupply,
462         uint8 _precision,
463         string _name,
464         string _symbol,
465         bool _transferAllSupplyToOwner,
466         bool _locked,
467         uint256 _emitTokensSince,
468         uint256 _maxSupply
469     )
470         public
471         MintingERC20(_totalSupply, _maxSupply, _name, _precision, _symbol, _transferAllSupplyToOwner, _locked)
472     {
473         standard = "GenesisToken 0.1";
474         emitTokensSince = _emitTokensSince;
475     }
476 
477     function addTokenEmission(uint256 _blockDuration, uint256 _blockTokens, uint256 _periodEndsAt) public onlyOwner {
478         emissions.push(TokenEmission(_blockDuration, _blockTokens, _periodEndsAt, false));
479     }
480 
481     function removeTokenEmission(uint256 _i) public onlyOwner {
482         require(_i < emissions.length);
483 
484         emissions[_i].removed = true;
485     }
486 
487     function updateTokenEmission(uint256 _i, uint256 _blockDuration, uint256 _blockTokens, uint256 _periodEndsAt)
488         public
489         onlyOwner
490     {
491         require(_i < emissions.length);
492 
493         emissions[_i].blockDuration = _blockDuration;
494         emissions[_i].blockTokens = _blockTokens;
495         emissions[_i].periodEndsAt = _periodEndsAt;
496     }
497 
498     function claim() public returns (uint256) {
499         require(false == locked);
500 
501         uint256 currentBalance = balanceOf(msg.sender);
502         uint256 currentTotalSupply = totalSupply();
503 
504         return claimInternal(block.timestamp, msg.sender, currentBalance, currentTotalSupply);
505     }
506 
507     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
508         return claimableTransferFrom(block.timestamp, _from, _to, _value);
509     }
510 
511     function calculateEmissionTokens(
512         uint256 _lastClaimedAt,
513         uint256 _currentTime,
514         uint256 _currentBalance,
515         uint256 _totalSupply
516     )
517         public constant returns (uint256 tokens)
518     {
519         uint256 totalTokens = 0;
520 
521         uint256 newCurrentTime = _lastClaimedAt;
522         uint256 remainingSeconds = _currentTime.sub(_lastClaimedAt);
523 
524         uint256 collectedTokensPerPeriod;
525 
526         for (uint256 i = 0; i < emissions.length; i++) {
527             TokenEmission storage emission = emissions[i];
528 
529             if (emission.removed) {
530                 continue;
531             }
532 
533             if (newCurrentTime < emission.periodEndsAt) {
534                 if (newCurrentTime.add(remainingSeconds) > emission.periodEndsAt) {
535                     uint256 diff = emission.periodEndsAt.sub(newCurrentTime);
536 
537                     collectedTokensPerPeriod = getPeriodMinedTokens(
538                     diff, _currentBalance,
539                     emission.blockDuration, emission.blockTokens,
540                     _totalSupply);
541 
542                     totalTokens += collectedTokensPerPeriod;
543 
544                     newCurrentTime += diff;
545                     remainingSeconds -= diff;
546                 } else {
547                     collectedTokensPerPeriod = getPeriodMinedTokens(
548                         remainingSeconds, _currentBalance,
549                         emission.blockDuration, emission.blockTokens,
550                         _totalSupply
551                     );
552 
553                     totalTokens += collectedTokensPerPeriod;
554 
555                     newCurrentTime += remainingSeconds;
556                     remainingSeconds = 0;
557                 }
558             }
559 
560             if (remainingSeconds == 0) {
561                 break;
562             }
563         }
564 
565         return totalTokens;
566     }
567 
568     /* internal methods */
569     function getPeriodMinedTokens(
570         uint256 _duration, uint256 _balance,
571         uint256 _blockDuration, uint256 _blockTokens,
572         uint256
573     )
574     internal returns (uint256)
575     {
576         uint256 blocks = _duration.div(_blockDuration);
577 
578         return blocks.mul(_blockTokens).mul(_balance).div(maxSupply);
579     }
580 
581     function tokensClaimedHook(address _holder, uint256 _since, uint256 _till, uint256 _tokens) internal {
582         ClaimedTokens(_holder, _since, _till, _tokens);
583     }
584 
585     function claimInternal(
586         uint256 _time,
587         address _address,
588         uint256 _currentBalance,
589         uint256 _currentTotalSupply
590     )
591     internal returns (uint256)
592     {
593         if (_time < emitTokensSince) {
594             lastClaims[_address] = emitTokensSince;
595 
596             return 0;
597         }
598 
599         if (_currentBalance == 0) {
600             lastClaims[_address] = _time;
601 
602             return 0;
603         }
604 
605         uint256 lastClaimAt = lastClaims[_address];
606 
607         if (lastClaimAt == 0) {
608             lastClaims[_address] = emitTokensSince;
609             lastClaimAt = emitTokensSince;
610         }
611 
612         if (lastClaimAt >= _time) {
613             return 0;
614         }
615 
616         uint256 tokens = calculateEmissionTokens(lastClaimAt, _time, _currentBalance, _currentTotalSupply);
617 
618         if (tokens > 0) {
619             tokensClaimedHook(_address, lastClaimAt, _time, tokens);
620 
621             lastClaims[_address] = _time;
622         
623             return tokens;
624         }
625 
626         return 0;
627     }
628 
629     function claimableTransfer(
630         uint256 _time,
631         address _from,
632         address _to,
633         uint256 _value,
634         bytes _data,
635         bool _useCustomFallback,
636         string _customFallback
637     )
638     internal returns (bool success)
639     {
640         uint256 senderCurrentBalance = balanceOf(_from);
641         uint256 receiverCurrentBalance = balanceOf(_to);
642 
643         uint256 _totalSupply = totalSupply();
644 
645         bool status = super.transferInternal(_from, _to, _value, _data, _useCustomFallback, _customFallback);
646 
647         require(status);
648 
649         claimInternal(_time, _from, senderCurrentBalance, _totalSupply);
650         claimInternal(_time, _to, receiverCurrentBalance, _totalSupply);
651 
652         return true;
653     }
654 
655     function transferInternal(
656         address _from,
657         address _to,
658         uint256 _value,
659         bytes _data,
660         bool _useCustomFallback,
661         string _customFallback
662     )
663     internal returns (bool success)
664     {
665         return claimableTransfer(block.timestamp, _from, _to, _value, _data, _useCustomFallback, _customFallback);
666     }
667 
668     function claimableTransferFrom(
669         uint256 _time,
670         address _from,
671         address _to,
672         uint256 _value
673     )
674     internal returns (bool success)
675     {
676         uint256 senderCurrentBalance = balanceOf(_from);
677         uint256 receiverCurrentBalance = balanceOf(_to);
678 
679         uint256 _totalSupply = totalSupply();
680 
681         bool status = super.transferFrom(_from, _to, _value);
682 
683         if (status) {
684             claimInternal(_time, _from, senderCurrentBalance, _totalSupply);
685             claimInternal(_time, _to, receiverCurrentBalance, _totalSupply);
686         }
687         
688         return status;
689     }
690 
691     function internalMint(address _addr, uint256 _amount) internal returns (uint256) {
692         claimInternal(now, _addr, balanceOf(_addr), totalSupply());
693 
694         uint256 minted = super.internalMint(_addr, _amount);
695 
696         return minted;
697     }
698 }
699 
700 contract CLC is MintingERC20, AbstractClaimableToken {
701     uint256 public createdAt;
702     Clout public genesisToken;
703 
704     function CLC(uint256 _maxSupply, uint8 decimals, Clout _genesisToken, bool transferAllSupplyToOwner) public
705         MintingERC20(0, _maxSupply, "CLC", decimals, "CLC", transferAllSupplyToOwner, false)
706     {
707         createdAt = now;
708         standard = "CLC 0.1";
709         genesisToken = _genesisToken;
710     }
711 
712     function claimedTokens(address _holder, uint256 _tokens) public {
713         require(msg.sender == address(genesisToken));
714 
715         uint256 minted = internalMint(_holder, _tokens);
716 
717         require(minted == _tokens);
718     }
719 
720     function setGenesisToken(Clout _genesisToken) public onlyOwner {
721         genesisToken = _genesisToken;
722     }
723 
724     function setTransferFrozen(bool _frozen) public onlyOwner {
725         transferFrozen = _frozen;
726     }
727 
728     function setLocked(bool _locked) public onlyOwner {
729         locked = _locked;
730     }
731 }
732 
733 
734 contract Clout is GenesisToken {
735     AbstractClaimableToken public claimableToken;
736     uint256 public createdAt;
737 
738     mapping (address => bool) public issuers;
739 
740     function Clout(uint256 emitTokensSince,
741         bool init,
742         uint256 initialSupply,
743         uint8 decimals,
744         string tokenName,
745         string tokenSymbol,
746         bool transferAllSupplyToOwner
747     )
748         public
749         GenesisToken(
750             0,
751             decimals,
752             tokenName,
753             tokenSymbol,
754             transferAllSupplyToOwner,
755             false,
756             emitTokensSince,
757             initialSupply
758         )
759         // solhint-disable-next-line function-max-lines
760     {
761         standard = "Clout 0.1";
762 
763         createdAt = now;
764 
765         // emissions
766         if (init) {
767 //            uint256 period0 = createdAt;
768 //            uint256 period1 = 1514764800; // 2018-01-01T00:00:00Z
769 //            uint256 period2 = 1577836800; // 2020-01-01T00:00:00Z
770 //            uint256 period3 = 1672531200; // 2023-01-01T00:00:00Z
771 //            uint256 period4 = 1798761600; // 2027-01-01T00:00:00Z
772 //            uint256 period5 = 1956528000; // 2032-01-01T00:00:00Z
773 //            uint256 period6 = 2145916800; // 2038-01-01T00:00:00Z
774 //            uint256 period7 = 2366841600; // 2045-01-01T00:00:00Z
775 //            uint256 period8 = 2619302400; // 2053-01-01T00:00:00Z
776 //            uint256 period9 = 2903299200; // 2062-01-01T00:00:00Z
777 
778             uint256 blockDuration = 15;
779 
780             // after ico till 2018-01-01
781             emissions.push(
782                 TokenEmission(
783                     blockDuration,
784                     100000000 * 10 ** 18 / ((1514764800 - emitTokensSince) / blockDuration), // tokens
785                     1514764800, // till
786                     false // removed
787                 )
788             );
789 
790             // till 2020-01-01. blocks 4,204,800, tokens per block 2.378234399E19
791             emissions.push(
792                 TokenEmission(
793                     blockDuration,
794                     100000000 * 10 ** 18 / ((1577836800 - 1514764800) / blockDuration), // tokens
795                     1577836800, // till
796                     false // removed
797                 )
798             );
799 
800             // till 2023-01-01, blocks 6,312,960, tokens per block 1.584042985E19
801             emissions.push(
802                 TokenEmission(
803                     blockDuration,
804                     100000000 * 10 ** 18 / ((1672531200 - 1577836800) / blockDuration), // tokens
805                     1672531200, // till
806                     false // removed
807                 )
808             );
809 
810             // till 2027-01-01, blocks 8,415,360, tokens per block 1.188303293E19
811             emissions.push(
812                 TokenEmission(
813                     blockDuration,
814                     100000000 * 10 ** 18 / ((1798761600 - 1672531200) / blockDuration), // tokens
815                     1798761600, // till
816                     false // removed
817                 )
818             );
819 
820             // till 2032-01-01, blocks 10,517,760, tokens per block 9.507727881E18
821             emissions.push(
822                 TokenEmission(
823                     blockDuration,
824                     100000000 * 10 ** 18 / ((1956528000 - 1798761600) / blockDuration), // tokens
825                     1956528000, // till
826                     false // removed
827                 )
828             );
829 
830             // till 2038-01-01, blocks 12,625,920, tokens per block 7.920214923E18
831             emissions.push(
832                 TokenEmission(
833                     blockDuration,
834                     100000000 * 10 ** 18 / ((2145916800 - 1956528000) / blockDuration), // tokens
835                     2145916800, // till
836                     false // removed
837                 )
838             );
839 
840             // till 2045-01-01, blocks 14,728,320, tokens per block 6.789640638E18
841             emissions.push(
842                 TokenEmission(
843                     blockDuration,
844                     100000000 * 10 ** 18 / ((2366841600 - 2145916800) / blockDuration), // tokens
845                     2366841600, // till
846                     false // removed
847                 )
848             );
849 
850             // till 2053-01-01, blocks 16,830,720, tokens per block 5.941516465E18
851             emissions.push(
852                 TokenEmission(
853                     blockDuration,
854                     100000000 * 10 ** 18 / ((2619302400 - 2366841600) / blockDuration), // tokens
855                     2619302400, // till
856                     false // removed
857                 )
858             );
859 
860             // till 2062-01-01, blocks 18,933,120, tokens per block 5.281749654E18
861             emissions.push(
862                 TokenEmission(
863                     blockDuration,
864                     100000000 * 10 ** 18 / ((2903299200 - 2619302400) / blockDuration), // tokens
865                     2903299200, // till
866                     false // removed
867                 )
868             );
869         }
870     }
871 
872     function setEmissions(uint256[] array) public onlyOwner {
873         require(array.length % 4 == 0);
874 
875         delete emissions;
876 
877         for (uint256 i = 0; i < array.length; i += 4) {
878             emissions.push(TokenEmission(array[i], array[i + 1], array[i + 2], array[i + 3] == 0 ? false : true));
879         }
880     }
881 
882     function setClaimableToken(AbstractClaimableToken _token) public onlyOwner {
883         claimableToken = _token;
884     }
885 
886     function setTransferFrozen(bool _frozen) public onlyOwner {
887         transferFrozen = _frozen;
888     }
889 
890     function setLocked(bool _locked) public onlyOwner {
891         locked = _locked;
892     }
893 
894     function tokensClaimedHook(address _holder, uint256 since, uint256 till, uint256 amount) internal {
895         if (claimableToken != address(0)) {
896             claimableToken.claimedTokens(_holder, amount);
897         }
898 
899         ClaimedTokens(_holder, since, till, amount);
900     }
901 }
902 
903 contract Multivest is Ownable {
904     /* public variables */
905     mapping (address => bool) public allowedMultivests;
906 
907     /* events */
908     event MultivestSet(address multivest);
909 
910     event MultivestUnset(address multivest);
911 
912     event Contribution(address _holder, uint256 value, uint256 tokens);
913 
914     modifier onlyAllowedMultivests() {
915         require(true == allowedMultivests[msg.sender]);
916         _;
917     }
918 
919     /* constructor */
920     function Multivest(address multivest) {
921         allowedMultivests[multivest] = true;
922     }
923 
924     /* public methods */
925     function setAllowedMultivest(address _address) public onlyOwner {
926         allowedMultivests[_address] = true;
927     }
928 
929     function unsetAllowedMultivest(address _address) public onlyOwner {
930         allowedMultivests[_address] = false;
931     }
932 
933     function multivestBuy(
934         address _holder,
935         uint256 _value
936     )
937     public
938     onlyAllowedMultivests
939     {
940         bool status = buy(_holder, block.timestamp, _value);
941 
942         require(status == true);
943     }
944 
945     function multivestBuy(
946         bytes32 _hash,
947         uint8 _v,
948         bytes32 _r,
949         bytes32 _s
950     )
951         public payable
952     {
953         require(_hash == keccak256(msg.sender));
954         require(allowedMultivests[verify(_hash, _v, _r, _s)] == true);
955         bool status = buy(msg.sender, block.timestamp, msg.value);
956 
957         require(status == true);
958     }
959 
960     function verify(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public constant returns (address) {
961         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
962 
963         return ecrecover(keccak256(prefix, hash), v, r, s);
964     }
965 
966     function buy(address _address, uint256 _time, uint256 _value) internal returns (bool);
967 }
968 
969 
970 
971 contract ICO is Ownable, Multivest {
972     uint256 public icoSince;
973     uint256 public icoTill;
974 
975     uint8 public decimals;
976 
977     mapping(address => uint256) public holderEthers;
978     uint256 public collectedEthers;
979     uint256 public soldTokens;
980 
981     uint256 public minEthToContribute;
982 
983     Phase[] public phases;
984 
985     bool public locked;
986 
987     Clout public clout;
988     CLC public clc;
989 
990     address[] public etherReceivers;
991     address public etherMasterWallet;
992 
993     struct Phase {
994         uint256 price;
995         uint256 maxAmount;
996     }
997 
998     event Contribution(address _holder, uint256 _ethers, uint256 _clouts, uint256 _clcs);
999 
1000     function ICO(
1001         uint256 _icoSince,
1002         uint256 _icoTill,
1003         uint8 _decimals,
1004         uint256 price1,
1005         uint256 price2,
1006         uint256 price3,
1007         Clout _clout,
1008         CLC _clc,
1009         uint256 _minEthToContribute,
1010         bool _locked
1011     )
1012         public
1013         Multivest(msg.sender)
1014     {
1015         icoSince = _icoSince;
1016         icoTill = _icoTill;
1017         decimals = _decimals;
1018         locked = _locked;
1019 
1020         clout = _clout;
1021         clc = _clc;
1022 
1023         if (_minEthToContribute > 0) {
1024             minEthToContribute = _minEthToContribute;
1025         } else {
1026             minEthToContribute = 0;
1027         }
1028 
1029         phases.push(Phase(price1, 5000000 * (uint256(10) ** decimals)));
1030         phases.push(Phase(price2, 3000000 * (uint256(10) ** decimals)));
1031         phases.push(Phase(price3, 2000000 * (uint256(10) ** decimals)));
1032     }
1033 
1034     function () payable {
1035         bool status = buy(msg.sender, block.timestamp, msg.value);
1036 
1037         require(status == true);
1038     }
1039 
1040     function setEtherReceivers(
1041         address _masterWallet,
1042         address[] _etherReceivers
1043     )
1044         public onlyOwner
1045     {
1046         require(_masterWallet != address(0));
1047         require(_etherReceivers.length == 4);
1048         require(_etherReceivers[0] != address(0));
1049         require(_etherReceivers[1] != address(0));
1050         require(_etherReceivers[2] != address(0));
1051         require(_etherReceivers[3] != address(0));
1052 
1053         etherMasterWallet = _masterWallet;
1054         etherReceivers = _etherReceivers;
1055     }
1056 
1057     function setPrice(uint256 price1, uint256 price2, uint256 price3) public onlyOwner {
1058         phases[0].price = price1;
1059         phases[1].price = price2;
1060         phases[2].price = price3;
1061     }
1062 
1063     function setPeriod(uint256 since, uint256 till) public onlyOwner {
1064         icoSince = since;
1065         icoTill = till;
1066     }
1067 
1068     function setClout(Clout _clout) public onlyOwner {
1069         clout = _clout;
1070     }
1071 
1072     function setCLC(CLC _clc) public onlyOwner {
1073         clc = _clc;
1074     }
1075 
1076     function setLocked(bool _locked) public onlyOwner {
1077         locked = _locked;
1078     }
1079 
1080     function getIcoTokensAmount(uint256 _soldTokens, uint256 _value) public constant returns (uint256) {
1081         uint256 amount;
1082 
1083         uint256 newSoldTokens = _soldTokens;
1084         uint256 remainingValue = _value;
1085     
1086         for (uint i = 0; i < phases.length; i++) {
1087             Phase storage phase = phases[i];
1088 
1089             uint256 tokens = remainingValue * (uint256(10) ** decimals) / phase.price;
1090 
1091             if (phase.maxAmount > newSoldTokens) {
1092                 if (newSoldTokens + tokens > phase.maxAmount) {
1093                     uint256 diff = phase.maxAmount - tokens;
1094 
1095                     amount += diff;
1096 
1097                     // get optimal amount of ethers for this phase
1098                     uint256 phaseEthers = diff * phase.price / (uint256(10) ** decimals);
1099 
1100                     remainingValue -= phaseEthers;
1101                     newSoldTokens += (phaseEthers * (uint256(10) ** decimals) / phase.price);
1102                 } else {
1103                     amount += tokens;
1104 
1105                     newSoldTokens += tokens;
1106 
1107                     remainingValue = 0;
1108                 }
1109             }
1110 
1111             if (remainingValue == 0) {
1112                 break;
1113             }
1114         }
1115 
1116         if (remainingValue > 0) {
1117             return 0;
1118         }
1119 
1120         return amount;
1121     }
1122 
1123     // solhint-disable-next-line code-complexity
1124     function transferEthers() public onlyOwner {
1125         require(this.balance > 0);
1126         require(etherReceivers.length == 4);
1127         require(etherMasterWallet != address(0));
1128 
1129         // ether balance on smart contract
1130         if (this.balance > 0) {
1131             uint256 balance = this.balance;
1132 
1133             etherReceivers[0].transfer(balance * 15 / 100);
1134 
1135             etherReceivers[1].transfer(balance * 15 / 100);
1136 
1137             etherReceivers[2].transfer(balance * 10 / 100);
1138 
1139             etherReceivers[3].transfer(balance * 10 / 100);
1140 
1141             // send rest to master wallet
1142 
1143             etherMasterWallet.transfer(this.balance);
1144         }
1145     }
1146 
1147     function buy(address _address, uint256 _time, uint256 _value) internal returns (bool) {
1148         if (locked == true) {
1149             return false;
1150         }
1151 
1152         if (_time < icoSince) {
1153             return false;
1154         }
1155 
1156         if (_time > icoTill) {
1157             return false;
1158         }
1159 
1160         if (_value < minEthToContribute || _value == 0) {
1161             return false;
1162         }
1163 
1164         uint256 amount = getIcoTokensAmount(soldTokens, _value);
1165 
1166         if (amount == 0) {
1167             return false;
1168         }
1169 
1170         uint256 cloutMinted = clout.mint(_address, amount);
1171         uint256 clcMinted = clc.mint(_address, amount);
1172 
1173         require(cloutMinted == amount);
1174         require(clcMinted == amount);
1175 
1176         soldTokens += amount;
1177         collectedEthers += _value;
1178         holderEthers[_address] += _value;
1179 
1180         Contribution(_address, _value, amount, amount);
1181 
1182         return true;
1183     }
1184 }