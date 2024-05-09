1 pragma solidity 0.5.7;
2 //import "https://raw.githubusercontent.com/KevK0/solidity-type-casting/master/contracts/stringCasting.sol";
3 //import "https://raw.githubusercontent.com/Arachnid/solidity-stringutils/master/src/strings.sol";
4 
5 library SafeMath {
6     /**
7     * @dev Multiplies two numbers, reverts on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0);
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32         return c;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46     * @dev Adds two numbers, reverts on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
57     * reverts when dividing by zero.
58     */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 
65 contract Ownable {
66   address public owner;
67 
68   event transferOwner(address indexed existingOwner, address indexed newOwner);
69 
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   function transferOwnership(address newOwner) onlyOwner public {
80     if (newOwner != address(0)) {
81       owner = newOwner;
82       emit transferOwner(msg.sender, owner);
83     }
84   }
85 }
86 
87 contract ERC20Basic {
88   function totalSupply() public view returns (uint256);
89   function balanceOf(address who) public view returns (uint256);
90   function transfer(address to, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   uint256 totalSupply_;
107 
108   /**
109   * @dev total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160     emit Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    *
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public view returns (uint256) {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * @dev Increase the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To increment
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _addedValue The amount of tokens to increase the allowance by.
199    */
200   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   /**
207    * @dev Decrease the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To decrement
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _subtractedValue The amount of tokens to decrease the allowance by.
215    */
216   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217     uint oldValue = allowed[msg.sender][_spender];
218     if (_subtractedValue > oldValue) {
219       allowed[msg.sender][_spender] = 0;
220     } else {
221       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222     }
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227 }
228 
229 contract ERC865 {
230 
231     function transferPreSigned(
232         bytes memory _signature,
233         address _to,
234         uint256 _value,
235         uint256 _fee,
236         uint256 _nonce
237     )
238         public
239         returns (bool);
240 
241     function approvePreSigned(
242         bytes memory _signature,
243         address _spender,
244         uint256 _value,
245         uint256 _fee,
246         uint256 _nonce
247     )
248         public
249         returns (bool);
250 
251     function increaseApprovalPreSigned(
252         bytes memory _signature,
253         address _spender,
254         uint256 _addedValue,
255         uint256 _fee,
256         uint256 _nonce
257     )
258         public
259         returns (bool);
260 
261     function decreaseApprovalPreSigned(
262         bytes memory _signature,
263         address _spender,
264         uint256 _subtractedValue,
265         uint256 _fee,
266         uint256 _nonce
267     )
268         public
269         returns (bool);
270 }
271 
272 contract ERC865Token is ERC865, StandardToken, Ownable {
273 
274     /* Nonces of transfers performed */
275     mapping(bytes => bool) signatures;
276     /* mapping of nonces of each user */
277     mapping (address => uint256) nonces;
278 
279     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
280     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
281 
282     bytes4 internal constant transferSig = 0x48664c16;
283     bytes4 internal constant approvalSig = 0xf7ac9c2e;
284     bytes4 internal constant increaseApprovalSig = 0xa45f71ff;
285     bytes4 internal constant decreaseApprovalSig = 0x59388d78;
286     //bytes memory vvv=0x1d915567e2b192cd7a09915020b24a7980e1705003e97b8774af4aa53d9886176fe4e09916f4d865cfbec913a36030534d9e04c9b0293346743bdcdc0020408f1b;
287 
288     //return nonce using function
289     function getNonce(address _owner) public view returns (uint256 nonce){
290       return nonces[_owner];
291     }
292 
293 
294     /**
295      * @notice Submit a presigned transfer
296      * @param _signature bytes The signature, issued by the owner.
297      * @param _to address The address which you want to transfer to.
298      * @param _value uint256 The amount of tokens to be transferred.
299      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
300      * @param _nonce uint256 Presigned transaction number.
301      */
302     function transferPreSigned(
303         bytes memory _signature,
304         address _to,
305         uint256 _value,
306         uint256 _fee,
307         uint256 _nonce
308     )
309         public
310         returns (bool)
311     {
312         require(_to != address(0));
313         require(signatures[_signature] == false);
314 
315         bytes32 hashedTx = recoverPreSignedHash(address(this), transferSig, _to, _value, _fee, _nonce);
316         address from = recover(hashedTx, _signature);
317         require(from != address(0));
318         require(_nonce == nonces[from].add(1));
319         require(_value.add(_fee) <= balances[from]);
320 
321         nonces[from] = _nonce;
322         signatures[_signature] = true;
323         balances[from] = balances[from].sub(_value).sub(_fee);
324         balances[_to] = balances[_to].add(_value);
325         balances[msg.sender] = balances[msg.sender].add(_fee);
326 
327         emit Transfer(from, _to, _value);
328         emit Transfer(from, msg.sender, _fee);
329         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
330         return true;
331     }
332 
333     /**
334      * @notice Submit a presigned approval
335      * @param _signature bytes The signature, issued by the owner.
336      * @param _spender address The address which will spend the funds.
337      * @param _value uint256 The amount of tokens to allow.
338      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
339      * @param _nonce uint256 Presigned transaction number.
340      */
341     function approvePreSigned(
342         bytes memory _signature,
343         address _spender,
344         uint256 _value,
345         uint256 _fee,
346         uint256 _nonce
347     )
348         public
349         returns (bool)
350     {
351         require(_spender != address(0));
352         require(signatures[_signature] == false);
353 
354         bytes32 hashedTx = recoverPreSignedHash(address(this), approvalSig, _spender, _value, _fee, _nonce);
355         address from = recover(hashedTx, _signature);
356         require(from != address(0));
357         require(_nonce == nonces[from].add(1));
358         require(_value.add(_fee) <= balances[from]);
359 
360         nonces[from] = _nonce;
361         signatures[_signature] = true;
362         allowed[from][_spender] =_value;
363         balances[from] = balances[from].sub(_fee);
364         balances[msg.sender] = balances[msg.sender].add(_fee);
365 
366         emit Approval(from, _spender, _value);
367         emit Transfer(from, msg.sender, _fee);
368         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
369         return true;
370     }
371 
372     /**
373      * @notice Increase the amount of tokens that an owner allowed to a spender.
374      * @param _signature bytes The signature, issued by the owner.
375      * @param _spender address The address which will spend the funds.
376      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
377      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
378      * @param _nonce uint256 Presigned transaction number.
379      */
380     function increaseApprovalPreSigned(
381         bytes memory _signature,
382         address _spender,
383         uint256 _addedValue,
384         uint256 _fee,
385         uint256 _nonce
386     )
387         public
388         returns (bool)
389     {
390         require(_spender != address(0));
391         require(signatures[_signature] == false);
392 
393 //bytes32 bb=0x59e737eebff4522155b125a11dbd8d225c1a7f047ce93747b103b197e116c224;
394 //bytes storage nbh=0x7e4362ae61ed93458b1921df843e72570c7f1e11713e6883c0b93ce95e40a1f939daf972b192cff66721f62382c3e3ad423c5d312c2c5c5ac6d00a6d187729861b;
395         bytes32 hashedTx = recoverPreSignedHash(address(this), increaseApprovalSig, _spender, _addedValue, _fee, _nonce);
396         address from = recover(hashedTx, _signature);
397         require(from != address(0));
398         require(_nonce == nonces[from].add(1));
399         require(allowed[from][_spender].add(_addedValue).add(_fee) <= balances[from]);
400         //require(_addedValue <= allowed[from][_spender]);
401 
402         nonces[from] = _nonce;
403         signatures[_signature] = true;
404         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
405         balances[from] = balances[from].sub(_fee);
406         balances[msg.sender] = balances[msg.sender].add(_fee);
407 
408         emit Approval(from, _spender, allowed[from][_spender]);
409         emit Transfer(from, msg.sender, _fee);
410         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
411         return true;
412     }
413 
414     /**
415      * @notice Decrease the amount of tokens that an owner allowed to a spender.
416      * @param _signature bytes The signature, issued by the owner
417      * @param _spender address The address which will spend the funds.
418      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
419      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
420      * @param _nonce uint256 Presigned transaction number.
421      */
422     function decreaseApprovalPreSigned(
423         bytes memory _signature,
424         address _spender,
425         uint256 _subtractedValue,
426         uint256 _fee,
427         uint256 _nonce
428     )
429         public
430         returns (bool)
431     {
432         require(_spender != address(0));
433         require(signatures[_signature] == false);
434 
435         bytes32 hashedTx = recoverPreSignedHash(address(this), decreaseApprovalSig, _spender, _subtractedValue, _fee, _nonce);
436         address from = recover(hashedTx, _signature);
437         require(from != address(0));
438         require(_nonce == nonces[from].add(1));
439         //require(_subtractedValue <= balances[from]);
440         //require(_subtractedValue <= allowed[from][_spender]);
441         //require(_subtractedValue <= allowed[from][_spender]);
442         require(_fee <= balances[from]);
443 
444         nonces[from] = _nonce;
445         signatures[_signature] = true;
446         uint oldValue = allowed[from][_spender];
447         if (_subtractedValue > oldValue) {
448             allowed[from][_spender] = 0;
449         } else {
450             allowed[from][_spender] = oldValue.sub(_subtractedValue);
451         }
452         balances[from] = balances[from].sub(_fee);
453         balances[msg.sender] = balances[msg.sender].add(_fee);
454 
455         emit Approval(from, _spender, _subtractedValue);
456         emit Transfer(from, msg.sender, _fee);
457         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
458         return true;
459     }
460 
461     /**
462      * @notice Transfer tokens from one address to another
463      * @param _signature bytes The signature, issued by the spender.
464      * @param _from address The address which you want to send tokens from.
465      * @param _to address The address which you want to transfer to.
466      * @param _value uint256 The amount of tokens to be transferred.
467      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
468      * @param _nonce uint256 Presigned transaction number.
469      */
470     /*function transferFromPreSigned(
471         bytes _signature,
472         address _from,
473         address _to,
474         uint256 _value,
475         uint256 _fee,
476         uint256 _nonce
477     )
478         public
479         returns (bool)
480     {
481         require(_to != address(0));
482         require(signatures[_signature] == false);
483         signatures[_signature] = true;
484 
485         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
486 
487         address spender = recover(hashedTx, _signature);
488         require(spender != address(0));
489         require(_value.add(_fee) <= balances[_from])?;
490 
491         balances[_from] = balances[_from].sub(_value);
492         balances[_to] = balances[_to].add(_value);
493         allowed[_from][spender] = allowed[_from][spender].sub(_value);
494 
495         balances[spender] = balances[spender].sub(_fee);
496         balances[msg.sender] = balances[msg.sender].add(_fee);
497 
498         emit Transfer(_from, _to, _value);
499         emit Transfer(spender, msg.sender, _fee);
500         return true;
501     }*/
502 
503      /**
504       * @notice Hash (keccak256) of the payload used by recoverPreSignedHash
505       * @param _token address The address of the token
506       * @param _spender address The address which will spend the funds.
507       * @param _value uint256 The amount of tokens.
508       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
509       * @param _nonce uint256 Presigned transaction number.
510       */    
511     function recoverPreSignedHash(
512         address _token,
513         bytes4 _functionSig,
514         address _spender,
515         uint256 _value,
516         uint256 _fee,
517         uint256 _nonce
518         )
519       public pure returns (bytes32)
520       {
521         //return keccak256(_token, _functionSig, _spender, _value, _fee, _nonce);
522         return keccak256(abi.encodePacked(_token, _functionSig, _spender, _value, _fee,_nonce));
523     }
524 
525     /**
526      * @notice Recover signer address from a message by using his signature
527      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
528      * @param sig bytes signature, the signature is generated using web3.eth.sign()
529      */
530     function recover(bytes32 hash, bytes memory sig) public pure returns (address) {
531       bytes32 r;
532       bytes32 s;
533       uint8 v;
534 
535       //Check the signature length
536       if (sig.length != 65) {
537         return (address(0));
538       }
539 
540       // Divide the signature in r, s and v variables
541       assembly {
542         r := mload(add(sig, 32))
543         s := mload(add(sig, 64))
544         v := byte(0, mload(add(sig, 96)))
545       }
546 
547       // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
548       if (v < 27) {
549         v += 27;
550       }
551 
552       // If the version is correct return the signer address
553       if (v != 27 && v != 28) {
554         return (address(0));
555       } else {
556         return ecrecover(hash, v, r, s);
557       }
558     }
559 
560 }
561 
562 
563 contract SampleERC865Token is ERC865Token {
564   //using strings for *;
565   using SafeMath for uint256;
566 
567   uint256 public constant _tokenSupply = 42000000;
568   string public constant name = "GCH Token";
569   string public constant symbol = "GCH";
570   uint8 public constant decimals = 18;
571   uint256 public constant decimalValue = 10 ** uint256(decimals);
572  
573   
574   bytes32 internal constant digest = 0x618e860eefb172f655b56aad9bdc5685c037efba70b9c34a8e303b19778efd2c;//=""
575   
576   uint256 public sellPrice;
577   uint256 public buyPrice;
578     
579   
580   constructor() public {
581     //require(_tokenSupply > 0);
582     totalSupply_ = _tokenSupply.mul(decimalValue);
583     balances[msg.sender] = totalSupply_;
584     owner = msg.sender;
585     emit Transfer(address(this), msg.sender, totalSupply_);
586   }
587   /*
588   function transferMul(address[] froms,
589     address[] _toes,
590     uint256[] _values,
591     uint256[] _fees) public returns (bool[]) {
592         require(msg.sender == owner);
593         
594         bool[] storage isSuccess;
595         //uint256 fee=0;
596             
597         for (uint i=0; i < _toes.length; i++) {
598         
599             if(_values[i].add(_fees[i]) <= balances[froms[i]]){
600                 balances[froms[i]] = balances[froms[i]].sub(_values[i]).sub(_fees[i]);
601                 balances[_toes[i]] = balances[_toes[i]].add(_values[i]);
602                 
603                 balances[msg.sender] = balances[msg.sender].add(_fees[i]);
604                 
605                 emit Transfer(froms[i], _toes[i], _values[i]);
606                 if(froms[i] != msg.sender){
607                 emit Transfer(froms[i], msg.sender, _fees[i]);
608                     
609                 }
610                 isSuccess.push(true);
611             }else{
612                 isSuccess.push(false);}
613         
614     }
615     //emit Transfer(msg.sender, _to, _value);
616     
617     return isSuccess;
618   }
619   */
620   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
621     /// @param newSellPrice Price the users can sell to the contract
622     /// @param newBuyPrice Price users can buy from the contract
623     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
624         sellPrice = newSellPrice;
625         buyPrice = newBuyPrice;
626     }
627 
628     /// @notice Buy tokens from contract by sending ether
629     function buy() payable public {
630         uint amount = msg.value / buyPrice;                 // calculates the amount
631         emit Transfer(address(this), msg.sender, amount);       // makes the transfers
632     }
633 
634     /// @notice Sell `amount` tokens to contract
635     /// @param amount amount of tokens to be sold
636     function sell(uint256 amount) public {
637         address myAddress = address(this);
638         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
639         emit Transfer(msg.sender, address(this), amount);       // makes the transfers
640         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
641     }
642 /*
643   using stringcast for string;
644   function transferArray(string signs,address[] _toes,
645         uint256[] _values,
646         uint256[] _fees,
647         uint256[] _nonces) public returns (bool) {
648             require(msg.sender == owner);
649          
650             var s = signs.toSlice();
651             var delim = ".".toSlice();
652             var parts = new string[](s.count(delim) + 1);
653             for(uint i = 0; i < parts.length; i++) {
654                 parts[i] = s.split(delim).toString();
655                 
656                 bytes32 hashedTx = recoverPreSignedHash(address(this), transferSig, _toes[i], _values[i], _fees[i], _nonces[i]);
657                 address from = recover(hashedTx,parts[i].toBytes());
658                 
659                 if(_values[i].add(_fees[i]) <= balances[from]){
660                 balances[from] = balances[from].sub(_values[i]).sub(_fees[i]);
661                 balances[_toes[i]] = balances[_toes[i]].add(_values[i]);
662                 
663                 balances[msg.sender] = balances[msg.sender].add(_fees[i]);
664                 
665                 emit Transfer(from, _toes[i], _values[i]);
666                 if(_fees[i] != 0){
667                     emit Transfer(from, msg.sender, _fees[i]);
668                     
669                 }
670             }
671         }
672     return true;
673   }
674   */
675   
676     
677   function transferArray(uint8[] memory v,bytes32[] memory r,bytes32[] memory s,address[] memory _toes,
678         uint256[] memory _values,
679         uint256[] memory _fees) public returns (bool) {
680             require(msg.sender == owner);
681             uint totalFee = 0;
682          
683             for(uint i = 0; i < _toes.length; i++) {
684                 //bytes32 messageDigest = keccak256(hashes[i]);
685                 address from = ecrecover(digest, v[i], r[i], s[i]);
686                 
687                 uint256 value=_values[i];
688                 uint256 fee=_fees[i];
689                 
690                 uint fromBalance = balances[from];
691                 
692                 
693                 if(value.add(fee) <= fromBalance){
694                     address to = _toes[i];
695                     uint toBalance = balances[to];
696                     
697                     balances[from] = fromBalance.sub(value).sub(fee);
698                     balances[to] = toBalance.add(value);
699                     
700                     //balances[msg.sender] = balances[msg.sender].add(_fees[i]);
701                     
702                     emit Transfer(from, to, value);
703                    
704                     totalFee=totalFee.add(fee);
705                     
706                     if(fee != 0){
707                         
708                     emit Transfer(from, msg.sender, fee);
709                     
710                     }
711                     
712                     
713                 
714                 }
715             
716             }
717             balances[msg.sender] = balances[msg.sender].add(totalFee);
718             
719         return true;
720   }
721   
722   
723   
724   
725     function sendBatchCS(address[] calldata _recipients, uint[] calldata _values) external returns (bool) {
726             require(_recipients.length == _values.length);
727     
728             uint senderBalance = balances[msg.sender];
729             for (uint i = 0; i < _values.length; i++) {
730                 uint value = _values[i];
731                 address to = _recipients[i];
732                 require(senderBalance >= value);
733                 if(msg.sender != to){
734                     senderBalance = senderBalance - value;
735                     balances[to] += value;
736                 }
737     			emit Transfer(msg.sender, to, value);
738             }
739             balances[msg.sender] = senderBalance;
740             return true;
741     }
742   
743 }