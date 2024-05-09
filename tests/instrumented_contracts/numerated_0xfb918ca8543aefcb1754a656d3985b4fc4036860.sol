1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that revert on error
77  */
78 library SafeMath {
79     int256 constant private INT256_MIN = -2**255;
80 
81     /**
82     * @dev Multiplies two unsigned integers, reverts on overflow.
83     */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b);
94 
95         return c;
96     }
97 
98     /**
99     * @dev Multiplies two signed integers, reverts on overflow.
100     */
101     function mul(int256 a, int256 b) internal pure returns (int256) {
102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103         // benefit is lost if 'b' is also tested.
104         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105         if (a == 0) {
106             return 0;
107         }
108 
109         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
110 
111         int256 c = a * b;
112         require(c / a == b);
113 
114         return c;
115     }
116 
117     /**
118     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
119     */
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
131     */
132     function div(int256 a, int256 b) internal pure returns (int256) {
133         require(b != 0); // Solidity only automatically asserts when dividing by 0
134         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
135 
136         int256 c = a / b;
137 
138         return c;
139     }
140 
141     /**
142     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
143     */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b <= a);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152     * @dev Subtracts two signed integers, reverts on overflow.
153     */
154     function sub(int256 a, int256 b) internal pure returns (int256) {
155         int256 c = a - b;
156         require((b >= 0 && c <= a) || (b < 0 && c > a));
157 
158         return c;
159     }
160 
161     /**
162     * @dev Adds two unsigned integers, reverts on overflow.
163     */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a);
167 
168         return c;
169     }
170 
171     /**
172     * @dev Adds two signed integers, reverts on overflow.
173     */
174     function add(int256 a, int256 b) internal pure returns (int256) {
175         int256 c = a + b;
176         require((b >= 0 && c >= a) || (b < 0 && c < a));
177 
178         return c;
179     }
180 
181     /**
182     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
183     * reverts when dividing by zero.
184     */
185     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186         require(b != 0);
187         return a % b;
188     }
189 }
190 
191 contract DetailedToken {
192   string public name;
193   string public symbol;
194   uint8 public decimals;
195   uint256 public totalSupply;
196 }
197 
198 contract KeyValueStorage {
199 
200   mapping(address => mapping(bytes32 => uint256)) _uintStorage;
201   mapping(address => mapping(bytes32 => address)) _addressStorage;
202   mapping(address => mapping(bytes32 => bool)) _boolStorage;
203 
204   /**** Get Methods ***********/
205 
206   function getAddress(bytes32 key) public view returns (address) {
207       return _addressStorage[msg.sender][key];
208   }
209 
210   function getUint(bytes32 key) public view returns (uint) {
211       return _uintStorage[msg.sender][key];
212   }
213 
214   function getBool(bytes32 key) public view returns (bool) {
215       return _boolStorage[msg.sender][key];
216   }
217 
218   /**** Set Methods ***********/
219 
220   function setAddress(bytes32 key, address value) public {
221     _addressStorage[msg.sender][key] = value;
222   }
223 
224   function setUint(bytes32 key, uint value) public {
225       _uintStorage[msg.sender][key] = value;
226   }
227 
228   function setBool(bytes32 key, bool value) public {
229       _boolStorage[msg.sender][key] = value;
230   }
231 
232   /**** Delete Methods ***********/
233 
234   function deleteAddress(bytes32 key) public {
235       delete _addressStorage[msg.sender][key];
236   }
237 
238   function deleteUint(bytes32 key) public {
239       delete _uintStorage[msg.sender][key];
240   }
241 
242   function deleteBool(bytes32 key) public {
243       delete _boolStorage[msg.sender][key];
244   }
245 
246 }
247 
248 contract Proxy is Ownable {
249 
250   event Upgraded(address indexed implementation);
251 
252   address internal _implementation;
253 
254   function implementation() public view returns (address) {
255     return _implementation;
256   }
257 
258   function upgradeTo(address impl) public onlyOwner {
259     require(_implementation != impl);
260     _implementation = impl;
261     emit Upgraded(impl);
262   }
263 
264   function () payable public {
265     address _impl = implementation();
266     require(_impl != address(0));
267     bytes memory data = msg.data;
268 
269     assembly {
270       let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
271       let size := returndatasize
272       let ptr := mload(0x40)
273       returndatacopy(ptr, 0, size)
274       switch result
275       case 0 { revert(ptr, size) }
276       default { return(ptr, size) }
277     }
278   }
279 
280 }
281 
282 contract StorageStateful {
283 
284   KeyValueStorage _storage;
285 
286 }
287 
288 contract StorageConsumer is StorageStateful {
289 
290   constructor(KeyValueStorage storage_) public {
291     _storage = storage_;
292   }
293 
294 }
295 
296 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
297 
298 
299 contract TokenVersion1 is StorageConsumer, Proxy, DetailedToken {
300 
301   constructor(KeyValueStorage storage_)
302     public
303     StorageConsumer(storage_)
304   {
305     // set some immutable state
306     name = "Influence";
307     symbol = "INFLU";
308     decimals = 18;
309     totalSupply = 10000000000 * 10 ** uint256(decimals);
310     
311     // set token owner in the key-value store
312     storage_.setAddress("owner", msg.sender);
313     _storage.setUint(keccak256("balances", msg.sender), totalSupply);
314   }
315 
316 }
317 
318 contract TokenDelegate is StorageStateful {
319   using SafeMath for uint256;
320 
321   function balanceOf(address owner) public view returns (uint256 balance) {
322     return getBalance(owner);
323   }
324 
325   function getBalance(address balanceHolder) public view returns (uint256) {
326     return _storage.getUint(keccak256("balances", balanceHolder));
327   }
328 
329   function totalSupply() public view returns (uint256) {
330     return _storage.getUint("totalSupply");
331   }
332 
333   function addSupply(uint256 amount) internal {
334     _storage.setUint("totalSupply", totalSupply().add(amount));
335   }
336   
337   function subSupply(uint256 amount) internal {
338       _storage.setUint("totalSupply", totalSupply().sub(amount));
339   }
340 
341   function addBalance(address balanceHolder, uint256 amount) internal {
342     setBalance(balanceHolder, getBalance(balanceHolder).add(amount));
343   }
344 
345   function subBalance(address balanceHolder, uint256 amount) internal {
346     setBalance(balanceHolder, getBalance(balanceHolder).sub(amount));
347   }
348 
349   function setBalance(address balanceHolder, uint256 amount) internal {
350     _storage.setUint(keccak256("balances", balanceHolder), amount);
351   }
352 
353 }
354 
355 contract TokenVersion2 is TokenDelegate {
356     
357     // This creates an array with all balances
358     mapping (address => mapping (address => uint256)) public allowance;
359   
360     // This generates a public event on the blockchain that will notify clients
361     event Transfer(address indexed from, address indexed to, uint256 value);
362     
363     // This generates a public event on the blockchain that will notify clients
364     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
365     
366     // This notifies clients about the amount burnt
367     event Burn(address indexed from, uint256 value);
368 
369   /**
370    * Internal transfer, only can be called by this contract
371    */
372   function _transfer(address _from, address _to, uint _value) internal {
373       require(_to != address(0x0));
374       require(getBalance(_from) >= _value);
375       require(getBalance(_to) + _value > getBalance(_to));
376       uint previousBalances = getBalance(_from) + getBalance(_to);
377       subBalance(_from, _value);
378       addBalance(_to, _value);
379       emit Transfer(_from, _to, _value);
380       assert(getBalance(_from) + getBalance(_to) == previousBalances);
381   }
382 
383   /**
384    * Transfer tokens
385    *
386    * Send `_value` tokens to `_to` from your account
387    *
388    * @param _to The address of the recipient
389    * @param _value the amount to send
390    */
391   function transfer(address _to, uint256 _value) public returns (bool success) {
392       _transfer(msg.sender, _to, _value);
393       return true;
394   }
395 
396   /**
397    * Transfer tokens from other address
398    *
399    * Send `_value` tokens to `_to` in behalf of `_from`
400    *
401    * @param _from The address of the sender
402    * @param _to The address of the recipient
403    * @param _value the amount to send
404    */
405   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
406       require(_value <= allowance[_from][msg.sender]);     // Check allowance
407       allowance[_from][msg.sender] -= _value;
408       _transfer(_from, _to, _value);
409       return true;
410   }
411 
412   /**
413    * Set allowance for other address
414    *
415    * Allows `_spender` to spend no more than `_value` tokens in your behalf
416    *
417    * @param _spender The address authorized to spend
418    * @param _value the max amount they can spend
419    */
420   function approve(address _spender, uint256 _value) public
421       returns (bool success) {
422       allowance[msg.sender][_spender] = _value;
423       emit Approval(msg.sender, _spender, _value);
424       return true;
425   }
426 
427   /**
428    * Set allowance for other address and notify
429    *
430    * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
431    *
432    * @param _spender The address authorized to spend
433    * @param _value the max amount they can spend
434    * @param _extraData some extra information to send to the approved contract
435    */
436   function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
437       public
438       returns (bool success) {
439       tokenRecipient spender = tokenRecipient(_spender);
440       if (approve(_spender, _value)) {
441           spender.receiveApproval(msg.sender, _value, address(this), _extraData);
442           return true;
443       }
444   }
445 
446   /**
447    * Destroy tokens
448    *
449    * Remove `_value` tokens from the system irreversibly
450    *
451    * @param _value the amount of money to burn
452    */
453   function burn(uint256 _value) public returns (bool success) {
454       require(getBalance(msg.sender) >= _value);   // Check if the sender has enough
455       subBalance(msg.sender, _value);              // Subtract from the sender
456       subSupply(_value);                           // Updates totalSupply
457       emit Burn(msg.sender, _value);
458       return true;
459   }
460 
461   /**
462    * Destroy tokens from other account
463    *
464    * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
465    *
466    * @param _from the address of the sender
467    * @param _value the amount of money to burn
468    */
469   function burnFrom(address _from, uint256 _value) public returns (bool success) {
470       require(getBalance(_from) >= _value);                // Check if the targeted balance is enough
471       require(_value <= allowance[_from][msg.sender]);    // Check allowance
472       subBalance(_from, _value);                          // Subtract from the targeted balance
473       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
474       
475       subSupply(_value);                                  // Update totalSupply
476       emit Burn(_from, _value);
477       return true;
478   }
479   
480 }
481 
482 contract TokenVersion3 is TokenDelegate {
483 
484   modifier onlyOwner {
485     require(msg.sender == _storage.getAddress("owner"));
486     _;
487   }
488 
489   
490     // This creates an array with all balances
491     mapping (address => mapping (address => uint256)) public allowance;
492     
493     mapping (address => bool) public frozenAccount;
494 
495     /* This generates a public event on the blockchain that will notify clients */
496     event FrozenFunds(address target, bool frozen);
497   
498     // This generates a public event on the blockchain that will notify clients
499     event Transfer(address indexed from, address indexed to, uint256 value);
500     
501     // This generates a public event on the blockchain that will notify clients
502     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
503     
504     // This notifies clients about the amount burnt
505     event Burn(address indexed from, uint256 value);
506 
507   /**
508    * Internal transfer, only can be called by this contract
509    */
510   function _transfer(address _from, address _to, uint _value) internal {
511       require(_to != address(0x0));
512       require(getBalance(_from) >= _value);
513       require(getBalance(_to) + _value > getBalance(_to));
514       uint previousBalances = getBalance(_from) + getBalance(_to);
515       subBalance(_from, _value);
516       addBalance(_to, _value);
517       emit Transfer(_from, _to, _value);
518       assert(getBalance(_from) + getBalance(_to) == previousBalances);
519   }
520 
521   /**
522    * Transfer tokens
523    *
524    * Send `_value` tokens to `_to` from your account
525    *
526    * @param _to The address of the recipient
527    * @param _value the amount to send
528    */
529   function transfer(address _to, uint256 _value) public returns (bool success) {
530       _transfer(msg.sender, _to, _value);
531       return true;
532   }
533 
534   /**
535    * Transfer tokens from other address
536    *
537    * Send `_value` tokens to `_to` in behalf of `_from`
538    *
539    * @param _from The address of the sender
540    * @param _to The address of the recipient
541    * @param _value the amount to send
542    */
543   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
544       require(_value <= allowance[_from][msg.sender]);     // Check allowance
545       allowance[_from][msg.sender] -= _value;
546       _transfer(_from, _to, _value);
547       return true;
548   }
549 
550   /**
551    * Set allowance for other address
552    *
553    * Allows `_spender` to spend no more than `_value` tokens in your behalf
554    *
555    * @param _spender The address authorized to spend
556    * @param _value the max amount they can spend
557    */
558   function approve(address _spender, uint256 _value) public
559       returns (bool success) {
560       allowance[msg.sender][_spender] = _value;
561       emit Approval(msg.sender, _spender, _value);
562       return true;
563   }
564 
565   /**
566    * Set allowance for other address and notify
567    *
568    * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
569    *
570    * @param _spender The address authorized to spend
571    * @param _value the max amount they can spend
572    * @param _extraData some extra information to send to the approved contract
573    */
574   function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
575       public
576       returns (bool success) {
577       tokenRecipient spender = tokenRecipient(_spender);
578       if (approve(_spender, _value)) {
579           spender.receiveApproval(msg.sender, _value, address(this), _extraData);
580           return true;
581       }
582   }
583 
584   /**
585    * Destroy tokens
586    *
587    * Remove `_value` tokens from the system irreversibly
588    *
589    * @param _value the amount of money to burn
590    */
591   function burn(uint256 _value) public returns (bool success) {
592       require(getBalance(msg.sender) >= _value);   // Check if the sender has enough
593       subBalance(msg.sender, _value);              // Subtract from the sender
594       subSupply(_value);                           // Updates totalSupply
595       emit Burn(msg.sender, _value);
596       return true;
597   }
598 
599   /**
600    * Destroy tokens from other account
601    *
602    * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
603    *
604    * @param _from the address of the sender
605    * @param _value the amount of money to burn
606    */
607   function burnFrom(address _from, uint256 _value) public returns (bool success) {
608       require(getBalance(_from) >= _value);                // Check if the targeted balance is enough
609       require(_value <= allowance[_from][msg.sender]);    // Check allowance
610       subBalance(_from, _value);                          // Subtract from the targeted balance
611       allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
612       
613       subSupply(_value);                                  // Update totalSupply
614       emit Burn(_from, _value);
615       return true;
616   }
617   
618     /// @notice Create `mintedAmount` tokens and send it to `target`
619     /// @param target Address to receive the tokens
620     /// @param mintedAmount the amount of tokens it will receive
621     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
622         addBalance(target, mintedAmount);
623         addSupply(mintedAmount);
624         emit Transfer(address(0), address(this), mintedAmount);
625         emit Transfer(address(this), target, mintedAmount);
626     }
627 
628     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
629     /// @param target Address to be frozen
630     /// @param freeze either to freeze it or not
631     function freezeAccount(address target, bool freeze) onlyOwner public {
632         frozenAccount[target] = freeze;
633         emit FrozenFunds(target, freeze);
634     }
635 
636 }