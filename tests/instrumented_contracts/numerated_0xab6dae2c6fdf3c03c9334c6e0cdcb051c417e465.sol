1 pragma solidity ^0.4.23;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
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
83 
84 contract Administratable is Ownable {
85     mapping (address => bool) admins;
86 
87     event AdminAdded(address indexed _admin);
88 
89     event AdminRemoved(address indexed _admin);
90 
91     modifier onlyAdmin() {
92         require(admins[msg.sender]);
93         _;
94     }
95 
96     function addAdmin(address _addressToAdd) external onlyOwner {
97         require(_addressToAdd != address(0));
98         admins[_addressToAdd] = true;
99 
100         emit AdminAdded(_addressToAdd);
101     }
102 
103     function removeAdmin(address _addressToRemove) external onlyOwner {
104         require(_addressToRemove != address(0));
105         admins[_addressToRemove] = false;
106 
107         emit AdminRemoved(_addressToRemove);
108     }
109 }
110 contract ApproveAndCallFallBack {
111     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
112 }
113 
114 contract ERC20 {
115     function totalSupply() public constant returns (uint);
116     function balanceOf(address tokenOwner) public constant returns (uint balance);
117     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
118     function transfer(address to, uint tokens) public returns (bool success);
119     function approve(address spender, uint tokens) public returns (bool success);
120     function transferFrom(address from, address to, uint tokens) public returns (bool success);
121 
122     event Transfer(address indexed from, address indexed to, uint tokens);
123     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
124 }
125 contract ERC865 is ERC20 {
126 
127     function transferPreSigned(
128         bytes _signature,
129         address _to,
130         uint256 _value,
131         uint256 _fee,
132         uint256 _nonce
133     )
134         public
135         returns (bool);
136 
137     function approvePreSigned(
138         bytes _signature,
139         address _spender,
140         uint256 _value,
141         uint256 _fee,
142         uint256 _nonce
143     )
144         public
145         returns (bool);
146 
147     function increaseApprovalPreSigned(
148         bytes _signature,
149         address _spender,
150         uint256 _addedValue,
151         uint256 _fee,
152         uint256 _nonce
153     )
154         public
155         returns (bool);
156 
157     function decreaseApprovalPreSigned(
158         bytes _signature,
159         address _spender,
160         uint256 _subtractedValue,
161         uint256 _fee,
162         uint256 _nonce
163     )
164         public
165         returns (bool);
166 
167     function transferFromPreSigned(
168         bytes _signature,
169         address _from,
170         address _to,
171         uint256 _value,
172         uint256 _fee,
173         uint256 _nonce
174     )
175         public
176         returns (bool);
177 
178     function revokeSignature(bytes _signature)
179     public
180     returns (bool);
181 
182 }
183 
184 contract StandardToken is ERC20  {
185 
186   using SafeMath for uint256;
187 
188   mapping (address => mapping (address => uint256)) internal allowed;
189 
190   mapping(address => uint256) public balances;
191 
192   uint256 _totalSupply;
193 
194   /**
195   * @dev total number of tokens in existence
196   */
197   function totalSupply() public view returns (uint256) {
198     return _totalSupply;
199   }
200 
201   /**
202   * @dev transfer token for a specified address
203   * @param _to The address to transfer to.
204   * @param _value The amount to be transferred.
205   */
206   function transfer(address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     require(_value <= balances[msg.sender]);
209 
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     emit Transfer(msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) public view returns (uint256 balance) {
222     return balances[_owner];
223   }
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[_from]);
234     require(_value <= allowed[_from][msg.sender]);
235 
236     balances[_from] = balances[_from].sub(_value);
237     balances[_to] = balances[_to].add(_value);
238     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239     emit Transfer(_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    *
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) public returns (bool) {
254     allowed[msg.sender][_spender] = _value;
255     emit Approval(msg.sender, _spender, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param _owner address The address which owns the funds.
262    * @param _spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(address _owner, address _spender) public view returns (uint256) {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
280     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 contract ERC865Token is ERC865, StandardToken {
309 
310     /* Nonces of transfers performed */
311     mapping(bytes => bool) nonces;
312 
313     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
314     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
315     event SignatureRevoked(bytes signature, address indexed from);
316 
317     /**
318      * @notice Submit a presigned transfer
319      * @param _signature bytes The signature, issued by the owner.
320      * @param _to address The address which you want to transfer to.
321      * @param _value uint256 The amount of tokens to be transferred.
322      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
323      * @param _nonce uint256 Presigned transaction number.
324      */
325     function transferPreSigned(
326         bytes _signature,
327         address _to,
328         uint256 _value,
329         uint256 _fee,
330         uint256 _nonce
331     )
332         public
333         returns (bool)
334     {
335         require(_to != address(0));
336         require(!nonces[_signature]);
337 
338         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
339 
340         address from = recover(hashedTx, _signature);
341         require(from != address(0));
342 
343         nonces[_signature] = true;
344 
345         balances[from] = balances[from].sub(_value).sub(_fee);
346         balances[_to] = balances[_to].add(_value);
347         balances[msg.sender] = balances[msg.sender].add(_fee);
348 
349         emit Transfer(from, _to, _value);
350         emit Transfer(from, msg.sender, _fee);
351         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
352         return true;
353     }
354 
355     /**
356      * @notice Submit a presigned approval
357      * @param _signature bytes The signature, issued by the owner.
358      * @param _spender address The address which will spend the funds.
359      * @param _value uint256 The amount of tokens to allow.
360      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
361      * @param _nonce uint256 Presigned transaction number.
362      */
363     function approvePreSigned(
364         bytes _signature,
365         address _spender,
366         uint256 _value,
367         uint256 _fee,
368         uint256 _nonce
369     )
370         public
371         returns (bool)
372     {
373         require(_spender != address(0));
374         require(!nonces[_signature]);
375 
376         bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
377         address from = recover(hashedTx, _signature);
378         require(from != address(0));
379 
380         nonces[_signature] = true;
381 
382         allowed[from][_spender] = _value;
383         balances[from] = balances[from].sub(_fee);
384         balances[msg.sender] = balances[msg.sender].add(_fee);
385 
386         emit Approval(from, _spender, _value);
387         emit Transfer(from, msg.sender, _fee);
388         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
389         return true;
390     }
391 
392     /**
393      * @notice Increase the amount of tokens that an owner allowed to a spender.
394      * @param _signature bytes The signature, issued by the owner.
395      * @param _spender address The address which will spend the funds.
396      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
397      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
398      * @param _nonce uint256 Presigned transaction number.
399      */
400     function increaseApprovalPreSigned(
401         bytes _signature,
402         address _spender,
403         uint256 _addedValue,
404         uint256 _fee,
405         uint256 _nonce
406     )
407         public
408         returns (bool)
409     {
410         require(_spender != address(0));
411         require(!nonces[_signature]);
412 
413         bytes32 hashedTx = increaseApprovalPreSignedHashing(address(this), _spender, _addedValue, _fee, _nonce);
414         address from = recover(hashedTx, _signature);
415         require(from != address(0));
416 
417         nonces[_signature] = true;
418 
419         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
420         balances[from] = balances[from].sub(_fee);
421         balances[msg.sender] = balances[msg.sender].add(_fee);
422 
423         emit Approval(from, _spender, allowed[from][_spender]);
424         emit Transfer(from, msg.sender, _fee);
425         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
426         return true;
427     }
428 
429     /**
430      * @notice Decrease the amount of tokens that an owner allowed to a spender.
431      * @param _signature bytes The signature, issued by the owner
432      * @param _spender address The address which will spend the funds.
433      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
434      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
435      * @param _nonce uint256 Presigned transaction number.
436      */
437     function decreaseApprovalPreSigned(
438         bytes _signature,
439         address _spender,
440         uint256 _subtractedValue,
441         uint256 _fee,
442         uint256 _nonce
443     )
444         public
445         returns (bool)
446     {
447         require(_spender != address(0));
448         require(!nonces[_signature]);
449 
450         bytes32 hashedTx = decreaseApprovalPreSignedHashing(address(this), _spender, _subtractedValue, _fee, _nonce);
451         address from = recover(hashedTx, _signature);
452         require(from != address(0));
453 
454         nonces[_signature] = true;
455 
456         uint oldValue = allowed[from][_spender];
457         if (_subtractedValue > oldValue) {
458             allowed[from][_spender] = 0;
459         } else {
460             allowed[from][_spender] = oldValue.sub(_subtractedValue);
461         }
462         balances[from] = balances[from].sub(_fee);
463         balances[msg.sender] = balances[msg.sender].add(_fee);
464 
465         emit Approval(from, _spender, _subtractedValue);
466         emit Transfer(from, msg.sender, _fee);
467         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
468         return true;
469     }
470 
471     /**
472      * @notice Transfer tokens from one address to another
473      * @param _signature bytes The signature, issued by the spender.
474      * @param _from address The address which you want to send tokens from.
475      * @param _to address The address which you want to transfer to.
476      * @param _value uint256 The amount of tokens to be transferred.
477      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
478      * @param _nonce uint256 Presigned transaction number.
479      */
480     function transferFromPreSigned(
481         bytes _signature,
482         address _from,
483         address _to,
484         uint256 _value,
485         uint256 _fee,
486         uint256 _nonce
487     )
488         public
489         returns (bool)
490     {
491         require(_to != address(0));
492         require(!nonces[_signature]);
493 
494         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
495 
496         address spender = recover(hashedTx, _signature);
497         require(spender != address(0));
498 
499         nonces[_signature] = true;
500 
501         balances[_from] = balances[_from].sub(_value);
502         balances[_to] = balances[_to].add(_value);
503         allowed[_from][spender] = allowed[_from][spender].sub(_value);
504 
505         balances[spender] = balances[spender].sub(_fee);
506         balances[msg.sender] = balances[msg.sender].add(_fee);
507         nonces[_signature] = true;
508 
509         emit Transfer(_from, _to, _value);
510         emit Transfer(spender, msg.sender, _fee);
511         return true;
512     }
513 
514     /**
515      * Revote previously approved signature
516      * @param  _signature bytes The signature to revoke
517      * @return bool  Returns true if revocation was successful
518      */
519     function revokeSignature(bytes _signature) public returns (bool) {
520         require(!nonces[_signature]);
521         nonces[_signature] = true;
522 
523         emit SignatureRevoked(_signature, msg.sender);
524         return true;
525     }
526 
527 
528     /**
529      * @notice Hash (keccak256) of the payload used by transferPreSigned
530      * @param _token address The address of the token.
531      * @param _to address The address which you want to transfer to.
532      * @param _value uint256 The amount of tokens to be transferred.
533      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
534      * @param _nonce uint256 Presigned transaction number.
535      */
536     function transferPreSignedHashing(
537         address _token,
538         address _to,
539         uint256 _value,
540         uint256 _fee,
541         uint256 _nonce
542     )
543         public
544         pure
545         returns (bytes32)
546     {
547         /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
548         return keccak256(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce);
549     }
550 
551     /**
552      * @notice Hash (keccak256) of the payload used by approvePreSigned
553      * @param _token address The address of the token
554      * @param _spender address The address which will spend the funds.
555      * @param _value uint256 The amount of tokens to allow.
556      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
557      * @param _nonce uint256 Presigned transaction number.
558      */
559     function approvePreSignedHashing(
560         address _token,
561         address _spender,
562         uint256 _value,
563         uint256 _fee,
564         uint256 _nonce
565     )
566         public
567         pure
568         returns (bytes32)
569     {
570         /* "f7ac9c2e": approvePreSignedHashing(address,address,uint256,uint256,uint256) */
571         return keccak256(bytes4(0xf7ac9c2e), _token, _spender, _value, _fee, _nonce);
572     }
573 
574     /**
575      * @notice Hash (keccak256) of the payload used by increaseApprovalPreSigned
576      * @param _token address The address of the token
577      * @param _spender address The address which will spend the funds.
578      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
579      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
580      * @param _nonce uint256 Presigned transaction number.
581      */
582     function increaseApprovalPreSignedHashing(
583         address _token,
584         address _spender,
585         uint256 _addedValue,
586         uint256 _fee,
587         uint256 _nonce
588     )
589         public
590         pure
591         returns (bytes32)
592     {
593         /* "a45f71ff": increaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
594         return keccak256(bytes4(0xa45f71ff), _token, _spender, _addedValue, _fee, _nonce);
595     }
596 
597      /**
598       * @notice Hash (keccak256) of the payload used by decreaseApprovalPreSigned
599       * @param _token address The address of the token
600       * @param _spender address The address which will spend the funds.
601       * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
602       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
603       * @param _nonce uint256 Presigned transaction number.
604       */
605     function decreaseApprovalPreSignedHashing(
606         address _token,
607         address _spender,
608         uint256 _subtractedValue,
609         uint256 _fee,
610         uint256 _nonce
611     )
612         public
613         pure
614         returns (bytes32)
615     {
616         /* "59388d78": decreaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
617         return keccak256(bytes4(0x59388d78), _token, _spender, _subtractedValue, _fee, _nonce);
618     }
619 
620     /**
621      * @notice Hash (keccak256) of the payload used by transferFromPreSigned
622      * @param _token address The address of the token
623      * @param _from address The address which you want to send tokens from.
624      * @param _to address The address which you want to transfer to.
625      * @param _value uint256 The amount of tokens to be transferred.
626      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
627      * @param _nonce uint256 Presigned transaction number.
628      */
629     function transferFromPreSignedHashing(
630         address _token,
631         address _from,
632         address _to,
633         uint256 _value,
634         uint256 _fee,
635         uint256 _nonce
636     )
637         public
638         pure
639         returns (bytes32)
640     {
641         /* "b7656dc5": transferFromPreSignedHashing(address,address,address,uint256,uint256,uint256) */
642         return keccak256(bytes4(0xb7656dc5), _token, _from, _to, _value, _fee, _nonce);
643     }
644 
645     /**
646      * @notice Recover signer address from a message by using his signature
647      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
648      * @param sig bytes signature, the signature is generated using web3.eth.sign()
649      */
650     function recover(bytes32 hash, bytes sig) public pure returns (address) {
651       bytes32 r;
652       bytes32 s;
653       uint8 v;
654 
655       //Check the signature length
656       if (sig.length != 65) {
657         return (address(0));
658       }
659 
660       // Divide the signature in r, s and v variables
661       assembly {
662         r := mload(add(sig, 32))
663         s := mload(add(sig, 64))
664         v := byte(0, mload(add(sig, 96)))
665       }
666 
667       // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
668       if (v < 27) {
669         v += 27;
670       }
671 
672       // If the version is correct return the signer address
673       if (v != 27 && v != 28) {
674         return (address(0));
675       } else {
676         return ecrecover(hash, v, r, s);
677       }
678     }
679 
680 }
681 
682 contract Pausable is Ownable {
683     event Paused();
684     event Unpaused();
685 
686     bool public paused = false;
687 
688 
689     /**
690     * @dev Modifier to make a function callable only when the contract is not paused.
691     */
692     modifier whenNotPaused() {
693         require(!paused);
694         _;
695     }
696 
697     /**
698     * @dev Modifier to make a function callable only when the contract is paused.
699     */
700     modifier whenPaused() {
701         require(paused);
702         _;
703     }
704 
705     /**
706     * @dev called by the owner to pause, triggers stopped state
707     */
708     function pause() onlyOwner whenNotPaused public {
709         paused = true;
710         emit Paused();
711     }
712 
713     /**
714     * @dev called by the owner to unpause, returns to normal state
715     */
716     function unpause() onlyOwner whenPaused public {
717         paused = false;
718         emit Unpaused();
719     }
720 }
721 
722 contract Crowdsale {
723   using SafeMath for uint256;
724 
725   // The token being sold
726   ERC20 public token;
727 
728   // Address where funds are collected
729   address public wallet;
730 
731   // How many token units a buyer gets per wei
732   uint256 public rate;
733 
734   // Amount of wei raised
735   uint256 public weiRaised;
736 
737   // Amount of token sold in wei
738   uint256 public tokenWeiSold;
739 
740   /**
741    * Event for token purchase logging
742    * @param purchaser who paid for the tokens
743    * @param beneficiary who got the tokens
744    * @param value weis paid for purchase
745    * @param amount amount of tokens purchased
746    */
747   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
748 
749   /**
750    * @param _rate Number of token units a buyer gets per wei
751    * @param _wallet Address where collected funds will be forwarded to
752    * @param _token Address of the token being sold
753    */
754   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
755     require(_rate > 0);
756     require(_wallet != address(0));
757     require(_token != address(0));
758 
759     rate = _rate;
760     wallet = _wallet;
761     token = _token;
762   }
763 
764   // -----------------------------------------
765   // Crowdsale external interface
766   // -----------------------------------------
767 
768   /**
769    * @dev fallback function ***DO NOT OVERRIDE***
770    */
771   function () external payable {
772     buyTokens(msg.sender);
773   }
774 
775   /**
776    * @dev low level token purchase ***DO NOT OVERRIDE***
777    * @param _beneficiary Address performing the token purchase
778    */
779   function buyTokens(address _beneficiary) public payable {
780 
781     uint256 weiAmount = msg.value;
782     _preValidatePurchase(_beneficiary, weiAmount);
783 
784     // calculate token amount to be created
785     uint256 tokens = _getTokenAmount(weiAmount);
786 
787     // update state
788     weiRaised = weiRaised.add(weiAmount);
789     tokenWeiSold = tokenWeiSold.add(tokens);
790 
791     _processPurchase(_beneficiary, tokens);
792     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
793 
794     _updatePurchasingState(_beneficiary, weiAmount);
795 
796     _forwardFunds();
797     _postValidatePurchase(_beneficiary, weiAmount);
798   }
799 
800   // -----------------------------------------
801   // Internal interface (extensible)
802   // -----------------------------------------
803 
804   /**
805    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
806    * @param _beneficiary Address performing the token purchase
807    * @param _weiAmount Value in wei involved in the purchase
808    */
809   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
810     require(_beneficiary != address(0));
811     require(_weiAmount != 0);
812   }
813 
814   /**
815    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
816    * @param _beneficiary Address performing the token purchase
817    * @param _weiAmount Value in wei involved in the purchase
818    */
819   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) pure internal {
820     // optional override
821   }
822 
823   /**
824    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
825    * @param _beneficiary Address performing the token purchase
826    * @param _tokenAmount Number of tokens to be emitted
827    */
828   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
829     token.transfer(_beneficiary, _tokenAmount);
830   }
831 
832   /**
833    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
834    * @param _beneficiary Address receiving the tokens
835    * @param _tokenAmount Nu mber of tokens to be purchased
836    */
837   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
838     _deliverTokens(_beneficiary, _tokenAmount);
839   }
840 
841   /**
842    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
843    * @param _beneficiary Address receiving the tokens
844    * @param _weiAmount Value in wei involved in the purchase
845    */
846   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) pure internal {
847     // optional override
848   }
849 
850   /**
851    * @dev Override to extend the way in which ether is converted to tokens.
852    * @param _weiAmount Value in wei to be converted into tokens
853    * @return Number of tokens that can be purchased with the specified _weiAmount
854    */
855   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
856     return _weiAmount.mul(rate);
857   }
858 
859   /**
860    * @dev Determines how ETH is stored/forwarded on purchases.
861    */
862   function _forwardFunds() internal {
863     wallet.transfer(msg.value);
864   }
865 }
866 
867 contract AllowanceCrowdsale is Crowdsale {
868   using SafeMath for uint256;
869 
870   address public tokenWallet;
871 
872   /**
873    * @dev Constructor, takes token wallet address.
874    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
875    */
876   constructor(address _tokenWallet) public {
877     require(_tokenWallet != address(0));
878     tokenWallet = _tokenWallet;
879   }
880 
881   /**
882    * @dev Checks the amount of tokens left in the allowance.
883    * @return Amount of tokens left in the allowance
884    */
885   function remainingTokens() public view returns (uint256) {
886     return token.allowance(tokenWallet, this);
887   }
888 
889   /**
890    * @dev Overrides parent behavior by transferring tokens from wallet.
891    * @param _beneficiary Token purchaser
892    * @param _tokenAmount Amount of tokens purchased
893    */
894   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
895     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
896   }
897 }
898 contract CappedCrowdsale is Crowdsale {
899     using SafeMath for uint256;
900 
901     uint256 public cap;
902 
903     /**
904     * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
905     * @param _cap Max amount of wei to be contributed
906     */
907     constructor(uint256 _cap) public {
908         require(_cap > 0);
909         cap = _cap;
910     }
911 
912     /**
913     * @dev Checks whether the cap has been reached.
914     * @return Whether the cap was reached
915     */
916     function capReached() public view returns (bool) {
917         return weiRaised >= cap;
918     }
919 
920     /**
921     * @dev Extend parent behavior requiring purchase to respect the funding cap.
922     * @param _beneficiary Token purchaser
923     * @param _weiAmount Amount of wei contributed
924     */
925     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
926         super._preValidatePurchase(_beneficiary, _weiAmount);
927         require(weiRaised.add(_weiAmount) <= cap);
928     }
929 
930 }
931 contract TimedCrowdsale is Crowdsale {
932   using SafeMath for uint256;
933 
934   uint256 public openingTime;
935   uint256 public closingTime;
936 
937   /**
938    * @dev Reverts if not in crowdsale time range.
939    */
940   modifier onlyWhileOpen {
941     // solium-disable-next-line security/no-block-members
942     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
943     _;
944   }
945 
946   /**
947    * @dev Constructor, takes crowdsale opening and closing times.
948    * @param _openingTime Crowdsale opening time
949    * @param _closingTime Crowdsale closing time
950    */
951   constructor(uint256 _openingTime, uint256 _closingTime) public {
952     // solium-disable-next-line security/no-block-members
953     require(_openingTime >= block.timestamp);
954     require(_closingTime >= _openingTime);
955 
956     openingTime = _openingTime;
957     closingTime = _closingTime;
958   }
959 
960   /**
961    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
962    * @return Whether crowdsale period has elapsed
963    */
964   function hasClosed() public view returns (bool) {
965     // solium-disable-next-line security/no-block-members
966     return block.timestamp > closingTime;
967   }
968 
969   /**
970    * @dev Extend parent behavior requiring to be within contributing period
971    * @param _beneficiary Token purchaser
972    * @param _weiAmount Amount of wei contributed
973    */
974   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
975     super._preValidatePurchase(_beneficiary, _weiAmount);
976   }
977 
978 }
979 contract WhitelistedCrowdsale is Crowdsale, Administratable {
980 
981   mapping(address => bool) public whitelist;
982 
983   /**
984    * Event for logging adding to whitelist
985    * @param _address the address to add to the whitelist
986    */
987   event AddedToWhitelist(address indexed _address);
988 
989   /**
990    * Event for logging removing from whitelist
991    * @param _address the address to remove from the whitelist
992    */
993   event RemovedFromWhitelist(address indexed _address);
994 
995 
996   /**
997    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
998    */
999   modifier isWhitelisted(address _beneficiary) {
1000     require(whitelist[_beneficiary]);
1001     _;
1002   }
1003 
1004   /**
1005    * @dev Adds single address to whitelist.
1006    * @param _beneficiary Address to be added to the whitelist
1007    */
1008   function addToWhitelist(address _beneficiary) external onlyAdmin {
1009     whitelist[_beneficiary] = true;
1010     emit AddedToWhitelist(_beneficiary);
1011   }
1012 
1013   /**
1014    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
1015    * @param _beneficiaries Addresses to be added to the whitelist
1016    */
1017   function addManyToWhitelist(address[] _beneficiaries) external onlyAdmin {
1018     for (uint256 i = 0; i < _beneficiaries.length; i++) {
1019       whitelist[_beneficiaries[i]] = true;
1020     }
1021   }
1022 
1023   /**
1024    * @dev Removes single address from whitelist.
1025    * @param _beneficiary Address to be removed to the whitelist
1026    */
1027   function removeFromWhitelist(address _beneficiary) external onlyAdmin {
1028     whitelist[_beneficiary] = false;
1029     emit RemovedFromWhitelist(_beneficiary);
1030   }
1031 
1032   /**
1033    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1034    * @param _beneficiary Token beneficiary
1035    * @param _weiAmount Amount of wei contributed
1036    */
1037   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
1038     super._preValidatePurchase(_beneficiary, _weiAmount);
1039   }
1040 
1041 }
1042 
1043 contract PostDeliveryCrowdsale is TimedCrowdsale, Administratable {
1044   using SafeMath for uint256;
1045 
1046   mapping(address => uint256) public balances;
1047   /**
1048    * Event for logging when token sale tokens are withdrawn
1049    * @param _address the address to withdraw tokens for
1050    * @param _amount the amount withdrawn for this address
1051    */
1052   event TokensWithdrawn(address indexed _address, uint256 _amount);
1053 
1054   /**
1055    * @dev Withdraw tokens only after crowdsale ends.
1056    */
1057   function withdrawTokens(address _beneficiary) public onlyAdmin {
1058     require(hasClosed());
1059     uint256 amount = balances[_beneficiary];
1060     require(amount > 0);
1061     balances[_beneficiary] = 0;
1062     _deliverTokens(_beneficiary, amount);
1063     emit TokensWithdrawn(_beneficiary, amount);
1064   }
1065 
1066   /**
1067    * @dev Overrides parent by storing balances instead of issuing tokens right away.
1068    * @param _beneficiary Token purchaser
1069    * @param _tokenAmount Amount of tokens purchased
1070    */
1071   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1072     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
1073   }
1074 
1075   function getBalance(address _beneficiary) public returns (uint256) {
1076       return balances[_beneficiary];
1077   }
1078 
1079 }
1080 
1081 contract MultiRoundCrowdsale is  Crowdsale, Ownable {
1082 
1083     using SafeMath for uint256;
1084 
1085     struct SaleRound {
1086         uint256 start;
1087         uint256 end;
1088         uint256 rate;
1089         uint256 roundCap;
1090         uint256 minPurchase;
1091     }
1092 
1093     SaleRound seedRound;
1094     SaleRound presale;
1095     SaleRound crowdsaleWeek1;
1096     SaleRound crowdsaleWeek2;
1097     SaleRound crowdsaleWeek3;
1098     SaleRound crowdsaleWeek4;
1099 
1100     bool public saleRoundsSet = false;
1101 
1102     /**
1103      * Sets the parameters for each round.
1104      *
1105      * Each round is defined by an array, with each field mapping to a field in the SaleRound struct.
1106      * The array elements are as follows:
1107      * array[0]: start time of the round
1108      * array[1]: end time of the round
1109      * array[2]: the exchange rate of this round. i.e number of TIP per ETH
1110      * array[3]: The cumulative cap of this round
1111      * array[4]: Minimum purchase of this round
1112      *
1113      * @param _seedRound [description]
1114      * @param _presale [description]
1115      * @param _crowdsaleWeek1 [description]
1116      * @param _crowdsaleWeek2 [description]
1117      * @param _crowdsaleWeek3 [description]
1118      * @param _crowdsaleWeek4 [description]
1119      */
1120     function setTokenSaleRounds(uint256[5] _seedRound, uint256[5] _presale, uint256[5] _crowdsaleWeek1, uint256[5] _crowdsaleWeek2, uint256[5] _crowdsaleWeek3, uint256[5] _crowdsaleWeek4) external onlyOwner returns (bool) {
1121         // This function can only be called once
1122         require(!saleRoundsSet);
1123 
1124         // Check that each round end time is after the start time
1125         require(_seedRound[0] < _seedRound[1]);
1126         require(_presale[0] < _presale[1]);
1127         require(_crowdsaleWeek1[0] < _crowdsaleWeek1[1]);
1128         require(_crowdsaleWeek2[0] < _crowdsaleWeek2[1]);
1129         require(_crowdsaleWeek3[0] < _crowdsaleWeek3[1]);
1130         require(_crowdsaleWeek4[0] < _crowdsaleWeek4[1]);
1131 
1132         // Check that each round ends before the next begins
1133         require(_seedRound[1] < _presale[0]);
1134         require(_presale[1] < _crowdsaleWeek1[0]);
1135         require(_crowdsaleWeek1[1] < _crowdsaleWeek2[0]);
1136         require(_crowdsaleWeek2[1] < _crowdsaleWeek3[0]);
1137         require(_crowdsaleWeek3[1] < _crowdsaleWeek4[0]);
1138 
1139         seedRound      = SaleRound(_seedRound[0], _seedRound[1], _seedRound[2], _seedRound[3], _seedRound[4]);
1140         presale        = SaleRound(_presale[0], _presale[1], _presale[2], _presale[3], _presale[4]);
1141         crowdsaleWeek1 = SaleRound(_crowdsaleWeek1[0], _crowdsaleWeek1[1], _crowdsaleWeek1[2], _crowdsaleWeek1[3], _crowdsaleWeek1[4]);
1142         crowdsaleWeek2 = SaleRound(_crowdsaleWeek2[0], _crowdsaleWeek2[1], _crowdsaleWeek2[2], _crowdsaleWeek2[3], _crowdsaleWeek2[4]);
1143         crowdsaleWeek3 = SaleRound(_crowdsaleWeek3[0], _crowdsaleWeek3[1], _crowdsaleWeek3[2], _crowdsaleWeek3[3], _crowdsaleWeek3[4]);
1144         crowdsaleWeek4 = SaleRound(_crowdsaleWeek4[0], _crowdsaleWeek4[1], _crowdsaleWeek4[2], _crowdsaleWeek4[3], _crowdsaleWeek4[4]);
1145 
1146         saleRoundsSet = true;
1147         return saleRoundsSet;
1148     }
1149 
1150     function getCurrentRound() internal view returns (SaleRound) {
1151         require(saleRoundsSet);
1152 
1153         uint256 currentTime = block.timestamp;
1154         if (currentTime > seedRound.start && currentTime <= seedRound.end) {
1155             return seedRound;
1156         } else if (currentTime > presale.start && currentTime <= presale.end) {
1157             return presale;
1158         } else if (currentTime > crowdsaleWeek1.start && currentTime <= crowdsaleWeek1.end) {
1159             return crowdsaleWeek1;
1160         } else if (currentTime > crowdsaleWeek2.start && currentTime <= crowdsaleWeek2.end) {
1161             return crowdsaleWeek2;
1162         } else if (currentTime > crowdsaleWeek3.start && currentTime <= crowdsaleWeek3.end) {
1163             return crowdsaleWeek3;
1164         } else if (currentTime > crowdsaleWeek4.start && currentTime <= crowdsaleWeek4.end) {
1165             return crowdsaleWeek4;
1166         } else {
1167             revert();
1168         }
1169     }
1170 
1171     function getCurrentRate() public view returns (uint256) {
1172         require(saleRoundsSet);
1173         SaleRound memory currentRound = getCurrentRound();
1174         return currentRound.rate;
1175     }
1176 
1177     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1178         require(_weiAmount != 0);
1179         uint256 currentRate = getCurrentRate();
1180         require(currentRate != 0);
1181 
1182         return currentRate.mul(_weiAmount);
1183     }
1184 }
1185 
1186 contract TipToken is ERC865Token, Ownable {
1187     using SafeMath for uint256;
1188 
1189     uint256 public constant TOTAL_SUPPLY = 10 ** 9;
1190 
1191     string public constant name = "Tip Token";
1192     string public constant symbol = "TIP";
1193     uint8 public constant decimals = 18;
1194 
1195     mapping (address => string) aliases;
1196     mapping (string => address) addresses;
1197 
1198     /**
1199      * Constructor
1200      */
1201     constructor() public {
1202         _totalSupply = TOTAL_SUPPLY * (10**uint256(decimals));
1203         balances[owner] = _totalSupply;
1204         emit Transfer(address(0), owner, _totalSupply);
1205     }
1206 
1207     /**
1208      * Returns the available supple (total supply minus tokens held by owner)
1209      */
1210     function availableSupply() public view returns (uint256) {
1211         return _totalSupply.sub(balances[owner]).sub(balances[address(0)]);
1212     }
1213 
1214     /**
1215      * Token owner can approve for `spender` to transferFrom(...) `tokens`
1216      * from the token owner's account. The `spender` contract function
1217      * `receiveApproval(...)` is then executed
1218      */
1219     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
1220         allowed[msg.sender][spender] = tokens;
1221         emit Approval(msg.sender, spender, tokens);
1222         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
1223         return true;
1224     }
1225 
1226     /**
1227      * Don't accept ETH.
1228      */
1229     function () public payable {
1230         revert();
1231     }
1232 
1233     /**
1234      * Owner can transfer out any accidentally sent ERC20 tokens
1235      */
1236     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
1237         return ERC20(tokenAddress).transfer(owner, tokens);
1238     }
1239 
1240     /**
1241      * Sets the alias for the msg.sender's address.
1242      * @param alias the alias to attach to an address
1243      */
1244     function setAlias(string alias) public {
1245         aliases[msg.sender] = alias;
1246         addresses[alias] = msg.sender;
1247     }
1248 }
1249 
1250 contract TipTokenCrowdsale is MultiRoundCrowdsale, CappedCrowdsale, WhitelistedCrowdsale, AllowanceCrowdsale, PostDeliveryCrowdsale, Pausable {
1251 
1252     /**
1253      * Contract name
1254      * String name - the name of the contract
1255      */
1256     string public constant name = "Tip Token Crowdsale";
1257 
1258 
1259     /**
1260      * @param _vault Address where collected funds will be forwarded to
1261      * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
1262      * @param _cap the maximum number of tokens to be collected in the sale
1263      * @param _token Address of the token being sold
1264      */
1265     constructor(
1266         ERC20 _token,
1267         address _tokenWallet,
1268         address _vault,
1269         uint256 _cap,
1270         uint256 _start, uint256 _end, uint256 _baseRate
1271         ) public
1272         Crowdsale(_baseRate, _vault, _token)
1273         CappedCrowdsale(_cap)
1274         TimedCrowdsale(_start, _end)
1275         PostDeliveryCrowdsale()
1276         WhitelistedCrowdsale()
1277         AllowanceCrowdsale(_tokenWallet)
1278         MultiRoundCrowdsale()
1279         {
1280     }
1281 
1282     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused() {
1283         super._preValidatePurchase(_beneficiary, _weiAmount);
1284 
1285         SaleRound memory currentRound = getCurrentRound();
1286         require(weiRaised.add(_weiAmount) <= currentRound.roundCap);
1287         require(balances[_beneficiary].add(_weiAmount) >= currentRound.minPurchase);
1288     }
1289 
1290     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1291         return MultiRoundCrowdsale._getTokenAmount(_weiAmount);
1292     }
1293 
1294     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
1295         AllowanceCrowdsale._deliverTokens(_beneficiary, _tokenAmount);
1296     }
1297 }