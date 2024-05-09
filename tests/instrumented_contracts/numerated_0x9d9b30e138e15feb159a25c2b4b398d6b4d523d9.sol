1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 contract Pausable is Ownable {
96   event Pause();
97   event Unpause();
98 
99   bool public paused = false;
100 
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is not paused.
104    */
105   modifier whenNotPaused() {
106     require(!paused);
107     _;
108   }
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(paused);
115     _;
116   }
117 
118   /**
119    * @dev called by the owner to pause, triggers stopped state
120    */
121   function pause() onlyOwner whenNotPaused public {
122     paused = true;
123     Pause();
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() onlyOwner whenPaused public {
130     paused = false;
131     Unpause();
132   }
133 }
134 
135 contract ERC865 is ERC20 {
136 
137     function transferPreSigned(
138         bytes _signature,
139         address _to,
140         uint256 _value,
141         uint256 _fee,
142         uint256 _nonce
143     )
144         public
145         returns (bool);
146 
147     function approvePreSigned(
148         bytes _signature,
149         address _spender,
150         uint256 _value,
151         uint256 _fee,
152         uint256 _nonce
153     )
154         public
155         returns (bool);
156 
157     function increaseApprovalPreSigned(
158         bytes _signature,
159         address _spender,
160         uint256 _addedValue,
161         uint256 _fee,
162         uint256 _nonce
163     )
164         public
165         returns (bool);
166 
167     function decreaseApprovalPreSigned(
168         bytes _signature,
169         address _spender,
170         uint256 _subtractedValue,
171         uint256 _fee,
172         uint256 _nonce
173     )
174         public
175         returns (bool);
176 
177     function transferFromPreSigned(
178         bytes _signature,
179         address _from,
180         address _to,
181         uint256 _value,
182         uint256 _fee,
183         uint256 _nonce
184     )
185         public
186         returns (bool);
187 }
188 
189 contract BasicToken is ERC20Basic {
190   using SafeMath for uint256;
191 
192   mapping(address => uint256) balances;
193 
194   uint256 totalSupply_;
195 
196   /**
197   * @dev total number of tokens in existence
198   */
199   function totalSupply() public view returns (uint256) {
200     return totalSupply_;
201   }
202 
203   /**
204   * @dev transfer token for a specified address
205   * @param _to The address to transfer to.
206   * @param _value The amount to be transferred.
207   */
208   function transfer(address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[msg.sender]);
211 
212     // SafeMath.sub will throw if there is not enough balance.
213     balances[msg.sender] = balances[msg.sender].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     Transfer(msg.sender, _to, _value);
216     return true;
217   }
218 
219   /**
220   * @dev Gets the balance of the specified address.
221   * @param _owner The address to query the the balance of.
222   * @return An uint256 representing the amount owned by the passed address.
223   */
224   function balanceOf(address _owner) public view returns (uint256 balance) {
225     return balances[_owner];
226   }
227 
228 }
229 
230 contract StandardToken is ERC20, BasicToken {
231 
232   mapping (address => mapping (address => uint256)) internal allowed;
233 
234 
235   /**
236    * @dev Transfer tokens from one address to another
237    * @param _from address The address which you want to send tokens from
238    * @param _to address The address which you want to transfer to
239    * @param _value uint256 the amount of tokens to be transferred
240    */
241   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
242     require(_to != address(0));
243     require(_value <= balances[_from]);
244     require(_value <= allowed[_from][msg.sender]);
245 
246     balances[_from] = balances[_from].sub(_value);
247     balances[_to] = balances[_to].add(_value);
248     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
249     Transfer(_from, _to, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255    *
256    * Beware that changing an allowance with this method brings the risk that someone may use both the old
257    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender The address which will spend the funds.
261    * @param _value The amount of tokens to be spent.
262    */
263   function approve(address _spender, uint256 _value) public returns (bool) {
264     allowed[msg.sender][_spender] = _value;
265     Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Function to check the amount of tokens that an owner allowed to a spender.
271    * @param _owner address The address which owns the funds.
272    * @param _spender address The address which will spend the funds.
273    * @return A uint256 specifying the amount of tokens still available for the spender.
274    */
275   function allowance(address _owner, address _spender) public view returns (uint256) {
276     return allowed[_owner][_spender];
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    *
282    * approve should be called when allowed[_spender] == 0. To increment
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _addedValue The amount of tokens to increase the allowance by.
288    */
289   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
290     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
291     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295   /**
296    * @dev Decrease the amount of tokens that an owner allowed to a spender.
297    *
298    * approve should be called when allowed[_spender] == 0. To decrement
299    * allowed value is better to use this function to avoid 2 calls (and wait until
300    * the first transaction is mined)
301    * From MonolithDAO Token.sol
302    * @param _spender The address which will spend the funds.
303    * @param _subtractedValue The amount of tokens to decrease the allowance by.
304    */
305   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
306     uint oldValue = allowed[msg.sender][_spender];
307     if (_subtractedValue > oldValue) {
308       allowed[msg.sender][_spender] = 0;
309     } else {
310       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
311     }
312     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316 }
317 
318 contract PausableToken is StandardToken, Pausable {
319 
320   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
321     return super.transfer(_to, _value);
322   }
323 
324   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
325     return super.transferFrom(_from, _to, _value);
326   }
327 
328   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
329     return super.approve(_spender, _value);
330   }
331 
332   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
333     return super.increaseApproval(_spender, _addedValue);
334   }
335 
336   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
337     return super.decreaseApproval(_spender, _subtractedValue);
338   }
339 }
340 
341 contract MintableToken is StandardToken, Ownable {
342   event Mint(address indexed to, uint256 amount);
343   event MintFinished();
344 
345   bool public mintingFinished = false;
346 
347 
348   modifier canMint() {
349     require(!mintingFinished);
350     _;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     Mint(_to, _amount);
363     Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() onlyOwner canMint public returns (bool) {
372     mintingFinished = true;
373     MintFinished();
374     return true;
375   }
376 }
377 
378 contract ERC865Token is ERC865, StandardToken {
379 
380     /* Nonces of transfers performed */
381     mapping(bytes => bool) signatures;
382 
383     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
384     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
385 
386     /**
387      * @notice Submit a presigned transfer
388      * @param _signature bytes The signature, issued by the owner.
389      * @param _to address The address which you want to transfer to.
390      * @param _value uint256 The amount of tokens to be transferred.
391      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
392      * @param _nonce uint256 Presigned transaction number.
393      */
394     function transferPreSigned(
395         bytes _signature,
396         address _to,
397         uint256 _value,
398         uint256 _fee,
399         uint256 _nonce
400     )
401         public
402         returns (bool)
403     {
404         require(_to != address(0), "No address provided");
405         require(signatures[_signature] == false, "No signature");
406 
407         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
408 
409         address from = recover(hashedTx, _signature);
410         require(from != address(0), "From address is not provided");
411 
412         balances[from] = balances[from].sub(_value).sub(_fee);
413         balances[_to] = balances[_to].add(_value);
414         balances[msg.sender] = balances[msg.sender].add(_fee);
415         signatures[_signature] = true;
416 
417         emit Transfer(from, _to, _value);
418         emit Transfer(from, msg.sender, _fee);
419         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
420         return true;
421     }
422 
423     /**
424      * @notice Submit a presigned approval
425      * @param _signature bytes The signature, issued by the owner.
426      * @param _spender address The address which will spend the funds.
427      * @param _value uint256 The amount of tokens to allow.
428      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
429      * @param _nonce uint256 Presigned transaction number.
430      */
431     function approvePreSigned(
432         bytes _signature,
433         address _spender,
434         uint256 _value,
435         uint256 _fee,
436         uint256 _nonce
437     )
438         public
439         returns (bool)
440     {
441         require(_spender != address(0), "Spender is not provided");
442         require(signatures[_signature] == false, "No signature");
443 
444         bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
445         address from = recover(hashedTx, _signature);
446         require(from != address(0), "From addres is not provided");
447 
448         allowed[from][_spender] = _value;
449         balances[from] = balances[from].sub(_fee);
450         balances[msg.sender] = balances[msg.sender].add(_fee);
451         signatures[_signature] = true;
452 
453         emit Approval(from, _spender, _value);
454         emit Transfer(from, msg.sender, _fee);
455         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
456         return true;
457     }
458 
459     /**
460      * @notice Increase the amount of tokens that an owner allowed to a spender.
461      * @param _signature bytes The signature, issued by the owner.
462      * @param _spender address The address which will spend the funds.
463      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
464      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
465      * @param _nonce uint256 Presigned transaction number.
466      */
467     function increaseApprovalPreSigned(
468         bytes _signature,
469         address _spender,
470         uint256 _addedValue,
471         uint256 _fee,
472         uint256 _nonce
473     )
474         public
475         returns (bool)
476     {
477         require(_spender != address(0), "Spender address is not provided");
478         require(signatures[_signature] == false, "No Signature");
479 
480         bytes32 hashedTx = increaseApprovalPreSignedHashing(address(this), _spender, _addedValue, _fee, _nonce);
481         address from = recover(hashedTx, _signature);
482         require(from != address(0), "From address is not provided");
483 
484         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
485         balances[from] = balances[from].sub(_fee);
486         balances[msg.sender] = balances[msg.sender].add(_fee);
487         signatures[_signature] = true;
488 
489         emit Approval(from, _spender, allowed[from][_spender]);
490         emit Transfer(from, msg.sender, _fee);
491         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
492         return true;
493     }
494 
495     /**
496      * @notice Decrease the amount of tokens that an owner allowed to a spender.
497      * @param _signature bytes The signature, issued by the owner
498      * @param _spender address The address which will spend the funds.
499      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
500      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
501      * @param _nonce uint256 Presigned transaction number.
502      */
503     function decreaseApprovalPreSigned(
504         bytes _signature,
505         address _spender,
506         uint256 _subtractedValue,
507         uint256 _fee,
508         uint256 _nonce
509     )
510         public
511         returns (bool)
512     {
513         require(_spender != address(0), "Spender address is not provided");
514         require(signatures[_signature] == false, "No sognature");
515 
516         bytes32 hashedTx = decreaseApprovalPreSignedHashing(address(this), _spender, _subtractedValue, _fee, _nonce);
517         address from = recover(hashedTx, _signature);
518         require(from != address(0), "From address is not provided");
519 
520         uint oldValue = allowed[from][_spender];
521         if (_subtractedValue > oldValue) {
522             allowed[from][_spender] = 0;
523         } else {
524             allowed[from][_spender] = oldValue.sub(_subtractedValue);
525         }
526         balances[from] = balances[from].sub(_fee);
527         balances[msg.sender] = balances[msg.sender].add(_fee);
528         signatures[_signature] = true;
529 
530         emit Approval(from, _spender, _subtractedValue);
531         emit Transfer(from, msg.sender, _fee);
532         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
533         return true;
534     }
535 
536     /**
537      * @notice Transfer tokens from one address to another
538      * @param _signature bytes The signature, issued by the spender.
539      * @param _from address The address which you want to send tokens from.
540      * @param _to address The address which you want to transfer to.
541      * @param _value uint256 The amount of tokens to be transferred.
542      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
543      * @param _nonce uint256 Presigned transaction number.
544      */
545     function transferFromPreSigned(
546         bytes _signature,
547         address _from,
548         address _to,
549         uint256 _value,
550         uint256 _fee,
551         uint256 _nonce
552     )
553         public
554         returns (bool)
555     {
556         require(_to != address(0), "No [to] address provided");
557         require(signatures[_signature] == false, "No signature provided");
558 
559         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
560 
561         address spender = recover(hashedTx, _signature);
562         require(spender != address(0), "Spender address is not provided");
563 
564         balances[_from] = balances[_from].sub(_value);
565         balances[_to] = balances[_to].add(_value);
566         allowed[_from][spender] = allowed[_from][spender].sub(_value);
567 
568         balances[spender] = balances[spender].sub(_fee);
569         balances[msg.sender] = balances[msg.sender].add(_fee);
570         signatures[_signature] = true;
571 
572         emit Transfer(_from, _to, _value);
573         emit Transfer(spender, msg.sender, _fee);
574         return true;
575     }
576 
577 
578     /**
579      * @notice Hash (keccak256) of the payload used by transferPreSigned
580      * @param _token address The address of the token.
581      * @param _to address The address which you want to transfer to.
582      * @param _value uint256 The amount of tokens to be transferred.
583      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
584      * @param _nonce uint256 Presigned transaction number.
585      */
586     function transferPreSignedHashing(
587         address _token,
588         address _to,
589         uint256 _value,
590         uint256 _fee,
591         uint256 _nonce
592     )
593         public
594         pure
595         returns (bytes32)
596     {
597         /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
598         return keccak256(abi.encodePacked(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce));
599     }
600 
601     /**
602      * @notice Hash (keccak256) of the payload used by approvePreSigned
603      * @param _token address The address of the token
604      * @param _spender address The address which will spend the funds.
605      * @param _value uint256 The amount of tokens to allow.
606      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
607      * @param _nonce uint256 Presigned transaction number.
608      */
609     function approvePreSignedHashing(
610         address _token,
611         address _spender,
612         uint256 _value,
613         uint256 _fee,
614         uint256 _nonce
615     )
616         public
617         pure
618         returns (bytes32)
619     {
620         /* "f7ac9c2e": approvePreSignedHashing(address,address,uint256,uint256,uint256) */
621         return keccak256(abi.encodePacked(bytes4(0xf7ac9c2e), _token, _spender, _value, _fee, _nonce));
622     }
623 
624     /**
625      * @notice Hash (keccak256) of the payload used by increaseApprovalPreSigned
626      * @param _token address The address of the token
627      * @param _spender address The address which will spend the funds.
628      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
629      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
630      * @param _nonce uint256 Presigned transaction number.
631      */
632     function increaseApprovalPreSignedHashing(
633         address _token,
634         address _spender,
635         uint256 _addedValue,
636         uint256 _fee,
637         uint256 _nonce
638     )
639         public
640         pure
641         returns (bytes32)
642     {
643         /* "a45f71ff": increaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
644         return keccak256(abi.encodePacked(bytes4(0xa45f71ff), _token, _spender, _addedValue, _fee, _nonce));
645     }
646 
647      /**
648       * @notice Hash (keccak256) of the payload used by decreaseApprovalPreSigned
649       * @param _token address The address of the token
650       * @param _spender address The address which will spend the funds.
651       * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
652       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
653       * @param _nonce uint256 Presigned transaction number.
654       */
655     function decreaseApprovalPreSignedHashing(
656         address _token,
657         address _spender,
658         uint256 _subtractedValue,
659         uint256 _fee,
660         uint256 _nonce
661     )
662         public
663         pure
664         returns (bytes32)
665     {
666         /* "59388d78": decreaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
667         return keccak256(abi.encodePacked(bytes4(0x59388d78), _token, _spender, _subtractedValue, _fee, _nonce));
668     }
669 
670     /**
671      * @notice Hash (keccak256) of the payload used by transferFromPreSigned
672      * @param _token address The address of the token
673      * @param _from address The address which you want to send tokens from.
674      * @param _to address The address which you want to transfer to.
675      * @param _value uint256 The amount of tokens to be transferred.
676      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
677      * @param _nonce uint256 Presigned transaction number.
678      */
679     function transferFromPreSignedHashing(
680         address _token,
681         address _from,
682         address _to,
683         uint256 _value,
684         uint256 _fee,
685         uint256 _nonce
686     )
687         public
688         pure
689         returns (bytes32)
690     {
691         /* "b7656dc5": transferFromPreSignedHashing(address,address,address,uint256,uint256,uint256) */
692         return keccak256(abi.encodePacked(bytes4(0xb7656dc5), _token, _from, _to, _value, _fee, _nonce));
693     }
694 
695     /**
696      * @notice Recover signer address from a message by using his signature
697      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
698      * @param sig bytes signature, the signature is generated using web3.eth.sign()
699      */
700     function recover(bytes32 hash, bytes sig) public pure returns (address) {
701         bytes32 r;
702         bytes32 s;
703         uint8 v;
704 
705         //Check the signature length
706         if (sig.length != 65) {
707             return (address(0));
708         }
709 
710         // Divide the signature in r, s and v variables
711         assembly {
712             r := mload(add(sig, 32))
713             s := mload(add(sig, 64))
714             v := byte(0, mload(add(sig, 96)))
715         }
716 
717         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
718         if (v < 27) {
719             v += 27;
720         }
721 
722         // If the version is correct return the signer address
723         if (v != 27 && v != 28) {
724             return (address(0));
725         } else {
726             return ecrecover(hash, v, r, s);
727         }
728     }
729 }
730 
731 contract KittiefightToken is ERC865Token, PausableToken, MintableToken {
732 
733     /* Set the token name for display */
734     string public constant symbol = "KTY";
735 
736     /* Set the token symbol for display */
737     string public constant name = "Kittiefight Token";
738 
739     /* Set the number of decimals for display */
740     uint8 public constant decimals = 18;
741 
742     /* 100 milion KTY specified */
743     uint256 public constant amountOfTokenToMint = 10**8 * 10**uint256(decimals);
744 
745     /* Is crowdsale filtering non registered users. false by default */
746     bool public isTransferWhitelistOnly = false;
747 
748     /* Mapping of whitelisted users */
749     mapping (address => bool) transfersWhitelist;
750 
751     event UserAllowedToTransfer(address user);
752 
753     event TransferWhitelistOnly(bool flag);
754 
755     /**
756      * @notice Is the address allowed to transfer
757      * @return true if the sender can transfer
758      */
759     function isUserAllowedToTransfer(address _user) public constant returns (bool) {
760         require(_user != 0x0);
761         return transfersWhitelist[_user];
762     }
763 
764     /**
765      * @notice Enabling / Disabling transfers of non whitelisted users
766      */
767     function setWhitelistedOnly(bool _isWhitelistOnly) onlyOwner public {
768         if (isTransferWhitelistOnly != _isWhitelistOnly) {
769             isTransferWhitelistOnly = _isWhitelistOnly;
770             TransferWhitelistOnly(_isWhitelistOnly);
771         }
772     }
773 
774     /**
775      * @notice Adding a user to the whitelist
776      */
777     function whitelistUserForTransfers(address _user) onlyOwner public {
778         require(!isUserAllowedToTransfer(_user));
779         transfersWhitelist[_user] = true;
780         UserAllowedToTransfer(_user);
781     }
782 
783     /**
784      * @notice Remove a user from the whitelist
785      */
786     function blacklistUserForTransfers(address _user) onlyOwner public {
787         require(isUserAllowedToTransfer(_user));
788         transfersWhitelist[_user] = false;
789         UserAllowedToTransfer(_user);
790     }
791 
792     /**
793     * @notice transfer token for a specified address
794     * @param _to The address to transfer to.
795     * @param _value The amount to be transferred.
796     */
797     function transfer(address _to, uint256 _value) public returns (bool) {
798       if (isTransferWhitelistOnly) {
799         require(isUserAllowedToTransfer(msg.sender));
800       }
801       return super.transfer(_to, _value);
802     }
803 
804     /**
805      * @notice Transfer tokens from one address to another
806      * @param _from address The address which you want to send tokens from
807      * @param _to address The address which you want to transfer to
808      * @param _value uint256 the amount of tokens to be transferred
809      */
810     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
811         if (isTransferWhitelistOnly) {
812             require(isUserAllowedToTransfer(_from));
813         }
814         return super.transferFrom(_from, _to, _value);
815     }
816 
817     /**
818      * @notice Submit a presigned transfer
819      * @param _signature bytes The signature, issued by the owner.
820      * @param _to address The address which you want to transfer to.
821      * @param _value uint256 The amount of tokens to be transferred.
822      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
823      * @param _nonce uint256 Presigned transaction number.
824      */
825     function transferPreSigned(
826         bytes _signature,
827         address _to,
828         uint256 _value,
829         uint256 _fee,
830         uint256 _nonce
831     )
832         whenNotPaused
833         public
834         returns (bool)
835     {
836         if (isTransferWhitelistOnly) {
837             bytes32 hashedTx = super.transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
838             address from = recover(hashedTx, _signature);
839             require(isUserAllowedToTransfer(from));
840         }
841         return super.transferPreSigned(_signature, _to, _value, _fee, _nonce);
842     }
843 
844     /**
845      * @notice Submit a presigned approval
846      * @param _signature bytes The signature, issued by the owner.
847      * @param _spender address The address which will spend the funds.
848      * @param _value uint256 The amount of tokens to allow.
849      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
850      * @param _nonce uint256 Presigned transaction number.
851      */
852     function approvePreSigned(
853         bytes _signature,
854         address _spender,
855         uint256 _value,
856         uint256 _fee,
857         uint256 _nonce
858     )
859         whenNotPaused
860         public
861         returns (bool)
862     {
863         if (isTransferWhitelistOnly) {
864             bytes32 hashedTx = super.approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
865             address from = recover(hashedTx, _signature);
866             require(isUserAllowedToTransfer(from));
867         }
868         return super.approvePreSigned(_signature, _spender, _value, _fee, _nonce);
869     }
870 }