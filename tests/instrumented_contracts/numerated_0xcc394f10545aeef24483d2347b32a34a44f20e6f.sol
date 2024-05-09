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
351 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
352 
353 /**
354  * @title Claimable
355  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
356  * This allows the new owner to accept the transfer.
357  */
358 contract Claimable is Ownable {
359   address public pendingOwner;
360 
361   /**
362    * @dev Modifier throws if called by any account other than the pendingOwner.
363    */
364   modifier onlyPendingOwner() {
365     require(msg.sender == pendingOwner);
366     _;
367   }
368 
369   /**
370    * @dev Allows the current owner to set the pendingOwner address.
371    * @param newOwner The address to transfer ownership to.
372    */
373   function transferOwnership(address newOwner) public onlyOwner {
374     pendingOwner = newOwner;
375   }
376 
377   /**
378    * @dev Allows the pendingOwner address to finalize the transfer.
379    */
380   function claimOwnership() public onlyPendingOwner {
381     emit OwnershipTransferred(owner, pendingOwner);
382     owner = pendingOwner;
383     pendingOwner = address(0);
384   }
385 }
386 
387 // File: contracts/VaultGuardianToken.sol
388 
389 /**
390  * @title VaultGuardianToken token
391  */
392 contract VaultGuardianToken is Claimable, StandardToken, BurnableToken {
393     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
394     event Multisended();
395     event TransferPaused(bool status);
396 
397     string public name = "Vault Guardian Token";
398     string public symbol = "VGT";
399     uint8 public decimals = 18;
400     uint256 public multiSendLimit = 220;
401     bool public pausedTransfers = false;
402 
403     modifier onlyOwner() {
404         require(msg.sender == owner, "not owner");
405         _;
406     }
407 
408     modifier isNotPaused() {
409         require(pausedTransfers == false, "paused");
410         _;
411     }
412 
413     modifier validRecipient(address _recipient) {
414         require(_recipient != address(0) && _recipient != address(this), "recipient is token address or empty");
415         _;
416     }
417 
418     modifier hasApproval(address _from, uint256 _value) {
419         require(_value <= allowed[_from][msg.sender], "not enough approved");
420         _;
421     }
422 
423     modifier hasBalance(address _from, uint256 _value) {
424         require(_value <= balances[_from], "not enough balance");
425         _;
426     }
427 
428     function() public {
429         revert("fallback is not supported");
430     }
431 
432     constructor() public {
433         // 1B tokens
434         totalSupply_ = 10 ** 18 * 1000000000;
435         balances[msg.sender] = totalSupply();
436     }
437 
438     function claimTokens(address _token, address _to) public onlyOwner {
439         require(_to != address(0), "to is 0");
440         if (_token == address(0)) {
441             _to.transfer(address(this).balance);
442             return;
443         }
444 
445         StandardToken token = StandardToken(_token);
446         uint256 balance = token.balanceOf(address(this));
447         require(token.transfer(_to, balance), "transfer failed");
448     }
449 
450     function superTransfer(address _to, uint256 _value) 
451         internal 
452         isNotPaused
453         validRecipient(_to)
454         hasBalance(msg.sender, _value)
455         returns(bool)
456     {
457         balances[msg.sender] = balances[msg.sender].sub(_value);
458         balances[_to] = balances[_to].add(_value);
459         emit Transfer(msg.sender, _to, _value);
460         return true;
461     }
462 
463     function superTransferFrom(address _from, address _to, uint256 _value) 
464         internal 
465         isNotPaused
466         hasBalance(_from, _value)
467         hasApproval(_from, _value)
468         validRecipient(_to)
469         returns(bool)
470     {
471         balances[_from] = balances[_from].sub(_value);
472         balances[_to] = balances[_to].add(_value);
473         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
474         emit Transfer(_from, _to, _value);
475         return true;
476     }
477 
478     function transferFrom(
479         address _from,
480         address _to,
481         uint256 _value
482     )
483         public
484         returns (bool)
485     {
486         require(superTransferFrom(_from, _to, _value));
487         return true;
488     }
489 
490     function transfer(address _to, uint256 _value) public returns (bool)
491     {
492         require(superTransfer(_to, _value));
493         return true;
494     }
495 
496 
497     function transferAndCall(address _to, uint _value, bytes _data) public returns (bool)
498     {
499         require(superTransfer(_to, _value));
500         emit Transfer(msg.sender, _to, _value, _data);
501 
502         if (isContract(_to)) {
503             require(contractFallback(msg.sender, _to, _value, _data), "contractFallback failed");
504         }
505         return true;
506     }
507 
508     function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool)
509     {
510         require(superTransferFrom(_from, _to, _value));
511         emit Transfer(msg.sender, _to, _value, _data);
512 
513         if (isContract(_to)) {
514             require(contractFallback(_from, _to, _value, _data), "contractFallback failed");
515         }
516         return true;
517     }
518 
519     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
520         require(super.approve(_spender, _amount));
521         return _spender.call(abi.encodeWithSignature("receiveApproval(address,uint256,bytes)",  _spender, _amount, _extraData));
522     }
523 
524     function setPausedTransfers(bool _state)
525         external 
526         onlyOwner 
527     {
528         require(pausedTransfers != _state);
529         pausedTransfers = _state;
530         emit TransferPaused(_state);
531     }
532 
533     /// @notice Function to send multiple token transfers in one tx
534     function multisend(address[] _recipients, uint256[] _balances) external {
535         require(_recipients.length == _balances.length, "not equal length");
536         require(_recipients.length <= multiSendLimit, "more than limit");
537         uint256 i = 0;
538         for( i; i < _balances.length; i++ ) {
539             transfer(_recipients[i], _balances[i]);
540         }
541         emit Multisended();
542     }
543 
544     function setMultisendLimit(uint256 _newLimit) external onlyOwner {
545         multiSendLimit = _newLimit;
546     }
547 
548     function renounceOwnership() public onlyOwner {
549     }
550 
551     function contractFallback(address _from, address _to, uint256 _value, bytes _data)
552         private
553         returns(bool)
554     {
555         return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)",  _from, _value, _data));
556     }
557 
558     function isContract(address _addr)
559         private
560         view
561         returns (bool)
562     {
563         uint length;
564         assembly { length := extcodesize(_addr) }
565         return length > 0;
566     }
567 
568     function currentTime() private view returns (uint256) {
569         return block.timestamp;
570     }
571 
572 }