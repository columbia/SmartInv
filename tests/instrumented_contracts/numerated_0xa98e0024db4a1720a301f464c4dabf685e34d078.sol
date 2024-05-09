1 pragma solidity ^0.4.23;
2 
3 // File: contracts\SignatureVerifier.sol
4 
5 /**
6  * @title Signature verifier
7  * @dev To verify C level actions
8  */
9 contract SignatureVerifier {
10 
11     function splitSignature(bytes sig)
12     internal
13     pure
14     returns (uint8, bytes32, bytes32)
15     {
16         require(sig.length == 65);
17 
18         bytes32 r;
19         bytes32 s;
20         uint8 v;
21 
22         assembly {
23         // first 32 bytes, after the length prefix
24             r := mload(add(sig, 32))
25         // second 32 bytes
26             s := mload(add(sig, 64))
27         // final byte (first byte of the next 32 bytes)
28             v := byte(0, mload(add(sig, 96)))
29         }
30         return (v, r, s);
31     }
32 
33     // Returns the address that signed a given string message
34     function verifyString(
35         string message,
36         uint8 v,
37         bytes32 r,
38         bytes32 s)
39     internal pure
40     returns (address signer) {
41 
42         // The message header; we will fill in the length next
43         string memory header = "\x19Ethereum Signed Message:\n000000";
44         uint256 lengthOffset;
45         uint256 length;
46 
47         assembly {
48         // The first word of a string is its length
49             length := mload(message)
50         // The beginning of the base-10 message length in the prefix
51             lengthOffset := add(header, 57)
52         }
53 
54         // Maximum length we support
55         require(length <= 999999);
56         // The length of the message's length in base-10
57         uint256 lengthLength = 0;
58         // The divisor to get the next left-most message length digit
59         uint256 divisor = 100000;
60         // Move one digit of the message length to the right at a time
61 
62         while (divisor != 0) {
63             // The place value at the divisor
64             uint256 digit = length / divisor;
65             if (digit == 0) {
66                 // Skip leading zeros
67                 if (lengthLength == 0) {
68                     divisor /= 10;
69                     continue;
70                 }
71             }
72             // Found a non-zero digit or non-leading zero digit
73             lengthLength++;
74             // Remove this digit from the message length's current value
75             length -= digit * divisor;
76             // Shift our base-10 divisor over
77             divisor /= 10;
78 
79             // Convert the digit to its ASCII representation (man ascii)
80             digit += 0x30;
81             // Move to the next character and write the digit
82             lengthOffset++;
83             assembly {
84                 mstore8(lengthOffset, digit)
85             }
86         }
87         // The null string requires exactly 1 zero (unskip 1 leading 0)
88         if (lengthLength == 0) {
89             lengthLength = 1 + 0x19 + 1;
90         } else {
91             lengthLength += 1 + 0x19;
92         }
93         // Truncate the tailing zeros from the header
94         assembly {
95             mstore(header, lengthLength)
96         }
97         // Perform the elliptic curve recover operation
98         bytes32 check = keccak256(abi.encodePacked(header, message));
99         return ecrecover(check, v, r, s);
100     }
101 }
102 
103 // File: contracts\SafeMath.sol
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110 
111     /**
112      * @dev Multiplies two numbers, throws on overflow.
113      */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
115         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         c = a * b;
123         assert(c / a == b);
124         return c;
125     }
126 
127     /**
128      * @dev Integer division of two numbers, truncating the quotient.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         // assert(b > 0); // Solidity automatically throws when dividing by 0
132         // uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134         return a / b;
135     }
136 
137     /**
138      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         assert(b <= a);
142         return a - b;
143     }
144 
145     /**
146      * @dev Adds two numbers, throws on overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
149         c = a + b;
150         assert(c >= a);
151         return c;
152     }
153 }
154 
155 // File: contracts\ERC20Token.sol
156 
157 /**
158  * @title A DEKLA token access control
159  * @author DEKLA (https://www.dekla.io)
160  * @dev The Dekla token has 3 C level address to manage.
161  * They can execute special actions but it need to be approved by another C level address.
162  */
163 contract DeklaAccessControl is SignatureVerifier {
164     using SafeMath for uint256;
165 
166     // C level address that can execute special actions.
167     address public ceoAddress;
168     address public cfoAddress;
169     address public cooAddress;
170     uint256 public CLevelTxCount_ = 0;
171 
172     // @dev store nonces
173     mapping(address => uint256) nonces;
174 
175     // @dev C level transaction must be approved with another C level address
176     modifier onlyCLevel() {
177         require(
178             msg.sender == cooAddress ||
179             msg.sender == ceoAddress ||
180             msg.sender == cfoAddress
181         );
182         _;
183     }
184 
185     function recover(bytes32 hash, bytes sig) public pure returns (address) {
186         bytes32 r;
187         bytes32 s;
188         uint8 v;
189         //Check the signature length
190         if (sig.length != 65) {
191             return (address(0));
192         }
193         // Divide the signature in r, s and v variables
194         (v, r, s) = splitSignature(sig);
195         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
196         if (v < 27) {
197             v += 27;
198         }
199         // If the version is correct return the signer address
200         if (v != 27 && v != 28) {
201             return (address(0));
202         } else {
203             bytes memory prefix = "\x19Ethereum Signed Message:\n32";
204             bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
205             return ecrecover(prefixedHash, v, r, s);
206         }
207     }
208 
209     // @dev return true if transaction already signed by a C Level address
210     // @param _message The string to be verify
211     function signedCLevel(
212         bytes32 _message,
213         bytes _sig
214     )
215     internal
216     view
217     onlyCLevel
218     returns (bool)
219     {
220         address signer = recover(_message, _sig);
221 
222         require(signer != msg.sender);
223         return (
224         signer == cooAddress ||
225         signer == ceoAddress ||
226         signer == cfoAddress
227         );
228     }
229 
230     /**
231      * @notice Hash (keccak256) of the payload used by setCEO
232      * @param _newCEO address The address of the new CEO
233      * @param _nonce uint256 setCEO transaction number.
234      */
235     function getCEOHashing(address _newCEO, uint256 _nonce) public pure returns (bytes32) {
236         return keccak256(abi.encodePacked(bytes4(0x486A0F3E), _newCEO, _nonce));
237     }
238 
239     // @dev Assigns a new address to act as the CEO. The C level transaction, must verify.
240     // @param _newCEO The address of the new CEO
241     function setCEO(
242         address _newCEO,
243         bytes _sig
244     ) external onlyCLevel {
245         require(
246             _newCEO != address(0) &&
247             _newCEO != cfoAddress &&
248             _newCEO != cooAddress
249         );
250 
251         bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]);
252         require(signedCLevel(hashedTx, _sig));
253         nonces[msg.sender]++;
254 
255         ceoAddress = _newCEO;
256         CLevelTxCount_++;
257     }
258 
259     /**
260      * @notice Hash (keccak256) of the payload used by setCFO
261      * @param _newCFO address The address of the new CFO
262      * @param _nonce uint256 setCFO transaction number.
263      */
264     function getCFOHashing(address _newCFO, uint256 _nonce) public pure returns (bytes32) {
265         return keccak256(abi.encodePacked(bytes4(0x486A0F3F), _newCFO, _nonce));
266     }
267 
268     // @dev Assigns a new address to act as the CFO. The C level transaction, must verify.
269     // @param _newCFO The address of the new CFO
270     function setCFO(
271         address _newCFO,
272         bytes _sig
273     ) external onlyCLevel {
274         require(
275             _newCFO != address(0) &&
276             _newCFO != ceoAddress &&
277             _newCFO != cooAddress
278         );
279 
280         bytes32 hashedTx = getCFOHashing(_newCFO, nonces[msg.sender]);
281         require(signedCLevel(hashedTx, _sig));
282         nonces[msg.sender]++;
283 
284         cfoAddress = _newCFO;
285         CLevelTxCount_++;
286     }
287 
288     /**
289      * @notice Hash (keccak256) of the payload used by setCOO
290      * @param _newCOO address The address of the new COO
291      * @param _nonce uint256 setCO transaction number.
292      */
293     function getCOOHashing(address _newCOO, uint256 _nonce) public pure returns (bytes32) {
294         return keccak256(abi.encodePacked(bytes4(0x486A0F40), _newCOO, _nonce));
295     }
296 
297     // @dev Assigns a new address to act as the COO. The C level transaction, must verify.
298     // @param _newCOO The address of the new COO
299     function setCOO(
300         address _newCOO,
301         bytes _sig
302     ) external onlyCLevel {
303         require(
304             _newCOO != address(0) &&
305             _newCOO != ceoAddress &&
306             _newCOO != cfoAddress
307         );
308 
309         bytes32 hashedTx = getCOOHashing(_newCOO, nonces[msg.sender]);
310         require(signedCLevel(hashedTx, _sig));
311         nonces[msg.sender]++;
312 
313         cooAddress = _newCOO;
314         CLevelTxCount_++;
315     }
316 
317     function getNonce() external view returns (uint256) {
318         return nonces[msg.sender];
319     }
320 }
321 
322 
323 /**
324  * @title ERC20Basic
325  * @dev Simpler version of ERC20 interface
326  * @dev see https://github.com/ethereum/EIPs/issues/179
327  */
328 contract ERC20Basic {
329     function totalSupply() public view returns (uint256);
330 
331     function balanceOf(address who) public view returns (uint256);
332 
333     function transfer(address to, uint256 value) public returns (bool);
334 
335     event Transfer(address indexed from, address indexed to, uint256 value);
336 }
337 
338 /**
339 * @title ERC865Token Token
340 *
341 * ERC865Token allows users paying transfers in tokens instead of gas
342 * https://github.com/ethereum/EIPs/issues/865
343 *
344 */
345 contract ERC865 is ERC20Basic {
346     function transferPreSigned(
347         bytes _signature,
348         address _to,
349         uint256 _value,
350         uint256 _fee,
351         uint256 _nonce
352     )
353     public
354     returns (bool);
355 
356     function approvePreSigned(
357         bytes _signature,
358         address _spender,
359         uint256 _value,
360         uint256 _fee,
361         uint256 _nonce
362     )
363     public
364     returns (bool);
365 
366     function increaseApprovalPreSigned(
367         bytes _signature,
368         address _spender,
369         uint256 _addedValue,
370         uint256 _fee,
371         uint256 _nonce
372     )
373     public
374     returns (bool);
375 
376     function decreaseApprovalPreSigned(
377         bytes _signature,
378         address _spender,
379         uint256 _subtractedValue,
380         uint256 _fee,
381         uint256 _nonce
382     )
383     public
384     returns (bool);
385 
386     function transferFromPreSigned(
387         bytes _signature,
388         address _from,
389         address _to,
390         uint256 _value,
391         uint256 _fee,
392         uint256 _nonce
393     )
394     public
395     returns (bool);
396 }
397 
398 /**
399  * @title Basic token
400  * @dev Basic version of StandardToken, with no allowances.
401  *
402  */
403 contract BasicToken is ERC20Basic, DeklaAccessControl {
404     using SafeMath for uint256;
405 
406     mapping(address => uint256) balances;
407 
408     uint256 totalSupply_;
409 
410     // Setable mint rate for the first time
411     uint256 mintTxCount_ = 1;
412     uint256 public teamRate = 20;
413     uint256 public saleRate = 80;
414 
415     // Team address
416     address public saleAddress;
417     address public teamAddress;
418     /**
419      * @dev total number of tokens in existence
420      */
421     function totalSupply() public view returns (uint256) {
422         return totalSupply_;
423     }
424 
425     /**
426      * @dev transfer token for a specified address
427      * @param _to The address to transfer to.
428      * @param _value The amount to be transferred.
429      */
430     function transfer(address _to, uint256 _value) public returns (bool) {
431         require(_to != address(0));
432         require(_value <= balances[msg.sender]);
433 
434         balances[msg.sender] = balances[msg.sender].sub(_value);
435         balances[_to] = balances[_to].add(_value);
436 
437         emit Transfer(msg.sender, _to, _value);
438         return true;
439     }
440 
441     /**
442      * @dev Gets the balance of the specified address.
443      * @param _owner The address to query the the balance of.
444      * @return An uint256 representing the amount owned by the passed address.
445      */
446     function balanceOf(address _owner) public view returns (uint256) {
447         return balances[_owner];
448     }
449 
450 }
451 
452 /**
453  * @title ERC20 interface
454  * @dev see https://github.com/ethereum/EIPs/issues/20
455  */
456 contract ERC20 is ERC20Basic {
457     function allowance(address owner, address spender)
458     public view returns (uint256);
459 
460     function transferFrom(address from, address to, uint256 value)
461     public returns (bool);
462 
463     function approve(address spender, uint256 value) public returns (bool);
464 
465     event Approval(
466         address indexed owner,
467         address indexed spender,
468         uint256 value
469     );
470 }
471 
472 
473 /**
474  * @title Standard ERC20 token
475  *
476  * @dev Implementation of the basic standard token.
477  * @dev https://github.com/ethereum/EIPs/issues/20
478  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
479  */
480 contract StandardToken is ERC20, BasicToken {
481 
482     mapping(address => mapping(address => uint256)) internal allowed;
483 
484 
485     /**
486      * @dev Transfer tokens from one address to another
487      * @param _from address The address which you want to send tokens from
488      * @param _to address The address which you want to transfer to
489      * @param _value uint256 the amount of tokens to be transferred
490      */
491     function transferFrom(
492         address _from,
493         address _to,
494         uint256 _value
495     )
496     public
497     returns (bool) {
498         require(_to != address(0));
499         require(_value <= balances[_from]);
500         require(_value <= allowed[_from][msg.sender]);
501 
502         balances[_from] = balances[_from].sub(_value);
503         balances[_to] = balances[_to].add(_value);
504 
505         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
506         emit Transfer(_from, _to, _value);
507         return true;
508     }
509 
510     /**
511      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
512      *
513      * Beware that changing an allowance with this method brings the risk that someone may use both the old
514      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
515      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
516      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
517      * @param _spender The address which will spend the funds.
518      * @param _value The amount of tokens to be spent.
519      */
520     function approve(address _spender, uint256 _value) public returns (bool) {
521         allowed[msg.sender][_spender] = _value;
522         emit Approval(msg.sender, _spender, _value);
523         return true;
524     }
525 
526     /**
527      * @dev Function to check the amount of tokens that an owner allowed to a spender.
528      * @param _owner address The address which owns the funds.
529      * @param _spender address The address which will spend the funds.
530      * @return A uint256 specifying the amount of tokens still available for the spender.
531      */
532     function allowance(
533         address _owner,
534         address _spender
535     )
536     public
537     view
538     returns (uint256) {
539         return allowed[_owner][_spender];
540     }
541 
542     /**
543      * @dev Increase the amount of tokens that an owner allowed to a spender.
544      *
545      * approve should be called when allowed[_spender] == 0. To increment
546      * allowed value is better to use this function to avoid 2 calls (and wait until
547      * the first transaction is mined)
548      * From MonolithDAO Token.sol
549      * @param _spender The address which will spend the funds.
550      * @param _addedValue The amount of tokens to increase the allowance by.
551      */
552     function increaseApproval(
553         address _spender,
554         uint _addedValue
555     )
556     public
557     returns (bool) {
558         allowed[msg.sender][_spender] = (
559         allowed[msg.sender][_spender].add(_addedValue));
560         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
561         return true;
562     }
563 
564     /**
565      * @dev Decrease the amount of tokens that an owner allowed to a spender.
566      *
567      * approve should be called when allowed[_spender] == 0. To decrement
568      * allowed value is better to use this function to avoid 2 calls (and wait until
569      * the first transaction is mined)
570      * From MonolithDAO Token.sol
571      * @param _spender The address which will spend the funds.
572      * @param _subtractedValue The amount of tokens to decrease the allowance by.
573      */
574     function decreaseApproval(
575         address _spender,
576         uint _subtractedValue
577     )
578     public
579     returns (bool) {
580         uint oldValue = allowed[msg.sender][_spender];
581         if (_subtractedValue > oldValue) {
582             allowed[msg.sender][_spender] = 0;
583         } else {
584             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
585         }
586         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
587         return true;
588     }
589 }
590 
591 
592 /**
593 * @title ERC865Token Token
594 *
595 * ERC865Token allows users paying transfers in tokens instead of gas
596 * https://github.com/ethereum/EIPs/issues/865
597 *
598 */
599 contract ERC865Token is ERC865, StandardToken {
600     /* Nonces of transfers performed */
601     // mapping(bytes => bool) signatures;
602 
603     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
604     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
605 
606     function recover(bytes32 hash, bytes sig) public pure returns (address) {
607         bytes32 r;
608         bytes32 s;
609         uint8 v;
610         //Check the signature length
611         if (sig.length != 65) {
612             return (address(0));
613         }
614         // Divide the signature in r, s and v variables
615         (v, r, s) = splitSignature(sig);
616         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
617         if (v < 27) {
618             v += 27;
619         }
620         // If the version is correct return the signer address
621         if (v != 27 && v != 28) {
622             return (address(0));
623         } else {
624             bytes memory prefix = "\x19Ethereum Signed Message:\n32";
625             bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
626             return ecrecover(prefixedHash, v, r, s);
627         }
628     }
629 
630     function recoverSigner(
631         bytes _signature,
632         address _to,
633         uint256 _value,
634         uint256 _fee,
635         uint256 _nonce
636     )
637     public
638     view
639     returns (address)
640     {
641         require(_to != address(0));
642         // require(signatures[_signature] == false);
643         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
644         address from = recover(hashedTx, _signature);
645         return from;
646     }
647 
648 
649     function transferPreSigned(
650         bytes _signature,
651         address _to,
652         uint256 _value,
653         uint256 _fee,
654         uint256 _nonce
655     )
656     public
657     returns (bool)
658     {
659         require(_to != address(0));
660         // require(signatures[_signature] == false);
661         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
662         address from = recover(hashedTx, _signature);
663         require(from != address(0));
664         balances[from] = balances[from].sub(_value).sub(_fee);
665         balances[_to] = balances[_to].add(_value);
666         balances[msg.sender] = balances[msg.sender].add(_fee);
667         // signatures[_signature] = true;
668         emit Transfer(from, _to, _value);
669         emit Transfer(from, msg.sender, _fee);
670         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
671         return true;
672     }
673     /**
674     * @notice Submit a presigned approval
675     * @param _signature bytes The signature, issued by the owner.
676     * @param _spender address The address which will spend the funds.
677     * @param _value uint256 The amount of tokens to allow.
678     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
679     * @param _nonce uint256 Presigned transaction number.
680     */
681     function approvePreSigned(
682         bytes _signature,
683         address _spender,
684         uint256 _value,
685         uint256 _fee,
686         uint256 _nonce
687     )
688     public
689     returns (bool)
690     {
691         require(_spender != address(0));
692         // require(signatures[_signature] == false);
693         bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
694         address from = recover(hashedTx, _signature);
695         require(from != address(0));
696         allowed[from][_spender] = _value;
697         balances[from] = balances[from].sub(_fee);
698         balances[msg.sender] = balances[msg.sender].add(_fee);
699         // signatures[_signature] = true;
700         emit Approval(from, _spender, _value);
701         emit Transfer(from, msg.sender, _fee);
702         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
703         return true;
704     }
705 
706     /**
707     * @notice Increase the amount of tokens that an owner allowed to a spender.
708     * @param _signature bytes The signature, issued by the owner.
709     * @param _spender address The address which will spend the funds.
710     * @param _addedValue uint256 The amount of tokens to increase the allowance by.
711     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
712     * @param _nonce uint256 Presigned transaction number.
713     */
714     function increaseApprovalPreSigned(
715         bytes _signature,
716         address _spender,
717         uint256 _addedValue,
718         uint256 _fee,
719         uint256 _nonce
720     )
721     public
722     returns (bool)
723     {
724         require(_spender != address(0));
725         // require(signatures[_signature] == false);
726         bytes32 hashedTx = increaseApprovalPreSignedHashing(address(this), _spender, _addedValue, _fee, _nonce);
727         address from = recover(hashedTx, _signature);
728         require(from != address(0));
729         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
730         balances[from] = balances[from].sub(_fee);
731         balances[msg.sender] = balances[msg.sender].add(_fee);
732         // signatures[_signature] = true;
733         emit Approval(from, _spender, allowed[from][_spender]);
734         emit Transfer(from, msg.sender, _fee);
735         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
736         return true;
737     }
738 
739     /**
740     * @notice Decrease the amount of tokens that an owner allowed to a spender.
741     * @param _signature bytes The signature, issued by the owner
742     * @param _spender address The address which will spend the funds.
743     * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
744     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
745     * @param _nonce uint256 Presigned transaction number.
746     */
747     function decreaseApprovalPreSigned(
748         bytes _signature,
749         address _spender,
750         uint256 _subtractedValue,
751         uint256 _fee,
752         uint256 _nonce
753     )
754     public
755     returns (bool)
756     {
757         require(_spender != address(0));
758         // require(signatures[_signature] == false);
759         bytes32 hashedTx = decreaseApprovalPreSignedHashing(address(this), _spender, _subtractedValue, _fee, _nonce);
760         address from = recover(hashedTx, _signature);
761         require(from != address(0));
762         uint oldValue = allowed[from][_spender];
763         if (_subtractedValue > oldValue) {
764             allowed[from][_spender] = 0;
765         } else {
766             allowed[from][_spender] = oldValue.sub(_subtractedValue);
767         }
768         balances[from] = balances[from].sub(_fee);
769         balances[msg.sender] = balances[msg.sender].add(_fee);
770         // signatures[_signature] = true;
771         emit Approval(from, _spender, _subtractedValue);
772         emit Transfer(from, msg.sender, _fee);
773         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
774         return true;
775     }
776 
777     /**
778     * @notice Transfer tokens from one address to another
779     * @param _signature bytes The signature, issued by the spender.
780     * @param _from address The address which you want to send tokens from.
781     * @param _to address The address which you want to transfer to.
782     * @param _value uint256 The amount of tokens to be transferred.
783     * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
784     * @param _nonce uint256 Presigned transaction number.
785     */
786     function transferFromPreSigned(
787         bytes _signature,
788         address _from,
789         address _to,
790         uint256 _value,
791         uint256 _fee,
792         uint256 _nonce
793     )
794     public
795     returns (bool)
796     {
797         require(_to != address(0));
798         // require(signatures[_signature] == false);
799         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
800         address spender = recover(hashedTx, _signature);
801         require(spender != address(0));
802         balances[_from] = balances[_from].sub(_value);
803         balances[_to] = balances[_to].add(_value);
804         allowed[_from][spender] = allowed[_from][spender].sub(_value);
805         balances[spender] = balances[spender].sub(_fee);
806         balances[msg.sender] = balances[msg.sender].add(_fee);
807         // signatures[_signature] = true;
808         emit Transfer(_from, _to, _value);
809         emit Transfer(spender, msg.sender, _fee);
810         return true;
811     }
812 
813     /**
814     * @notice Hash (keccak256) of the payload used by transferPreSigned
815     * @param _token address The address of the token.
816     * @param _to address The address which you want to transfer to.
817     * @param _value uint256 The amount of tokens to be transferred.
818     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
819     * @param _nonce uint256 Presigned transaction number.
820     */
821     function transferPreSignedHashing(
822         address _token,
823         address _to,
824         uint256 _value,
825         uint256 _fee,
826         uint256 _nonce
827     )
828     public
829     pure
830     returns (bytes32)
831     {
832         /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
833         return keccak256(abi.encodePacked(bytes4(0x486A0F41), _token, _to, _value, _fee, _nonce));
834     }
835     /**
836     * @notice Hash (keccak256) of the payload used by approvePreSigned
837     * @param _token address The address of the token
838     * @param _spender address The address which will spend the funds.
839     * @param _value uint256 The amount of tokens to allow.
840     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
841     * @param _nonce uint256 Presigned transaction number.
842     */
843     function approvePreSignedHashing(
844         address _token,
845         address _spender,
846         uint256 _value,
847         uint256 _fee,
848         uint256 _nonce
849     )
850     public
851     pure
852     returns (bytes32)
853     {
854         return keccak256(abi.encodePacked(_token, _spender, _value, _fee, _nonce));
855     }
856     /**
857     * @notice Hash (keccak256) of the payload used by increaseApprovalPreSigned
858     * @param _token address The address of the token
859     * @param _spender address The address which will spend the funds.
860     * @param _addedValue uint256 The amount of tokens to increase the allowance by.
861     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
862     * @param _nonce uint256 Presigned transaction number.
863     */
864     function increaseApprovalPreSignedHashing(
865         address _token,
866         address _spender,
867         uint256 _addedValue,
868         uint256 _fee,
869         uint256 _nonce
870     )
871     public
872     pure
873     returns (bytes32)
874     {
875         /* "a45f71ff": increaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
876         return keccak256(abi.encodePacked(bytes4(0x486A0F42), _token, _spender, _addedValue, _fee, _nonce));
877     }
878     /**
879     * @notice Hash (keccak256) of the payload used by decreaseApprovalPreSigned
880     * @param _token address The address of the token
881     * @param _spender address The address which will spend the funds.
882     * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
883     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
884     * @param _nonce uint256 Presigned transaction number.
885     */
886     function decreaseApprovalPreSignedHashing(
887         address _token,
888         address _spender,
889         uint256 _subtractedValue,
890         uint256 _fee,
891         uint256 _nonce
892     )
893     public
894     pure
895     returns (bytes32)
896     {
897         /* "59388d78": decreaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
898         return keccak256(abi.encodePacked(bytes4(0x486A0F43), _token, _spender, _subtractedValue, _fee, _nonce));
899     }
900     /**
901     * @notice Hash (keccak256) of the payload used by transferFromPreSigned
902     * @param _token address The address of the token
903     * @param _from address The address which you want to send tokens from.
904     * @param _to address The address which you want to transfer to.
905     * @param _value uint256 The amount of tokens to be transferred.
906     * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
907     * @param _nonce uint256 Presigned transaction number.
908     */
909     function transferFromPreSignedHashing(
910         address _token,
911         address _from,
912         address _to,
913         uint256 _value,
914         uint256 _fee,
915         uint256 _nonce
916     )
917     public
918     pure
919     returns (bytes32)
920     {
921         /* "b7656dc5": transferFromPreSignedHashing(address,address,address,uint256,uint256,uint256) */
922         return keccak256(abi.encodePacked(bytes4(0x486A0F44), _token, _from, _to, _value, _fee, _nonce));
923     }
924 }
925 
926 /**
927  * @title Mintable token
928  * @dev Simple ERC20 Token example, with mintable token creation
929  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
930  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
931  */
932 
933 contract MintableToken is ERC865Token {
934     using SafeMath for uint256;
935 
936     event Mint(address indexed to, uint256 amount);
937 
938     // Limit total supply to 10 billion
939     uint256 public constant totalTokenLimit = 10000000000000000000000000000;
940 
941     // Max token left percent allow to mint, based on 100%
942     uint256 public maxTokenRateToMint = 20;
943     uint256 public canMintLimit = 0;
944 
945 
946     /**
947      * @dev Throws if total supply is higher than total token limit
948      */
949     modifier canMint()
950     {
951 
952         // Address to mint must defined
953         require(
954             teamAddress != address(0) &&
955             saleAddress != address(0)
956 
957         );
958 
959         // Total supply after mint must lower or equal total token limit
960         require(totalSupply_ <= totalTokenLimit);
961         require(balances[saleAddress] <= canMintLimit);
962         _;
963     }
964 
965 
966     /**
967      * @dev Function to mint tokens: mint 1000000000000000000000000000 every times
968      * @return A boolean that indicates if the operation was successful.
969      */
970     function mint() onlyCLevel external {
971         _mint(1000000000000000000000000000);
972     }
973 
974     function _mint(uint256 _amount)
975     canMint
976     internal
977     {
978         uint256 saleAmount_ = _amount.mul(saleRate).div(100);
979         uint256 teamAmount_ = _amount.mul(teamRate).div(100);
980 
981         totalSupply_ = totalSupply_.add(_amount);
982         balances[saleAddress] = balances[saleAddress].add(saleAmount_);
983         balances[teamAddress] = balances[teamAddress].add(teamAmount_);
984 
985         canMintLimit = balances[saleAddress]
986         .mul(maxTokenRateToMint)
987         .div(100);
988         mintTxCount_++;
989 
990         emit Mint(saleAddress, saleAmount_);
991         emit Mint(teamAddress, teamAmount_);
992     }
993 
994     function getMaxTokenRateToMintHashing(uint256 _rate, uint256 _nonce) public pure returns (bytes32) {
995         return keccak256(abi.encodePacked(bytes4(0x486A0F45), _rate, _nonce));
996     }
997 
998     function setMaxTokenRateToMint(
999         uint256 _rate,
1000         bytes _sig
1001     ) external onlyCLevel {
1002         require(_rate <= 100);
1003         require(_rate >= 0);
1004 
1005         bytes32 hashedTx = getMaxTokenRateToMintHashing(_rate, nonces[msg.sender]);
1006         require(signedCLevel(hashedTx, _sig));
1007         nonces[msg.sender]++;
1008 
1009         maxTokenRateToMint = _rate;
1010         CLevelTxCount_++;
1011     }
1012 
1013     function getMintRatesHashing(uint256 _saleRate, uint256 _nonce) public pure returns (bytes32) {
1014         return keccak256(abi.encodePacked(bytes4(0x486A0F46), _saleRate, _nonce));
1015     }
1016 
1017     function setMintRates(
1018         uint256 saleRate_,
1019         bytes _sig
1020     )
1021     external
1022     onlyCLevel
1023     {
1024         require(saleRate.add(teamRate) == 100);
1025         require(mintTxCount_ >= 3);
1026 
1027         bytes32 hashedTx = getMintRatesHashing(saleRate_, nonces[msg.sender]);
1028         require(signedCLevel(hashedTx, _sig));
1029         nonces[msg.sender]++;
1030 
1031         saleRate = saleRate_;
1032         CLevelTxCount_++;
1033     }
1034 }
1035 
1036 
1037 contract DeklaToken is MintableToken {
1038     string public name = "Dekla Token";
1039     string public symbol = "DKL";
1040     uint256 public decimals = 18;
1041     uint256 public INITIAL_SUPPLY = 1000000000 * (10 ** decimals);
1042 
1043     function isDeklaToken() public pure returns (bool){
1044         return true;
1045     }
1046 
1047     constructor (
1048         address _ceoAddress,
1049         address _cfoAddress,
1050         address _cooAddress,
1051         address _teamAddress,
1052         address _saleAddress
1053     ) public {
1054         // initial prize address
1055         teamAddress = _teamAddress;
1056 
1057         // initial C level address
1058         ceoAddress = _ceoAddress;
1059         cfoAddress = _cfoAddress;
1060         cooAddress = _cooAddress;
1061         saleAddress = _saleAddress;
1062 
1063         // mint tokens first time
1064         _mint(INITIAL_SUPPLY);
1065     }
1066 }