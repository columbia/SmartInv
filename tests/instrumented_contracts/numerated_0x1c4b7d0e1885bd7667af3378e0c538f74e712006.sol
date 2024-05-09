1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123   event Pause();
124   event Unpause();
125 
126   bool public paused = false;
127 
128 
129   /**
130    * @dev Modifier to make a function callable only when the contract is not paused.
131    */
132   modifier whenNotPaused() {
133     require(!paused);
134     _;
135   }
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is paused.
139    */
140   modifier whenPaused() {
141     require(paused);
142     _;
143   }
144 
145   /**
146    * @dev called by the owner to pause, triggers stopped state
147    */
148   function pause() onlyOwner whenNotPaused public {
149     paused = true;
150     emit Pause();
151   }
152 
153   /**
154    * @dev called by the owner to unpause, returns to normal state
155    */
156   function unpause() onlyOwner whenPaused public {
157     paused = false;
158     emit Unpause();
159   }
160 }
161 
162 
163 /**
164  * @title ERC20Basic
165  * @dev Simpler version of ERC20 interface
166  * See https://github.com/ethereum/EIPs/issues/179
167  */
168 contract ERC20Basic {
169   function totalSupply() public view returns (uint256);
170   function balanceOf(address who) public view returns (uint256);
171   function transfer(address to, uint256 value) public returns (bool);
172   event Transfer(address indexed from, address indexed to, uint256 value);
173 }
174 
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 is ERC20Basic {
181   function allowance(address owner, address spender)
182     public view returns (uint256);
183 
184   function transferFrom(address from, address to, uint256 value)
185     public returns (bool);
186 
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(
189     address indexed owner,
190     address indexed spender,
191     uint256 value
192   );
193 }
194 
195 
196 /**
197  * @title Basic token
198  * @dev Basic version of StandardToken, with no allowances.
199  */
200 contract BasicToken is ERC20Basic {
201   using SafeMath for uint256;
202 
203   mapping(address => uint256) balances;
204 
205   uint256 totalSupply_;
206 
207   /**
208   * @dev Total number of tokens in existence
209   */
210   function totalSupply() public view returns (uint256) {
211     return totalSupply_;
212   }
213 
214   /**
215   * @dev Transfer token for a specified address
216   * @param _to The address to transfer to.
217   * @param _value The amount to be transferred.
218   */
219   function transfer(address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[msg.sender]);
222 
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     emit Transfer(msg.sender, _to, _value);
226     return true;
227   }
228 
229   /**
230   * @dev Gets the balance of the specified address.
231   * @param _owner The address to query the the balance of.
232   * @return An uint256 representing the amount owned by the passed address.
233   */
234   function balanceOf(address _owner) public view returns (uint256) {
235     return balances[_owner];
236   }
237 
238 }
239 
240 
241 /**
242  * @title Standard ERC20 token
243  *
244  * @dev Implementation of the basic standard token.
245  * https://github.com/ethereum/EIPs/issues/20
246  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
247  */
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   )
264     public
265     returns (bool)
266   {
267     require(_to != address(0));
268     require(_value <= balances[_from]);
269     require(_value <= allowed[_from][msg.sender]);
270 
271     balances[_from] = balances[_from].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274     emit Transfer(_from, _to, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
280    * Beware that changing an allowance with this method brings the risk that someone may use both the old
281    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284    * @param _spender The address which will spend the funds.
285    * @param _value The amount of tokens to be spent.
286    */
287   function approve(address _spender, uint256 _value) public returns (bool) {
288     allowed[msg.sender][_spender] = _value;
289     emit Approval(msg.sender, _spender, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Function to check the amount of tokens that an owner allowed to a spender.
295    * @param _owner address The address which owns the funds.
296    * @param _spender address The address which will spend the funds.
297    * @return A uint256 specifying the amount of tokens still available for the spender.
298    */
299   function allowance(
300     address _owner,
301     address _spender
302    )
303     public
304     view
305     returns (uint256)
306   {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    * approve should be called when allowed[_spender] == 0. To increment
313    * allowed value is better to use this function to avoid 2 calls (and wait until
314    * the first transaction is mined)
315    * From MonolithDAO Token.sol
316    * @param _spender The address which will spend the funds.
317    * @param _addedValue The amount of tokens to increase the allowance by.
318    */
319   function increaseApproval(
320     address _spender,
321     uint256 _addedValue
322   )
323     public
324     returns (bool)
325   {
326     allowed[msg.sender][_spender] = (
327       allowed[msg.sender][_spender].add(_addedValue));
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332   /**
333    * @dev Decrease the amount of tokens that an owner allowed to a spender.
334    * approve should be called when allowed[_spender] == 0. To decrement
335    * allowed value is better to use this function to avoid 2 calls (and wait until
336    * the first transaction is mined)
337    * From MonolithDAO Token.sol
338    * @param _spender The address which will spend the funds.
339    * @param _subtractedValue The amount of tokens to decrease the allowance by.
340    */
341   function decreaseApproval(
342     address _spender,
343     uint256 _subtractedValue
344   )
345     public
346     returns (bool)
347   {
348     uint256 oldValue = allowed[msg.sender][_spender];
349     if (_subtractedValue > oldValue) {
350       allowed[msg.sender][_spender] = 0;
351     } else {
352       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
353     }
354     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 
358 }
359 
360 
361 contract IOGToken is StandardToken, Ownable, Pausable {
362 
363     // events
364     event Burn(address indexed burner, uint256 amount);
365     event AddressLocked(address indexed _owner, uint256 _expiry);
366 
367     // erc20 constants
368     string public constant name = "IOGToken";
369     string public constant symbol = "IOG";
370     uint8 public constant decimals = 18;
371     uint256 public constant TOTAL_SUPPLY = 2200000000 * (10 ** uint256(decimals));
372 
373     // lock
374     mapping (address => uint256) public addressLocks;
375 
376     // constructor
377     constructor(address[] addressList, uint256[] tokenAmountList, uint256[] lockedPeriodList) public {
378         totalSupply_ = TOTAL_SUPPLY;
379         balances[msg.sender] = TOTAL_SUPPLY;
380         emit Transfer(0x0, msg.sender, TOTAL_SUPPLY);
381 
382         // distribution
383         distribution(addressList, tokenAmountList, lockedPeriodList);
384     }
385 
386     // distribution
387     function distribution(address[] addressList, uint256[] tokenAmountList, uint256[] lockedPeriodList) onlyOwner internal {
388         // Token allocation
389         // - foundation: 25% (16% locked)
390         // - platform ecosystem: 35% (30% locked)
391         // - early investor: 15% (12.5% locked)
392         // - private sale: 10%
393         // - board of advisor: 10%
394         // - bounty: 5%
395 
396         for (uint i = 0; i < addressList.length; i++) {
397             uint256 lockedPeriod = lockedPeriodList[i];
398 
399             // lock
400             if (0 < lockedPeriod) {
401                 timeLock(addressList[i], tokenAmountList[i] * (10 ** uint256(decimals)), now + (lockedPeriod * 60 * 60 * 24));
402             }
403             // unlock
404             else {
405                 transfer(addressList[i], tokenAmountList[i] * (10 ** uint256(decimals)));
406             }
407         }
408     }
409 
410     // lock
411     modifier canTransfer(address _sender) {
412         require(_sender != address(0));
413         require(canTransferIfLocked(_sender));
414 
415         _;
416     }
417 
418     function canTransferIfLocked(address _sender) internal view returns(bool) {
419         if (0 == addressLocks[_sender])
420             return true;
421 
422         return (now >= addressLocks[_sender]);
423     }
424 
425     function timeLock(address _to, uint256 _value, uint256 releaseDate) onlyOwner public {
426         addressLocks[_to] = releaseDate;
427         transfer(_to, _value);
428         emit AddressLocked(_to, _value);
429     }
430 
431     // erc20 methods
432     function transfer(address _to, uint256 _value) canTransfer(msg.sender) whenNotPaused public returns (bool success) {
433         return super.transfer(_to, _value);
434     }
435 
436     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) whenNotPaused public returns (bool success) {
437         return super.transferFrom(_from, _to, _value);
438     }
439     
440     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
441         return super.approve(_spender, _value);
442     }
443 
444     function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool success) {
445         return super.increaseApproval(_spender, _addedValue);
446     }
447 
448     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool success) {
449         return super.decreaseApproval(_spender, _subtractedValue);
450     }
451 
452     // burn
453     function burn(uint256 _value) public {
454         _burn(msg.sender, _value);
455     }
456 
457     function _burn(address _who, uint256 _value) internal {
458         require(_value <= balances[_who]);
459 
460         balances[_who] = balances[_who].sub(_value);
461         totalSupply_ = totalSupply_.sub(_value);
462 
463         emit Burn(_who, _value);
464         emit Transfer(_who, address(0), _value);
465     }
466 	
467 	// token drain
468     function emergencyERC20Drain(ERC20 token, uint256 amount) external onlyOwner {
469         // owner can drain tokens that are sent here by mistake
470         token.transfer(owner, amount);
471     }
472 }