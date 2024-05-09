1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
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
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
379 
380 /**
381  * @title Burnable Token
382  * @dev Token that can be irreversibly burned (destroyed).
383  */
384 contract BurnableToken is BasicToken {
385 
386   event Burn(address indexed burner, uint256 value);
387 
388   /**
389    * @dev Burns a specific amount of tokens.
390    * @param _value The amount of token to be burned.
391    */
392   function burn(uint256 _value) public {
393     _burn(msg.sender, _value);
394   }
395 
396   function _burn(address _who, uint256 _value) internal {
397     require(_value <= balances[_who]);
398     // no need to require value <= totalSupply, since that would imply the
399     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
400 
401     balances[_who] = balances[_who].sub(_value);
402     totalSupply_ = totalSupply_.sub(_value);
403     emit Burn(_who, _value);
404     emit Transfer(_who, address(0), _value);
405   }
406 }
407 
408 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
409 
410 /**
411  * @title DetailedERC20 token
412  * @dev The decimals are only for visualization purposes.
413  * All the operations are done using the smallest and indivisible token unit,
414  * just as on Ethereum all the operations are done in wei.
415  */
416 contract DetailedERC20 is ERC20 {
417   string public name;
418   string public symbol;
419   uint8 public decimals;
420 
421   constructor(string _name, string _symbol, uint8 _decimals) public {
422     name = _name;
423     symbol = _symbol;
424     decimals = _decimals;
425   }
426 }
427 
428 // File: openzeppelin-solidity/contracts/ECRecovery.sol
429 
430 /**
431  * @title Elliptic curve signature operations
432  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
433  * TODO Remove this library once solidity supports passing a signature to ecrecover.
434  * See https://github.com/ethereum/solidity/issues/864
435  */
436 
437 library ECRecovery {
438 
439   /**
440    * @dev Recover signer address from a message by using their signature
441    * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
442    * @param _sig bytes signature, the signature is generated using web3.eth.sign()
443    */
444   function recover(bytes32 _hash, bytes _sig)
445     internal
446     pure
447     returns (address)
448   {
449     bytes32 r;
450     bytes32 s;
451     uint8 v;
452 
453     // Check the signature length
454     if (_sig.length != 65) {
455       return (address(0));
456     }
457 
458     // Divide the signature in r, s and v variables
459     // ecrecover takes the signature parameters, and the only way to get them
460     // currently is to use assembly.
461     // solium-disable-next-line security/no-inline-assembly
462     assembly {
463       r := mload(add(_sig, 32))
464       s := mload(add(_sig, 64))
465       v := byte(0, mload(add(_sig, 96)))
466     }
467 
468     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
469     if (v < 27) {
470       v += 27;
471     }
472 
473     // If the version is correct return the signer address
474     if (v != 27 && v != 28) {
475       return (address(0));
476     } else {
477       // solium-disable-next-line arg-overflow
478       return ecrecover(_hash, v, r, s);
479     }
480   }
481 
482   /**
483    * toEthSignedMessageHash
484    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
485    * and hash the result
486    */
487   function toEthSignedMessageHash(bytes32 _hash)
488     internal
489     pure
490     returns (bytes32)
491   {
492     // 32 is the length in bytes of hash,
493     // enforced by the type signature above
494     return keccak256(
495       abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
496     );
497   }
498 }
499 
500 // File: contracts/RemoteToken.sol
501 
502 contract RemoteToken is MintableToken, BurnableToken {
503     mapping(bytes32 => bool) private _spentSignature;
504 
505     modifier isUpToDate(uint256 blockNumber) {
506         require(block.number <= blockNumber, "Signature is outdated");
507         _;
508     }
509 
510     modifier spendSignature(bytes32 r) {
511         require(!_spentSignature[r], "Signature was used");
512         _spentSignature[r] = true;
513         _;
514     }
515 
516     constructor() public {
517     }
518     
519     function depositEther() public payable onlyOwner {
520     }
521 
522     function withdrawEther(uint256 value) public onlyOwner {
523         msg.sender.transfer(value);
524     }
525 
526     function mint(address /*to*/, uint256 amount) public onlyOwner returns(bool) {
527         return super.mint(this, amount);
528     }
529 
530     function burn(uint256 amount) public onlyOwner {
531         _burn(this, amount);
532     }
533 
534     function buy(
535         uint256 priceMul,
536         uint256 priceDiv,
537         uint256 blockNumber,
538         bytes32 r,
539         bytes32 s,
540         uint8 v
541     ) 
542         public
543         payable
544         spendSignature(r)
545         isUpToDate(blockNumber)
546         returns(uint256 amount)
547     {
548         bytes memory data = abi.encodePacked(this.buy.selector, msg.value, priceMul, priceDiv, blockNumber);
549         require(checkOwnerSignature(data, r, s, v), "Signature is invalid");
550         amount = msg.value.mul(priceMul).div(priceDiv);
551         require(this.transfer(msg.sender, amount), "There are no enough tokens available for buying");
552     }
553 
554     function sell(
555         uint256 amount,
556         uint256 priceMul,
557         uint256 priceDiv,
558         uint256 blockNumber,
559         bytes32 r,
560         bytes32 s,
561         uint8 v
562     ) 
563         public
564         spendSignature(r)
565         isUpToDate(blockNumber)
566         returns(uint256 value)
567     {
568         bytes memory data = abi.encodePacked(this.sell.selector, amount, priceMul, priceDiv, blockNumber);
569         require(checkOwnerSignature(data, r, s, v), "Signature is invalid");
570         require(this.transferFrom(msg.sender, this, amount), "There are not enough tokens available for selling");
571         value = amount.mul(priceMul).div(priceDiv);
572         msg.sender.transfer(value);
573     }
574 
575     function checkOwnerSignature(
576         bytes data,
577         bytes32 r,
578         bytes32 s,
579         uint8 v
580     ) public view returns(bool) {
581         require(v == 0 || v == 1 || v == 27 || v == 28, "Signature version is invalid");
582         bytes32 messageHash = keccak256(data);
583         bytes32 signedHash = ECRecovery.toEthSignedMessageHash(messageHash);
584         return owner == ecrecover(signedHash, v < 27 ? v + 27 : v, r, s);
585     }
586 }
587 
588 // File: contracts/implementation/EOSToken.sol
589 
590 contract EOSToken is RemoteToken, DetailedERC20 {
591     constructor() public DetailedERC20("EOSToken", "EOST", 18) {
592     }
593 }