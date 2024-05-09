1 pragma solidity ^0.5.1;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Pausable is Ownable {
107   event Pause();
108   event Unpause();
109 
110   bool public paused = false;
111 
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyOwner whenNotPaused {
133     paused = true;
134     emit Pause();
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyOwner whenPaused {
141     paused = false;
142     emit Unpause();
143   }
144 }
145 
146 contract ERC20Basic {
147     function totalSupply() public view returns (uint256);
148     function balanceOf(address _who) public view returns (uint256);
149     function transfer(address _to, uint256 _value) public returns (bool);
150 
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 }
153 
154 contract BasicToken is ERC20Basic {
155     using SafeMath for uint256;
156 
157     mapping(address => uint256) internal balances;
158 
159     uint256 internal totalSupply_;
160 
161     /**
162      * @dev Total number of tokens in existence
163      */
164     function totalSupply() public view returns (uint256) {
165         return totalSupply_;
166     }
167 
168     /**
169      * @dev Transfer token for a specified address
170      * @param _to The address to transfer to.
171      * @param _value The amount to be transferred.
172      */
173     function transfer(address _to, uint256 _value) public returns (bool) {
174         require(_value <= balances[msg.sender]);
175         require(_to != address(0));
176 
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         emit Transfer(msg.sender, _to, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Gets the balance of the specified address.
185      * @param _owner The address to query the the balance of.
186      * @return An uint256 representing the amount owned by the passed address.
187      */
188     function balanceOf(address _owner) public view returns (uint256) {
189         return balances[_owner];
190     }
191 }
192 
193 contract ERC20 is ERC20Basic {
194     function allowance(address _owner, address _spender) public view returns (uint256);
195     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
196     function approve(address _spender, uint256 _value) public returns (bool);
197 
198     event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 contract StandardToken is ERC20, BasicToken {
202     mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205     /**
206      * @dev Transfer tokens from one address to another
207      * @param _from address The address which you want to send tokens from
208      * @param _to address The address which you want to transfer to
209      * @param _value uint256 the amount of tokens to be transferred
210      */
211     function transferFrom(address _from, address _to, uint256 _value)
212         public returns (bool) {
213         require(_value <= balances[_from]);
214         require(_value <= allowed[_from][msg.sender]);
215         require(_to != address(0));
216 
217         balances[_from] = balances[_from].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220         emit Transfer(_from, _to, _value);
221         return true;
222     }
223 
224 
225     /**
226      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param _spender The address which will spend the funds.
232      * @param _value The amount of tokens to be spent.
233      */
234     function approve(address _spender, uint256 _value) public returns (bool) {
235         allowed[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240 
241     /**
242      * @dev Function to check the amount of tokens that an owner allowed to a spender.
243      * @param _owner address The address which owns the funds.
244      * @param _spender address The address which will spend the funds.
245      * @return A uint256 specifying the amount of tokens still available for the spender.
246      */
247     function allowance(address _owner, address _spender)
248         public view returns (uint256) {
249         return allowed[_owner][_spender];
250     }
251 
252 
253     /**
254      * @dev Increase the amount of tokens that an owner allowed to a spender.
255      * approve should be called when allowed[_spender] == 0. To increment
256      * allowed value is better to use this function to avoid 2 calls (and wait until
257      * the first transaction is mined)
258      * From MonolithDAO Token.sol
259      * @param _spender The address which will spend the funds.
260      * @param _addedValue The amount of tokens to increase the allowance by.
261      */
262     function increaseApproval(address _spender, uint256 _addedValue)
263         public returns (bool) {
264         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 
269 
270     /**
271      * @dev Decrease the amount of tokens that an owner allowed to a spender.
272      * approve should be called when allowed[_spender] == 0. To decrement
273      * allowed value is better to use this function to avoid 2 calls (and wait until
274      * the first transaction is mined)
275      * From MonolithDAO Token.sol
276      * @param _spender The address which will spend the funds.
277      * @param _subtractedValue The amount of tokens to decrease the allowance by.
278      */
279     function decreaseApproval(address _spender, uint256 _subtractedValue)
280         public returns (bool) {
281         uint256 oldValue = allowed[msg.sender][_spender];
282 
283         if (_subtractedValue >= oldValue) allowed[msg.sender][_spender] = 0;
284         else allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285 
286         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287         return true;
288     }
289 }
290 
291 contract BurnableToken is StandardToken, Ownable {
292     event Burn(address indexed burner, uint256 value);
293 
294 
295     /**
296      * @dev Burns a specific amount of tokens.
297      * @param _value The amount of token to be burned.
298      * @param _who The user whose token should be burned.
299      */
300     function burn(address _who, uint256 _value) onlyOwner public {
301         require(_value <= balances[_who]);
302         // no need to require value <= totalSupply, since that would imply the
303         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
304 
305         balances[_who] = balances[_who].sub(_value);
306         totalSupply_ = totalSupply_.sub(_value);
307         emit Burn(_who, _value);
308         emit Transfer(_who, address(0), _value);
309     }
310 }
311 
312 contract MintableToken is StandardToken, Ownable {
313     event Mint(address indexed to, uint256 amount);
314     event MintFinished();
315 
316     bool public mintingFinished = false;
317 
318 
319     modifier canMint() {
320         require(!mintingFinished);
321         _;
322     }
323 
324 
325     modifier hasMintPermission() {
326         require(msg.sender == owner);
327         _;
328     }
329 
330 
331     /**
332      * @dev Function to mint tokens
333      * @param _to The address that will receive the minted tokens.
334      * @param _amount The amount of tokens to mint.
335      * @return A boolean that indicates if the operation was successful.
336      */
337     function mint(address _to, uint256 _amount)
338         public hasMintPermission canMint returns (bool) {
339         totalSupply_ = totalSupply_.add(_amount);
340         balances[_to] = balances[_to].add(_amount);
341         emit Mint(_to, _amount);
342         emit Transfer(address(0), _to, _amount);
343         return true;
344     }
345 
346 
347     /**
348      * @dev Function to stop minting new tokens.
349      * @return True if the operation was successful.
350      */
351     function finishMinting() public onlyOwner canMint returns (bool) {
352         mintingFinished = true;
353         emit MintFinished();
354         return true;
355     }
356 }
357 
358 contract CappedToken is MintableToken {
359     uint256 public cap;
360 
361 
362     constructor(uint256 _cap) public {
363         require(_cap > 0);
364         cap = _cap;
365     }
366 
367 
368     /**
369      * @dev Function to mint tokens
370      * @param _to The address that will receive the minted tokens.
371      * @param _amount The amount of tokens to mint.
372      * @return A boolean that indicates if the operation was successful.
373      */
374     function mint(address _to, uint256 _amount) public returns (bool) {
375         require(totalSupply_.add(_amount) <= cap);
376         return super.mint(_to, _amount);
377     }
378 }
379 
380 contract PausableToken is StandardToken, Pausable {
381     function transfer(address _to, uint256 _value)
382         public whenNotPaused returns (bool) {
383         return super.transfer(_to, _value);
384     }
385 
386 
387     function transferFrom(address _from, address _to, uint256 _value)
388         public whenNotPaused returns (bool) {
389         return super.transferFrom(_from, _to, _value);
390     }
391 
392 
393     function approve(address _spender, uint256 _value)
394         public whenNotPaused returns (bool) {
395         return super.approve(_spender, _value);
396     }
397 
398 
399     function increaseApproval(address _spender, uint _addedValue)
400         public whenNotPaused returns (bool success) {
401         return super.increaseApproval(_spender, _addedValue);
402     }
403 
404 
405     function decreaseApproval(address _spender, uint _subtractedValue)
406         public whenNotPaused returns (bool success) {
407         return super.decreaseApproval(_spender, _subtractedValue);
408     }
409 }
410 
411 contract CryptoControlToken is BurnableToken, PausableToken, CappedToken {
412     address public upgradedAddress;
413     bool public deprecated;
414     string public contactInformation = "contact@cryptocontrol.io";
415     string public name = "CryptoControl";
416     string public reason;
417     string public symbol = "CCIO";
418     uint8 public decimals = 18;
419 
420     constructor () CappedToken(10000000000000000000) public {}
421 
422     // Fix for the ERC20 short address attack.
423     modifier onlyPayloadSize(uint size) {
424         require(!(msg.data.length < size + 4), "payload too big");
425         _;
426     }
427 
428     // Forward ERC20 methods to upgraded contract if this one is deprecated
429     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
430         if (deprecated) return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
431         else return super.transfer(_to, _value);
432     }
433 
434     // Forward ERC20 methods to upgraded contract if this one is deprecated
435     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
436         if (deprecated) return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
437         else return super.transferFrom(_from, _to, _value);
438     }
439 
440     // Forward ERC20 methods to upgraded contract if this one is deprecated
441     function balanceOf(address who) public view returns (uint256) {
442         if (deprecated) return UpgradedStandardToken(upgradedAddress).balanceOf(who);
443         else return super.balanceOf(who);
444     }
445 
446     // Forward ERC20 methods to upgraded contract if this one is deprecated
447     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
448         if (deprecated) return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
449         else return super.approve(_spender, _value);
450     }
451 
452     // Forward ERC20 methods to upgraded contract if this one is deprecated
453     function allowance(address _owner, address _spender) public view returns (uint remaining) {
454         if (deprecated) return StandardToken(upgradedAddress).allowance(_owner, _spender);
455         else return super.allowance(_owner, _spender);
456     }
457 
458     // deprecate current contract in favour of a new one
459     function deprecate(address _upgradedAddress, string memory _reason) public onlyOwner {
460         deprecated = true;
461         upgradedAddress = _upgradedAddress;
462         reason = _reason;
463         emit Deprecate(_upgradedAddress, _reason);
464     }
465 
466     // Called when contract is deprecated
467     event Deprecate(address newAddress, string reason);
468 }
469 
470 contract UpgradedStandardToken is PausableToken {
471     // those methods are called by the legacy contract
472     // and they must ensure msg.sender to be the contract address
473     function transferByLegacy(address from, address to, uint value) public returns (bool);
474     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
475     function approveByLegacy(address from, address spender, uint value) public returns (bool);
476 }