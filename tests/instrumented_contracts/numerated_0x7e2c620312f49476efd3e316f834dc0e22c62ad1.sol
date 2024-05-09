1 pragma solidity ^0.4.24;
2 contract ERC20Basic {
3   function totalSupply() public view returns (uint256);
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers, truncating the quotient.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   /**
69   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   /**
77   * @dev Adds two numbers, throws on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) public view returns (uint256);
88   function transferFrom(address from, address to, uint256 value) public returns (bool);
89   function approve(address spender, uint256 value) public returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   uint256 totalSupply_;
139 
140   /**
141   * @dev total number of tokens in existence
142   */
143   function totalSupply() public view returns (uint256) {
144     return totalSupply_;
145   }
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     // SafeMath.sub will throw if there is not enough balance.
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256 balance) {
169     return balances[_owner];
170   }
171 
172 }
173 
174 contract ERC865 is ERC20 {
175 
176     function transferPreSigned(
177         bytes _signature,
178         address _to,
179         uint256 _value,
180         uint256 _fee,
181         uint256 _nonce
182     )
183         public
184         returns (bool);
185 
186     function approvePreSigned(
187         bytes _signature,
188         address _spender,
189         uint256 _value,
190         uint256 _fee,
191         uint256 _nonce
192     )
193         public
194         returns (bool);
195 
196     function increaseApprovalPreSigned(
197         bytes _signature,
198         address _spender,
199         uint256 _addedValue,
200         uint256 _fee,
201         uint256 _nonce
202     )
203         public
204         returns (bool);
205 
206     function decreaseApprovalPreSigned(
207         bytes _signature,
208         address _spender,
209         uint256 _subtractedValue,
210         uint256 _fee,
211         uint256 _nonce
212     )
213         public
214         returns (bool);
215 
216     function transferFromPreSigned(
217         bytes _signature,
218         address _from,
219         address _to,
220         uint256 _value,
221         uint256 _fee,
222         uint256 _nonce
223     )
224         public
225         returns (bool);
226 }
227 
228 contract StandardToken is ERC20, BasicToken {
229 
230   mapping (address => mapping (address => uint256)) internal allowed;
231 
232 
233   /**
234    * @dev Transfer tokens from one address to another
235    * @param _from address The address which you want to send tokens from
236    * @param _to address The address which you want to transfer to
237    * @param _value uint256 the amount of tokens to be transferred
238    */
239   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
240     require(_to != address(0));
241     require(_value <= balances[_from]);
242     require(_value <= allowed[_from][msg.sender]);
243 
244     balances[_from] = balances[_from].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247     Transfer(_from, _to, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    *
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _value) public returns (bool) {
262     allowed[msg.sender][_spender] = _value;
263     Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) public view returns (uint256) {
274     return allowed[_owner][_spender];
275   }
276 
277   /**
278    * @dev Increase the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To increment
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _addedValue The amount of tokens to increase the allowance by.
286    */
287   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
288     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
289     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    *
296    * approve should be called when allowed[_spender] == 0. To decrement
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _subtractedValue The amount of tokens to decrease the allowance by.
302    */
303   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
304     uint oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue > oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314 }
315 
316 contract MintableToken is StandardToken, Ownable {
317   event Mint(address indexed to, uint256 amount);
318   event MintFinished();
319 
320   bool public mintingFinished = false;
321 
322 
323   modifier canMint() {
324     require(!mintingFinished);
325     _;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
335     totalSupply_ = totalSupply_.add(_amount);
336     balances[_to] = balances[_to].add(_amount);
337     Mint(_to, _amount);
338     Transfer(address(0), _to, _amount);
339     return true;
340   }
341 
342   /**
343    * @dev Function to stop minting new tokens.
344    * @return True if the operation was successful.
345    */
346   function finishMinting() onlyOwner canMint public returns (bool) {
347     mintingFinished = true;
348     MintFinished();
349     return true;
350   }
351 }
352 
353 contract PausableToken is StandardToken, Pausable {
354 
355   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
356     return super.transfer(_to, _value);
357   }
358 
359   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
360     return super.transferFrom(_from, _to, _value);
361   }
362 
363   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
364     return super.approve(_spender, _value);
365   }
366 
367   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
368     return super.increaseApproval(_spender, _addedValue);
369   }
370 
371   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
372     return super.decreaseApproval(_spender, _subtractedValue);
373   }
374 }
375 
376 contract ERC865Token is ERC865, StandardToken {
377 
378     /* Nonces of transfers performed */
379     mapping(bytes => bool) signatures;
380 
381     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
382     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
383 
384     /**
385      * @notice Submit a presigned transfer
386      * @param _signature bytes The signature, issued by the owner.
387      * @param _to address The address which you want to transfer to.
388      * @param _value uint256 The amount of tokens to be transferred.
389      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
390      * @param _nonce uint256 Presigned transaction number.
391      */
392     function transferPreSigned(
393         bytes _signature,
394         address _to,
395         uint256 _value,
396         uint256 _fee,
397         uint256 _nonce
398     )
399         public
400         returns (bool)
401     {
402         require(_to != address(0), "No address provided");
403         require(signatures[_signature] == false, "No signature");
404 
405         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
406 
407         address from = recover(hashedTx, _signature);
408         require(from != address(0), "From address is not provided");
409 
410         balances[from] = balances[from].sub(_value).sub(_fee);
411         balances[_to] = balances[_to].add(_value);
412         balances[msg.sender] = balances[msg.sender].add(_fee);
413         signatures[_signature] = true;
414 
415         emit Transfer(from, _to, _value);
416         emit Transfer(from, msg.sender, _fee);
417         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
418         return true;
419     }
420 
421     /**
422      * @notice Submit a presigned approval
423      * @param _signature bytes The signature, issued by the owner.
424      * @param _spender address The address which will spend the funds.
425      * @param _value uint256 The amount of tokens to allow.
426      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
427      * @param _nonce uint256 Presigned transaction number.
428      */
429     function approvePreSigned(
430         bytes _signature,
431         address _spender,
432         uint256 _value,
433         uint256 _fee,
434         uint256 _nonce
435     )
436         public
437         returns (bool)
438     {
439         require(_spender != address(0), "Spender is not provided");
440         require(signatures[_signature] == false, "No signature");
441 
442         bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
443         address from = recover(hashedTx, _signature);
444         require(from != address(0), "From addres is not provided");
445 
446         allowed[from][_spender] = _value;
447         balances[from] = balances[from].sub(_fee);
448         balances[msg.sender] = balances[msg.sender].add(_fee);
449         signatures[_signature] = true;
450 
451         emit Approval(from, _spender, _value);
452         emit Transfer(from, msg.sender, _fee);
453         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
454         return true;
455     }
456 
457     /**
458      * @notice Increase the amount of tokens that an owner allowed to a spender.
459      * @param _signature bytes The signature, issued by the owner.
460      * @param _spender address The address which will spend the funds.
461      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
462      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
463      * @param _nonce uint256 Presigned transaction number.
464      */
465     function increaseApprovalPreSigned(
466         bytes _signature,
467         address _spender,
468         uint256 _addedValue,
469         uint256 _fee,
470         uint256 _nonce
471     )
472         public
473         returns (bool)
474     {
475         require(_spender != address(0), "Spender address is not provided");
476         require(signatures[_signature] == false, "No Signature");
477 
478         bytes32 hashedTx = increaseApprovalPreSignedHashing(address(this), _spender, _addedValue, _fee, _nonce);
479         address from = recover(hashedTx, _signature);
480         require(from != address(0), "From address is not provided");
481 
482         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
483         balances[from] = balances[from].sub(_fee);
484         balances[msg.sender] = balances[msg.sender].add(_fee);
485         signatures[_signature] = true;
486 
487         emit Approval(from, _spender, allowed[from][_spender]);
488         emit Transfer(from, msg.sender, _fee);
489         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
490         return true;
491     }
492 
493     /**
494      * @notice Decrease the amount of tokens that an owner allowed to a spender.
495      * @param _signature bytes The signature, issued by the owner
496      * @param _spender address The address which will spend the funds.
497      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
498      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
499      * @param _nonce uint256 Presigned transaction number.
500      */
501     function decreaseApprovalPreSigned(
502         bytes _signature,
503         address _spender,
504         uint256 _subtractedValue,
505         uint256 _fee,
506         uint256 _nonce
507     )
508         public
509         returns (bool)
510     {
511         require(_spender != address(0), "Spender address is not provided");
512         require(signatures[_signature] == false, "No sognature");
513 
514         bytes32 hashedTx = decreaseApprovalPreSignedHashing(address(this), _spender, _subtractedValue, _fee, _nonce);
515         address from = recover(hashedTx, _signature);
516         require(from != address(0), "From address is not provided");
517 
518         uint oldValue = allowed[from][_spender];
519         if (_subtractedValue > oldValue) {
520             allowed[from][_spender] = 0;
521         } else {
522             allowed[from][_spender] = oldValue.sub(_subtractedValue);
523         }
524         balances[from] = balances[from].sub(_fee);
525         balances[msg.sender] = balances[msg.sender].add(_fee);
526         signatures[_signature] = true;
527 
528         emit Approval(from, _spender, _subtractedValue);
529         emit Transfer(from, msg.sender, _fee);
530         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
531         return true;
532     }
533 
534     /**
535      * @notice Transfer tokens from one address to another
536      * @param _signature bytes The signature, issued by the spender.
537      * @param _from address The address which you want to send tokens from.
538      * @param _to address The address which you want to transfer to.
539      * @param _value uint256 The amount of tokens to be transferred.
540      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
541      * @param _nonce uint256 Presigned transaction number.
542      */
543     function transferFromPreSigned(
544         bytes _signature,
545         address _from,
546         address _to,
547         uint256 _value,
548         uint256 _fee,
549         uint256 _nonce
550     )
551         public
552         returns (bool)
553     {
554         require(_to != address(0), "No [to] address provided");
555         require(signatures[_signature] == false, "No signature provided");
556 
557         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
558 
559         address spender = recover(hashedTx, _signature);
560         require(spender != address(0), "Spender address is not provided");
561 
562         balances[_from] = balances[_from].sub(_value);
563         balances[_to] = balances[_to].add(_value);
564         allowed[_from][spender] = allowed[_from][spender].sub(_value);
565 
566         balances[spender] = balances[spender].sub(_fee);
567         balances[msg.sender] = balances[msg.sender].add(_fee);
568         signatures[_signature] = true;
569 
570         emit Transfer(_from, _to, _value);
571         emit Transfer(spender, msg.sender, _fee);
572         return true;
573     }
574 
575 
576     /**
577      * @notice Hash (keccak256) of the payload used by transferPreSigned
578      * @param _token address The address of the token.
579      * @param _to address The address which you want to transfer to.
580      * @param _value uint256 The amount of tokens to be transferred.
581      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
582      * @param _nonce uint256 Presigned transaction number.
583      */
584     function transferPreSignedHashing(
585         address _token,
586         address _to,
587         uint256 _value,
588         uint256 _fee,
589         uint256 _nonce
590     )
591         public
592         pure
593         returns (bytes32)
594     {
595         /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
596         return keccak256(abi.encodePacked(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce));
597     }
598 
599     /**
600      * @notice Hash (keccak256) of the payload used by approvePreSigned
601      * @param _token address The address of the token
602      * @param _spender address The address which will spend the funds.
603      * @param _value uint256 The amount of tokens to allow.
604      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
605      * @param _nonce uint256 Presigned transaction number.
606      */
607     function approvePreSignedHashing(
608         address _token,
609         address _spender,
610         uint256 _value,
611         uint256 _fee,
612         uint256 _nonce
613     )
614         public
615         pure
616         returns (bytes32)
617     {
618         /* "f7ac9c2e": approvePreSignedHashing(address,address,uint256,uint256,uint256) */
619         return keccak256(abi.encodePacked(bytes4(0xf7ac9c2e), _token, _spender, _value, _fee, _nonce));
620     }
621 
622     /**
623      * @notice Hash (keccak256) of the payload used by increaseApprovalPreSigned
624      * @param _token address The address of the token
625      * @param _spender address The address which will spend the funds.
626      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
627      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
628      * @param _nonce uint256 Presigned transaction number.
629      */
630     function increaseApprovalPreSignedHashing(
631         address _token,
632         address _spender,
633         uint256 _addedValue,
634         uint256 _fee,
635         uint256 _nonce
636     )
637         public
638         pure
639         returns (bytes32)
640     {
641         /* "a45f71ff": increaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
642         return keccak256(abi.encodePacked(bytes4(0xa45f71ff), _token, _spender, _addedValue, _fee, _nonce));
643     }
644 
645      /**
646       * @notice Hash (keccak256) of the payload used by decreaseApprovalPreSigned
647       * @param _token address The address of the token
648       * @param _spender address The address which will spend the funds.
649       * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
650       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
651       * @param _nonce uint256 Presigned transaction number.
652       */
653     function decreaseApprovalPreSignedHashing(
654         address _token,
655         address _spender,
656         uint256 _subtractedValue,
657         uint256 _fee,
658         uint256 _nonce
659     )
660         public
661         pure
662         returns (bytes32)
663     {
664         /* "59388d78": decreaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
665         return keccak256(abi.encodePacked(bytes4(0x59388d78), _token, _spender, _subtractedValue, _fee, _nonce));
666     }
667 
668     /**
669      * @notice Hash (keccak256) of the payload used by transferFromPreSigned
670      * @param _token address The address of the token
671      * @param _from address The address which you want to send tokens from.
672      * @param _to address The address which you want to transfer to.
673      * @param _value uint256 The amount of tokens to be transferred.
674      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
675      * @param _nonce uint256 Presigned transaction number.
676      */
677     function transferFromPreSignedHashing(
678         address _token,
679         address _from,
680         address _to,
681         uint256 _value,
682         uint256 _fee,
683         uint256 _nonce
684     )
685         public
686         pure
687         returns (bytes32)
688     {
689         /* "b7656dc5": transferFromPreSignedHashing(address,address,address,uint256,uint256,uint256) */
690         return keccak256(abi.encodePacked(bytes4(0xb7656dc5), _token, _from, _to, _value, _fee, _nonce));
691     }
692 
693     /**
694      * @notice Recover signer address from a message by using his signature
695      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
696      * @param sig bytes signature, the signature is generated using web3.eth.sign()
697      */
698     function recover(bytes32 hash, bytes sig) public pure returns (address) {
699         bytes32 r;
700         bytes32 s;
701         uint8 v;
702 
703         //Check the signature length
704         if (sig.length != 65) {
705             return (address(0));
706         }
707 
708         // Divide the signature in r, s and v variables
709         assembly {
710             r := mload(add(sig, 32))
711             s := mload(add(sig, 64))
712             v := byte(0, mload(add(sig, 96)))
713         }
714 
715         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
716         if (v < 27) {
717             v += 27;
718         }
719 
720         // If the version is correct return the signer address
721         if (v != 27 && v != 28) {
722             return (address(0));
723         } else {
724             return ecrecover(hash, v, r, s);
725         }
726     }
727 }
728 
729 contract CappedToken is MintableToken {
730 
731   uint256 public cap;
732 
733   constructor(uint256 _cap) public {
734     require(_cap > 0);
735     cap = _cap;
736   }
737 
738   /**
739    * @dev Function to mint tokens
740    * @param _to The address that will receive the minted tokens.
741    * @param _amount The amount of tokens to mint.
742    * @return A boolean that indicates if the operation was successful.
743    */
744   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
745     require(totalSupply_.add(_amount) <= cap);
746 
747     return super.mint(_to, _amount);
748   }
749 
750 }
751 
752 contract KittiefightToken is ERC865Token, PausableToken, CappedToken {
753 
754     /* Set the token name for display */
755     string public constant symbol = "KTY";
756 
757     /* Set the token symbol for display */
758     string public constant name = "Kittiefight";
759 
760     /* Set the number of decimals for display */
761     uint8 public constant decimals = 18;
762 
763     /* 100 milion KTY specified */
764     uint256 public constant amountOfTokenToMint = 10**8 * 10**uint256(decimals);
765 
766     /* Is crowdsale filtering non registered users. false by default */
767     bool public isTransferWhitelistOnly = false;
768 
769     /* Mapping of whitelisted users */
770     mapping (address => bool) transfersWhitelist;
771 
772     event UserAllowedToTransfer(address user);
773 
774     event TransferWhitelistOnly(bool flag);
775 
776 
777     constructor() CappedToken(amountOfTokenToMint) {
778         
779     }
780 
781     /**
782      * @notice Is the address allowed to transfer
783      * @return true if the sender can transfer
784      */
785     function isUserAllowedToTransfer(address _user) public constant returns (bool) {
786         require(_user != 0x0);
787         return transfersWhitelist[_user];
788     }
789 
790     /**
791      * @notice Enabling / Disabling transfers of non whitelisted users
792      */
793     function setWhitelistedOnly(bool _isWhitelistOnly) onlyOwner public {
794         if (isTransferWhitelistOnly != _isWhitelistOnly) {
795             isTransferWhitelistOnly = _isWhitelistOnly;
796             TransferWhitelistOnly(_isWhitelistOnly);
797         }
798     }
799 
800     /**
801      * @notice Adding a user to the whitelist
802      */
803     function whitelistUserForTransfers(address _user) onlyOwner public {
804         require(!isUserAllowedToTransfer(_user));
805         transfersWhitelist[_user] = true;
806         UserAllowedToTransfer(_user);
807     }
808 
809     /**
810      * @notice Remove a user from the whitelist
811      */
812     function blacklistUserForTransfers(address _user) onlyOwner public {
813         require(isUserAllowedToTransfer(_user));
814         transfersWhitelist[_user] = false;
815         UserAllowedToTransfer(_user);
816     }
817 
818     /**
819     * @notice transfer token for a specified address
820     * @param _to The address to transfer to.
821     * @param _value The amount to be transferred.
822     */
823     function transfer(address _to, uint256 _value) public returns (bool) {
824       if (isTransferWhitelistOnly) {
825         require(isUserAllowedToTransfer(msg.sender));
826       }
827       return super.transfer(_to, _value);
828     }
829 
830     /**
831      * @notice Transfer tokens from one address to another
832      * @param _from address The address which you want to send tokens from
833      * @param _to address The address which you want to transfer to
834      * @param _value uint256 the amount of tokens to be transferred
835      */
836     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
837         if (isTransferWhitelistOnly) {
838             require(isUserAllowedToTransfer(_from));
839         }
840         return super.transferFrom(_from, _to, _value);
841     }
842 
843     /**
844      * @notice Submit a presigned transfer
845      * @param _signature bytes The signature, issued by the owner.
846      * @param _to address The address which you want to transfer to.
847      * @param _value uint256 The amount of tokens to be transferred.
848      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
849      * @param _nonce uint256 Presigned transaction number.
850      */
851     function transferPreSigned(
852         bytes _signature,
853         address _to,
854         uint256 _value,
855         uint256 _fee,
856         uint256 _nonce
857     )
858         whenNotPaused
859         public
860         returns (bool)
861     {
862         if (isTransferWhitelistOnly) {
863             bytes32 hashedTx = super.transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
864             address from = recover(hashedTx, _signature);
865             require(isUserAllowedToTransfer(from));
866         }
867         return super.transferPreSigned(_signature, _to, _value, _fee, _nonce);
868     }
869 
870     /**
871      * @notice Submit a presigned approval
872      * @param _signature bytes The signature, issued by the owner.
873      * @param _spender address The address which will spend the funds.
874      * @param _value uint256 The amount of tokens to allow.
875      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
876      * @param _nonce uint256 Presigned transaction number.
877      */
878     function approvePreSigned(
879         bytes _signature,
880         address _spender,
881         uint256 _value,
882         uint256 _fee,
883         uint256 _nonce
884     )
885         whenNotPaused
886         public
887         returns (bool)
888     {
889         if (isTransferWhitelistOnly) {
890             bytes32 hashedTx = super.approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
891             address from = recover(hashedTx, _signature);
892             require(isUserAllowedToTransfer(from));
893         }
894         return super.approvePreSigned(_signature, _spender, _value, _fee, _nonce);
895     }
896 }