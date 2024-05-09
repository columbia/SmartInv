1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev Total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev Transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 
113 
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender)
122     public view returns (uint256);
123 
124   function transferFrom(address from, address to, uint256 value)
125     public returns (bool);
126 
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(
129     address indexed owner,
130     address indexed spender,
131     uint256 value
132   );
133 }
134 
135 
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * https://github.com/ethereum/EIPs/issues/20
142  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(
156     address _from,
157     address _to,
158     uint256 _value
159   )
160     public
161     returns (bool)
162   {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     emit Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address _owner,
197     address _spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint256 _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(
238     address _spender,
239     uint256 _subtractedValue
240   )
241     public
242     returns (bool)
243   {
244     uint256 oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 
257 /**
258  * @title Lock Token
259  *
260  * Token would be locked for thirty days after ICO.  During this period
261  * new buyer could still trade their tokens.
262  */
263 
264  contract LockToken is StandardToken {
265    using SafeMath for uint256;
266 
267    bool public isPublic;
268    PrivateToken public privateToken;
269 
270    modifier onlyPrivateToken() {
271      require(msg.sender == address(privateToken));
272      _;
273    }
274 
275    /**
276    * @dev Deposit is the function should only be called from PrivateToken
277    * When the user wants to deposit their private Token to Origin Token. They should
278    * let the Private Token invoke this function.
279    * @param _depositor address. The person who wants to deposit.
280    */
281 
282    function deposit(address _depositor, uint256 _value) public onlyPrivateToken returns(bool){
283      require(_value != 0);
284      balances[_depositor] = balances[_depositor].add(_value);
285      emit Transfer(privateToken, _depositor, _value);
286      return true;
287    }
288  }
289 
290 /**
291  * @title Eliptic curve signature operations
292  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
293  * TODO Remove this library once solidity supports passing a signature to ecrecover.
294  * See https://github.com/ethereum/solidity/issues/864
295  */
296 
297 library ECRecovery {
298 
299   /**
300    * @dev Recover signer address from a message by using their signature
301    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
302    * @param sig bytes signature, the signature is generated using web3.eth.sign()
303    */
304   function recover(bytes32 hash, bytes sig)
305     internal
306     pure
307     returns (address)
308   {
309     bytes32 r;
310     bytes32 s;
311     uint8 v;
312 
313     // Check the signature length
314     if (sig.length != 65) {
315       return (address(0));
316     }
317 
318     // Divide the signature in r, s and v variables
319     // ecrecover takes the signature parameters, and the only way to get them
320     // currently is to use assembly.
321     // solium-disable-next-line security/no-inline-assembly
322     assembly {
323       r := mload(add(sig, 32))
324       s := mload(add(sig, 64))
325       v := byte(0, mload(add(sig, 96)))
326     }
327 
328     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
329     if (v < 27) {
330       v += 27;
331     }
332 
333     // If the version is correct return the signer address
334     if (v != 27 && v != 28) {
335       return (address(0));
336     } else {
337       // solium-disable-next-line arg-overflow
338       return ecrecover(hash, v, r, s);
339     }
340   }
341 
342   /**
343    * toEthSignedMessageHash
344    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
345    * and hash the result
346    */
347   function toEthSignedMessageHash(bytes32 hash)
348     internal
349     pure
350     returns (bytes32)
351   {
352     // 32 is the length in bytes of hash,
353     // enforced by the type signature above
354     return keccak256(
355       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
356     );
357   }
358 }
359 
360 contract PrivateToken is StandardToken {
361     using SafeMath for uint256;
362 
363     string public name; // solium-disable-line uppercase
364     string public symbol; // solium-disable-line uppercase
365     uint8 public decimals; // solium-disable-line uppercase
366 
367     mapping (address => bool) internal superUsers;
368 
369     address public admin;
370     bool public isPublic;
371     uint256 public unLockTime;
372     LockToken originToken;
373 
374     event StartPublicSale(uint256 unlockTime);
375     event Deposit(address indexed from, uint256 value);
376     /**
377     *  @dev check if msg.sender is allowed to deposit Origin token.
378     */
379     function isDepositAllowed() internal view{
380       // If the tokens isn't public yet all transfering are limited to origin tokens
381       require(isPublic);
382       require(msg.sender == admin || block.timestamp > unLockTime);
383     }
384 
385     /**
386     * @dev Deposit msg.sender's origin token to real token
387     */
388     function deposit(address _depositor) public returns (bool){
389       isDepositAllowed();
390       uint256 _value;
391       _value = balances[_depositor];
392       require(_value > 0);
393       balances[_depositor] = 0;
394       require(originToken.deposit(_depositor, _value));
395       emit Deposit(_depositor, _value);
396 
397       // This event is for those apps calculate balance from events rather than balanceOf
398       emit Transfer(_depositor, address(0), _value);
399     }
400 
401     /**
402     *  @dev Start Public sale and allow admin to deposit the token.
403     *  normal users could deposit their tokens after the tokens unlocked
404     */
405     function startPublicSale(uint256 _unLockTime) public onlyAdmin {
406       require(!isPublic);
407       isPublic = true;
408       unLockTime = _unLockTime;
409       emit StartPublicSale(_unLockTime);
410     }
411 
412     /**
413     *  @dev unLock the origin token and start the public sale.
414     */
415     function unLock() public onlyAdmin{
416       require(isPublic);
417       unLockTime = block.timestamp;
418     }
419 
420     modifier onlyAdmin() {
421       require(msg.sender == admin);
422       _;
423     }
424 
425     constructor(address _admin, string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{
426       originToken = LockToken(msg.sender);
427       admin = _admin;
428       name = _name;
429       symbol = _symbol;
430       decimals = _decimals;
431       totalSupply_ = _totalSupply;
432       balances[admin] = _totalSupply;
433       emit Transfer(address(0), admin, _totalSupply);
434     }
435 }
436 
437 
438 contract BCNTToken is LockToken{
439   string public constant name = "Bincentive SIT Token"; // solium-disable-line uppercase
440   string public constant symbol = "BCNT-SIT"; // solium-disable-line uppercase
441   uint8 public constant decimals = 18; // solium-disable-line uppercase
442   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
443   mapping(bytes => bool) internal signatures;
444   event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
445 
446     /**
447     * @notice Submit a presigned transfer
448     * @param _signature bytes The signature, issued by the owner.
449     * @param _to address The address which you want to transfer to.
450     * @param _value uint256 The amount of tokens to be transferred.
451     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
452     * @param _nonce uint256 Presigned transaction number.
453     * @param _validUntil uint256 Block number until which the presigned transaction is still valid.
454     */
455     function transferPreSigned(
456         bytes _signature,
457         address _to,
458         uint256 _value,
459         uint256 _fee,
460         uint256 _nonce,
461         uint256 _validUntil
462     )
463         public
464         returns (bool)
465     {
466         require(_to != address(0));
467         require(signatures[_signature] == false);
468         require(block.number <= _validUntil);
469 
470         bytes32 hashedTx = ECRecovery.toEthSignedMessageHash(transferPreSignedHashing(address(this), _to, _value, _fee, _nonce, _validUntil));
471 
472         address from = ECRecovery.recover(hashedTx, _signature);
473         require(from != address(0));
474 
475         balances[from] = balances[from].sub(_value).sub(_fee);
476         balances[_to] = balances[_to].add(_value);
477         balances[msg.sender] = balances[msg.sender].add(_fee);
478         signatures[_signature] = true;
479 
480         emit Transfer(from, _to, _value);
481         emit Transfer(from, msg.sender, _fee);
482         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
483         return true;
484     }
485 
486     /**
487     * @notice Hash (keccak256) of the payload used by transferPreSigned
488     * @param _token address The address of the token.
489     * @param _to address The address which you want to transfer to.
490     * @param _value uint256 The amount of tokens to be transferred.
491     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
492     * @param _nonce uint256 Presigned transaction number.
493     * @param _validUntil uint256 Block number until which the presigned transaction is still valid.
494     */
495     function transferPreSignedHashing(
496         address _token,
497         address _to,
498         uint256 _value,
499         uint256 _fee,
500         uint256 _nonce,
501         uint256 _validUntil
502     )
503         public
504         pure
505         returns (bytes32)
506     {
507         /* "0d2d1bf5": transferPreSigned(address,address,uint256,uint256,uint256,uint256) */
508         return keccak256(bytes4(0x0a0fb66b), _token, _to, _value, _fee, _nonce, _validUntil);
509     }
510     function transferPreSignedHashingWithPrefix(
511         address _token,
512         address _to,
513         uint256 _value,
514         uint256 _fee,
515         uint256 _nonce,
516         uint256 _validUntil
517     )
518         public
519         pure
520         returns (bytes32)
521     {
522         return ECRecovery.toEthSignedMessageHash(transferPreSignedHashing(_token, _to, _value, _fee, _nonce, _validUntil));
523     }
524 
525     /**
526     * @dev Constructor that gives _owner all of existing tokens.
527     */
528     constructor(address _admin) public {
529         totalSupply_ = INITIAL_SUPPLY;
530         privateToken = new PrivateToken(
531           _admin, "Bincentive SIT Private Token", "BCNP-SIT", decimals, INITIAL_SUPPLY
532        );
533     }
534 }