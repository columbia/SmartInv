1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
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
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/zeppelin-solidity/contracts/ownership/Claimable.sol
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 // File: contracts/OwnClaimRenounceable.sol
82 
83 /**
84  * @title `owner` can renounce its role and leave the contract unowned.
85  * @dev There can not be a new `owner`.
86  * @dev No `onlyOwner` functions can ever be called again.
87  */
88 contract OwnClaimRenounceable is Claimable {
89 
90     function renounceOwnershipForever(uint8 _confirm)
91         public
92         onlyOwner
93     {
94         require(_confirm == 73); // Owner knows what he's doing
95         owner = address(0);
96         pendingOwner = address(0);
97     }
98 
99 }
100 
101 // File: contracts/TokenController.sol
102 
103 /** The interface for a token contract to notify a controller of every transfers. */
104 contract TokenController {
105     bytes4 public constant INTERFACE = bytes4(keccak256("TokenController"));
106 
107     function allowTransfer(address _sender, address _from, address _to, uint256 _value, bytes _purpose) public returns (bool);
108 }
109 
110 
111 // Basic examples
112 
113 contract YesController is TokenController {
114     function allowTransfer(address /* _sender */, address /* _from */, address /* _to */, uint256 /* _value */, bytes /* _purpose */)
115         public returns (bool)
116     {
117         return true; // allow all transfers
118     }
119 }
120 
121 
122 contract NoController is TokenController {
123     function allowTransfer(address /* _sender */, address /* _from */, address /* _to */, uint256 /* _value */, bytes /* _purpose */)
124         public returns (bool)
125     {
126         return false; // veto all transfers
127     }
128 }
129 
130 // File: contracts/zeppelin-solidity/contracts/math/SafeMath.sol
131 
132 /**
133  * @title SafeMath
134  * @dev Math operations with safety checks that throw on error
135  */
136 library SafeMath {
137 
138   /**
139   * @dev Multiplies two numbers, throws on overflow.
140   */
141   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142     if (a == 0) {
143       return 0;
144     }
145     uint256 c = a * b;
146     assert(c / a == b);
147     return c;
148   }
149 
150   /**
151   * @dev Integer division of two numbers, truncating the quotient.
152   */
153   function div(uint256 a, uint256 b) internal pure returns (uint256) {
154     // assert(b > 0); // Solidity automatically throws when dividing by 0
155     uint256 c = a / b;
156     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157     return c;
158   }
159 
160   /**
161   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
162   */
163   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164     assert(b <= a);
165     return a - b;
166   }
167 
168   /**
169   * @dev Adds two numbers, throws on overflow.
170   */
171   function add(uint256 a, uint256 b) internal pure returns (uint256) {
172     uint256 c = a + b;
173     assert(c >= a);
174     return c;
175   }
176 }
177 
178 // File: contracts/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
179 
180 /**
181  * @title ERC20Basic
182  * @dev Simpler version of ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/179
184  */
185 contract ERC20Basic {
186   function totalSupply() public view returns (uint256);
187   function balanceOf(address who) public view returns (uint256);
188   function transfer(address to, uint256 value) public returns (bool);
189   event Transfer(address indexed from, address indexed to, uint256 value);
190 }
191 
192 // File: contracts/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
193 
194 /**
195  * @title Basic token
196  * @dev Basic version of StandardToken, with no allowances.
197  */
198 contract BasicToken is ERC20Basic {
199   using SafeMath for uint256;
200 
201   mapping(address => uint256) balances;
202 
203   uint256 totalSupply_;
204 
205   /**
206   * @dev total number of tokens in existence
207   */
208   function totalSupply() public view returns (uint256) {
209     return totalSupply_;
210   }
211 
212   /**
213   * @dev transfer token for a specified address
214   * @param _to The address to transfer to.
215   * @param _value The amount to be transferred.
216   */
217   function transfer(address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(_value <= balances[msg.sender]);
220 
221     // SafeMath.sub will throw if there is not enough balance.
222     balances[msg.sender] = balances[msg.sender].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     Transfer(msg.sender, _to, _value);
225     return true;
226   }
227 
228   /**
229   * @dev Gets the balance of the specified address.
230   * @param _owner The address to query the the balance of.
231   * @return An uint256 representing the amount owned by the passed address.
232   */
233   function balanceOf(address _owner) public view returns (uint256 balance) {
234     return balances[_owner];
235   }
236 
237 }
238 
239 // File: contracts/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
240 
241 /**
242  * @title ERC20 interface
243  * @dev see https://github.com/ethereum/EIPs/issues/20
244  */
245 contract ERC20 is ERC20Basic {
246   function allowance(address owner, address spender) public view returns (uint256);
247   function transferFrom(address from, address to, uint256 value) public returns (bool);
248   function approve(address spender, uint256 value) public returns (bool);
249   event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 // File: contracts/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
253 
254 /**
255  * @title Standard ERC20 token
256  *
257  * @dev Implementation of the basic standard token.
258  * @dev https://github.com/ethereum/EIPs/issues/20
259  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
260  */
261 contract StandardToken is ERC20, BasicToken {
262 
263   mapping (address => mapping (address => uint256)) internal allowed;
264 
265 
266   /**
267    * @dev Transfer tokens from one address to another
268    * @param _from address The address which you want to send tokens from
269    * @param _to address The address which you want to transfer to
270    * @param _value uint256 the amount of tokens to be transferred
271    */
272   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
273     require(_to != address(0));
274     require(_value <= balances[_from]);
275     require(_value <= allowed[_from][msg.sender]);
276 
277     balances[_from] = balances[_from].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
280     Transfer(_from, _to, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286    *
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(address _owner, address _spender) public view returns (uint256) {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    *
313    * approve should be called when allowed[_spender] == 0. To increment
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
321     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
322     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326   /**
327    * @dev Decrease the amount of tokens that an owner allowed to a spender.
328    *
329    * approve should be called when allowed[_spender] == 0. To decrement
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _subtractedValue The amount of tokens to decrease the allowance by.
335    */
336   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
337     uint oldValue = allowed[msg.sender][_spender];
338     if (_subtractedValue > oldValue) {
339       allowed[msg.sender][_spender] = 0;
340     } else {
341       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
342     }
343     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
344     return true;
345   }
346 
347 }
348 
349 // File: contracts/SapienCoin.sol
350 
351 /**
352  * @title Has a `controller`.
353  * @dev The `controller` must be a contract implementing TokenController.
354  * @dev The `controller` can track or veto the tokens transfers.
355  * @dev The `controller` can assign its role to another address.
356  * @dev The `owner` have all the powers of the `controller`.
357  */
358 contract Controlled is OwnClaimRenounceable {
359 
360     bytes4 public constant TOKEN_CONTROLLER_INTERFACE = bytes4(keccak256("TokenController"));
361     TokenController public controller;
362 
363     function Controlled() public {}
364 
365     /// @notice The address of the controller is the only address that can call
366     ///  a function with this modifier
367     modifier onlyControllerOrOwner {
368         require((msg.sender == address(controller)) || (msg.sender == owner));
369         _;
370     }
371 
372     /// @notice Changes the controller of the contract
373     /// @param _newController The new controller of the contract
374     function changeController(TokenController _newController)
375         public onlyControllerOrOwner
376     {
377         if(address(_newController) != address(0)) {
378             // Check type to prevent mistakes
379             require(_newController.INTERFACE() == TOKEN_CONTROLLER_INTERFACE);
380         }
381         controller = _newController;
382     }
383 
384 }
385 
386 
387 contract ControlledToken is StandardToken, Controlled {
388 
389     modifier controllerCallback(address _from, address _to, uint256 _value, bytes _purpose) {
390         // If a controller is present, ask it about the transfer.
391         if(address(controller) != address(0)) {
392             bool _allow = controller.allowTransfer(msg.sender, _from, _to, _value, _purpose);
393             if(!_allow) {
394                 return; // Do not transfer
395             }
396         }
397         _; // Proceed with the transfer
398     }
399 
400     /** @dev ERC20 transfer with controller callback */
401     function transfer(address _to, uint256 _value)
402         public
403         controllerCallback(msg.sender, _to, _value, hex"")
404         returns (bool)
405     {
406         return super.transfer(_to, _value);
407     }
408 
409     /** @dev ERC20 transferFrom with controller callback */
410     function transferFrom(address _from, address _to, uint256 _value)
411         public
412         controllerCallback(_from, _to, _value, hex"")
413         returns (bool)
414     {
415         return super.transferFrom(_from, _to, _value);
416     }
417 
418     /**
419     * @dev Transfer tokens to a specified address, including a purpose.
420     * @param _to The address to transfer to.
421     * @param _value The amount to be transferred.
422     * @param _purpose Arbitrary data attached to the transaction.
423     */
424     function transferWithPurpose(address _to, uint256 _value, bytes _purpose)
425         public
426         controllerCallback(msg.sender, _to, _value, _purpose)
427         returns (bool)
428     {
429         return super.transfer(_to, _value);
430     }
431 
432 }
433 
434 
435 contract BatchToken is ControlledToken {
436 
437     /**
438     * @dev Transfer to many addresses in a single transaction.
439     * @dev Call transfer(to, amount) with the arguments taken from two arrays.
440     * @dev If one transfer is invalid, everything is aborted.
441     * @dev The `_expectZero` option is intended for the initial batch minting.
442     *      It allows operations to be retried and prevents double-minting due to the
443     *      asynchronous and uncertain nature of blockchain transactions.
444     *      It should be avoided after trading has started.
445     * @param _toArray Addresses that will receive tokens.
446     * @param _amountArray Amounts of tokens to transfer, in the same order as `_toArray`.
447     * @param _expectZero If false, transfer the tokens immediately.
448     *                    If true, expect the current balance of `_to` to be zero before
449     *                    the transfer. If not zero, skip this transfer but continue.
450     */
451     function transferBatchIdempotent(address[] _toArray, uint256[] _amountArray, bool _expectZero)
452         // Anyone can call if they have the balance
453         public
454     {
455         // Check that the arrays are the same size
456         uint256 _count = _toArray.length;
457         require(_amountArray.length == _count);
458 
459         for (uint256 i = 0; i < _count; i++) {
460             address _to = _toArray[i];
461             // Either regular transfer, or check that BasicToken.balances is zero.
462             if(!_expectZero || (balanceOf(_to) == 0)) {
463                 transfer(_to, _amountArray[i]);
464             }
465         }
466     }
467 
468 }
469 
470 
471 /**
472  * @title The Sapien Token.
473  */
474 contract SapienToken is BatchToken {
475 
476     string public constant name = "Sapien Network";
477     string public constant symbol = "SPN";
478     uint256 public constant decimals = 6;
479     string public constant website = "https://sapien.network";
480 
481     /**
482     * @dev The maximum supply that can be minted, in microSPN.
483     *      500M with 6 decimals.
484     */
485     uint256 public constant MAX_SUPPLY_USPN = 500 * 1000 * 1000 * (10**decimals);
486 
487     function SapienToken() public {
488         // All initial tokens to owner
489         balances[msg.sender] = MAX_SUPPLY_USPN;
490         totalSupply_ = MAX_SUPPLY_USPN;
491     }
492 
493 }