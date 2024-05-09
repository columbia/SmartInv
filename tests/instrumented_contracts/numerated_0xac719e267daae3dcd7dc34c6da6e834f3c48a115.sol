1 pragma solidity 0.4.24;
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
257 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
258 
259 /**
260  * @title Burnable Token
261  * @dev Token that can be irreversibly burned (destroyed).
262  */
263 contract BurnableToken is BasicToken {
264 
265   event Burn(address indexed burner, uint256 value);
266 
267   /**
268    * @dev Burns a specific amount of tokens.
269    * @param _value The amount of token to be burned.
270    */
271   function burn(uint256 _value) public {
272     _burn(msg.sender, _value);
273   }
274 
275   function _burn(address _who, uint256 _value) internal {
276     require(_value <= balances[_who]);
277     // no need to require value <= totalSupply, since that would imply the
278     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
279 
280     balances[_who] = balances[_who].sub(_value);
281     totalSupply_ = totalSupply_.sub(_value);
282     emit Burn(_who, _value);
283     emit Transfer(_who, address(0), _value);
284   }
285 }
286 
287 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295   address public owner;
296 
297 
298   event OwnershipRenounced(address indexed previousOwner);
299   event OwnershipTransferred(
300     address indexed previousOwner,
301     address indexed newOwner
302   );
303 
304 
305   /**
306    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
307    * account.
308    */
309   constructor() public {
310     owner = msg.sender;
311   }
312 
313   /**
314    * @dev Throws if called by any account other than the owner.
315    */
316   modifier onlyOwner() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Allows the current owner to relinquish control of the contract.
323    * @notice Renouncing to ownership will leave the contract without an owner.
324    * It will not be possible to call the functions with the `onlyOwner`
325    * modifier anymore.
326    */
327   function renounceOwnership() public onlyOwner {
328     emit OwnershipRenounced(owner);
329     owner = address(0);
330   }
331 
332   /**
333    * @dev Allows the current owner to transfer control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336   function transferOwnership(address _newOwner) public onlyOwner {
337     _transferOwnership(_newOwner);
338   }
339 
340   /**
341    * @dev Transfers control of the contract to a newOwner.
342    * @param _newOwner The address to transfer ownership to.
343    */
344   function _transferOwnership(address _newOwner) internal {
345     require(_newOwner != address(0));
346     emit OwnershipTransferred(owner, _newOwner);
347     owner = _newOwner;
348   }
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
364 
365   modifier canMint() {
366     require(!mintingFinished);
367     _;
368   }
369 
370   modifier hasMintPermission() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(
382     address _to,
383     uint256 _amount
384   )
385     public
386     hasMintPermission
387     canMint
388     returns (bool)
389   {
390     totalSupply_ = totalSupply_.add(_amount);
391     balances[_to] = balances[_to].add(_amount);
392     emit Mint(_to, _amount);
393     emit Transfer(address(0), _to, _amount);
394     return true;
395   }
396 
397   /**
398    * @dev Function to stop minting new tokens.
399    * @return True if the operation was successful.
400    */
401   function finishMinting() public onlyOwner canMint returns (bool) {
402     mintingFinished = true;
403     emit MintFinished();
404     return true;
405   }
406 }
407 
408 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
409 
410 /**
411  * @title Claimable
412  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
413  * This allows the new owner to accept the transfer.
414  */
415 contract Claimable is Ownable {
416   address public pendingOwner;
417 
418   /**
419    * @dev Modifier throws if called by any account other than the pendingOwner.
420    */
421   modifier onlyPendingOwner() {
422     require(msg.sender == pendingOwner);
423     _;
424   }
425 
426   /**
427    * @dev Allows the current owner to set the pendingOwner address.
428    * @param newOwner The address to transfer ownership to.
429    */
430   function transferOwnership(address newOwner) public onlyOwner {
431     pendingOwner = newOwner;
432   }
433 
434   /**
435    * @dev Allows the pendingOwner address to finalize the transfer.
436    */
437   function claimOwnership() public onlyPendingOwner {
438     emit OwnershipTransferred(owner, pendingOwner);
439     owner = pendingOwner;
440     pendingOwner = address(0);
441   }
442 }
443 
444 
445 /**
446  * @title SNOWBALL token
447  */
448 contract SnowBallToken is Ownable, Claimable, MintableToken, BurnableToken {
449     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
450     event Multisended();
451 
452     string public name = "SnowballUSD";
453     string public symbol = "SBUSD";
454     uint8 public decimals = 6;
455     uint256 public multiSendLimit = 150;
456     bool public pausedTransfers = false;
457 
458     modifier onlyOwner() {
459         require(msg.sender == owner, "not owner");
460         _;
461     }
462 
463     modifier isNotPaused() {
464         require(pausedTransfers == false, "paused");
465         _;
466     }
467 
468     modifier validRecipient(address _recipient) {
469         require(_recipient != address(0) && _recipient != address(this), "recipient is token address or empty");
470         _;
471     }
472 
473     modifier hasApproval(address _from, uint256 _value) {
474         require(_value <= allowed[_from][msg.sender], "not enough approved");
475         _;
476     }
477 
478     modifier hasBalance(address _from, uint256 _value) {
479         require(_value <= balances[_from], "not enough balance");
480         _;
481     }
482 
483     function() public {
484         revert("fallback is not supported");
485     }
486 
487     constructor() public {
488         // 550,000,000 tokens
489         totalSupply_ = 0 ether;
490         balances[msg.sender] = totalSupply();
491     }
492 
493     function claimTokens(address _token, address _to) public onlyOwner {
494         require(_to != address(0), "to is 0");
495         if (_token == address(0)) {
496             _to.transfer(address(this).balance);
497             return;
498         }
499 
500         StandardToken token = StandardToken(_token);
501         uint256 balance = token.balanceOf(address(this));
502         require(token.transfer(_to, balance), "transfer failed");
503     }
504 
505     function superTransfer(address _to, uint256 _value) 
506         internal 
507         isNotPaused
508         validRecipient(_to)
509         hasBalance(msg.sender, _value)
510         returns(bool)
511     {
512         balances[msg.sender] = balances[msg.sender].sub(_value);
513         balances[_to] = balances[_to].add(_value);
514         emit Transfer(msg.sender, _to, _value);
515         return true;
516     }
517 
518     function superTransferFrom(address _from, address _to, uint256 _value) 
519         internal 
520         isNotPaused
521         hasBalance(_from, _value)
522         hasApproval(_from, _value)
523         validRecipient(_to)
524         returns(bool)
525     {
526         balances[_from] = balances[_from].sub(_value);
527         balances[_to] = balances[_to].add(_value);
528         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
529         emit Transfer(_from, _to, _value);
530         return true;
531     }
532 
533     function transferFrom(
534         address _from,
535         address _to,
536         uint256 _value
537     )
538         public
539         returns (bool)
540     {
541         require(superTransferFrom(_from, _to, _value));
542         return true;
543     }
544 
545     function transfer(address _to, uint256 _value) public returns (bool)
546     {
547         require(superTransfer(_to, _value));
548         return true;
549     }
550 
551 
552     function transferAndCall(address _to, uint _value, bytes _data) public returns (bool)
553     {
554         require(superTransfer(_to, _value));
555         emit Transfer(msg.sender, _to, _value, _data);
556 
557         if (isContract(_to)) {
558             require(contractFallback(msg.sender, _to, _value, _data), "contractFallback failed");
559         }
560         return true;
561     }
562 
563     function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool)
564     {
565         require(superTransferFrom(_from, _to, _value));
566         emit Transfer(msg.sender, _to, _value, _data);
567 
568         if (isContract(_to)) {
569             require(contractFallback(_from, _to, _value, _data), "contractFallback failed");
570         }
571         return true;
572     }
573 
574     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
575         require(super.approve(_spender, _amount));
576         return _spender.call(abi.encodeWithSignature("receiveApproval(address,uint256,bytes)",  _spender, _amount, _extraData));
577     }
578 
579     function setPausedTransfers(bool _state)
580         external 
581         onlyOwner 
582     {
583         require(pausedTransfers != _state);
584         pausedTransfers = _state;
585     }
586 
587     /// @notice Function to send multiple token transfers in one tx
588     function multisend(address[] _recipients, uint256[] _balances) public {
589         require(_recipients.length == _balances.length, "not equal length");
590         require(_recipients.length <= multiSendLimit, "more than limit");
591         uint256 i = 0;
592         for( i; i < _balances.length; i++ ) {
593             transfer(_recipients[i], _balances[i]);
594         }
595         emit Multisended();
596     }
597 
598     function setMultisendLimit(uint256 _newLimit) external onlyOwner {
599         multiSendLimit = _newLimit;
600     }
601 
602     function contractFallback(address _from, address _to, uint256 _value, bytes _data)
603         private
604         returns(bool)
605     {
606         return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)",  _from, _value, _data));
607     }
608 
609     function isContract(address _addr)
610         private
611         view
612         returns (bool)
613     {
614         uint length;
615         assembly { length := extcodesize(_addr) }
616         return length > 0;
617     }
618 
619     function currentTime() private view returns (uint256) {
620         return block.timestamp;
621     }
622 
623 }