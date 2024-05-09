1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, May 2, 2019
3  (UTC) */
4 
5 pragma solidity 0.5.8;
6 //import "https://raw.githubusercontent.com/KevK0/solidity-type-casting/master/contracts/stringCasting.sol";
7 //import "https://raw.githubusercontent.com/Arachnid/solidity-stringutils/master/src/strings.sol";
8 
9 library SafeMath {
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 contract Ownable {
70   address public owner;
71 
72   event transferOwner(address indexed existingOwner, address indexed newOwner);
73 
74   constructor() public {
75     owner = msg.sender;
76   }
77 
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   function transferOwnership(address newOwner) onlyOwner public {
84     if (newOwner != address(0)) {
85       owner = newOwner;
86       emit transferOwner(msg.sender, owner);
87     }
88   }
89 }
90 
91 contract ERC20Basic {
92   function totalSupply() public view returns (uint256);
93   function balanceOf(address who) public view returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) public view returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     emit Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public view returns (uint256) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * @dev Increase the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
205     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221     uint oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue > oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 }
232 
233 contract ERC865 {
234 
235     function transferPreSigned(
236         bytes memory _signature,
237         address _to,
238         uint256 _value,
239         uint256 _fee,
240         uint256 _nonce
241     )
242         public
243         returns (bool);
244 
245     function approvePreSigned(
246         bytes memory _signature,
247         address _spender,
248         uint256 _value,
249         uint256 _fee,
250         uint256 _nonce
251     )
252         public
253         returns (bool);
254 
255     function increaseApprovalPreSigned(
256         bytes memory _signature,
257         address _spender,
258         uint256 _addedValue,
259         uint256 _fee,
260         uint256 _nonce
261     )
262         public
263         returns (bool);
264 
265     function decreaseApprovalPreSigned(
266         bytes memory _signature,
267         address _spender,
268         uint256 _subtractedValue,
269         uint256 _fee,
270         uint256 _nonce
271     )
272         public
273         returns (bool);
274 }
275 
276 contract ERC865Token is ERC865, StandardToken, Ownable {
277 
278     /* Nonces of transfers performed */
279     mapping(bytes => bool) signatures;
280     /* mapping of nonces of each user */
281     mapping (address => uint256) nonces;
282 
283     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
284     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
285 
286     bytes4 internal constant transferSig = 0x48664c16;
287     bytes4 internal constant approvalSig = 0xf7ac9c2e;
288     bytes4 internal constant increaseApprovalSig = 0xa45f71ff;
289     bytes4 internal constant decreaseApprovalSig = 0x59388d78;
290     //bytes memory vvv=0x1d915567e2b192cd7a09915020b24a7980e1705003e97b8774af4aa53d9886176fe4e09916f4d865cfbec913a36030534d9e04c9b0293346743bdcdc0020408f1b;
291 
292     //return nonce using function
293     function getNonce(address _owner) public view returns (uint256 nonce){
294       return nonces[_owner];
295     }
296 
297 
298     /**
299      * @notice Submit a presigned transfer
300      * @param _signature bytes The signature, issued by the owner.
301      * @param _to address The address which you want to transfer to.
302      * @param _value uint256 The amount of tokens to be transferred.
303      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
304      * @param _nonce uint256 Presigned transaction number.
305      */
306     function transferPreSigned(
307         bytes memory _signature,
308         address _to,
309         uint256 _value,
310         uint256 _fee,
311         uint256 _nonce
312     )
313         public
314         returns (bool)
315     {
316         require(_to != address(0));
317         require(signatures[_signature] == false);
318 
319         bytes32 hashedTx = recoverPreSignedHash(address(this), transferSig, _to, _value, _fee, _nonce);
320         address from = recover(hashedTx, _signature);
321         require(from != address(0));
322         require(_nonce == nonces[from].add(1));
323         require(_value.add(_fee) <= balances[from]);
324 
325         nonces[from] = _nonce;
326         signatures[_signature] = true;
327         balances[from] = balances[from].sub(_value).sub(_fee);
328         balances[_to] = balances[_to].add(_value);
329         balances[msg.sender] = balances[msg.sender].add(_fee);
330 
331         emit Transfer(from, _to, _value);
332         emit Transfer(from, msg.sender, _fee);
333         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
334         return true;
335     }
336 
337     /**
338      * @notice Submit a presigned approval
339      * @param _signature bytes The signature, issued by the owner.
340      * @param _spender address The address which will spend the funds.
341      * @param _value uint256 The amount of tokens to allow.
342      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
343      * @param _nonce uint256 Presigned transaction number.
344      */
345     function approvePreSigned(
346         bytes memory _signature,
347         address _spender,
348         uint256 _value,
349         uint256 _fee,
350         uint256 _nonce
351     )
352         public
353         returns (bool)
354     {
355         require(_spender != address(0));
356         require(signatures[_signature] == false);
357 
358         bytes32 hashedTx = recoverPreSignedHash(address(this), approvalSig, _spender, _value, _fee, _nonce);
359         address from = recover(hashedTx, _signature);
360         require(from != address(0));
361         require(_nonce == nonces[from].add(1));
362         require(_value.add(_fee) <= balances[from]);
363 
364         nonces[from] = _nonce;
365         signatures[_signature] = true;
366         allowed[from][_spender] =_value;
367         balances[from] = balances[from].sub(_fee);
368         balances[msg.sender] = balances[msg.sender].add(_fee);
369 
370         emit Approval(from, _spender, _value);
371         emit Transfer(from, msg.sender, _fee);
372         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
373         return true;
374     }
375 
376     /**
377      * @notice Increase the amount of tokens that an owner allowed to a spender.
378      * @param _signature bytes The signature, issued by the owner.
379      * @param _spender address The address which will spend the funds.
380      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
381      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
382      * @param _nonce uint256 Presigned transaction number.
383      */
384     function increaseApprovalPreSigned(
385         bytes memory _signature,
386         address _spender,
387         uint256 _addedValue,
388         uint256 _fee,
389         uint256 _nonce
390     )
391         public
392         returns (bool)
393     {
394         require(_spender != address(0));
395         require(signatures[_signature] == false);
396 
397 //bytes32 bb=0x59e737eebff4522155b125a11dbd8d225c1a7f047ce93747b103b197e116c224;
398 //bytes storage nbh=0x7e4362ae61ed93458b1921df843e72570c7f1e11713e6883c0b93ce95e40a1f939daf972b192cff66721f62382c3e3ad423c5d312c2c5c5ac6d00a6d187729861b;
399         bytes32 hashedTx = recoverPreSignedHash(address(this), increaseApprovalSig, _spender, _addedValue, _fee, _nonce);
400         address from = recover(hashedTx, _signature);
401         require(from != address(0));
402         require(_nonce == nonces[from].add(1));
403         require(allowed[from][_spender].add(_addedValue).add(_fee) <= balances[from]);
404         //require(_addedValue <= allowed[from][_spender]);
405 
406         nonces[from] = _nonce;
407         signatures[_signature] = true;
408         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
409         balances[from] = balances[from].sub(_fee);
410         balances[msg.sender] = balances[msg.sender].add(_fee);
411 
412         emit Approval(from, _spender, allowed[from][_spender]);
413         emit Transfer(from, msg.sender, _fee);
414         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
415         return true;
416     }
417 
418     /**
419      * @notice Decrease the amount of tokens that an owner allowed to a spender.
420      * @param _signature bytes The signature, issued by the owner
421      * @param _spender address The address which will spend the funds.
422      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
423      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
424      * @param _nonce uint256 Presigned transaction number.
425      */
426     function decreaseApprovalPreSigned(
427         bytes memory _signature,
428         address _spender,
429         uint256 _subtractedValue,
430         uint256 _fee,
431         uint256 _nonce
432     )
433         public
434         returns (bool)
435     {
436         require(_spender != address(0));
437         require(signatures[_signature] == false);
438 
439         bytes32 hashedTx = recoverPreSignedHash(address(this), decreaseApprovalSig, _spender, _subtractedValue, _fee, _nonce);
440         address from = recover(hashedTx, _signature);
441         require(from != address(0));
442         require(_nonce == nonces[from].add(1));
443         //require(_subtractedValue <= balances[from]);
444         //require(_subtractedValue <= allowed[from][_spender]);
445         //require(_subtractedValue <= allowed[from][_spender]);
446         require(_fee <= balances[from]);
447 
448         nonces[from] = _nonce;
449         signatures[_signature] = true;
450         uint oldValue = allowed[from][_spender];
451         if (_subtractedValue > oldValue) {
452             allowed[from][_spender] = 0;
453         } else {
454             allowed[from][_spender] = oldValue.sub(_subtractedValue);
455         }
456         balances[from] = balances[from].sub(_fee);
457         balances[msg.sender] = balances[msg.sender].add(_fee);
458 
459         emit Approval(from, _spender, _subtractedValue);
460         emit Transfer(from, msg.sender, _fee);
461         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
462         return true;
463     }
464 
465     /**
466      * @notice Transfer tokens from one address to another
467      * @param _signature bytes The signature, issued by the spender.
468      * @param _from address The address which you want to send tokens from.
469      * @param _to address The address which you want to transfer to.
470      * @param _value uint256 The amount of tokens to be transferred.
471      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
472      * @param _nonce uint256 Presigned transaction number.
473      */
474     /*function transferFromPreSigned(
475         bytes _signature,
476         address _from,
477         address _to,
478         uint256 _value,
479         uint256 _fee,
480         uint256 _nonce
481     )
482         public
483         returns (bool)
484     {
485         require(_to != address(0));
486         require(signatures[_signature] == false);
487         signatures[_signature] = true;
488 
489         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
490 
491         address spender = recover(hashedTx, _signature);
492         require(spender != address(0));
493         require(_value.add(_fee) <= balances[_from])?;
494 
495         balances[_from] = balances[_from].sub(_value);
496         balances[_to] = balances[_to].add(_value);
497         allowed[_from][spender] = allowed[_from][spender].sub(_value);
498 
499         balances[spender] = balances[spender].sub(_fee);
500         balances[msg.sender] = balances[msg.sender].add(_fee);
501 
502         emit Transfer(_from, _to, _value);
503         emit Transfer(spender, msg.sender, _fee);
504         return true;
505     }*/
506 
507      /**
508       * @notice Hash (keccak256) of the payload used by recoverPreSignedHash
509       * @param _token address The address of the token
510       * @param _spender address The address which will spend the funds.
511       * @param _value uint256 The amount of tokens.
512       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
513       * @param _nonce uint256 Presigned transaction number.
514       */    
515     function recoverPreSignedHash(
516         address _token,
517         bytes4 _functionSig,
518         address _spender,
519         uint256 _value,
520         uint256 _fee,
521         uint256 _nonce
522         )
523       public pure returns (bytes32)
524       {
525         //return keccak256(_token, _functionSig, _spender, _value, _fee, _nonce);
526         return keccak256(abi.encodePacked(_token, _functionSig, _spender, _value, _fee,_nonce));
527     }
528 
529     /**
530      * @notice Recover signer address from a message by using his signature
531      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
532      * @param sig bytes signature, the signature is generated using web3.eth.sign()
533      */
534     function recover(bytes32 hash, bytes memory sig) public pure returns (address) {
535       bytes32 r;
536       bytes32 s;
537       uint8 v;
538 
539       //Check the signature length
540       if (sig.length != 65) {
541         return (address(0));
542       }
543 
544       // Divide the signature in r, s and v variables
545       assembly {
546         r := mload(add(sig, 32))
547         s := mload(add(sig, 64))
548         v := byte(0, mload(add(sig, 96)))
549       }
550 
551       // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
552       if (v < 27) {
553         v += 27;
554       }
555 
556       // If the version is correct return the signer address
557       if (v != 27 && v != 28) {
558         return (address(0));
559       } else {
560         return ecrecover(hash, v, r, s);
561       }
562     }
563 
564 }
565 
566 
567 contract SampleERC865Token is ERC865Token {
568   //using strings for *;
569   using SafeMath for uint256;
570 
571   uint256 public constant _tokenSupply = 42000000;
572   string public constant name = "Gravity Cash";
573   string public constant symbol = "GVCH";
574   uint8 public constant decimals = 18;
575   uint256 public constant decimalValue = 10 ** uint256(decimals);
576   
577   bytes32 internal constant digest = 0x618e860eefb172f655b56aad9bdc5685c037efba70b9c34a8e303b19778efd2c;//=""
578   
579   uint256 public sellPrice;
580   uint256 public buyPrice;
581     
582   
583   constructor() public {
584     //require(_tokenSupply > 0);
585     totalSupply_ = _tokenSupply.mul(decimalValue);
586     balances[msg.sender] = totalSupply_;
587     owner = msg.sender;
588     emit Transfer(address(this), msg.sender, totalSupply_);
589   }
590   /*
591   function transferMul(address[] froms,
592     address[] _toes,
593     uint256[] _values,
594     uint256[] _fees) public returns (bool[]) {
595         require(msg.sender == owner);
596         
597         bool[] storage isSuccess;
598         //uint256 fee=0;
599             
600         for (uint i=0; i < _toes.length; i++) {
601         
602             if(_values[i].add(_fees[i]) <= balances[froms[i]]){
603                 balances[froms[i]] = balances[froms[i]].sub(_values[i]).sub(_fees[i]);
604                 balances[_toes[i]] = balances[_toes[i]].add(_values[i]);
605                 
606                 balances[msg.sender] = balances[msg.sender].add(_fees[i]);
607                 
608                 emit Transfer(froms[i], _toes[i], _values[i]);
609                 if(froms[i] != msg.sender){
610                 emit Transfer(froms[i], msg.sender, _fees[i]);
611                     
612                 }
613                 isSuccess.push(true);
614             }else{
615                 isSuccess.push(false);}
616         
617     }
618     //emit Transfer(msg.sender, _to, _value);
619     
620     return isSuccess;
621   }
622   */
623   /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
624     /// @param newSellPrice Price the users can sell to the contract
625     /// @param newBuyPrice Price users can buy from the contract
626     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
627         sellPrice = newSellPrice;
628         buyPrice = newBuyPrice;
629     }
630 
631     /// @notice Buy tokens from contract by sending ether
632     function buy() payable public {
633         uint amount = msg.value / buyPrice;                 // calculates the amount
634         emit Transfer(address(this), msg.sender, amount);       // makes the transfers
635     }
636 
637     /// @notice Sell `amount` tokens to contract
638     /// @param amount amount of tokens to be sold
639     function sell(uint256 amount) public {
640         address myAddress = address(this);
641         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
642         emit Transfer(msg.sender, address(this), amount);       // makes the transfers
643         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
644     }
645 /*
646   using stringcast for string;
647   function transferArray(string signs,address[] _toes,
648         uint256[] _values,
649         uint256[] _fees,
650         uint256[] _nonces) public returns (bool) {
651             require(msg.sender == owner);
652          
653             var s = signs.toSlice();
654             var delim = ".".toSlice();
655             var parts = new string[](s.count(delim) + 1);
656             for(uint i = 0; i < parts.length; i++) {
657                 parts[i] = s.split(delim).toString();
658                 
659                 bytes32 hashedTx = recoverPreSignedHash(address(this), transferSig, _toes[i], _values[i], _fees[i], _nonces[i]);
660                 address from = recover(hashedTx,parts[i].toBytes());
661                 
662                 if(_values[i].add(_fees[i]) <= balances[from]){
663                 balances[from] = balances[from].sub(_values[i]).sub(_fees[i]);
664                 balances[_toes[i]] = balances[_toes[i]].add(_values[i]);
665                 
666                 balances[msg.sender] = balances[msg.sender].add(_fees[i]);
667                 
668                 emit Transfer(from, _toes[i], _values[i]);
669                 if(_fees[i] != 0){
670                     emit Transfer(from, msg.sender, _fees[i]);
671                     
672                 }
673             }
674         }
675     return true;
676   }
677   */
678   
679     
680   function transferArray(uint8[] memory v,bytes32[] memory r,bytes32[] memory s,address[] memory _toes,
681         uint256[] memory _values,
682         uint256[] memory _fees) public returns (bool) {
683             require(msg.sender == owner);
684             uint totalFee = 0;
685          
686             for(uint i = 0; i < _toes.length; i++) {
687                 //bytes32 messageDigest = keccak256(hashes[i]);
688                 address from = ecrecover(digest, v[i], r[i], s[i]);
689                 
690                 uint256 value=_values[i];
691                 uint256 fee=_fees[i];
692                 
693                 uint fromBalance = balances[from];
694                 
695                 
696                 if(value.add(fee) <= fromBalance){
697                     address to = _toes[i];
698                     uint toBalance = balances[to];
699                     
700                     balances[from] = fromBalance.sub(value).sub(fee);
701                     balances[to] = toBalance.add(value);
702                     
703                     //balances[msg.sender] = balances[msg.sender].add(_fees[i]);
704                     
705                     emit Transfer(from, to, value);
706                    
707                     totalFee=totalFee.add(fee);
708                     
709                     if(fee != 0){
710                         
711                         emit Transfer(from, msg.sender, fee);
712                     
713                     }
714                     
715                     
716                 
717                 }
718             
719             }
720             balances[msg.sender] = balances[msg.sender].add(totalFee);
721             
722         return true;
723   }
724   
725   
726   
727   
728     function sendBatchCS(address[] calldata _recipients, uint[] calldata _values) external returns (bool) {
729             require(_recipients.length == _values.length);
730     
731             uint senderBalance = balances[msg.sender];
732             for (uint i = 0; i < _values.length; i++) {
733                 uint value = _values[i];
734                 address to = _recipients[i];
735                 require(senderBalance >= value);
736                 if(msg.sender != to){
737                     senderBalance = senderBalance - value;
738                     balances[to] += value;
739                 }
740     			emit Transfer(msg.sender, to, value);
741             }
742             balances[msg.sender] = senderBalance;
743             return true;
744     }
745   
746 }