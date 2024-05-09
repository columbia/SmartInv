1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity\contracts\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity\contracts\lifecycle\Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity\contracts\math\SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     if (a == 0) {
104       return 0;
105     }
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return a / b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 // File: zeppelin-solidity\contracts\token\ERC20\ERC20.sol
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender) public view returns (uint256);
207   function transferFrom(address from, address to, uint256 value) public returns (bool);
208   function approve(address spender, uint256 value) public returns (bool);
209   event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 // File: zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236 
237     balances[_from] = balances[_from].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240     emit Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    *
247    * Beware that changing an allowance with this method brings the risk that someone may use both the old
248    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
249    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
250    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) public returns (bool) {
255     allowed[msg.sender][_spender] = _value;
256     emit Approval(msg.sender, _spender, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Function to check the amount of tokens that an owner allowed to a spender.
262    * @param _owner address The address which owns the funds.
263    * @param _spender address The address which will spend the funds.
264    * @return A uint256 specifying the amount of tokens still available for the spender.
265    */
266   function allowance(address _owner, address _spender) public view returns (uint256) {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    *
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 // File: zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
310 
311 /**
312  * @title Mintable token
313  * @dev Simple ERC20 Token example, with mintable token creation
314  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
315  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
316  */
317 contract MintableToken is StandardToken, Ownable {
318   event Mint(address indexed to, uint256 amount);
319   event MintFinished();
320 
321   bool public mintingFinished = false;
322 
323 
324   modifier canMint() {
325     require(!mintingFinished);
326     _;
327   }
328 
329   /**
330    * @dev Function to mint tokens
331    * @param _to The address that will receive the minted tokens.
332    * @param _amount The amount of tokens to mint.
333    * @return A boolean that indicates if the operation was successful.
334    */
335   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
336     totalSupply_ = totalSupply_.add(_amount);
337     balances[_to] = balances[_to].add(_amount);
338     emit Mint(_to, _amount);
339     emit Transfer(address(0), _to, _amount);
340     return true;
341   }
342 
343   /**
344    * @dev Function to stop minting new tokens.
345    * @return True if the operation was successful.
346    */
347   function finishMinting() onlyOwner canMint public returns (bool) {
348     mintingFinished = true;
349     emit MintFinished();
350     return true;
351   }
352 }
353 
354 // File: contracts\lib\PreSignedContract.sol
355 
356 contract PreSignedContract is Ownable {
357   mapping (uint8 => bytes) internal _prefixPreSignedFirst;
358   mapping (uint8 => bytes) internal _prefixPreSignedSecond;
359 
360   function upgradePrefixPreSignedFirst(uint8 _version, bytes _prefix) public onlyOwner {
361     _prefixPreSignedFirst[_version] = _prefix;
362   }
363 
364   function upgradePrefixPreSignedSecond(uint8 _version, bytes _prefix) public onlyOwner {
365     _prefixPreSignedSecond[_version] = _prefix;
366   }
367 
368   /**
369    * @dev Recover signer address from a message by using their signature
370    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
371    * @param sig bytes signature, the signature is generated using web3.eth.sign()
372    */
373   function recover(bytes32 hash, bytes sig) public pure returns (address) {
374     bytes32 r;
375     bytes32 s;
376     uint8 v;
377 
378     // Check the signature length
379     if (sig.length != 65) {
380       return (address(0));
381     }
382 
383     // Divide the signature in r, s and v variables
384     // ecrecover takes the signature parameters, and the only way to get them
385     // currently is to use assembly.
386     // solium-disable-next-line security/no-inline-assembly
387     assembly {
388       r := mload(add(sig, 32))
389       s := mload(add(sig, 64))
390       v := byte(0, mload(add(sig, 96)))
391     }
392 
393     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
394     if (v < 27) {
395       v += 27;
396     }
397 
398     // If the version is correct return the signer address
399     if (v != 27 && v != 28) {
400       return (address(0));
401     } else {
402       // solium-disable-next-line arg-overflow
403       return ecrecover(hash, v, r, s);
404     }
405   }
406 
407   function messagePreSignedHashing(
408     bytes8 _mode,
409     address _token,
410     address _to,
411     uint256 _value,
412     uint256 _fee,
413     uint256 _nonce,
414     uint8 _version
415   ) public view returns (bytes32 hash) {
416     if (_version <= 2) {
417       hash = keccak256(
418         _mode,
419         _token,
420         _to,
421         _value,
422         _fee,
423         _nonce
424       );
425     } else {
426       // Support SignTypedData flexibly
427       hash = keccak256(
428         _prefixPreSignedFirst[_version],
429         _mode,
430         _token,
431         _to,
432         _value,
433         _fee,
434         _nonce
435       );
436     }
437   }
438 
439   function preSignedHashing(
440     bytes8 _mode,
441     address _token,
442     address _to,
443     uint256 _value,
444     uint256 _fee,
445     uint256 _nonce,
446     uint8 _version
447   ) public view returns (bytes32) {
448     bytes32 hash = messagePreSignedHashing(
449       _mode,
450       _token,
451       _to,
452       _value,
453       _fee,
454       _nonce,
455       _version
456     );
457 
458     if (_version <= 2) {
459       if (_version == 0) {
460         return hash;
461       } else if (_version == 1) {
462         return keccak256(
463           '\x19Ethereum Signed Message:\n32',
464           hash
465         );
466       } else {
467         // Support Standard Prefix (Trezor)
468         return keccak256(
469           '\x19Ethereum Signed Message:\n\x20',
470           hash
471         );
472       }
473     } else {
474       // Support SignTypedData flexibly
475       if (_prefixPreSignedSecond[_version].length > 0) {
476         return keccak256(
477           _prefixPreSignedSecond[_version],
478           hash
479         );
480       } else {
481         return hash;
482       }
483     }
484   }
485 
486   function preSignedCheck(
487     bytes8 _mode,
488     address _token,
489     address _to,
490     uint256 _value,
491     uint256 _fee,
492     uint256 _nonce,
493     uint8 _version,
494     bytes _sig
495   ) public view returns (address) {
496     bytes32 hash = preSignedHashing(
497       _mode,
498       _token,
499       _to,
500       _value,
501       _fee,
502       _nonce,
503       _version
504     );
505 
506     address _from = recover(hash, _sig);
507     require(_from != address(0));
508 
509     return _from;
510   }
511 
512   function transferPreSignedCheck(
513     address _token,
514     address _to,
515     uint256 _value,
516     uint256 _fee,
517     uint256 _nonce,
518     uint8 _version,
519     bytes _sig
520   ) external view returns (address) {
521     return preSignedCheck('Transfer', _token, _to, _value, _fee, _nonce, _version, _sig);
522   }
523 
524   function approvePreSignedCheck(
525     address _token,
526     address _to,
527     uint256 _value,
528     uint256 _fee,
529     uint256 _nonce,
530     uint8 _version,
531     bytes _sig
532   ) external view returns (address) {
533     return preSignedCheck('Approval', _token, _to, _value, _fee, _nonce, _version, _sig);
534   }
535 
536   function increaseApprovalPreSignedCheck(
537     address _token,
538     address _to,
539     uint256 _value,
540     uint256 _fee,
541     uint256 _nonce,
542     uint8 _version,
543     bytes _sig
544   ) external view returns (address) {
545     return preSignedCheck('IncApprv', _token, _to, _value, _fee, _nonce, _version, _sig);
546   }
547 
548   function decreaseApprovalPreSignedCheck(
549     address _token,
550     address _to,
551     uint256 _value,
552     uint256 _fee,
553     uint256 _nonce,
554     uint8 _version,
555     bytes _sig
556   ) external view returns (address) {
557     return preSignedCheck('DecApprv', _token, _to, _value, _fee, _nonce, _version, _sig);
558   }
559 }
560 
561 // File: contracts\token\MuzikaCoin.sol
562 
563 contract MuzikaCoin is MintableToken, Pausable {
564   string public name = 'MUZIKA COIN';
565   string public symbol = 'MZK';
566   uint8 public decimals = 18;
567 
568   event Burn(address indexed burner, uint256 value);
569 
570   event FreezeAddress(address indexed target);
571   event UnfreezeAddress(address indexed target);
572 
573   event TransferPreSigned(
574     address indexed from,
575     address indexed to,
576     address indexed delegate,
577     uint256 value,
578     uint256 fee
579   );
580   event ApprovalPreSigned(
581     address indexed owner,
582     address indexed spender,
583     address indexed delegate,
584     uint256 value,
585     uint256 fee
586   );
587 
588   mapping (address => bool) public frozenAddress;
589 
590   mapping (bytes => bool) internal _signatures;
591 
592   PreSignedContract internal _preSignedContract = PreSignedContract(0xE55b5f4fAd5cD3923C392e736F58dEF35d7657b8);
593 
594   modifier onlyNotFrozenAddress(address _target) {
595     require(!frozenAddress[_target]);
596     _;
597   }
598 
599   modifier onlyFrozenAddress(address _target) {
600     require(frozenAddress[_target]);
601     _;
602   }
603 
604   constructor(uint256 initialSupply) public {
605     totalSupply_ = initialSupply;
606     balances[msg.sender] = initialSupply;
607     emit Transfer(address(0), msg.sender, initialSupply);
608   }
609 
610   /**
611    * @dev Freeze account(address)
612    *
613    * @param _target The address to freeze
614    */
615   function freezeAddress(address _target)
616     public
617     onlyOwner
618     onlyNotFrozenAddress(_target)
619   {
620     frozenAddress[_target] = true;
621 
622     emit FreezeAddress(_target);
623   }
624 
625   /**
626    * @dev Unfreeze account(address)
627    *
628    * @param _target The address to unfreeze
629    */
630   function unfreezeAddress(address _target)
631     public
632     onlyOwner
633     onlyFrozenAddress(_target)
634   {
635     delete frozenAddress[_target];
636 
637     emit UnfreezeAddress(_target);
638   }
639 
640   /**
641    * @dev Burns a specific amount of tokens.
642    * @param _value The amount of token to be burned.
643    */
644   function burn(uint256 _value) public onlyOwner {
645     _burn(msg.sender, _value);
646   }
647 
648   function _burn(address _who, uint256 _value) internal {
649     require(_value <= balances[_who]);
650     // no need to require value <= totalSupply, since that would imply the
651     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
652 
653     balances[_who] = balances[_who].sub(_value);
654     totalSupply_ = totalSupply_.sub(_value);
655     emit Burn(_who, _value);
656     emit Transfer(_who, address(0), _value);
657   }
658 
659   function transfer(
660     address _to,
661     uint256 _value
662   )
663     public
664     onlyNotFrozenAddress(msg.sender)
665     whenNotPaused
666     returns (bool)
667   {
668     return super.transfer(_to, _value);
669   }
670 
671   function transferFrom(
672     address _from,
673     address _to,
674     uint256 _value
675   )
676     public
677     onlyNotFrozenAddress(_from)
678     onlyNotFrozenAddress(msg.sender)
679     whenNotPaused
680     returns (bool)
681   {
682     return super.transferFrom(_from, _to, _value);
683   }
684 
685   function approve(
686     address _spender,
687     uint256 _value
688   )
689     public
690     onlyNotFrozenAddress(msg.sender)
691     whenNotPaused
692     returns (bool)
693   {
694     return super.approve(_spender, _value);
695   }
696 
697   function increaseApproval(
698     address _spender,
699     uint _addedValue
700   )
701     public
702     onlyNotFrozenAddress(msg.sender)
703     whenNotPaused
704     returns (bool)
705   {
706     return super.increaseApproval(_spender, _addedValue);
707   }
708 
709   function decreaseApproval(
710     address _spender,
711     uint _subtractedValue
712   )
713     public
714     onlyNotFrozenAddress(msg.sender)
715     whenNotPaused
716     returns (bool)
717   {
718     return super.decreaseApproval(_spender, _subtractedValue);
719   }
720 
721   /**
722    * @dev Be careful to use delegateTransfer.
723    * @dev If attacker whose balance is less than sum of fee and amount
724    * @dev requests constantly transferring using delegateTransfer/delegateApprove to someone,
725    * @dev he or she may lose all ether to process these requests.
726    */
727   function transferPreSigned(
728     address _to,
729     uint256 _value,
730     uint256 _fee,
731     uint256 _nonce,
732     uint8 _version,
733     bytes _sig
734   )
735     public
736     onlyNotFrozenAddress(msg.sender)
737     whenNotPaused
738     returns (bool)
739   {
740     require(_to != address(0));
741     require(_signatures[_sig] == false);
742 
743     address _from = _preSignedContract.transferPreSignedCheck(
744       address(this),
745       _to,
746       _value,
747       _fee,
748       _nonce,
749       _version,
750       _sig
751     );
752     require(!frozenAddress[_from]);
753 
754     uint256 _burden = _value.add(_fee);
755     require(_burden <= balances[_from]);
756 
757     balances[_from] = balances[_from].sub(_burden);
758     balances[_to] = balances[_to].add(_value);
759     balances[msg.sender] = balances[msg.sender].add(_fee);
760     emit Transfer(_from, _to, _value);
761     emit Transfer(_from, msg.sender, _fee);
762 
763     _signatures[_sig] = true;
764     emit TransferPreSigned(_from, _to, msg.sender, _value, _fee);
765 
766     return true;
767   }
768 
769   function approvePreSigned(
770     address _to,
771     uint256 _value,
772     uint256 _fee,
773     uint256 _nonce,
774     uint8 _version,
775     bytes _sig
776   )
777     public
778     onlyNotFrozenAddress(msg.sender)
779     whenNotPaused
780     returns (bool)
781   {
782     require(_signatures[_sig] == false);
783 
784     address _from = _preSignedContract.approvePreSignedCheck(
785       address(this),
786       _to,
787       _value,
788       _fee,
789       _nonce,
790       _version,
791       _sig
792     );
793 
794     require(!frozenAddress[_from]);
795     require(_fee <= balances[_from]);
796 
797     allowed[_from][_to] = _value;
798     emit Approval(_from, _to, _value);
799 
800     if (_fee > 0) {
801       balances[_from] = balances[_from].sub(_fee);
802       balances[msg.sender] = balances[msg.sender].add(_fee);
803       emit Transfer(_from, msg.sender, _fee);
804     }
805 
806     _signatures[_sig] = true;
807     emit ApprovalPreSigned(_from, _to, msg.sender, _value, _fee);
808 
809     return true;
810   }
811 
812   function increaseApprovalPreSigned(
813     address _to,
814     uint256 _value,
815     uint256 _fee,
816     uint256 _nonce,
817     uint8 _version,
818     bytes _sig
819   )
820     public
821     onlyNotFrozenAddress(msg.sender)
822     whenNotPaused
823     returns (bool)
824   {
825     require(_signatures[_sig] == false);
826 
827     address _from = _preSignedContract.increaseApprovalPreSignedCheck(
828       address(this),
829       _to,
830       _value,
831       _fee,
832       _nonce,
833       _version,
834       _sig
835     );
836 
837     require(!frozenAddress[_from]);
838     require(_fee <= balances[_from]);
839 
840     allowed[_from][_to] = allowed[_from][_to].add(_value);
841     emit Approval(_from, _to, allowed[_from][_to]);
842 
843     if (_fee > 0) {
844       balances[_from] = balances[_from].sub(_fee);
845       balances[msg.sender] = balances[msg.sender].add(_fee);
846       emit Transfer(_from, msg.sender, _fee);
847     }
848 
849     _signatures[_sig] = true;
850     emit ApprovalPreSigned(_from, _to, msg.sender, allowed[_from][_to], _fee);
851 
852     return true;
853   }
854 
855   function decreaseApprovalPreSigned(
856     address _to,
857     uint256 _value,
858     uint256 _fee,
859     uint256 _nonce,
860     uint8 _version,
861     bytes _sig
862   )
863     public
864     onlyNotFrozenAddress(msg.sender)
865     whenNotPaused
866     returns (bool)
867   {
868     require(_signatures[_sig] == false);
869 
870     address _from = _preSignedContract.decreaseApprovalPreSignedCheck(
871       address(this),
872       _to,
873       _value,
874       _fee,
875       _nonce,
876       _version,
877       _sig
878     );
879     require(!frozenAddress[_from]);
880 
881     require(_fee <= balances[_from]);
882 
883     uint256 oldValue = allowed[_from][_to];
884     if (_value > oldValue) {
885       oldValue = 0;
886     } else {
887       oldValue = oldValue.sub(_value);
888     }
889 
890     allowed[_from][_to] = oldValue;
891     emit Approval(_from, _to, oldValue);
892 
893     if (_fee > 0) {
894       balances[_from] = balances[_from].sub(_fee);
895       balances[msg.sender] = balances[msg.sender].add(_fee);
896       emit Transfer(_from, msg.sender, _fee);
897     }
898 
899     _signatures[_sig] = true;
900     emit ApprovalPreSigned(_from, _to, msg.sender, oldValue, _fee);
901 
902     return true;
903   }
904 }