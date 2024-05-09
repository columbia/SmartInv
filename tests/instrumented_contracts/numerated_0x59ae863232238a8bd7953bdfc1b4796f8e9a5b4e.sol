1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 contract Ownable {
51     address public owner;
52 
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57     /**
58     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59     * account.
60     */
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     /**
66     * @dev Throws if called by any account other than the owner.
67     */
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     /**
74     * @dev Allows the current owner to transfer control of the contract to a newOwner.
75     * @param newOwner The address to transfer ownership to.
76     */
77     function transferOwnership(address newOwner) public onlyOwner {
78         require(newOwner != address(0));
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 }
83 contract ERC20 {
84     function totalSupply() public constant returns (uint);
85     function balanceOf(address tokenOwner) public constant returns (uint balance);
86     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
87     function transfer(address to, uint tokens) public returns (bool success);
88     function approve(address spender, uint tokens) public returns (bool success);
89     function transferFrom(address from, address to, uint tokens) public returns (bool success);
90 
91     event Transfer(address indexed from, address indexed to, uint tokens);
92     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
93 }
94 contract ERC865 is ERC20 {
95 
96     function transferPreSigned(
97         bytes _signature,
98         address _to,
99         uint256 _value,
100         uint256 _fee,
101         uint256 _nonce
102     )
103         public
104         returns (bool);
105 
106     function approvePreSigned(
107         bytes _signature,
108         address _spender,
109         uint256 _value,
110         uint256 _fee,
111         uint256 _nonce
112     )
113         public
114         returns (bool);
115 
116     function increaseApprovalPreSigned(
117         bytes _signature,
118         address _spender,
119         uint256 _addedValue,
120         uint256 _fee,
121         uint256 _nonce
122     )
123         public
124         returns (bool);
125 
126     function decreaseApprovalPreSigned(
127         bytes _signature,
128         address _spender,
129         uint256 _subtractedValue,
130         uint256 _fee,
131         uint256 _nonce
132     )
133         public
134         returns (bool);
135 
136     function transferFromPreSigned(
137         bytes _signature,
138         address _from,
139         address _to,
140         uint256 _value,
141         uint256 _fee,
142         uint256 _nonce
143     )
144         public
145         returns (bool);
146 
147     function revokeSignature(bytes _signature)
148     public
149     returns (bool);
150 
151 }
152 contract StandardToken is ERC20  {
153 
154   using SafeMath for uint256;
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158   mapping(address => uint256) public balances;
159 
160   uint256 _totalSupply;
161 
162   /**
163   * @dev total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return _totalSupply;
167   }
168 
169   /**
170   * @dev transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[msg.sender]);
177 
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(_value <= balances[_from]);
202     require(_value <= allowed[_from][msg.sender]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     emit Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     emit Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public view returns (uint256) {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _addedValue The amount of tokens to increase the allowance by.
246    */
247   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   /**
254    * @dev Decrease the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To decrement
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _subtractedValue The amount of tokens to decrease the allowance by.
262    */
263   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264     uint oldValue = allowed[msg.sender][_spender];
265     if (_subtractedValue > oldValue) {
266       allowed[msg.sender][_spender] = 0;
267     } else {
268       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269     }
270     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274 }
275 
276 contract ERC865Token is ERC865, StandardToken {
277 
278     /* Nonces of transfers performed */
279     mapping(bytes => bool) nonces;
280 
281     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
282     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
283     event SignatureRevoked(bytes signature, address indexed from);
284 
285     /**
286      * @notice Submit a presigned transfer
287      * @param _signature bytes The signature, issued by the owner.
288      * @param _to address The address which you want to transfer to.
289      * @param _value uint256 The amount of tokens to be transferred.
290      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
291      * @param _nonce uint256 Presigned transaction number.
292      */
293     function transferPreSigned(
294         bytes _signature,
295         address _to,
296         uint256 _value,
297         uint256 _fee,
298         uint256 _nonce
299     )
300         public
301         returns (bool)
302     {
303         require(_to != address(0));
304         require(!nonces[_signature]);
305 
306         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
307 
308         address from = recover(hashedTx, _signature);
309         require(from != address(0));
310 
311         nonces[_signature] = true;
312 
313         balances[from] = balances[from].sub(_value).sub(_fee);
314         balances[_to] = balances[_to].add(_value);
315         balances[msg.sender] = balances[msg.sender].add(_fee);
316 
317         emit Transfer(from, _to, _value);
318         emit Transfer(from, msg.sender, _fee);
319         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
320         return true;
321     }
322 
323     /**
324      * @notice Submit a presigned approval
325      * @param _signature bytes The signature, issued by the owner.
326      * @param _spender address The address which will spend the funds.
327      * @param _value uint256 The amount of tokens to allow.
328      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
329      * @param _nonce uint256 Presigned transaction number.
330      */
331     function approvePreSigned(
332         bytes _signature,
333         address _spender,
334         uint256 _value,
335         uint256 _fee,
336         uint256 _nonce
337     )
338         public
339         returns (bool)
340     {
341         require(_spender != address(0));
342         require(!nonces[_signature]);
343 
344         bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
345         address from = recover(hashedTx, _signature);
346         require(from != address(0));
347 
348         nonces[_signature] = true;
349 
350         allowed[from][_spender] = _value;
351         balances[from] = balances[from].sub(_fee);
352         balances[msg.sender] = balances[msg.sender].add(_fee);
353 
354         emit Approval(from, _spender, _value);
355         emit Transfer(from, msg.sender, _fee);
356         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
357         return true;
358     }
359 
360     /**
361      * @notice Increase the amount of tokens that an owner allowed to a spender.
362      * @param _signature bytes The signature, issued by the owner.
363      * @param _spender address The address which will spend the funds.
364      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
365      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
366      * @param _nonce uint256 Presigned transaction number.
367      */
368     function increaseApprovalPreSigned(
369         bytes _signature,
370         address _spender,
371         uint256 _addedValue,
372         uint256 _fee,
373         uint256 _nonce
374     )
375         public
376         returns (bool)
377     {
378         require(_spender != address(0));
379         require(!nonces[_signature]);
380 
381         bytes32 hashedTx = increaseApprovalPreSignedHashing(address(this), _spender, _addedValue, _fee, _nonce);
382         address from = recover(hashedTx, _signature);
383         require(from != address(0));
384 
385         nonces[_signature] = true;
386 
387         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
388         balances[from] = balances[from].sub(_fee);
389         balances[msg.sender] = balances[msg.sender].add(_fee);
390 
391         emit Approval(from, _spender, allowed[from][_spender]);
392         emit Transfer(from, msg.sender, _fee);
393         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
394         return true;
395     }
396 
397     /**
398      * @notice Decrease the amount of tokens that an owner allowed to a spender.
399      * @param _signature bytes The signature, issued by the owner
400      * @param _spender address The address which will spend the funds.
401      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
402      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
403      * @param _nonce uint256 Presigned transaction number.
404      */
405     function decreaseApprovalPreSigned(
406         bytes _signature,
407         address _spender,
408         uint256 _subtractedValue,
409         uint256 _fee,
410         uint256 _nonce
411     )
412         public
413         returns (bool)
414     {
415         require(_spender != address(0));
416         require(!nonces[_signature]);
417 
418         bytes32 hashedTx = decreaseApprovalPreSignedHashing(address(this), _spender, _subtractedValue, _fee, _nonce);
419         address from = recover(hashedTx, _signature);
420         require(from != address(0));
421 
422         nonces[_signature] = true;
423 
424         uint oldValue = allowed[from][_spender];
425         if (_subtractedValue > oldValue) {
426             allowed[from][_spender] = 0;
427         } else {
428             allowed[from][_spender] = oldValue.sub(_subtractedValue);
429         }
430         balances[from] = balances[from].sub(_fee);
431         balances[msg.sender] = balances[msg.sender].add(_fee);
432 
433         emit Approval(from, _spender, _subtractedValue);
434         emit Transfer(from, msg.sender, _fee);
435         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
436         return true;
437     }
438 
439     /**
440      * @notice Transfer tokens from one address to another
441      * @param _signature bytes The signature, issued by the spender.
442      * @param _from address The address which you want to send tokens from.
443      * @param _to address The address which you want to transfer to.
444      * @param _value uint256 The amount of tokens to be transferred.
445      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
446      * @param _nonce uint256 Presigned transaction number.
447      */
448     function transferFromPreSigned(
449         bytes _signature,
450         address _from,
451         address _to,
452         uint256 _value,
453         uint256 _fee,
454         uint256 _nonce
455     )
456         public
457         returns (bool)
458     {
459         require(_to != address(0));
460         require(!nonces[_signature]);
461 
462         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
463 
464         address spender = recover(hashedTx, _signature);
465         require(spender != address(0));
466 
467         nonces[_signature] = true;
468 
469         balances[_from] = balances[_from].sub(_value);
470         balances[_to] = balances[_to].add(_value);
471         allowed[_from][spender] = allowed[_from][spender].sub(_value);
472 
473         balances[spender] = balances[spender].sub(_fee);
474         balances[msg.sender] = balances[msg.sender].add(_fee);
475         nonces[_signature] = true;
476 
477         emit Transfer(_from, _to, _value);
478         emit Transfer(spender, msg.sender, _fee);
479         return true;
480     }
481 
482     /**
483      * Revote previously approved signature
484      * @param  _signature bytes The signature to revoke
485      * @return bool  Returns true if revocation was successful
486      */
487     function revokeSignature(bytes _signature) public returns (bool) {
488         require(!nonces[_signature]);
489         nonces[_signature] = true;
490 
491         emit SignatureRevoked(_signature, msg.sender);
492         return true;
493     }
494 
495 
496     /**
497      * @notice Hash (keccak256) of the payload used by transferPreSigned
498      * @param _token address The address of the token.
499      * @param _to address The address which you want to transfer to.
500      * @param _value uint256 The amount of tokens to be transferred.
501      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
502      * @param _nonce uint256 Presigned transaction number.
503      */
504     function transferPreSignedHashing(
505         address _token,
506         address _to,
507         uint256 _value,
508         uint256 _fee,
509         uint256 _nonce
510     )
511         public
512         pure
513         returns (bytes32)
514     {
515         /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
516         return keccak256(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce);
517     }
518 
519     /**
520      * @notice Hash (keccak256) of the payload used by approvePreSigned
521      * @param _token address The address of the token
522      * @param _spender address The address which will spend the funds.
523      * @param _value uint256 The amount of tokens to allow.
524      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
525      * @param _nonce uint256 Presigned transaction number.
526      */
527     function approvePreSignedHashing(
528         address _token,
529         address _spender,
530         uint256 _value,
531         uint256 _fee,
532         uint256 _nonce
533     )
534         public
535         pure
536         returns (bytes32)
537     {
538         /* "f7ac9c2e": approvePreSignedHashing(address,address,uint256,uint256,uint256) */
539         return keccak256(bytes4(0xf7ac9c2e), _token, _spender, _value, _fee, _nonce);
540     }
541 
542     /**
543      * @notice Hash (keccak256) of the payload used by increaseApprovalPreSigned
544      * @param _token address The address of the token
545      * @param _spender address The address which will spend the funds.
546      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
547      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
548      * @param _nonce uint256 Presigned transaction number.
549      */
550     function increaseApprovalPreSignedHashing(
551         address _token,
552         address _spender,
553         uint256 _addedValue,
554         uint256 _fee,
555         uint256 _nonce
556     )
557         public
558         pure
559         returns (bytes32)
560     {
561         /* "a45f71ff": increaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
562         return keccak256(bytes4(0xa45f71ff), _token, _spender, _addedValue, _fee, _nonce);
563     }
564 
565      /**
566       * @notice Hash (keccak256) of the payload used by decreaseApprovalPreSigned
567       * @param _token address The address of the token
568       * @param _spender address The address which will spend the funds.
569       * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
570       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
571       * @param _nonce uint256 Presigned transaction number.
572       */
573     function decreaseApprovalPreSignedHashing(
574         address _token,
575         address _spender,
576         uint256 _subtractedValue,
577         uint256 _fee,
578         uint256 _nonce
579     )
580         public
581         pure
582         returns (bytes32)
583     {
584         /* "59388d78": decreaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
585         return keccak256(bytes4(0x59388d78), _token, _spender, _subtractedValue, _fee, _nonce);
586     }
587 
588     /**
589      * @notice Hash (keccak256) of the payload used by transferFromPreSigned
590      * @param _token address The address of the token
591      * @param _from address The address which you want to send tokens from.
592      * @param _to address The address which you want to transfer to.
593      * @param _value uint256 The amount of tokens to be transferred.
594      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
595      * @param _nonce uint256 Presigned transaction number.
596      */
597     function transferFromPreSignedHashing(
598         address _token,
599         address _from,
600         address _to,
601         uint256 _value,
602         uint256 _fee,
603         uint256 _nonce
604     )
605         public
606         pure
607         returns (bytes32)
608     {
609         /* "b7656dc5": transferFromPreSignedHashing(address,address,address,uint256,uint256,uint256) */
610         return keccak256(bytes4(0xb7656dc5), _token, _from, _to, _value, _fee, _nonce);
611     }
612 
613     /**
614      * @notice Recover signer address from a message by using his signature
615      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
616      * @param sig bytes signature, the signature is generated using web3.eth.sign()
617      */
618     function recover(bytes32 hash, bytes sig) public pure returns (address) {
619       bytes32 r;
620       bytes32 s;
621       uint8 v;
622 
623       //Check the signature length
624       if (sig.length != 65) {
625         return (address(0));
626       }
627 
628       // Divide the signature in r, s and v variables
629       assembly {
630         r := mload(add(sig, 32))
631         s := mload(add(sig, 64))
632         v := byte(0, mload(add(sig, 96)))
633       }
634 
635       // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
636       if (v < 27) {
637         v += 27;
638       }
639 
640       // If the version is correct return the signer address
641       if (v != 27 && v != 28) {
642         return (address(0));
643       } else {
644         return ecrecover(hash, v, r, s);
645       }
646     }
647 
648 }
649 
650 contract TipToken is ERC865Token, Ownable {
651     using SafeMath for uint256;
652 
653     uint256 public constant TOTAL_SUPPLY = 10 ** 9;
654 
655     string public constant name = "Tip Token";
656     string public constant symbol = "TIP";
657     uint8 public constant decimals = 18;
658 
659     mapping (address => string) aliases;
660     mapping (string => address) addresses;
661 
662     /**
663      * Constructor
664      */
665     constructor() public {
666         _totalSupply = TOTAL_SUPPLY * (10**uint256(decimals));
667         balances[owner] = _totalSupply;
668         emit Transfer(address(0), owner, _totalSupply);
669     }
670 
671     /**
672      * Returns the available supple (total supply minus tokens held by owner)
673      */
674     function availableSupply() public view returns (uint256) {
675         return _totalSupply.sub(balances[owner]).sub(balances[address(0)]);
676     }
677 
678     /**
679      * Token owner can approve for `spender` to transferFrom(...) `tokens`
680      * from the token owner's account. The `spender` contract function
681      * `receiveApproval(...)` is then executed
682      */
683     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
684         allowed[msg.sender][spender] = tokens;
685         emit Approval(msg.sender, spender, tokens);
686         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
687         return true;
688     }
689 
690     /**
691      * Don't accept ETH.
692      */
693     function () public payable {
694         revert();
695     }
696 
697     /**
698      * Owner can transfer out any accidentally sent ERC20 tokens
699      */
700     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
701         return ERC20(tokenAddress).transfer(owner, tokens);
702     }
703 
704     /**
705      * Sets the alias for the msg.sender's address.
706      * @param alias the alias to attach to an address
707      */
708     function setAlias(string alias) public {
709         aliases[msg.sender] = alias;
710         addresses[alias] = msg.sender;
711     }
712 }