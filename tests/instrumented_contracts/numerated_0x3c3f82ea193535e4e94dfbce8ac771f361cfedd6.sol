1 pragma solidity ^0.4.23;
2 
3 // File: contracts/helpers/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16   * @dev The Constructor sets the original owner of the contract to the
17   * sender account.
18   */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24   * @dev Throws if called by any other account other than owner.
25   */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: contracts/helpers/SafeMath.sol
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 
90 }
91 
92 // File: contracts/token/ERC20Interface.sol
93 
94 contract ERC20Interface {
95 
96   event Transfer(address indexed from, address indexed to, uint256 value);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102 
103   function approve(address spender, uint256 value) public returns (bool);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function allowance(address owner, address spender) public view returns (uint256);
106 
107 }
108 
109 // File: contracts/token/BaseToken.sol
110 
111 contract BaseToken is ERC20Interface {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115   mapping (address => mapping (address => uint256)) internal allowed;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev Obtain total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135   /**
136   * @dev Transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(msg.sender, _to, _value);
148 
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     require(_spender != address(0));
164 
165     allowed[msg.sender][_spender] = _value;
166     emit Approval(msg.sender, _spender, _value);
167 
168     return true;
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185 
186     emit Transfer(_from, _to, _value);
187 
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214 
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 // File: contracts/token/MintableToken.sol
242 
243 /**
244  * @title Mintable token
245  * @dev Simple ERC20 Token example, with mintable token creation
246  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
247  */
248 contract MintableToken is BaseToken, Ownable {
249 
250   event Mint(address indexed to, uint256 amount);
251   event MintFinished();
252 
253   bool public mintingFinished = false;
254 
255   modifier canMint() {
256     require(!mintingFinished);
257     _;
258   }
259 
260   /**
261    * @dev Function to mint tokens
262    * @param _to The address that will receive the minted tokens.
263    * @param _amount The amount of tokens to mint.
264    * @return A boolean that indicates if the operation was successful.
265    */
266   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
267     require(_to != address(0));
268 
269     totalSupply_ = totalSupply_.add(_amount);
270     balances[_to] = balances[_to].add(_amount);
271     emit Mint(_to, _amount);
272     emit Transfer(address(0), _to, _amount);
273     return true;
274   }
275 
276   /**
277    * @dev Function to stop minting new tokens.
278    * @return True if the operation was successful.
279    */
280   function finishMinting() onlyOwner canMint public returns (bool) {
281     mintingFinished = true;
282     emit MintFinished();
283     return true;
284   }
285 
286 }
287 
288 // File: contracts/token/CappedToken.sol
289 
290 contract CappedToken is MintableToken {
291 
292   uint256 public cap;
293 
294   constructor(uint256 _cap) public {
295     require(_cap > 0);
296     cap = _cap;
297   }
298 
299   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
300     require(totalSupply_.add(_amount) <= cap);
301 
302     return super.mint(_to, _amount);
303   }
304 
305 }
306 
307 // File: contracts/helpers/Pausable.sol
308 
309 /**
310  * @title Pausable
311  * @dev Base contract which allows children to implement an emergency stop mechanism.
312  */
313 contract Pausable is Ownable {
314   event Pause();
315   event Unpause();
316 
317   bool public paused = false;
318 
319   /**
320    * @dev Modifier to make a function callable only when the contract is not paused.
321    */
322   modifier whenNotPaused() {
323     require(!paused);
324     _;
325   }
326 
327   /**
328    * @dev Modifier to make a function callable only when the contract is paused.
329    */
330   modifier whenPaused() {
331     require(paused);
332     _;
333   }
334 
335   /**
336    * @dev called by the owner to pause, triggers stopped state
337    */
338   function pause() onlyOwner whenNotPaused public {
339     paused = true;
340     emit Pause();
341   }
342 
343   /**
344    * @dev called by the owner to unpause, returns to normal state
345    */
346   function unpause() onlyOwner whenPaused public {
347     paused = false;
348     emit Unpause();
349   }
350 
351 }
352 
353 // File: contracts/token/PausableToken.sol
354 
355 /**
356  * @title Pausable token
357  * @dev BaseToken modified with pausable transfers.
358  **/
359 contract PausableToken is BaseToken, Pausable {
360 
361   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
362     return super.transfer(_to, _value);
363   }
364 
365   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
366     return super.transferFrom(_from, _to, _value);
367   }
368 
369   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
370     return super.approve(_spender, _value);
371   }
372 
373   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
374     return super.increaseApproval(_spender, _addedValue);
375   }
376 
377   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
378     return super.decreaseApproval(_spender, _subtractedValue);
379   }
380 }
381 
382 // File: contracts/token/SignedTransferToken.sol
383 
384 /**
385 * @title SignedTransferToken
386 * @dev The SignedTransferToken enables collection of fees for token transfers
387 * in native token currency. User will provide a signature that allows the third
388 * party to settle the transaction in his name and collect fee for provided
389 * serivce.
390 */
391 contract SignedTransferToken is BaseToken {
392 
393   event TransferPreSigned(
394     address indexed from,
395     address indexed to,
396     address indexed settler,
397     uint256 value,
398     uint256 fee
399   );
400 
401 
402   // Mapping of already executed settlements for a given address
403   mapping(address => mapping(bytes32 => bool)) internal executedSettlements;
404 
405   /**
406   * @dev Will settle a pre-signed transfer
407   */
408   function transferPreSigned(address _from,
409                              address _to,
410                              uint256 _value,
411                              uint256 _fee,
412                              uint256 _nonce,
413                              uint8 _v,
414                              bytes32 _r,
415                              bytes32 _s) public returns (bool) {
416     uint256 total = _value.add(_fee);
417     bytes32 calcHash = calculateHash(_from, _to, _value, _fee, _nonce);
418 
419     require(_to != address(0));
420     require(isValidSignature(_from, calcHash, _v, _r, _s));
421     require(balances[_from] >= total);
422     require(!executedSettlements[_from][calcHash]);
423 
424     executedSettlements[_from][calcHash] = true;
425 
426     // Move tokens
427     balances[_from] = balances[_from].sub(_value);
428     balances[_to] = balances[_to].add(_value);
429     emit Transfer(_from, _to, _value);
430 
431     // Move fee
432     balances[_from] = balances[_from].sub(_fee);
433     balances[msg.sender] = balances[msg.sender].add(_fee);
434     emit Transfer(_from, msg.sender, _fee);
435 
436     emit TransferPreSigned(_from, _to, msg.sender, _value, _fee);
437 
438     return true;
439   }
440 
441   /**
442   * @dev Settle multiple transactions in a single call. Please note that
443   * should a single one fail the full state will be reverted. Your client
444   * implementation should always first check for balances, correct signatures
445   * and any other conditions that might result in failed transaction.
446   */
447   function transferPreSignedBulk(address[] _from,
448                                  address[] _to,
449                                  uint256[] _values,
450                                  uint256[] _fees,
451                                  uint256[] _nonces,
452                                  uint8[] _v,
453                                  bytes32[] _r,
454                                  bytes32[] _s) public returns (bool) {
455     // Make sure all the arrays are of the same length
456     require(_from.length == _to.length &&
457             _to.length ==_values.length &&
458             _values.length == _fees.length &&
459             _fees.length == _nonces.length &&
460             _nonces.length == _v.length &&
461             _v.length == _r.length &&
462             _r.length == _s.length);
463 
464     for(uint i; i < _from.length; i++) {
465       transferPreSigned(_from[i],
466                         _to[i],
467                         _values[i],
468                         _fees[i],
469                         _nonces[i],
470                         _v[i],
471                         _r[i],
472                         _s[i]);
473     }
474 
475     return true;
476   }
477 
478   /**
479   * @dev Calculates transfer hash.
480   */
481   function calculateHash(address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce) public view returns (bytes32) {
482     return keccak256(abi.encodePacked(uint256(0), address(this), _from, _to, _value, _fee, _nonce));
483   }
484 
485   /**
486   * @dev Validates the signature
487   */
488   function isValidSignature(address _signer, bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (bool) {
489     return _signer == ecrecover(
490             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)),
491             _v,
492             _r,
493             _s
494         );
495   }
496 
497   /**
498   * @dev Allows you to check whether a certain transaction has been already
499   * settled or not.
500   */
501   function isTransactionAlreadySettled(address _from, bytes32 _calcHash) public view returns (bool) {
502     return executedSettlements[_from][_calcHash];
503   }
504 
505 }
506 
507 // File: contracts/token/PausableSignedTransferToken.sol
508 
509 contract PausableSignedTransferToken is SignedTransferToken, PausableToken {
510 
511   function transferPreSigned(address _from,
512                              address _to,
513                              uint256 _value,
514                              uint256 _fee,
515                              uint256 _nonce,
516                              uint8 _v,
517                              bytes32 _r,
518                              bytes32 _s) public whenNotPaused returns (bool) {
519     return super.transferPreSigned(_from, _to, _value, _fee, _nonce, _v, _r, _s);
520   }
521 
522   function transferPreSignedBulk(address[] _from,
523                                  address[] _to,
524                                  uint256[] _values,
525                                  uint256[] _fees,
526                                  uint256[] _nonces,
527                                  uint8[] _v,
528                                  bytes32[] _r,
529                                  bytes32[] _s) public whenNotPaused returns (bool) {
530     return super.transferPreSignedBulk(_from, _to, _values, _fees, _nonces, _v, _r, _s);
531   }
532 
533 }
534 
535 // File: contracts/ElesToken.sol
536 
537 contract ElesToken is CappedToken, PausableSignedTransferToken  {
538   string public name = 'Elements Estates Token';
539   string public symbol = 'ELES';
540   uint256 public decimals = 18;
541 
542 
543   // Max supply of 250 million
544   uint256 internal maxSupply = 250000000 * 10**decimals;
545 
546   constructor()
547    CappedToken(maxSupply) public {
548       paused = true;
549   }
550 
551   // @dev Recover any mistakenly sent ERC20 tokens to the Token address
552   function recoverERC20Tokens(address _erc20, uint256 _amount) public onlyOwner {
553     ERC20Interface(_erc20).transfer(msg.sender, _amount);
554   }
555 
556 }