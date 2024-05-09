1 pragma solidity ^0.4.13;
2 
3 library ECRecovery {
4 
5   /**
6    * @dev Recover signer address from a message by using their signature
7    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
8    * @param sig bytes signature, the signature is generated using web3.eth.sign()
9    */
10   function recover(bytes32 hash, bytes sig)
11     internal
12     pure
13     returns (address)
14   {
15     bytes32 r;
16     bytes32 s;
17     uint8 v;
18 
19     // Check the signature length
20     if (sig.length != 65) {
21       return (address(0));
22     }
23 
24     // Divide the signature in r, s and v variables
25     // ecrecover takes the signature parameters, and the only way to get them
26     // currently is to use assembly.
27     // solium-disable-next-line security/no-inline-assembly
28     assembly {
29       r := mload(add(sig, 32))
30       s := mload(add(sig, 64))
31       v := byte(0, mload(add(sig, 96)))
32     }
33 
34     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
35     if (v < 27) {
36       v += 27;
37     }
38 
39     // If the version is correct return the signer address
40     if (v != 27 && v != 28) {
41       return (address(0));
42     } else {
43       // solium-disable-next-line arg-overflow
44       return ecrecover(hash, v, r, s);
45     }
46   }
47 
48   /**
49    * toEthSignedMessageHash
50    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
51    * and hash the result
52    */
53   function toEthSignedMessageHash(bytes32 hash)
54     internal
55     pure
56     returns (bytes32)
57   {
58     // 32 is the length in bytes of hash,
59     // enforced by the type signature above
60     return keccak256(
61       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
62     );
63   }
64 }
65 
66 contract ERC20Basic {
67   function totalSupply() public view returns (uint256);
68   function balanceOf(address who) public view returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev Total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev Transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     emit Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 library SafeMath {
129 
130   /**
131   * @dev Multiplies two numbers, throws on overflow.
132   */
133   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
134     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
135     // benefit is lost if 'b' is also tested.
136     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137     if (a == 0) {
138       return 0;
139     }
140 
141     c = a * b;
142     assert(c / a == b);
143     return c;
144   }
145 
146   /**
147   * @dev Integer division of two numbers, truncating the quotient.
148   */
149   function div(uint256 a, uint256 b) internal pure returns (uint256) {
150     // assert(b > 0); // Solidity automatically throws when dividing by 0
151     // uint256 c = a / b;
152     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153     return a / b;
154   }
155 
156   /**
157   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
158   */
159   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160     assert(b <= a);
161     return a - b;
162   }
163 
164   /**
165   * @dev Adds two numbers, throws on overflow.
166   */
167   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
168     c = a + b;
169     assert(c >= a);
170     return c;
171   }
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175     using SafeMath for uint256;
176 
177     mapping (address => mapping (address => uint256)) internal allowed;
178 
179     /**
180     * @dev Transfer tokens from one address to another
181     * @param _from address The address which you want to send tokens from
182     * @param _to address The address which you want to transfer to
183     * @param _value uint256 the amount of tokens to be transferred
184     */
185     function transferFrom(
186         address _from,
187         address _to,
188         uint256 _value
189     )
190         public
191         returns (bool)
192     {
193         require(_to != address(0));
194         require(_value <= balances[_from]);
195         require(_value <= allowed[_from][msg.sender]);
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200         emit Transfer(_from, _to, _value);
201         return true;
202     }
203 
204     /**
205     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206     * Beware that changing an allowance with this method brings the risk that someone may use both the old
207     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210     * @param _spender The address which will spend the funds.
211     * @param _value The amount of tokens to be spent.
212     */
213     function approve(address _spender, uint256 _value) public returns (bool) {
214         allowed[msg.sender][_spender] = _value;
215         emit Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     /**
220     * @dev Function to check the amount of tokens that an owner allowed to a spender.
221     * @param _owner address The address which owns the funds.
222     * @param _spender address The address which will spend the funds.
223     * @return A uint256 specifying the amount of tokens still available for the spender.
224     */
225     function allowance(
226         address _owner,
227         address _spender
228     )
229         public
230         view
231         returns (uint256)
232     {
233         return allowed[_owner][_spender];
234     }
235 
236     /**
237     * @dev Increase the amount of tokens that an owner allowed to a spender.
238     * approve should be called when allowed[_spender] == 0. To increment
239     * allowed value is better to use this function to avoid 2 calls (and wait until
240     * the first transaction is mined)
241     * From MonolithDAO Token.sol
242     * @param _spender The address which will spend the funds.
243     * @param _addedValue The amount of tokens to increase the allowance by.
244     */
245     function increaseApproval(
246         address _spender,
247         uint256 _addedValue
248     )
249         public
250         returns (bool)
251     {
252         allowed[msg.sender][_spender] = (
253         allowed[msg.sender][_spender].add(_addedValue));
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258     /**
259     * @dev Decrease the amount of tokens that an owner allowed to a spender.
260     * approve should be called when allowed[_spender] == 0. To decrement
261     * allowed value is better to use this function to avoid 2 calls (and wait until
262     * the first transaction is mined)
263     * From MonolithDAO Token.sol
264     * @param _spender The address which will spend the funds.
265     * @param _subtractedValue The amount of tokens to decrease the allowance by.
266     */
267     function decreaseApproval(
268         address _spender,
269         uint256 _subtractedValue
270     )
271         public
272         returns (bool)
273     {
274         uint256 oldValue = allowed[msg.sender][_spender];
275         if (_subtractedValue > oldValue) {
276         allowed[msg.sender][_spender] = 0;
277         } else {
278         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279         }
280         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281         return true;
282     }
283 
284 }
285 
286 contract DepositFromPrivateToken is StandardToken {
287    using SafeMath for uint256;
288 
289    PrivateToken public privateToken;
290 
291    modifier onlyPrivateToken() {
292      require(msg.sender == address(privateToken));
293      _;
294    }
295 
296    /**
297    * @dev Deposit is the function should only be called from PrivateToken
298    * When the user wants to deposit their private Token to Origin Token. They should
299    * let the Private Token invoke this function.
300    * @param _depositor address. The person who wants to deposit.
301    */
302 
303    function deposit(address _depositor, uint256 _value) public onlyPrivateToken returns(bool){
304      require(_value != 0);
305      balances[_depositor] = balances[_depositor].add(_value);
306      emit Transfer(privateToken, _depositor, _value);
307      return true;
308    }
309  }
310 
311 contract BCNTToken is DepositFromPrivateToken{
312     using SafeMath for uint256;
313 
314     string public constant name = "Bincentive Token"; // solium-disable-line uppercase
315     string public constant symbol = "BCNT"; // solium-disable-line uppercase
316     uint8 public constant decimals = 18; // solium-disable-line uppercase
317     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
318     mapping(bytes => bool) internal signatures;
319     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
320 
321     /**
322     * @notice Submit a presigned transfer
323     * @param _signature bytes The signature, issued by the owner.
324     * @param _to address The address which you want to transfer to.
325     * @param _value uint256 The amount of tokens to be transferred.
326     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
327     * @param _nonce uint256 Presigned transaction number.
328     * @param _validUntil uint256 Block number until which the presigned transaction is still valid.
329     */
330     function transferPreSigned(
331         bytes _signature,
332         address _to,
333         uint256 _value,
334         uint256 _fee,
335         uint256 _nonce,
336         uint256 _validUntil
337     )
338         public
339         returns (bool)
340     {
341         require(_to != address(0));
342         require(signatures[_signature] == false);
343         require(block.number <= _validUntil);
344 
345         bytes32 hashedTx = ECRecovery.toEthSignedMessageHash(
346           transferPreSignedHashing(address(this), _to, _value, _fee, _nonce, _validUntil)
347         );
348 
349         address from = ECRecovery.recover(hashedTx, _signature);
350 
351         balances[from] = balances[from].sub(_value).sub(_fee);
352         balances[_to] = balances[_to].add(_value);
353         balances[msg.sender] = balances[msg.sender].add(_fee);
354         signatures[_signature] = true;
355 
356         emit Transfer(from, _to, _value);
357         emit Transfer(from, msg.sender, _fee);
358         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
359         return true;
360     }
361 
362     /**
363     * @notice Hash (keccak256) of the payload used by transferPreSigned
364     * @param _token address The address of the token.
365     * @param _to address The address which you want to transfer to.
366     * @param _value uint256 The amount of tokens to be transferred.
367     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
368     * @param _nonce uint256 Presigned transaction number.
369     * @param _validUntil uint256 Block number until which the presigned transaction is still valid.
370     */
371     function transferPreSignedHashing(
372         address _token,
373         address _to,
374         uint256 _value,
375         uint256 _fee,
376         uint256 _nonce,
377         uint256 _validUntil
378     )
379         public
380         pure
381         returns (bytes32)
382     {
383         /* "0d2d1bf5": transferPreSigned(address,address,uint256,uint256,uint256,uint256) */
384         return keccak256(
385             abi.encodePacked(
386                 bytes4(0x0d2d1bf5),
387                 _token,
388                 _to,
389                 _value,
390                 _fee,
391                 _nonce,
392                 _validUntil
393             )
394         );
395     }
396 
397     /**
398     * @dev Constructor that gives _owner all of existing tokens.
399     */
400     constructor(address _admin) public {
401         totalSupply_ = INITIAL_SUPPLY;
402         privateToken = new PrivateToken(
403           _admin, "Bincentive Private Token", "BCNP", decimals, INITIAL_SUPPLY
404        );
405     }
406 }
407 
408 contract PrivateToken is StandardToken {
409     using SafeMath for uint256;
410 
411     string public name; // solium-disable-line uppercase
412     string public symbol; // solium-disable-line uppercase
413     uint8 public decimals; // solium-disable-line uppercase
414 
415     address public admin;
416     bool public isPublic;
417     uint256 public unLockTime;
418     DepositFromPrivateToken originToken;
419 
420     event StartPublicSale(uint256 unlockTime);
421     event Deposit(address indexed from, uint256 value);
422     /**
423     *  @dev check if msg.sender is allowed to deposit Origin token.
424     */
425     function isDepositAllowed() internal view{
426       // If the tokens isn't public yet all transfering are limited to origin tokens
427       require(isPublic);
428       require(msg.sender == admin || block.timestamp > unLockTime);
429     }
430 
431     /**
432     * @dev Deposit msg.sender's origin token to real token
433     */
434     function deposit(address _depositor) public returns (bool){
435       isDepositAllowed();
436       uint256 _value;
437       _value = balances[_depositor];
438       require(_value > 0);
439       balances[_depositor] = 0;
440       require(originToken.deposit(_depositor, _value));
441       emit Deposit(_depositor, _value);
442 
443       // This event is for those apps calculate balance from events rather than balanceOf
444       emit Transfer(_depositor, address(0), _value);
445     }
446 
447     /**
448     *  @dev Start Public sale and allow admin to deposit the token.
449     *  normal users could deposit their tokens after the tokens unlocked
450     */
451     function startPublicSale(uint256 _unLockTime) public onlyAdmin {
452       require(!isPublic);
453       isPublic = true;
454       unLockTime = _unLockTime;
455       emit StartPublicSale(_unLockTime);
456     }
457 
458     /**
459     *  @dev unLock the origin token and start the public sale.
460     */
461     function unLock() public onlyAdmin{
462       require(isPublic);
463       unLockTime = block.timestamp;
464     }
465 
466     modifier onlyAdmin() {
467       require(msg.sender == admin);
468       _;
469     }
470 
471     constructor(address _admin, string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{
472       originToken = DepositFromPrivateToken(msg.sender);
473       admin = _admin;
474       name = _name;
475       symbol = _symbol;
476       decimals = _decimals;
477       totalSupply_ = _totalSupply;
478       balances[admin] = _totalSupply;
479       emit Transfer(address(0), admin, _totalSupply);
480     }
481 }