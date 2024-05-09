1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   uint256 totalSupply_;
25 
26   /**
27   * @dev Total number of tokens in existence
28   */
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   /**
34   * @dev Transfer token for a specified address
35   * @param _to The address to transfer to.
36   * @param _value The amount to be transferred.
37   */
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value <= balances[msg.sender]);
41 
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     emit Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   /**
49   * @dev Gets the balance of the specified address.
50   * @param _owner The address to query the the balance of.
51   * @return An uint256 representing the amount owned by the passed address.
52   */
53   function balanceOf(address _owner) public view returns (uint256) {
54     return balances[_owner];
55   }
56 
57 }
58 
59 
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 
82 
83 
84 
85 /**
86  * @title Standard ERC20 token
87  *
88  * @dev Implementation of the basic standard token.
89  * https://github.com/ethereum/EIPs/issues/20
90  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
91  */
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) internal allowed;
95 
96 
97   /**
98    * @dev Transfer tokens from one address to another
99    * @param _from address The address which you want to send tokens from
100    * @param _to address The address which you want to transfer to
101    * @param _value uint256 the amount of tokens to be transferred
102    */
103   function transferFrom(
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     public
109     returns (bool)
110   {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * Beware that changing an allowance with this method brings the risk that someone may use both the old
125    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
126    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
127    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) public returns (bool) {
132     allowed[msg.sender][_spender] = _value;
133     emit Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(
144     address _owner,
145     address _spender
146    )
147     public
148     view
149     returns (uint256)
150   {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * @dev Increase the amount of tokens that an owner allowed to a spender.
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    * @param _spender The address which will spend the funds.
161    * @param _addedValue The amount of tokens to increase the allowance by.
162    */
163   function increaseApproval(
164     address _spender,
165     uint256 _addedValue
166   )
167     public
168     returns (bool)
169   {
170     allowed[msg.sender][_spender] = (
171       allowed[msg.sender][_spender].add(_addedValue));
172     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   /**
177    * @dev Decrease the amount of tokens that an owner allowed to a spender.
178    * approve should be called when allowed[_spender] == 0. To decrement
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _subtractedValue The amount of tokens to decrease the allowance by.
184    */
185   function decreaseApproval(
186     address _spender,
187     uint256 _subtractedValue
188   )
189     public
190     returns (bool)
191   {
192     uint256 oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202 }
203 
204 
205 
206 /**
207  * @title Lock Token
208  *
209  * Token would be locked for thirty days after ICO.  During this period
210  * new buyer could still trade their tokens.
211  */
212 
213  contract LockToken is StandardToken {
214    using SafeMath for uint256;
215 
216    bool public isPublic;
217    uint256 public unLockTime;
218    PrivateToken public privateToken;
219 
220    modifier onlyPrivateToken() {
221      require(msg.sender == address(privateToken));
222      _;
223    }
224 
225    /**
226    * @dev Deposit is the function should only be called from PrivateToken
227    * When the user wants to deposit their private Token to Origin Token. They should
228    * let the Private Token invoke this function.
229    * @param _depositor address. The person who wants to deposit.
230    */
231 
232    function deposit(address _depositor, uint256 _value) public onlyPrivateToken returns(bool){
233      require(_value != 0);
234      balances[_depositor] = balances[_depositor].add(_value);
235      emit Transfer(privateToken, _depositor, _value);
236      return true;
237    }
238 
239    constructor() public {
240      //2050/12/31 00:00:00.
241      unLockTime = 2556057600;
242    }
243  }
244 
245 contract BCNTToken is LockToken{
246   string public constant name = "Bincentive SIT Token"; // solium-disable-line uppercase
247   string public constant symbol = "BCNT-SIT"; // solium-disable-line uppercase
248   uint8 public constant decimals = 18; // solium-disable-line uppercase
249   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
250   mapping(bytes => bool) internal signatures;
251   event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
252 
253     /**
254     * @notice Submit a presigned transfer
255     * @param _signature bytes The signature, issued by the owner.
256     * @param _to address The address which you want to transfer to.
257     * @param _value uint256 The amount of tokens to be transferred.
258     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
259     * @param _nonce uint256 Presigned transaction number.
260     * @param _validUntil uint256 Block number until which the presigned transaction is still valid.
261     */
262     function transferPreSigned(
263         bytes _signature,
264         address _to,
265         uint256 _value,
266         uint256 _fee,
267         uint256 _nonce,
268         uint256 _validUntil
269     )
270         public
271         returns (bool)
272     {
273         require(_to != address(0));
274         require(signatures[_signature] == false);
275         require(block.number <= _validUntil);
276 
277         bytes32 hashedTx = ECRecovery.toEthSignedMessageHash(transferPreSignedHashing(address(this), _to, _value, _fee, _nonce, _validUntil));
278 
279         address from = ECRecovery.recover(hashedTx, _signature);
280         require(from != address(0));
281 
282         balances[from] = balances[from].sub(_value).sub(_fee);
283         balances[_to] = balances[_to].add(_value);
284         balances[msg.sender] = balances[msg.sender].add(_fee);
285         signatures[_signature] = true;
286 
287         emit Transfer(from, _to, _value);
288         emit Transfer(from, msg.sender, _fee);
289         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
290         return true;
291     }
292 
293     /**
294     * @notice Hash (keccak256) of the payload used by transferPreSigned
295     * @param _token address The address of the token.
296     * @param _to address The address which you want to transfer to.
297     * @param _value uint256 The amount of tokens to be transferred.
298     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
299     * @param _nonce uint256 Presigned transaction number.
300     * @param _validUntil uint256 Block number until which the presigned transaction is still valid.
301     */
302     function transferPreSignedHashing(
303         address _token,
304         address _to,
305         uint256 _value,
306         uint256 _fee,
307         uint256 _nonce,
308         uint256 _validUntil
309     )
310         public
311         pure
312         returns (bytes32)
313     {
314         /* "0d2d1bf5": transferPreSigned(address,address,uint256,uint256,uint256,uint256) */
315         return keccak256(bytes4(0x0a0fb66b), _token, _to, _value, _fee, _nonce, _validUntil);
316     }
317     function transferPreSignedHashingWithPrefix(
318         address _token,
319         address _to,
320         uint256 _value,
321         uint256 _fee,
322         uint256 _nonce,
323         uint256 _validUntil
324     )
325         public
326         pure
327         returns (bytes32)
328     {
329         return ECRecovery.toEthSignedMessageHash(transferPreSignedHashing(_token, _to, _value, _fee, _nonce, _validUntil));
330     }
331 
332     /**
333     * @dev Constructor that gives _owner all of existing tokens.
334     */
335     constructor(address _admin) public {
336         totalSupply_ = INITIAL_SUPPLY;
337         privateToken = new PrivateToken(
338           _admin, "Bincentive Private SIT Token", "BCNP-SIT", decimals, INITIAL_SUPPLY
339        );
340     }
341 }
342 
343 
344 /**
345  * @title DetailedERC20 token
346  * @dev The decimals are only for visualization purposes.
347  * All the operations are done using the smallest and indivisible token unit,
348  * just as on Ethereum all the operations are done in wei.
349  */
350 contract DetailedERC20 is ERC20 {
351   string public name;
352   string public symbol;
353   uint8 public decimals;
354 
355   constructor(string _name, string _symbol, uint8 _decimals) public {
356     name = _name;
357     symbol = _symbol;
358     decimals = _decimals;
359   }
360 }
361 
362 
363 /**
364  * @title Eliptic curve signature operations
365  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
366  * TODO Remove this library once solidity supports passing a signature to ecrecover.
367  * See https://github.com/ethereum/solidity/issues/864
368  */
369 
370 library ECRecovery {
371 
372   /**
373    * @dev Recover signer address from a message by using their signature
374    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
375    * @param sig bytes signature, the signature is generated using web3.eth.sign()
376    */
377   function recover(bytes32 hash, bytes sig)
378     internal
379     pure
380     returns (address)
381   {
382     bytes32 r;
383     bytes32 s;
384     uint8 v;
385 
386     // Check the signature length
387     if (sig.length != 65) {
388       return (address(0));
389     }
390 
391     // Divide the signature in r, s and v variables
392     // ecrecover takes the signature parameters, and the only way to get them
393     // currently is to use assembly.
394     // solium-disable-next-line security/no-inline-assembly
395     assembly {
396       r := mload(add(sig, 32))
397       s := mload(add(sig, 64))
398       v := byte(0, mload(add(sig, 96)))
399     }
400 
401     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
402     if (v < 27) {
403       v += 27;
404     }
405 
406     // If the version is correct return the signer address
407     if (v != 27 && v != 28) {
408       return (address(0));
409     } else {
410       // solium-disable-next-line arg-overflow
411       return ecrecover(hash, v, r, s);
412     }
413   }
414 
415   /**
416    * toEthSignedMessageHash
417    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
418    * and hash the result
419    */
420   function toEthSignedMessageHash(bytes32 hash)
421     internal
422     pure
423     returns (bytes32)
424   {
425     // 32 is the length in bytes of hash,
426     // enforced by the type signature above
427     return keccak256(
428       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
429     );
430   }
431 }
432 
433 
434 
435 /**
436  * @title SafeMath
437  * @dev Math operations with safety checks that throw on error
438  */
439 library SafeMath {
440 
441   /**
442   * @dev Multiplies two numbers, throws on overflow.
443   */
444   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
445     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
446     // benefit is lost if 'b' is also tested.
447     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
448     if (a == 0) {
449       return 0;
450     }
451 
452     c = a * b;
453     assert(c / a == b);
454     return c;
455   }
456 
457   /**
458   * @dev Integer division of two numbers, truncating the quotient.
459   */
460   function div(uint256 a, uint256 b) internal pure returns (uint256) {
461     // assert(b > 0); // Solidity automatically throws when dividing by 0
462     // uint256 c = a / b;
463     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
464     return a / b;
465   }
466 
467   /**
468   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
469   */
470   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
471     assert(b <= a);
472     return a - b;
473   }
474 
475   /**
476   * @dev Adds two numbers, throws on overflow.
477   */
478   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
479     c = a + b;
480     assert(c >= a);
481     return c;
482   }
483 }
484 
485 
486 pragma solidity ^0.4.24;
487 pragma solidity ^0.4.24;
488 
489 
490 /**
491  * @title Ownable
492  * @dev The Ownable contract has an owner address, and provides basic authorization control
493  * functions, this simplifies the implementation of "user permissions".
494  */
495 contract Ownable {
496   address public owner;
497 
498   /**
499    * @dev Throws if called by any account other than the owner.
500    */
501   modifier onlyOwner() {
502     require(msg.sender == owner);
503     _;
504   }
505 }
506 
507 
508 contract PrivateToken is StandardToken {
509     using SafeMath for uint256;
510 
511     string public name; // solium-disable-line uppercase
512     string public symbol; // solium-disable-line uppercase
513     uint8 public decimals; // solium-disable-line uppercase
514 
515     address public admin;
516     bool public isPublic;
517     uint256 public unLockTime;
518     LockToken originToken;
519 
520     event StartPublicSale(uint256);
521     event Deposit(address indexed from, uint256 value);
522     /**
523     *  @dev check if msg.sender is allowed to deposit Origin token.
524     */
525     function isDepositAllowed() internal view{
526       // If the tokens isn't public yet all transfering are limited to origin tokens
527       require(isPublic);
528       require(msg.sender == admin || block.timestamp > unLockTime);
529     }
530 
531     /**
532     * @dev Deposit msg.sender's origin token to real token
533     */
534     function deposit() public returns (bool){
535       isDepositAllowed();
536       uint256 _value;
537       _value = balances[msg.sender];
538       require(_value > 0);
539       balances[msg.sender] = 0;
540       require(originToken.deposit(msg.sender, _value));
541       emit Deposit(msg.sender, _value);
542     }
543 
544     /**
545     * @dev Deposit depositor's origin token from privateToken
546     * @param _depositor address The address of whom deposit the token.
547     */
548     function adminDeposit(address _depositor) public onlyAdmin returns (bool){
549       isDepositAllowed();
550       uint256 _value;
551       _value = balances[_depositor];
552       require(_value > 0);
553       balances[_depositor] = 0;
554       require(originToken.deposit(_depositor, _value));
555       emit Deposit(_depositor, _value);
556     }
557 
558     /**
559     *  @dev Start Public sale and allow admin to deposit the token.
560     *  normal users could deposit their tokens after the tokens unlocked
561     */
562     function startPublicSale(uint256 _unLockTime) public onlyAdmin {
563       require(!isPublic);
564       isPublic = true;
565       unLockTime = _unLockTime;
566       emit StartPublicSale(_unLockTime);
567     }
568 
569     /**
570     *  @dev unLock the origin token and start the public sale.
571     */
572     function unLock() public onlyAdmin{
573       require(isPublic);
574       unLockTime = block.timestamp;
575     }
576 
577 
578     modifier onlyAdmin() {
579       require(msg.sender == admin);
580       _;
581     }
582 
583     constructor(address _admin, string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{
584       originToken = LockToken(msg.sender);
585       admin = _admin;
586       name = _name;
587       symbol = _symbol;
588       decimals = _decimals;
589       totalSupply_ = _totalSupply;
590       balances[admin] = _totalSupply;
591       emit Transfer(address(0), admin, _totalSupply);
592     }
593 }