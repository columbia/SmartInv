1 pragma solidity ^0.4.17;
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
19   function Ownable() public {
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
37     OwnershipTransferred(owner, newOwner);
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
147     Transfer(msg.sender, _to, _value);
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
166     Approval(msg.sender, _spender, _value);
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
186     Transfer(_from, _to, _value);
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
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
246  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
247  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
248  */
249 contract MintableToken is BaseToken, Ownable {
250 
251   event Mint(address indexed to, uint256 amount);
252   event MintFinished();
253 
254   bool public mintingFinished = false;
255 
256   modifier canMint() {
257     require(!mintingFinished);
258     _;
259   }
260 
261   /**
262    * @dev Function to mint tokens
263    * @param _to The address that will receive the minted tokens.
264    * @param _amount The amount of tokens to mint.
265    * @return A boolean that indicates if the operation was successful.
266    */
267   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
268     require(_to != address(0));
269 
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_to] = balances[_to].add(_amount);
272     Mint(_to, _amount);
273     Transfer(address(0), _to, _amount);
274     return true;
275   }
276 
277   /**
278    * @dev Function to stop minting new tokens.
279    * @return True if the operation was successful.
280    */
281   function finishMinting() onlyOwner canMint public returns (bool) {
282     mintingFinished = true;
283     MintFinished();
284     return true;
285   }
286 
287 }
288 
289 // File: contracts/token/CappedToken.sol
290 
291 contract CappedToken is MintableToken {
292 
293   uint256 public cap;
294 
295   function CappedToken(uint256 _cap) public {
296     require(_cap > 0);
297     cap = _cap;
298   }
299 
300   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
301     require(totalSupply_.add(_amount) <= cap);
302 
303     return super.mint(_to, _amount);
304   }
305 
306 }
307 
308 // File: contracts/helpers/Pausable.sol
309 
310 /**
311  * @title Pausable
312  * @dev Base contract which allows children to implement an emergency stop mechanism.
313  */
314 contract Pausable is Ownable {
315   event Pause();
316   event Unpause();
317 
318   bool public paused = false;
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337    * @dev called by the owner to pause, triggers stopped state
338    */
339   function pause() onlyOwner whenNotPaused public {
340     paused = true;
341     Pause();
342   }
343 
344   /**
345    * @dev called by the owner to unpause, returns to normal state
346    */
347   function unpause() onlyOwner whenPaused public {
348     paused = false;
349     Unpause();
350   }
351 
352 }
353 
354 // File: contracts/token/PausableToken.sol
355 
356 /**
357  * @title Pausable token
358  * @dev BaseToken modified with pausable transfers.
359  **/
360 contract PausableToken is BaseToken, Pausable {
361 
362   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
363     return super.transfer(_to, _value);
364   }
365 
366   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
367     return super.transferFrom(_from, _to, _value);
368   }
369 
370   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
371     return super.approve(_spender, _value);
372   }
373 
374   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
375     return super.increaseApproval(_spender, _addedValue);
376   }
377 
378   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
379     return super.decreaseApproval(_spender, _subtractedValue);
380   }
381 }
382 
383 // File: contracts/token/SignedTransferToken.sol
384 
385 /**
386 * @title SignedTransferToken
387 * @dev The SignedTransferToken enables collection of fees for token transfers
388 * in native token currency. User will provide a signature that allows the third
389 * party to settle the transaction in his name and collect fee for provided
390 * serivce.
391 */
392 contract SignedTransferToken is BaseToken {
393 
394   event TransferPreSigned(
395     address indexed from,
396     address indexed to,
397     address indexed settler,
398     uint256 value,
399     uint256 fee
400   );
401 
402   event TransferPreSignedMany(
403     address indexed from,
404     address indexed settler,
405     uint256 value,
406     uint256 fee
407   );
408 
409 
410   // Mapping of already executed settlements for a given address
411   mapping(address => mapping(bytes32 => bool)) executedSettlements;
412 
413   /**
414   * @dev Will settle a pre-signed transfer
415   */
416   function transferPreSigned(address _from,
417                              address _to,
418                              uint256 _value,
419                              uint256 _fee,
420                              uint256 _nonce,
421                              uint8 _v,
422                              bytes32 _r,
423                              bytes32 _s) public returns (bool) {
424     uint256 total = _value.add(_fee);
425     bytes32 calcHash = calculateHash(_from, _to, _value, _fee, _nonce);
426 
427     require(_to != address(0));
428     require(isValidSignature(_from, calcHash, _v, _r, _s));
429     require(balances[_from] >= total);
430     require(!executedSettlements[_from][calcHash]);
431 
432     executedSettlements[_from][calcHash] = true;
433 
434     // Move tokens
435     balances[_from] = balances[_from].sub(_value);
436     balances[_to] = balances[_to].add(_value);
437     Transfer(_from, _to, _value);
438 
439     // Move fee
440     balances[_from] = balances[_from].sub(_fee);
441     balances[msg.sender] = balances[msg.sender].add(_fee);
442     Transfer(_from, msg.sender, _fee);
443 
444     TransferPreSigned(_from, _to, msg.sender, _value, _fee);
445 
446     return true;
447   }
448 
449   /**
450   * @dev Settle multiple transactions in a single call. Please note that
451   * should a single one fail the full state will be reverted. Your client
452   * implementation should always first check for balances, correct signatures
453   * and any other conditions that might result in failed transaction.
454   */
455   function transferPreSignedBulk(address[] _from,
456                                  address[] _to,
457                                  uint256[] _values,
458                                  uint256[] _fees,
459                                  uint256[] _nonces,
460                                  uint8[] _v,
461                                  bytes32[] _r,
462                                  bytes32[] _s) public returns (bool) {
463     // Make sure all the arrays are of the same length
464     require(_from.length == _to.length &&
465             _to.length ==_values.length &&
466             _values.length == _fees.length &&
467             _fees.length == _nonces.length &&
468             _nonces.length == _v.length &&
469             _v.length == _r.length &&
470             _r.length == _s.length);
471 
472     for(uint i; i < _from.length; i++) {
473       transferPreSigned(_from[i],
474                         _to[i],
475                         _values[i],
476                         _fees[i],
477                         _nonces[i],
478                         _v[i],
479                         _r[i],
480                         _s[i]);
481     }
482 
483     return true;
484   }
485 
486 
487   function transferPreSignedMany(address _from,
488                                  address[] _tos,
489                                  uint256[] _values,
490                                  uint256 _fee,
491                                  uint256 _nonce,
492                                  uint8 _v,
493                                  bytes32 _r,
494                                  bytes32 _s) public returns (bool) {
495    require(_tos.length == _values.length);
496    uint256 total = getTotal(_tos, _values, _fee);
497 
498    bytes32 calcHash = calculateManyHash(_from, _tos, _values, _fee, _nonce);
499 
500    require(isValidSignature(_from, calcHash, _v, _r, _s));
501    require(balances[_from] >= total);
502    require(!executedSettlements[_from][calcHash]);
503 
504    executedSettlements[_from][calcHash] = true;
505 
506    // transfer to each recipient and take fee at the end
507    for(uint i; i < _tos.length; i++) {
508      // Move tokens
509      balances[_from] = balances[_from].sub(_values[i]);
510      balances[_tos[i]] = balances[_tos[i]].add(_values[i]);
511      Transfer(_from, _tos[i], _values[i]);
512    }
513 
514    // Move fee
515    balances[_from] = balances[_from].sub(_fee);
516    balances[msg.sender] = balances[msg.sender].add(_fee);
517    Transfer(_from, msg.sender, _fee);
518 
519    TransferPreSignedMany(_from, msg.sender, total, _fee);
520 
521    return true;
522   }
523 
524   function getTotal(address[] _tos, uint256[] _values, uint256 _fee) private view returns (uint256)  {
525     uint256 total = _fee;
526 
527     for(uint i; i < _tos.length; i++) {
528       total = total.add(_values[i]); // sum of all the values + fee
529       require(_tos[i] != address(0)); // check that the recipient is a valid address
530     }
531 
532     return total;
533   }
534 
535   /**
536   * @dev Calculates transfer hash for transferPreSignedMany
537   */
538   function calculateManyHash(address _from, address[] _tos, uint256[] _values, uint256 _fee, uint256 _nonce) public view returns (bytes32) {
539     return keccak256(uint256(1), address(this), _from, _tos, _values, _fee, _nonce);
540   }
541 
542   /**
543   * @dev Calculates transfer hash.
544   */
545   function calculateHash(address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce) public view returns (bytes32) {
546     return keccak256(uint256(0), address(this), _from, _to, _value, _fee, _nonce);
547   }
548 
549   /**
550   * @dev Validates the signature
551   */
552   function isValidSignature(address _signer, bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (bool) {
553     return _signer == ecrecover(
554             keccak256("\x19Ethereum Signed Message:\n32", _hash),
555             _v,
556             _r,
557             _s
558         );
559   }
560 
561   /**
562   * @dev Allows you to check whether a certain transaction has been already
563   * settled or not.
564   */
565   function isTransactionAlreadySettled(address _from, bytes32 _calcHash) public view returns (bool) {
566     return executedSettlements[_from][_calcHash];
567   }
568 
569 }
570 
571 // File: contracts/token/PausableSignedTransferToken.sol
572 
573 contract PausableSignedTransferToken is SignedTransferToken, PausableToken {
574 
575   function transferPreSigned(address _from,
576                              address _to,
577                              uint256 _value,
578                              uint256 _fee,
579                              uint256 _nonce,
580                              uint8 _v,
581                              bytes32 _r,
582                              bytes32 _s) public whenNotPaused returns (bool) {
583     return super.transferPreSigned(_from, _to, _value, _fee, _nonce, _v, _r, _s);
584   }
585 
586   function transferPreSignedBulk(address[] _from,
587                                  address[] _to,
588                                  uint256[] _values,
589                                  uint256[] _fees,
590                                  uint256[] _nonces,
591                                  uint8[] _v,
592                                  bytes32[] _r,
593                                  bytes32[] _s) public whenNotPaused returns (bool) {
594     return super.transferPreSignedBulk(_from, _to, _values, _fees, _nonces, _v, _r, _s);
595   }
596 
597   function transferPreSignedMany(address _from,
598                                  address[] _tos,
599                                  uint256[] _values,
600                                  uint256 _fee,
601                                  uint256 _nonce,
602                                  uint8 _v,
603                                  bytes32 _r,
604                                  bytes32 _s) public whenNotPaused returns (bool) {
605     return super.transferPreSignedMany(_from, _tos, _values, _fee, _nonce, _v, _r, _s);
606   }
607 }
608 
609 // File: contracts/FourToken.sol
610 
611 contract FourToken is CappedToken, PausableSignedTransferToken  {
612   string public name = 'The 4th Pillar Token';
613   string public symbol = 'FOUR';
614   uint256 public decimals = 18;
615 
616   // Max supply of 400 million
617   uint256 public maxSupply = 400000000 * 10**decimals;
618 
619   function FourToken()
620     CappedToken(maxSupply) public {
621       paused = true;
622   }
623 
624   // @dev Recover any mistakenly sent ERC20 tokens to the Token address
625   function recoverERC20Tokens(address _erc20, uint256 _amount) public onlyOwner {
626     ERC20Interface(_erc20).transfer(msg.sender, _amount);
627   }
628 
629 }