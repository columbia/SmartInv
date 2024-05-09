1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
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
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
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
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
146 
147 /**
148  * @title Ownable
149  * @dev The Ownable contract has an owner address, and provides basic authorization control
150  * functions, this simplifies the implementation of "user permissions".
151  */
152 contract Ownable {
153   address public owner;
154 
155 
156   event OwnershipRenounced(address indexed previousOwner);
157   event OwnershipTransferred(
158     address indexed previousOwner,
159     address indexed newOwner
160   );
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   constructor() public {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to relinquish control of the contract.
181    */
182   function renounceOwnership() public onlyOwner {
183     emit OwnershipRenounced(owner);
184     owner = address(0);
185   }
186 
187   /**
188    * @dev Allows the current owner to transfer control of the contract to a newOwner.
189    * @param _newOwner The address to transfer ownership to.
190    */
191   function transferOwnership(address _newOwner) public onlyOwner {
192     _transferOwnership(_newOwner);
193   }
194 
195   /**
196    * @dev Transfers control of the contract to a newOwner.
197    * @param _newOwner The address to transfer ownership to.
198    */
199   function _transferOwnership(address _newOwner) internal {
200     require(_newOwner != address(0));
201     emit OwnershipTransferred(owner, _newOwner);
202     owner = _newOwner;
203   }
204 }
205 
206 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
207 
208 /**
209  * @title ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 contract ERC20 is ERC20Basic {
213   function allowance(address owner, address spender)
214     public view returns (uint256);
215 
216   function transferFrom(address from, address to, uint256 value)
217     public returns (bool);
218 
219   function approve(address spender, uint256 value) public returns (bool);
220   event Approval(
221     address indexed owner,
222     address indexed spender,
223     uint256 value
224   );
225 }
226 
227 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
228 
229 /**
230  * @title Standard ERC20 token
231  *
232  * @dev Implementation of the basic standard token.
233  * @dev https://github.com/ethereum/EIPs/issues/20
234  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
235  */
236 contract StandardToken is ERC20, BasicToken {
237 
238   mapping (address => mapping (address => uint256)) internal allowed;
239 
240 
241   /**
242    * @dev Transfer tokens from one address to another
243    * @param _from address The address which you want to send tokens from
244    * @param _to address The address which you want to transfer to
245    * @param _value uint256 the amount of tokens to be transferred
246    */
247   function transferFrom(
248     address _from,
249     address _to,
250     uint256 _value
251   )
252     public
253     returns (bool)
254   {
255     require(_to != address(0));
256     require(_value <= balances[_from]);
257     require(_value <= allowed[_from][msg.sender]);
258 
259     balances[_from] = balances[_from].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262     emit Transfer(_from, _to, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
268    *
269    * Beware that changing an allowance with this method brings the risk that someone may use both the old
270    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273    * @param _spender The address which will spend the funds.
274    * @param _value The amount of tokens to be spent.
275    */
276   function approve(address _spender, uint256 _value) public returns (bool) {
277     allowed[msg.sender][_spender] = _value;
278     emit Approval(msg.sender, _spender, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Function to check the amount of tokens that an owner allowed to a spender.
284    * @param _owner address The address which owns the funds.
285    * @param _spender address The address which will spend the funds.
286    * @return A uint256 specifying the amount of tokens still available for the spender.
287    */
288   function allowance(
289     address _owner,
290     address _spender
291    )
292     public
293     view
294     returns (uint256)
295   {
296     return allowed[_owner][_spender];
297   }
298 
299   /**
300    * @dev Increase the amount of tokens that an owner allowed to a spender.
301    *
302    * approve should be called when allowed[_spender] == 0. To increment
303    * allowed value is better to use this function to avoid 2 calls (and wait until
304    * the first transaction is mined)
305    * From MonolithDAO Token.sol
306    * @param _spender The address which will spend the funds.
307    * @param _addedValue The amount of tokens to increase the allowance by.
308    */
309   function increaseApproval(
310     address _spender,
311     uint _addedValue
312   )
313     public
314     returns (bool)
315   {
316     allowed[msg.sender][_spender] = (
317       allowed[msg.sender][_spender].add(_addedValue));
318     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322   /**
323    * @dev Decrease the amount of tokens that an owner allowed to a spender.
324    *
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(
333     address _spender,
334     uint _subtractedValue
335   )
336     public
337     returns (bool)
338   {
339     uint oldValue = allowed[msg.sender][_spender];
340     if (_subtractedValue > oldValue) {
341       allowed[msg.sender][_spender] = 0;
342     } else {
343       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344     }
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349 }
350 
351 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
357  */
358 contract MintableToken is StandardToken, Ownable {
359   event Mint(address indexed to, uint256 amount);
360   event MintFinished();
361 
362   bool public mintingFinished = false;
363 
364   address public minter;
365 
366   modifier canMint() {
367     require(!mintingFinished);
368     _;
369   }
370 
371   modifier hasMintPermission() {
372     require(msg.sender == owner || msg.sender == minter);
373     _;
374   }
375 
376 
377   function setMinter(address allowedMinter) public onlyOwner returns (bool) {
378     minter = allowedMinter;
379     return true;
380   }
381   /**
382    * @dev Function to mint tokens
383    * @param _to The address that will receive the minted tokens.
384    * @param _amount The amount of tokens to mint.
385    * @return A boolean that indicates if the operation was successful.
386    */
387   function mint(
388     address _to,
389     uint256 _amount
390   )
391     hasMintPermission
392     canMint
393     public
394     returns (bool)
395   {
396     totalSupply_ = totalSupply_.add(_amount);
397     balances[_to] = balances[_to].add(_amount);
398     emit Mint(_to, _amount);
399     emit Transfer(address(0), _to, _amount);
400     return true;
401   }
402 
403   /**
404    * @dev Function to stop minting new tokens.
405    * @return True if the operation was successful.
406    */
407   function finishMinting() onlyOwner canMint public returns (bool) {
408     mintingFinished = true;
409     emit MintFinished();
410     return true;
411   }
412 }
413 
414 
415 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
416 
417 /**
418  * @title Capped token
419  * @dev Mintable token with a token cap.
420  */
421 contract CappedToken is MintableToken {
422 
423   uint256 public cap;
424 
425   constructor(uint256 _cap) public {
426     require(_cap > 0);
427     cap = _cap;
428   }
429 
430   /**
431    * @dev Function to mint tokens
432    * @param _to The address that will receive the minted tokens.
433    * @param _amount The amount of tokens to mint.
434    * @return A boolean that indicates if the operation was successful.
435    */
436   function mint(
437     address _to,
438     uint256 _amount
439   )
440     hasMintPermission
441     canMint
442     public
443     returns (bool)
444   {
445     require(totalSupply_.add(_amount) <= cap);
446 
447     return super.mint(_to, _amount);
448   }
449 
450 }
451 
452 // File: contracts/HaraToken.sol
453 
454 contract HaraToken is BurnableToken, CappedToken(1200000000 * (10 ** uint256(18))) {
455     // token details
456     string public constant name = "HaraToken";
457     string public constant symbol = "HART";
458     uint8 public constant decimals = 18;
459     
460     // initial supply of token
461     uint256 public constant INITIAL_SUPPLY = 12000 * (10 ** 5) * (10 ** uint256(decimals));
462 
463     // network hart network id from deployed contract network, as for now,
464     // 1: mainnet
465     // 2: hara network
466     uint8 public constant HART_NETWORK_ID = 1;
467     
468     uint256 public nonce;
469     mapping (uint8 => mapping(uint256 => bool)) public mintStatus;
470 
471     // event for log Burn proccess
472     event BurnLog(uint256 indexed id, address indexed burner, uint256 value, bytes32 hashDetails, string data);
473     // event for log Mint proccess
474     event MintLog(uint256 indexed id, address indexed requester, uint256 value, bool status);
475 
476     /**
477     * @dev Constructor that gives msg.sender all of existing tokens.
478     */
479     constructor() public {
480         totalSupply_ = INITIAL_SUPPLY;
481         balances[msg.sender] = INITIAL_SUPPLY;
482         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
483     }
484     /**
485     * @dev Function to burn tokens
486     * @param value The amount of tokens to burn.
487     * @param data String of description.
488     */
489     function burnToken(uint256 value, string data) public {
490         burn(value);
491         emit BurnLog(nonce, msg.sender, value, hashDetails(nonce, msg.sender, value, HART_NETWORK_ID), data);
492         nonce = nonce + 1;
493     }
494 
495     /**
496     * @dev Function to burn tokens
497     * @param value The amount of tokens to burn.
498     */
499     function burnToken(uint256 value) public {
500         burnToken(value, "");
501     }
502 
503     /**
504     * @dev Function to mint tokens
505     * @param id The unique burn ID.
506     * @param requester The address that will receive the minted tokens.
507     * @param value The amount of tokens to mint.
508     * @param hash Generated hash from burn function.
509     * @return A boolean that indicates if the operation was successful.
510     */
511     function mintToken(uint256 id, address requester, uint256 value, bytes32 hash, uint8 from) public returns(bool) {
512         require(mintStatus[from][id]==false, "id already requested for mint");
513         bytes32 hashInput = hashDetails(id, requester, value, from);
514         require(hashInput == hash, "request item are not valid");
515         bool status = mint(requester, value);
516         emit MintLog(id, requester, value, status);
517         mintStatus[from][id] = status;
518         return status;
519     }
520 
521     /**
522     * @dev Function to hash burn and mint details.
523     * @param id The unique burn ID.
524     * @param burner The address that will receive the minted tokens.
525     * @param value The amount of tokens to mint.
526     * @param hartNetworkID hart network id
527     * @return bytes32 from keccak256 hash of inputs.
528     */
529     function hashDetails(uint256 id, address burner, uint256 value, uint8 hartNetworkID) internal pure returns (bytes32) {
530         return keccak256(abi.encodePacked(id, burner, value, hartNetworkID));
531     }   
532 }