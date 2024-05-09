1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to relinquish control of the contract.
35    * @notice Renouncing to ownership will leave the contract without an owner.
36    * It will not be possible to call the functions with the `onlyOwner`
37    * modifier anymore.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 
62   function kill() public onlyOwner {
63     selfdestruct(owner);
64   }
65 }/*
66  * Name: Full Fill TV - XTV Network Utils Contract
67  * Author: Allen Sarkisyan
68  * Copyright: 2017 Full Fill TV, Inc.
69  * Version: 1.0.0
70 */
71 
72 
73 library XTVNetworkUtils {
74   function verifyXTVSignatureAddress(bytes32 hash, bytes memory sig) internal pure returns (address) {
75     bytes32 r;
76     bytes32 s;
77     uint8 v;
78 
79     if (sig.length != 65) {
80       return (address(0));
81     }
82 
83     // solium-disable-next-line security/no-inline-assembly
84     assembly {
85       r := mload(add(sig, 32))
86       s := mload(add(sig, 64))
87       v := byte(0, mload(add(sig, 96)))
88     }
89 
90     if (v < 27) {
91       v += 27;
92     }
93 
94     if (v != 27 && v != 28) {
95       return (address(0));
96     }
97 
98     bytes32 prefixedHash = keccak256(
99       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
100     );
101 
102     // solium-disable-next-line arg-overflow
103     return ecrecover(prefixedHash, v, r, s);
104   }
105 }/*
106  * Name: Full Fill TV Contract
107  * Author: Allen Sarkisyan
108  * Copyright: 2017 Full Fill TV, Inc.
109  * Version: 1.0.0
110 */
111 
112 
113 
114 
115 contract XTVNetworkGuard {
116   mapping(address => bool) xtvNetworkEndorser;
117 
118   modifier validateSignature(
119     string memory message,
120     bytes32 verificationHash,
121     bytes memory xtvSignature
122   ) {
123     bytes32 xtvVerificationHash = keccak256(abi.encodePacked(verificationHash, message));
124 
125     require(verifyXTVSignature(xtvVerificationHash, xtvSignature));
126     _;
127   }
128 
129   function setXTVNetworkEndorser(address _addr, bool isEndorser) public;
130 
131   function verifyXTVSignature(bytes32 hash, bytes memory sig) public view returns (bool) {
132     address signerAddress = XTVNetworkUtils.verifyXTVSignatureAddress(hash, sig);
133 
134     return xtvNetworkEndorser[signerAddress];
135   }
136 }
137 /*
138  * Name: Full Fill TV - XTV Token Contract
139  * Author: Allen Sarkisyan
140  * Copyright: 2017 Full Fill TV, Inc.
141  * Version: 1.0.0
142 */
143 
144 
145 
146 
147 /**
148  * @title SafeMath
149  * @dev Math operations with safety checks that throw on error
150  */
151 library SafeMath {
152 
153   /**
154   * @dev Multiplies two numbers, throws on overflow.
155   */
156   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
157     if (a == 0) {
158       return 0;
159     }
160     c = a * b;
161     assert(c / a == b);
162     return c;
163   }
164 
165   /**
166   * @dev Integer division of two numbers, truncating the quotient.
167   */
168   function div(uint256 a, uint256 b) internal pure returns (uint256) {
169     // assert(b > 0); // Solidity automatically throws when dividing by 0
170     // uint256 c = a / b;
171     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172     return a / b;
173   }
174 
175   /**
176   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177   */
178   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   /**
184   * @dev Adds two numbers, throws on overflow.
185   */
186   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
187     c = a + b;
188     assert(c >= a);
189     return c;
190   }
191 }
192 /*
193  * Name: Full Fill TV Contract
194  * Author: Allen Sarkisyan
195  * Copyright: 2017 Full Fill TV, Inc.
196  * Version: 1.0.0
197 */
198 
199 
200 
201 
202 /*
203  * Name: Full Fill TV Contract
204  * Author: Allen Sarkisyan
205  * Copyright: 2017 Full Fill TV, Inc.
206  * Version: 1.0.0
207 */
208 
209 
210 /**
211  * @title ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/20
213  */
214 contract ERC20 {
215   bool public paused = false;
216   bool public mintingFinished = false;
217 
218   mapping(address => uint256) balances;
219   mapping(address => mapping(address => uint256)) internal allowed;
220 
221   uint256 totalSupply_;
222 
223   function totalSupply() public view returns (uint256);
224   function balanceOf(address who) public view returns (uint256);
225   function transfer(address to, uint256 value) public returns (bool);
226   function transferFrom(address from, address to, uint256 value) public returns (bool);
227   function approve(address spender, uint256 value) public returns (bool);
228   function allowance(address _owner, address spender) public view returns (uint256);
229   function increaseApproval(address spender, uint addedValue) public returns (bool);
230   function decreaseApproval(address spender, uint subtractedValue) public returns (bool);
231 
232   modifier canMint() {
233     require(!mintingFinished);
234     _;
235   }
236 
237   /**
238    * @dev Modifier to make a function callable only when the contract is not paused.
239    */
240   modifier whenNotPaused() {
241     require(!paused);
242     _;
243   }
244 
245   /**
246    * @dev Modifier to make a function callable only when the contract is paused.
247    */
248   modifier whenPaused() {
249     require(paused);
250     _;
251   }
252 
253   event Approval(address indexed owner, address indexed spender, uint256 value);
254   event Transfer(address indexed from, address indexed to, uint256 value);
255   event Buy(address indexed _recipient, uint _amount);
256   event Mint(address indexed to, uint256 amount);
257   event MintFinished();
258   event Pause();
259   event Unpause();
260 }
261 
262 contract ERC20Token is ERC20, Ownable {
263   using SafeMath for uint256;
264 
265   /** ERC20 Interface Methods */
266   /**
267   * @dev total number of tokens in existence
268   */
269   function totalSupply() public view returns (uint256) { return totalSupply_; }
270 
271   /**
272   * @dev Gets the balance of the specified address.
273   * @param _owner The address to query the the balance of.
274   * @return An uint256 representing the amount owned by the passed address.
275   */
276   function balanceOf(address _owner) public view returns (uint256) { return balances[_owner]; }
277 
278   /**
279   * @dev transfer token for a specified address
280   * @param _to The address to transfer to.
281   * @param _value The amount to be transferred.
282   */
283   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
284     require(_to != address(0));
285     require(_value <= balances[msg.sender]);
286 
287     balances[msg.sender] = balances[msg.sender].sub(_value);
288     balances[_to] = balances[_to].add(_value);
289     emit Transfer(msg.sender, _to, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Transfer tokens from one address to another
295    * @param _from address The address which you want to send tokens from
296    * @param _to address The address which you want to transfer to
297    * @param _value uint256 the amount of tokens to be transferred
298    */
299   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
300     require(_to != address(0));
301     require(_value <= balances[_from]);
302     require(_value <= allowed[_from][msg.sender]);
303 
304     balances[_from] = balances[_from].sub(_value);
305     balances[_to] = balances[_to].add(_value);
306     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
307     emit Transfer(_from, _to, _value);
308     return true;
309   }
310 
311   /**
312    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
313    *
314    * Beware that changing an allowance with this method brings the risk that someone may use both the old
315    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
316    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
317    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
318    * @param _spender The address which will spend the funds.
319    * @param _value The amount of tokens to be spent.
320    */
321   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
322     allowed[msg.sender][_spender] = _value;
323     emit Approval(msg.sender, _spender, _value);
324     return true;
325   }
326 
327   /**
328    * @dev Function to check the amount of tokens that an owner allowed to a spender.
329    * @param _owner address The address which owns the funds.
330    * @param _spender address The address which will spend the funds.
331    * @return A uint256 specifying the amount of tokens still available for the spender.
332    */
333   function allowance(address _owner, address _spender) public view returns (uint256) {
334     return allowed[_owner][_spender];
335   }
336 
337   /**
338    * @dev Increase the amount of tokens that an owner allowed to a spender.
339    *
340    * approve should be called when allowed[_spender] == 0. To increment
341    * allowed value is better to use this function to avoid 2 calls (and wait until
342    * the first transaction is mined)
343    * From MonolithDAO Token.sol
344    * @param _spender The address which will spend the funds.
345    * @param _addedValue The amount of tokens to increase the allowance by.
346    */
347   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
348     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353   /**
354    * @dev Decrease the amount of tokens that an owner allowed to a spender.
355    *
356    * approve should be called when allowed[_spender] == 0. To decrement
357    * allowed value is better to use this function to avoid 2 calls (and wait until
358    * the first transaction is mined)
359    * From MonolithDAO Token.sol
360    * @param _spender The address which will spend the funds.
361    * @param _subtractedValue The amount of tokens to decrease the allowance by.
362    */
363   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
364     uint oldValue = allowed[msg.sender][_spender];
365 
366     if (_subtractedValue > oldValue) {
367       allowed[msg.sender][_spender] = 0;
368     } else {
369       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
370     }
371  
372     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373     return true;
374   }
375 
376     /**
377    * @dev called by the owner to pause, triggers stopped state
378    */
379   function pause() onlyOwner whenNotPaused public {
380     paused = true;
381     emit Pause();
382   }
383 
384   /**
385    * @dev called by the owner to unpause, returns to normal state
386    */
387   function unpause() onlyOwner whenPaused public {
388     paused = false;
389     emit Unpause();
390   }
391 
392   /**
393    * @dev Function to mint tokens
394    * @param _to The address that will receive the minted tokens.
395    * @param _amount The amount of tokens to mint.
396    * @return A boolean that indicates if the operation was successful.
397    */
398   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
399     totalSupply_ = totalSupply_.add(_amount);
400     balances[_to] = balances[_to].add(_amount);
401     emit Mint(_to, _amount);
402     emit Transfer(address(0), _to, _amount);
403     return true;
404   }
405 
406   /**
407    * @dev Function to stop minting new tokens.
408    * @return True if the operation was successful.
409    */
410   function finishMinting() onlyOwner canMint public returns (bool) {
411     mintingFinished = true;
412     emit MintFinished();
413     return true;
414   }
415 }
416 
417 
418 
419 contract XTVToken is XTVNetworkGuard, ERC20Token {
420   using SafeMath for uint256;
421 
422   string public constant name = "XTV Network";
423   string public constant symbol = "XTV";
424   uint public constant decimals = 18;
425 
426   address public fullfillTeamAddress;
427   address public fullfillFounder;
428   address public fullfillAdvisors;
429   address public XTVNetworkContractAddress;
430 
431   bool public airdropActive;
432   uint public startTime;
433   uint public endTime;
434   uint public XTVAirDropped;
435   uint public XTVBurned;
436   mapping(address => bool) public claimed;
437   
438   uint256 private constant TOKEN_MULTIPLIER = 1000000;
439   uint256 private constant DECIMALS = 10 ** decimals;
440   uint256 public constant INITIAL_SUPPLY = 500 * TOKEN_MULTIPLIER * DECIMALS;
441   uint256 public constant EXPECTED_TOTAL_SUPPLY = 1000 * TOKEN_MULTIPLIER * DECIMALS;
442 
443   // 33%
444   uint256 public constant ALLOC_TEAM = 330 * TOKEN_MULTIPLIER * DECIMALS;
445   // 7%
446   uint256 public constant ALLOC_ADVISORS = 70 * TOKEN_MULTIPLIER * DECIMALS;
447   // 10%
448   uint256 public constant ALLOC_FOUNDER = 100 * TOKEN_MULTIPLIER * DECIMALS;
449   // 50%
450   uint256 public constant ALLOC_AIRDROP = 500 * TOKEN_MULTIPLIER * DECIMALS;
451 
452   uint256 public constant AIRDROP_CLAIM_AMMOUNT = 500 * DECIMALS;
453 
454   modifier isAirdropActive() {
455     require(airdropActive);
456     _;
457   }
458 
459   modifier canClaimTokens() {
460     uint256 remainingSupply = balances[address(0)];
461 
462     require(!claimed[msg.sender] && remainingSupply > AIRDROP_CLAIM_AMMOUNT);
463     _;
464   }
465 
466   event LogAirdropClaim(
467     address addr,
468     string token,
469     bytes32 verificationHash,
470     bytes xtvSignature
471   );
472 
473   constructor(
474     address _fullfillTeam,
475     address _fullfillFounder,
476     address _fullfillAdvisors
477   ) public {
478     owner = msg.sender;
479     fullfillTeamAddress = _fullfillTeam;
480     fullfillFounder = _fullfillFounder;
481     fullfillAdvisors = _fullfillAdvisors;
482 
483     airdropActive = true;
484     startTime = block.timestamp;
485     endTime = startTime + 365 days;
486 
487     balances[_fullfillTeam] = ALLOC_TEAM;
488     balances[_fullfillFounder] = ALLOC_FOUNDER;
489     balances[_fullfillAdvisors] = ALLOC_ADVISORS;
490 
491     balances[address(0)] = ALLOC_AIRDROP;
492 
493     totalSupply_ = INITIAL_SUPPLY;
494   }
495 
496   function setXTVNetworkEndorser(address _addr, bool isEndorser) public onlyOwner {
497     xtvNetworkEndorser[_addr] = isEndorser;
498   }
499 
500   // @dev 500 XTV Tokens per claimant
501   function claim(
502     string memory token,
503     bytes32 verificationHash,
504     bytes memory xtvSignature
505   ) 
506     public
507     isAirdropActive
508     canClaimTokens
509     validateSignature(token, verificationHash, xtvSignature)
510     returns (uint256)
511   {
512     claimed[msg.sender] = true;
513 
514     balances[address(0)] = balances[address(0)].sub(AIRDROP_CLAIM_AMMOUNT);
515     balances[msg.sender] = balances[msg.sender].add(AIRDROP_CLAIM_AMMOUNT);
516 
517     XTVAirDropped = XTVAirDropped.add(AIRDROP_CLAIM_AMMOUNT);
518     totalSupply_ = totalSupply_.add(AIRDROP_CLAIM_AMMOUNT);
519 
520     emit LogAirdropClaim(msg.sender, token, verificationHash, xtvSignature);
521 
522     return balances[msg.sender];
523   }
524 
525   // @dev Anyone can call this function
526   // @dev Locks the burned tokens at address 0x00
527   function burnTokens() public {
528     if (block.timestamp > endTime) {
529       uint256 remaining = balances[address(0)];
530 
531       airdropActive = false;
532 
533       XTVBurned = remaining;
534     }
535   }
536 
537   function setXTVNetworkContractAddress(address addr) public onlyOwner {
538     XTVNetworkContractAddress = addr;
539   }
540 
541   function setXTVTokenAirdropStatus(bool _status) public onlyOwner {
542     airdropActive = _status;
543   }
544 
545   function drain() public onlyOwner {
546     owner.transfer(address(this).balance);
547   }
548 }