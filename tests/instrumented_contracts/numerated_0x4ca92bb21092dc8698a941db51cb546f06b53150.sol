1 pragma solidity 0.4.24;
2 
3 // File: contracts\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts\ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address _who) public view returns (uint256);
77   function transfer(address _to, uint256 _value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: contracts\SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
93     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
94     // benefit is lost if 'b' is also tested.
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96     if (_a == 0) {
97       return 0;
98     }
99 
100     c = _a * _b;
101     assert(c / _a == _b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
109     // assert(_b > 0); // Solidity automatically throws when dividing by 0
110     // uint256 c = _a / _b;
111     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
112     return _a / _b;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     assert(_b <= _a);
120     return _a - _b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
127     c = _a + _b;
128     assert(c >= _a);
129     return c;
130   }
131 }
132 
133 // File: contracts\BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: contracts\BurnableToken.sol
180 
181 /**
182  * @title Burnable Token
183  * @dev Token that can be irreversibly burned (destroyed).
184  */
185 contract BurnableToken is BasicToken {
186 
187   event Burn(address indexed burner, uint256 value);
188 
189   /**
190    * @dev Burns a specific amount of tokens.
191    * @param _value The amount of token to be burned.
192    */
193   function burn(uint256 _value) public {
194     _burn(msg.sender, _value);
195   }
196 
197   function _burn(address _who, uint256 _value) internal {
198     require(_value <= balances[_who]);
199     // no need to require value <= totalSupply, since that would imply the
200     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
201 
202     balances[_who] = balances[_who].sub(_value);
203     totalSupply_ = totalSupply_.sub(_value);
204     emit Burn(_who, _value);
205     emit Transfer(_who, address(0), _value);
206   }
207 }
208 
209 // File: contracts\ERC20.sol
210 
211 /**
212  * @title ERC20 interface
213  * @dev see https://github.com/ethereum/EIPs/issues/20
214  */
215 contract ERC20 is ERC20Basic {
216   function allowance(address _owner, address _spender)
217     public view returns (uint256);
218 
219   function transferFrom(address _from, address _to, uint256 _value)
220     public returns (bool);
221 
222   function approve(address _spender, uint256 _value) public returns (bool);
223   event Approval(
224     address indexed owner,
225     address indexed spender,
226     uint256 value
227   );
228 }
229 
230 // File: contracts\StandardToken.sol
231 
232 /**
233  * @title Standard ERC20 token
234  *
235  * @dev Implementation of the basic standard token.
236  * https://github.com/ethereum/EIPs/issues/20
237  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
238  */
239 contract StandardToken is ERC20, BasicToken {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param _from address The address which you want to send tokens from
247    * @param _to address The address which you want to transfer to
248    * @param _value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(
251     address _from,
252     address _to,
253     uint256 _value
254   )
255     public
256     returns (bool)
257   {
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260     require(_to != address(0));
261 
262     balances[_from] = balances[_from].sub(_value);
263     balances[_to] = balances[_to].add(_value);
264     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265     emit Transfer(_from, _to, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     emit Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(
291     address _owner,
292     address _spender
293    )
294     public
295     view
296     returns (uint256)
297   {
298     return allowed[_owner][_spender];
299   }
300 
301   /**
302    * @dev Increase the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To increment
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _addedValue The amount of tokens to increase the allowance by.
309    */
310   function increaseApproval(
311     address _spender,
312     uint256 _addedValue
313   )
314     public
315     returns (bool)
316   {
317     allowed[msg.sender][_spender] = (
318       allowed[msg.sender][_spender].add(_addedValue));
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323   /**
324    * @dev Decrease the amount of tokens that an owner allowed to a spender.
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(
333     address _spender,
334     uint256 _subtractedValue
335   )
336     public
337     returns (bool)
338   {
339     uint256 oldValue = allowed[msg.sender][_spender];
340     if (_subtractedValue >= oldValue) {
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
351 // File: contracts\TrebitRefundToken.sol
352 
353 /** @title Trebit Token
354   * An ERC20-compliant token.
355   */
356 contract TrebitRefundToken is StandardToken, Ownable, BurnableToken {
357     using SafeMath for uint256;
358 
359     string public name = "TCO - Refund Project Coin";
360     string public symbol = "TCO-R";
361     uint256 public decimals = 18;
362 
363     // global token transfer lock
364     bool public globalTokenTransferLock;
365 
366     // mapping that provides address based lock. default at the time of issueance
367     // is locked, and will not be transferrable until explicit unlock call for
368     // the address.
369     mapping( address => bool ) public lockedStatusAddress;
370 
371     event GlobalLocked();
372     event GlobalUnlocked();
373     event Locked(address lockedAddress);
374     event Unlocked(address unlockedaddress);
375 
376     // Check for global lock status to be unlocked
377     modifier checkGlobalTokenTransferLock {
378         require(!globalTokenTransferLock);
379         _;
380     }
381 
382     // Check for address lock to be unlocked
383     modifier checkAddressLock {
384         require(!lockedStatusAddress[msg.sender]);
385         _;
386     }
387 
388     constructor() public {
389         totalSupply_ = 5000000000 * (10**18);
390         balances[msg.sender] = 5000000000 * (10**18);
391     }
392 
393     function setGlobalTokenTransferLock(bool locked) public
394     onlyOwner
395     returns (bool)
396     {
397         globalTokenTransferLock = locked;
398         if (globalTokenTransferLock) {
399             emit GlobalLocked();
400         } else {
401             emit GlobalUnlocked();
402         }
403         return globalTokenTransferLock;
404     }
405 
406     /**
407       * @dev Allows token issuer to lock token transfer for an address.
408       * @param target Target address to lock token transfer.
409       */
410     function lockAddress(address target) public
411     onlyOwner
412     {
413         require(owner != target);
414         lockedStatusAddress[target] = true;
415         emit Locked(target);
416     }
417 
418     /**
419       * @dev Allows token issuer to unlock token transfer for an address.
420       * @param target Target address to unlock token transfer.
421       */
422     function unlockAddress(address target) public
423     onlyOwner
424     {
425         lockedStatusAddress[target] = false;
426         emit Unlocked(target);
427     }
428 
429     /** @dev Transfer `_value` token to `_to` from `msg.sender`, on the condition
430       * that global token lock and individual address lock in the `msg.sender`
431       * accountare both released.
432       * @param _to The address of the recipient.
433       * @param _value The amount of token to be transferred.
434       * @return Whether the transfer was successful or not.
435       */
436     function transfer(address _to, uint256 _value)
437     public
438     checkGlobalTokenTransferLock
439     checkAddressLock
440     returns (bool) {
441         require(_to != address(0));
442         require(_value <= balances[msg.sender]);
443 
444         // SafeMath.sub will throw if there is not enough balance.
445         balances[msg.sender] = balances[msg.sender].sub(_value);
446         balances[_to] = balances[_to].add(_value);
447         emit Transfer(msg.sender, _to, _value);
448         return true;
449     }
450 
451     /**
452      * @dev Transfer tokens from one address to another
453      * @param _from address The address which you want to send tokens from
454      * @param _to address The address which you want to transfer to
455      * @param _value uint256 the amount of tokens to be transferred
456      */
457     function transferFrom(
458         address _from,
459         address _to,
460         uint256 _value
461     )
462     public
463     checkGlobalTokenTransferLock
464     checkAddressLock
465     returns (bool)
466     {
467         require(_value <= balances[_from]);
468         require(_value <= allowed[_from][msg.sender]);
469         require(_to != address(0));
470 
471         balances[_from] = balances[_from].sub(_value);
472         balances[_to] = balances[_to].add(_value);
473         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
474         emit Transfer(_from, _to, _value);
475         return true;
476     }
477 }