1 // File: SignatureUtils.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /// @title A library of utilities for (multi)signatures
6 /// @author Alexander Kern <alex@cleargraph.com>
7 /// @dev This library can be linked to another Solidity contract to expose signature manipulation functions.
8 contract SignatureUtils {
9 
10     /// @notice Converts a bytes32 to an signed message hash.
11     /// @param _msg The bytes32 message (i.e. keccak256 result) to encrypt
12     function toEthBytes32SignedMessageHash(
13         bytes32 _msg
14     )
15         pure
16         public
17         returns (bytes32 signHash)
18     {
19         signHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _msg));
20     }
21 
22     /// @notice Converts a byte array to a personal signed message hash (result of `web3.personal.sign(...)`) by concatenating its length.
23     /// @param _msg The bytes array to encrypt
24     function toEthPersonalSignedMessageHash(
25         bytes _msg
26     )
27         pure
28         public
29         returns (bytes32 signHash)
30     {
31         signHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", uintToString(_msg.length), _msg));
32     }
33 
34     /// @notice Converts a uint to its decimal string representation.
35     /// @param v The uint to convert
36     function uintToString(
37         uint v
38     )
39         pure
40         public
41         returns (string)
42     {
43         uint w = v;
44         bytes32 x;
45         if (v == 0) {
46             x = "0";
47         } else {
48             while (w > 0) {
49                 x = bytes32(uint(x) / (2 ** 8));
50                 x |= bytes32(((w % 10) + 48) * 2 ** (8 * 31));
51                 w /= 10;
52             }
53         }
54 
55         bytes memory bytesString = new bytes(32);
56         uint charCount = 0;
57         for (uint j = 0; j < 32; j++) {
58             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
59             if (char != 0) {
60                 bytesString[charCount] = char;
61                 charCount++;
62             }
63         }
64         bytes memory resultBytes = new bytes(charCount);
65         for (j = 0; j < charCount; j++) {
66             resultBytes[j] = bytesString[j];
67         }
68 
69         return string(resultBytes);
70     }
71 
72     /// @notice Extracts the r, s, and v parameters to `ecrecover(...)` from the signature at position `_pos` in a densely packed signatures bytes array.
73     /// @dev Based on [OpenZeppelin's ECRecovery](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol)
74     /// @param _signatures The signatures bytes array
75     /// @param _pos The position of the signature in the bytes array (0 indexed)
76     function parseSignature(
77         bytes _signatures,
78         uint _pos
79     )
80         pure
81         public
82         returns (uint8 v, bytes32 r, bytes32 s)
83     {
84         uint offset = _pos * 65;
85         // The signature format is a compact form of:
86         //   {bytes32 r}{bytes32 s}{uint8 v}
87         // Compact means, uint8 is not padded to 32 bytes.
88         assembly { // solium-disable-line security/no-inline-assembly
89             r := mload(add(_signatures, add(32, offset)))
90             s := mload(add(_signatures, add(64, offset)))
91             // Here we are loading the last 32 bytes, including 31 bytes
92             // of 's'. There is no 'mload8' to do this.
93             //
94             // 'byte' is not working due to the Solidity parser, so lets
95             // use the second best option, 'and'
96             v := and(mload(add(_signatures, add(65, offset))), 0xff)
97         }
98 
99         if (v < 27) v += 27;
100 
101         require(v == 27 || v == 28);
102     }
103 
104     /// @notice Counts the number of signatures in a signatures bytes array. Returns 0 if the length is invalid.
105     /// @param _signatures The signatures bytes array
106     /// @dev Signatures are 65 bytes long and are densely packed.
107     function countSignatures(
108         bytes _signatures
109     )
110         pure
111         public
112         returns (uint)
113     {
114         return _signatures.length % 65 == 0 ? _signatures.length / 65 : 0;
115     }
116 
117     /// @notice Recovers an address using a message hash and a signature in a bytes array.
118     /// @param _hash The signed message hash
119     /// @param _signatures The signatures bytes array
120     /// @param _pos The signature's position in the bytes array (0 indexed)
121     function recoverAddress(
122         bytes32 _hash,
123         bytes _signatures,
124         uint _pos
125     )
126         pure
127         public
128         returns (address)
129     {
130         uint8 v;
131         bytes32 r;
132         bytes32 s;
133         (v, r, s) = parseSignature(_signatures, _pos);
134         return ecrecover(_hash, v, r, s);
135     }
136 
137     /// @notice Recovers an array of addresses using a message hash and a signatures bytes array.
138     /// @param _hash The signed message hash
139     /// @param _signatures The signatures bytes array
140     function recoverAddresses(
141         bytes32 _hash,
142         bytes _signatures
143     )
144         pure
145         public
146         returns (address[] addresses)
147     {
148         uint8 v;
149         bytes32 r;
150         bytes32 s;
151         uint count = countSignatures(_signatures);
152         addresses = new address[](count);
153         for (uint i = 0; i < count; i++) {
154             (v, r, s) = parseSignature(_signatures, i);
155             addresses[i] = ecrecover(_hash, v, r, s);
156         }
157     }
158 
159 }
160 
161 // File: ERC20.sol
162 
163 pragma solidity ^0.4.24;
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 interface IERC20 {
170   function totalSupply() external view returns (uint256);
171 
172   function balanceOf(address who) external view returns (uint256);
173 
174   function allowance(address owner, address spender)
175     external view returns (uint256);
176 
177   function transfer(address to, uint256 value) external returns (bool);
178 
179   function approve(address spender, uint256 value)
180     external returns (bool);
181 
182   function transferFrom(address from, address to, uint256 value)
183     external returns (bool);
184 
185   event Transfer(
186     address indexed from,
187     address indexed to,
188     uint256 value
189   );
190 
191   event Approval(
192     address indexed owner,
193     address indexed spender,
194     uint256 value
195   );
196 }
197 
198 
199 /**
200  * @title SafeMath
201  * @dev Math operations with safety checks that revert on error
202  */
203 library SafeMath {
204 
205   /**
206   * @dev Multiplies two numbers, reverts on overflow.
207   */
208   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210     // benefit is lost if 'b' is also tested.
211     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
212     if (a == 0) {
213       return 0;
214     }
215 
216     uint256 c = a * b;
217     require(c / a == b);
218 
219     return c;
220   }
221 
222   /**
223   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
224   */
225   function div(uint256 a, uint256 b) internal pure returns (uint256) {
226     require(b > 0); // Solidity only automatically asserts when dividing by 0
227     uint256 c = a / b;
228     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230     return c;
231   }
232 
233   /**
234   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
235   */
236   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
237     require(b <= a);
238     uint256 c = a - b;
239 
240     return c;
241   }
242 
243   /**
244   * @dev Adds two numbers, reverts on overflow.
245   */
246   function add(uint256 a, uint256 b) internal pure returns (uint256) {
247     uint256 c = a + b;
248     require(c >= a);
249 
250     return c;
251   }
252 
253   /**
254   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
255   * reverts when dividing by zero.
256   */
257   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258     require(b != 0);
259     return a % b;
260   }
261 }
262 
263 /**
264  * @title Standard ERC20 token
265  *
266  * @dev Implementation of the basic standard token.
267  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
268  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
269  */
270 contract ERC20 is IERC20 {
271   using SafeMath for uint256;
272 
273   mapping (address => uint256) private _balances;
274 
275   mapping (address => mapping (address => uint256)) private _allowed;
276 
277   uint256 private _totalSupply;
278 
279   /**
280   * @dev Total number of tokens in existence
281   */
282   function totalSupply() public view returns (uint256) {
283     return _totalSupply;
284   }
285 
286   /**
287   * @dev Gets the balance of the specified address.
288   * @param owner The address to query the balance of.
289   * @return An uint256 representing the amount owned by the passed address.
290   */
291   function balanceOf(address owner) public view returns (uint256) {
292     return _balances[owner];
293   }
294 
295   /**
296    * @dev Function to check the amount of tokens that an owner allowed to a spender.
297    * @param owner address The address which owns the funds.
298    * @param spender address The address which will spend the funds.
299    * @return A uint256 specifying the amount of tokens still available for the spender.
300    */
301   function allowance(
302     address owner,
303     address spender
304    )
305     public
306     view
307     returns (uint256)
308   {
309     return _allowed[owner][spender];
310   }
311 
312   /**
313   * @dev Transfer token for a specified address
314   * @param to The address to transfer to.
315   * @param value The amount to be transferred.
316   */
317   function transfer(address to, uint256 value) public returns (bool) {
318     _transfer(msg.sender, to, value);
319     return true;
320   }
321 
322   /**
323    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
324    * Beware that changing an allowance with this method brings the risk that someone may use both the old
325    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
326    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
327    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
328    * @param spender The address which will spend the funds.
329    * @param value The amount of tokens to be spent.
330    */
331   function approve(address spender, uint256 value) public returns (bool) {
332     require(spender != address(0));
333 
334     _allowed[msg.sender][spender] = value;
335     emit Approval(msg.sender, spender, value);
336     return true;
337   }
338 
339   /**
340    * @dev Transfer tokens from one address to another
341    * @param from address The address which you want to send tokens from
342    * @param to address The address which you want to transfer to
343    * @param value uint256 the amount of tokens to be transferred
344    */
345   function transferFrom(
346     address from,
347     address to,
348     uint256 value
349   )
350     public
351     returns (bool)
352   {
353     require(value <= _allowed[from][msg.sender]);
354 
355     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
356     _transfer(from, to, value);
357     return true;
358   }
359 
360   /**
361    * @dev Increase the amount of tokens that an owner allowed to a spender.
362    * approve should be called when allowed_[_spender] == 0. To increment
363    * allowed value is better to use this function to avoid 2 calls (and wait until
364    * the first transaction is mined)
365    * From MonolithDAO Token.sol
366    * @param spender The address which will spend the funds.
367    * @param addedValue The amount of tokens to increase the allowance by.
368    */
369   function increaseAllowance(
370     address spender,
371     uint256 addedValue
372   )
373     public
374     returns (bool)
375   {
376     require(spender != address(0));
377 
378     _allowed[msg.sender][spender] = (
379       _allowed[msg.sender][spender].add(addedValue));
380     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
381     return true;
382   }
383 
384   /**
385    * @dev Decrease the amount of tokens that an owner allowed to a spender.
386    * approve should be called when allowed_[_spender] == 0. To decrement
387    * allowed value is better to use this function to avoid 2 calls (and wait until
388    * the first transaction is mined)
389    * From MonolithDAO Token.sol
390    * @param spender The address which will spend the funds.
391    * @param subtractedValue The amount of tokens to decrease the allowance by.
392    */
393   function decreaseAllowance(
394     address spender,
395     uint256 subtractedValue
396   )
397     public
398     returns (bool)
399   {
400     require(spender != address(0));
401 
402     _allowed[msg.sender][spender] = (
403       _allowed[msg.sender][spender].sub(subtractedValue));
404     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
405     return true;
406   }
407 
408   /**
409   * @dev Transfer token for a specified addresses
410   * @param from The address to transfer from.
411   * @param to The address to transfer to.
412   * @param value The amount to be transferred.
413   */
414   function _transfer(address from, address to, uint256 value) internal {
415     require(value <= _balances[from]);
416     require(to != address(0));
417 
418     _balances[from] = _balances[from].sub(value);
419     _balances[to] = _balances[to].add(value);
420     emit Transfer(from, to, value);
421   }
422 
423   /**
424    * @dev Internal function that mints an amount of the token and assigns it to
425    * an account. This encapsulates the modification of balances such that the
426    * proper events are emitted.
427    * @param account The account that will receive the created tokens.
428    * @param value The amount that will be created.
429    */
430   function _mint(address account, uint256 value) internal {
431     require(account != 0);
432     _totalSupply = _totalSupply.add(value);
433     _balances[account] = _balances[account].add(value);
434     emit Transfer(address(0), account, value);
435   }
436 
437   /**
438    * @dev Internal function that burns an amount of the token of a given
439    * account.
440    * @param account The account whose tokens will be burnt.
441    * @param value The amount that will be burnt.
442    */
443   function _burn(address account, uint256 value) internal {
444     require(account != 0);
445     require(value <= _balances[account]);
446 
447     _totalSupply = _totalSupply.sub(value);
448     _balances[account] = _balances[account].sub(value);
449     emit Transfer(account, address(0), value);
450   }
451 
452   /**
453    * @dev Internal function that burns an amount of the token of a given
454    * account, deducting from the sender's allowance for said account. Uses the
455    * internal burn function.
456    * @param account The account whose tokens will be burnt.
457    * @param value The amount that will be burnt.
458    */
459   function _burnFrom(address account, uint256 value) internal {
460     require(value <= _allowed[account][msg.sender]);
461 
462     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
463     // this function needs to emit an event with the updated approval.
464     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
465       value);
466     _burn(account, value);
467   }
468 }
469 // File: Bridgeable.sol
470 
471 pragma solidity ^0.4.24;
472 
473 
474 /**
475  * @title Ownable
476  * @dev The Ownable contract has an owner address, and provides basic authorization control
477  * functions, this simplifies the implementation of "user permissions".
478  */
479 contract Ownable {
480   address public owner;
481 
482   function Ownable() {
483     owner = msg.sender;
484   }
485 
486   modifier onlyOwner() {
487     if (msg.sender != owner) {
488       throw;
489     }
490     _;
491   }
492 
493   function transferOwnership(address newOwner) onlyOwner {
494     if (newOwner != address(0)) {
495       owner = newOwner;
496     }
497   }
498 }
499 
500 
501 contract Bridgeable is ERC20, SignatureUtils, Ownable {
502 	address[] public validators;
503 	address public foreignContract;
504 	mapping (bytes32 => bool) foreignTransactions;
505 
506 	event EnterBridgeEvent(address indexed from, uint256 amount);
507   event ExitBridgeEvent(address indexed sender, uint256 amount);
508   event Mint(address indexed to, uint256 amount);
509 	event Burn(address indexed burner, uint256 value);
510 
511     function addValidator(address _validator) public onlyOwner {
512         validators.push(_validator);
513     }
514 
515     function pair(address _foreignContract) public onlyOwner {
516     	foreignContract = _foreignContract;
517     }
518         
519     function enter(uint256 _amount) public {
520         emit EnterBridgeEvent(msg.sender, _amount);
521         burn(_amount);
522     }
523     
524     function exit(bytes32 _txnHash, address _foreignContract, uint256 _amount, bytes _signatures) public {
525     	require(contains(_txnHash) == false, 'Foreign transaction has already been processed');
526         bytes32 hash = toEthBytes32SignedMessageHash(entranceHash(_txnHash,_foreignContract, _amount));
527         address[] memory recovered = recoverAddresses(hash, _signatures);
528         require(verifyValidators(recovered), "Validator verification failed.");
529         require(_foreignContract == foreignContract, "Invalid contract target.");
530         mint(msg.sender, _amount);
531         foreignTransactions[_txnHash] = true;
532         emit ExitBridgeEvent(msg.sender, _amount);      
533     }
534 
535     function contains(bytes32 _txnHash) internal view returns (bool){
536         return foreignTransactions[_txnHash];
537     }
538 
539     function verifyValidators(address[] recovered) internal view returns (bool) {
540         require(recovered.length == validators.length, "Invalid number of signatures");
541         for(uint i = 0 ; i < validators.length; i++) {
542             if(validators[i] != recovered[i]) {
543                 return false;
544             }
545         }
546         return true;
547     }
548 
549     function mint( address _to, uint256 _amount )
550 	    internal returns (bool) {
551       _mint(_to, _amount);
552 	    // emit Mint(_to, _amount);
553 	    return true;
554 	  }
555 
556     /**
557     * @dev Burns a specific amount of tokens.
558     * @param _value The amount of token to be burned.
559     */
560     function burn(uint256 _value) internal {
561       _burn(msg.sender, _value);
562     }
563 	    
564     /**
565      * @notice Hash (keccak256) of the payload used by deposit
566      * @param _contractAddress the target ERC20 address
567      * @param _amount the original minter
568      */
569     function entranceHash(bytes32 txnHash, address _contractAddress, uint256 _amount) public view returns (bytes32) {
570         // "0x8177cf3c": entranceHash(bytes32, address,uint256)
571         return keccak256(abi.encode( bytes4(0x8177cf3c), msg.sender, txnHash, _contractAddress, _amount));
572     }
573 
574 }
575 // File: bECH.sol
576 
577 pragma solidity ^0.4.25;
578 
579 
580 contract BridgedEchelon is Bridgeable {
581     string public name = "Bridged Echelon"; 
582     string public symbol = "bECH";
583     uint public decimals = 18;
584 
585     constructor() public {
586         // totalSupply = INITIAL_SUPPLY / 2;
587         // balanceOf[msg.sender] = totalSupply;
588     }
589 }