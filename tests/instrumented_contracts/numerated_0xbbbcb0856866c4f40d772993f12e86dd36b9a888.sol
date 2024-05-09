1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.23;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.23;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
125 
126 pragma solidity ^0.4.23;
127 
128 
129 
130 /**
131  * @title Burnable Token
132  * @dev Token that can be irreversibly burned (destroyed).
133  */
134 contract BurnableToken is BasicToken {
135 
136   event Burn(address indexed burner, uint256 value);
137 
138   /**
139    * @dev Burns a specific amount of tokens.
140    * @param _value The amount of token to be burned.
141    */
142   function burn(uint256 _value) public {
143     _burn(msg.sender, _value);
144   }
145 
146   function _burn(address _who, uint256 _value) internal {
147     require(_value <= balances[_who]);
148     // no need to require value <= totalSupply, since that would imply the
149     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
150 
151     balances[_who] = balances[_who].sub(_value);
152     totalSupply_ = totalSupply_.sub(_value);
153     emit Burn(_who, _value);
154     emit Transfer(_who, address(0), _value);
155   }
156 }
157 
158 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
159 
160 pragma solidity ^0.4.23;
161 
162 
163 
164 /**
165  * @title ERC20 interface
166  * @dev see https://github.com/ethereum/EIPs/issues/20
167  */
168 contract ERC20 is ERC20Basic {
169   function allowance(address owner, address spender)
170     public view returns (uint256);
171 
172   function transferFrom(address from, address to, uint256 value)
173     public returns (bool);
174 
175   function approve(address spender, uint256 value) public returns (bool);
176   event Approval(
177     address indexed owner,
178     address indexed spender,
179     uint256 value
180   );
181 }
182 
183 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
184 
185 pragma solidity ^0.4.23;
186 
187 
188 
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     public
214     returns (bool)
215   {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    *
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     emit Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(
250     address _owner,
251     address _spender
252    )
253     public
254     view
255     returns (uint256)
256   {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * @dev Increase the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(
271     address _spender,
272     uint _addedValue
273   )
274     public
275     returns (bool)
276   {
277     allowed[msg.sender][_spender] = (
278       allowed[msg.sender][_spender].add(_addedValue));
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(
294     address _spender,
295     uint _subtractedValue
296   )
297     public
298     returns (bool)
299   {
300     uint oldValue = allowed[msg.sender][_spender];
301     if (_subtractedValue > oldValue) {
302       allowed[msg.sender][_spender] = 0;
303     } else {
304       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305     }
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310 }
311 
312 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
313 
314 pragma solidity ^0.4.23;
315 
316 
317 /**
318  * @title Ownable
319  * @dev The Ownable contract has an owner address, and provides basic authorization control
320  * functions, this simplifies the implementation of "user permissions".
321  */
322 contract Ownable {
323   address public owner;
324 
325 
326   event OwnershipRenounced(address indexed previousOwner);
327   event OwnershipTransferred(
328     address indexed previousOwner,
329     address indexed newOwner
330   );
331 
332 
333   /**
334    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
335    * account.
336    */
337   constructor() public {
338     owner = msg.sender;
339   }
340 
341   /**
342    * @dev Throws if called by any account other than the owner.
343    */
344   modifier onlyOwner() {
345     require(msg.sender == owner);
346     _;
347   }
348 
349   /**
350    * @dev Allows the current owner to relinquish control of the contract.
351    */
352   function renounceOwnership() public onlyOwner {
353     emit OwnershipRenounced(owner);
354     owner = address(0);
355   }
356 
357   /**
358    * @dev Allows the current owner to transfer control of the contract to a newOwner.
359    * @param _newOwner The address to transfer ownership to.
360    */
361   function transferOwnership(address _newOwner) public onlyOwner {
362     _transferOwnership(_newOwner);
363   }
364 
365   /**
366    * @dev Transfers control of the contract to a newOwner.
367    * @param _newOwner The address to transfer ownership to.
368    */
369   function _transferOwnership(address _newOwner) internal {
370     require(_newOwner != address(0));
371     emit OwnershipTransferred(owner, _newOwner);
372     owner = _newOwner;
373   }
374 }
375 
376 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
377 
378 pragma solidity ^0.4.23;
379 
380 
381 
382 
383 /**
384  * @title Mintable token
385  * @dev Simple ERC20 Token example, with mintable token creation
386  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
387  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
388  */
389 contract MintableToken is StandardToken, Ownable {
390   event Mint(address indexed to, uint256 amount);
391   event MintFinished();
392 
393   bool public mintingFinished = false;
394 
395 
396   modifier canMint() {
397     require(!mintingFinished);
398     _;
399   }
400 
401   modifier hasMintPermission() {
402     require(msg.sender == owner);
403     _;
404   }
405 
406   /**
407    * @dev Function to mint tokens
408    * @param _to The address that will receive the minted tokens.
409    * @param _amount The amount of tokens to mint.
410    * @return A boolean that indicates if the operation was successful.
411    */
412   function mint(
413     address _to,
414     uint256 _amount
415   )
416     hasMintPermission
417     canMint
418     public
419     returns (bool)
420   {
421     totalSupply_ = totalSupply_.add(_amount);
422     balances[_to] = balances[_to].add(_amount);
423     emit Mint(_to, _amount);
424     emit Transfer(address(0), _to, _amount);
425     return true;
426   }
427 
428   /**
429    * @dev Function to stop minting new tokens.
430    * @return True if the operation was successful.
431    */
432   function finishMinting() onlyOwner canMint public returns (bool) {
433     mintingFinished = true;
434     emit MintFinished();
435     return true;
436   }
437 }
438 
439 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
440 
441 pragma solidity ^0.4.23;
442 
443 
444 
445 /**
446  * @title DetailedERC20 token
447  * @dev The decimals are only for visualization purposes.
448  * All the operations are done using the smallest and indivisible token unit,
449  * just as on Ethereum all the operations are done in wei.
450  */
451 contract DetailedERC20 is ERC20 {
452   string public name;
453   string public symbol;
454   uint8 public decimals;
455 
456   constructor(string _name, string _symbol, uint8 _decimals) public {
457     name = _name;
458     symbol = _symbol;
459     decimals = _decimals;
460   }
461 }
462 
463 // File: contracts/ERC677.sol
464 
465 pragma solidity 0.4.24;
466 
467 
468 
469 contract ERC677 is ERC20 {
470     event Transfer(address indexed from, address indexed to, uint value, bytes data);
471 
472     function transferAndCall(address, uint, bytes) external returns (bool);
473 
474 }
475 
476 // File: contracts/IBurnableMintableERC677Token.sol
477 
478 pragma solidity 0.4.24;
479 
480 
481 
482 contract IBurnableMintableERC677Token is ERC677 {
483     function mint(address, uint256) public returns (bool);
484     function burn(uint256 _value) public;
485     function claimTokens(address _token, address _to) public;
486 }
487 
488 // File: contracts/ERC677Receiver.sol
489 
490 pragma solidity 0.4.24;
491 
492 
493 contract ERC677Receiver {
494   function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
495 }
496 
497 // File: contracts/ERC677BridgeToken.sol
498 
499 pragma solidity 0.4.24;
500 
501 
502 
503 
504 
505 
506 
507 contract ERC677BridgeToken is
508     IBurnableMintableERC677Token,
509     DetailedERC20,
510     BurnableToken,
511     MintableToken {
512 
513     address public bridgeContract;
514 
515     event ContractFallbackCallFailed(address from, address to, uint value);
516 
517     constructor(
518         string _name,
519         string _symbol,
520         uint8 _decimals)
521     public DetailedERC20(_name, _symbol, _decimals) {}
522 
523     function setBridgeContract(address _bridgeContract) onlyOwner public {
524         require(_bridgeContract != address(0) && isContract(_bridgeContract));
525         bridgeContract = _bridgeContract;
526     }
527 
528     modifier validRecipient(address _recipient) {
529         require(_recipient != address(0) && _recipient != address(this));
530         _;
531     }
532 
533     function transferAndCall(address _to, uint _value, bytes _data)
534         external validRecipient(_to) returns (bool)
535     {
536         require(superTransfer(_to, _value));
537         emit Transfer(msg.sender, _to, _value, _data);
538 
539         if (isContract(_to)) {
540             require(contractFallback(_to, _value, _data));
541         }
542         return true;
543     }
544 
545     function getTokenInterfacesVersion() public pure returns(uint64 major, uint64 minor, uint64 patch) {
546         return (2, 0, 0);
547     }
548 
549     function superTransfer(address _to, uint256 _value) internal returns(bool)
550     {
551         return super.transfer(_to, _value);
552     }
553 
554     function transfer(address _to, uint256 _value) public returns (bool)
555     {
556         require(superTransfer(_to, _value));
557         if (isContract(_to) && !contractFallback(_to, _value, new bytes(0))) {
558             if (_to == bridgeContract) {
559                 revert();
560             } else {
561                 emit ContractFallbackCallFailed(msg.sender, _to, _value);
562             }
563         }
564         return true;
565     }
566 
567     function contractFallback(address _to, uint _value, bytes _data)
568         private
569         returns(bool)
570     {
571         return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)",  msg.sender, _value, _data));
572     }
573 
574     function isContract(address _addr)
575         private
576         view
577         returns (bool)
578     {
579         uint length;
580         assembly { length := extcodesize(_addr) }
581         return length > 0;
582     }
583 
584     function finishMinting() public returns (bool) {
585         revert();
586     }
587 
588     function renounceOwnership() public onlyOwner {
589         revert();
590     }
591 
592     function claimTokens(address _token, address _to) public onlyOwner {
593         require(_to != address(0));
594         if (_token == address(0)) {
595             _to.transfer(address(this).balance);
596             return;
597         }
598 
599         DetailedERC20 token = DetailedERC20(_token);
600         uint256 balance = token.balanceOf(address(this));
601         require(token.transfer(_to, balance));
602     }
603 
604 
605 }